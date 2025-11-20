package openfl.data;
import openfl.utils.Function;
import openfl.utils.Object;
import openfl.errors.ArgumentError;
import openfl.errors.IOError;
import openfl.errors.SQLError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.SQLErrorEvent;
import openfl.events.SQLEvent;
import openfl.utils.ByteArray;
import openfl.FileSystem.File;
import lime.system.BackgroundWorker;
import sys.FileSystem;
import sys.db.Connection;
import sys.db.ResultSet;
import sys.db.Sqlite;
import sys.thread.Deque;
import sys.thread.Mutex;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(openfl.data.SQLStatement)
class SQLConnection extends EventDispatcher
{
	public static inline var isSupported:Bool =
		#if windows
		true;
		#end
	private static inline var DEFAULT_CACHE_SIZE:UInt = 2000;
	public var autoCompact(get, null):Bool;
	public var cacheSize(get, set):UInt;
	//public var columnNameStyle(get, set):String;
	public var connected(get, null):Bool;
	public var inTransaction(get, null):Bool;
	public var lastInsertRowID(get, null):Float;
	public var pageSize(get, null):UInt;
	public var totalChanges(get, null):Float;

	private var __totalChanges:Float = 0;
	private var __lasInsertRowID:Float = 0;
	private var __inTransaction:Bool = false;
	private var __async:Null<Bool>;
	private var __reference:String;
	private var __initAutoCompact:Bool;
	private var __initPageSize:UInt;

	@:noCompletion private var __connection:Connection;
	private var __openMode:SQLMode;

	private var __sqlWorker:BackgroundWorker;
	private var __sqlQueue:Deque<Function>;
	private var __sqlMutex:Mutex;

	public function new()
	{
		super();
	}

	private function __onSQLWorkerComplete(message:Dynamic):Void
	{

	}

	private function __onSQLWorkerError(message:Dynamic<>):Void
	{

	}

	private function __onSQLWorkerProgress(message:Dynamic):Void
	{
		if (Std.isOfType(message, SQLEvent)){
			var evt:SQLEvent = message;
			__dispatchEvent(evt);
		} else {
			var obj:Object = message;
			
			var type:Int = obj.type;
			var statement:SQLStatement = obj.statement;
			var event:Event = obj.event;
			var prefetch:Int = obj.prefetch;
			statement.__prefetch = prefetch;
			
			if(type == 0){
				
				
				var results:ResultSet = obj.results;
				
			
				statement.__resultSet = results;
				
				statement.__queueResult();
				
			} else {
				var executing:Bool = obj.executing;
				if (executing){
					statement.__queueResult();
				}
			}
			
			statement.__dispatchEvent(event);
		}
	}

	private function __initSQLWorker():Void
	{
		__sqlMutex = new Mutex();
		__sqlQueue = new Deque();
		__sqlWorker = new BackgroundWorker();
		__sqlWorker.onComplete.add(__onSQLWorkerComplete);
		__sqlWorker.onError.add(__onSQLWorkerError);
		__sqlWorker.onProgress.add(__onSQLWorkerProgress);
		__sqlWorker.doWork.add(__sqlWork);
		__sqlWorker.run();

	}

	private function __sqlWork(m:Dynamic):Void
	{
		while (!__sqlWorker.canceled)
		{
			var job:Function = __sqlQueue.pop(true);
			job();
		}
	}
	
	private function __addToQue(job:Function):Void{
		__sqlMutex.acquire();
		__sqlQueue.add(job);
		__sqlMutex.release;
	}

	public function analyze():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__analyzeAsync);
			__sqlMutex.release;
		}
		else {
			__connection.request("ANALYZE;");
			__dispatchSQLEvent(SQLEvent.ANALYZE);
		}
	}

	private function __analyzeAsync():Void
	{
		var event:Event;

		try{
			__connection.request("ANALYZE;");
			event = new SQLEvent(SQLEvent.ANALYZE);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.ANALYZE, e, "Execution failed"));
		}

		__sqlWorker.sendProgress(event);
	}

	public function begin(options:String = null):Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__beginAsync(options));
			__sqlMutex.release;
		}
		else {
			__connection.startTransaction();
			__dispatchSQLEvent(SQLEvent.BEGIN);
		}

	}

	private function __beginAsync(options:String):Function
	{
		return function()
		{
			var event:Event;

			try
			{
				__connection.startTransaction();
				event = new SQLEvent(SQLEvent.BEGIN);
			}
			catch (e:Dynamic)
			{
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.BEGIN, e, "Execution failed"));
			}
			__sqlWorker.sendProgress(event);
		}
	}

	public function deanalyze():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(deanalyzeAsync);
			__sqlMutex.release;
		}
		else {
			__connection.close();
			open(__reference, __openMode, __initAutoCompact, __initPageSize);
		}

		__dispatchSQLEvent(SQLEvent.DEANALYZE);
	}

	private function deanalyzeAsync():Void
	{
		var event:Event;

		try{
			__connection.close();
			openAsync(__reference, __openMode, __initAutoCompact, __initPageSize);
			event = new SQLEvent(SQLEvent.DEANALYZE);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.DEANALYZE, "Execution failed"));
		}
		__sqlWorker.sendProgress(event);
	}

	public function cancel():Void
	{
		if (__async)
		{
			__sqlWorker.cancel();

			__sqlMutex.acquire();
			__sqlQueue = new Deque();
			__sqlMutex.release();
		}

		__dispatchSQLEvent(SQLEvent.CANCEL);
	}

	public function close():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__closeAsync);
			__sqlMutex.release;
		}
		else {
			__connection.close();
			__dispatchSQLEvent(SQLEvent.CLOSE);
		}

	}

	private function __closeAsync():Void
	{
		var event:Event;

		try{
			__connection.close();
			event = new SQLEvent(SQLEvent.CLOSE);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.CLOSE, "Execution failed"));
		}
		__sqlWorker.sendProgress(event);
	}

	public function commit():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__commitAsync);
			__sqlMutex.release;
		}
		else {
			__connection.commit();
			__dispatchSQLEvent(SQLEvent.COMMIT);
		}
	}

	private function __commitAsync():Void
	{
		var event:Event;

		try{
			__connection.commit();
			event = new SQLEvent(SQLEvent.COMMIT);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.COMMIT, "Execution failed"));
		}
		__sqlWorker.sendProgress(event);
	}

	public function compact():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__compactAsync);
			__sqlMutex.release;
		}
		else {
			__connection.request("VACUUM;");
			__dispatchSQLEvent(SQLEvent.COMPACT);
		}
	}

	private function __compactAsync():Void
	{
		var event:Event;

		try{
			__connection.request("VACUUM;");
			event = new SQLEvent(SQLEvent.COMPACT);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.COMPACT, "Execution failed"));
		}
		__sqlWorker.sendProgress(event);
	}

	public function open(reference:Object = null, openMode:SQLMode = CREATE, autoCompact:Bool = false, pageSize:Int = 1024):Void
	{
		__async = false;
		__open(reference, openMode, autoCompact, pageSize);

		__dispatchSQLEvent(SQLEvent.OPEN);
	}

	private function __open(reference:Object = null, openMode:SQLMode = CREATE, autoCompact:Bool = false, pageSize:Int = 1024):Void
	{
		__initAutoCompact = autoCompact;
		__initPageSize = pageSize;

		if (reference == null || reference == ":memory:")
		{
			__openMode = CREATE;
			reference = ":memory:";
			__createConnection(reference);
		}
		else {
			var file:File;
			__openMode = openMode;

			if (Std.isOfType(reference, String))
			{
				try
				{
					file = new File(reference);
				}
				catch (e:Dynamic)
				{
					throw new ArgumentError(e);
				}
			}
			else if (Std.isOfType(reference, File))
			{
				file = reference;
			}
			else {
				throw new ArgumentError("The reference argument is neither a String to a path or a File Object.");
			}

			__reference = file.nativePath;

			switch (openMode)
			{
				case CREATE:
					__createConnection(file.nativePath);
				case READ, UPDATE:
					if (file.exists)
					{
						__createConnection(file.nativePath);
					}
					else
					{
						throw new ArgumentError("Database does not exist.");
					}
			}
		}

		if (__openMode == CREATE)
		{
			__connection.request('PRAGMA page_size = $pageSize;');

			if (autoCompact)
			{
				__connection.request("PRAGMA auto_vacuum = 2;");
			}
		}

		cacheSize = DEFAULT_CACHE_SIZE;
	}

	public function openAsync(reference:Object = null, openMode:SQLMode = CREATE, autoCompact:Bool = false, pageSize:Int = 1024):Void
	{

		__async = true;
		__initSQLWorker();
		__sqlMutex.acquire();
		__sqlQueue.add(__openAsync(reference, openMode, autoCompact, pageSize));
		__sqlMutex.release;
	}

	private function __openAsync(reference:Object = null, openMode:SQLMode = CREATE, autoCompact:Bool = false, pageSize:Int = 1024):Function
	{
		return function()
		{
			var event:Event;

			try
			{
				__open(reference, openMode, autoCompact, pageSize);
				event = new SQLEvent(SQLEvent.OPEN);
			}
			catch (e:Dynamic)
			{
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.OPEN, "Execution failed"));
			}
			__sqlWorker.sendProgress(event);
		}
	}

	public function releaseSavepoint(name:String = null):Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__releaseSavePointAsync(name));
			__sqlMutex.release;
		}
		else {
			__connection.request('RELEASE $name;');
			__dispatchSQLEvent(SQLEvent.RELEASE_SAVEPOINT);
		}
	}

	private function __releaseSavePointAsync(name:String):Function
	{
		return function()
		{
			var event:Event;

			try
			{
				__connection.request('RELEASE $name;');
				event = new SQLEvent(SQLEvent.RELEASE_SAVEPOINT);
			}
			catch (e:Dynamic)
			{
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.RELEASE_SAVEPOINT, "Execution failed"));
			}
			__sqlWorker.sendProgress(event);
		}
	}

	public function rollback():Void
	{
		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(__rollbackAsync);
			__sqlMutex.release;
		}
		else {
			__connection.rollback();
			__dispatchSQLEvent(SQLEvent.ROLLBACK);
		}
	}

	private function __rollbackAsync():Void
	{
		var event:Event;

		try
		{
			__connection.rollback();
			event = new SQLEvent(SQLEvent.ROLLBACK);
		}
		catch (e:Dynamic)
		{
			event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.ROLLBACK, "Execution failed"));
		}
		__sqlWorker.sendProgress(event);
	}

	public function rollbackToSavepoint(name:String = null):Void
	{
		if (name == null)
		{
			rollback();
			return;
		}

		if (__async)
		{
			__sqlMutex.acquire();
			__sqlQueue.add(rollbackToSavepointAsync(name));
			__sqlMutex.release;
		}
		else {
			__connection.request('ROLLBACK TO $name;');
			__dispatchSQLEvent(SQLEvent.ROLLBACK_TO_SAVEPOINT);
		}
	}

	private function rollbackToSavepointAsync(name:String):Function
	{
		return function()
		{
			var event:Event;

			try
			{
				__connection.request('ROLLBACK TO $name;');
				event = new SQLEvent(SQLEvent.ROLLBACK_TO_SAVEPOINT);
			}
			catch (e:Dynamic)
			{
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.ROLLBACK_TO_SAVEPOINT, "Execution failed"));
			}
			__sqlWorker.sendProgress(event);
		}
	}

	public function setSavepoint(name:String = null):Void
	{
		if (__async){
			__sqlMutex.acquire();
			__sqlQueue.add(__setSavepointAsync(name));
			__sqlMutex.release;
		} else {
			__connection.request('SAVEPOINT $name;');
			__dispatchSQLEvent(SQLEvent.SET_SAVEPOINT);
		}
		
	}
	
	private function __setSavepointAsync(name:String):Function{
		return function(){
			var event:Event;

			try
			{
				__connection.request('SAVEPOINT $name;');
				event = new SQLEvent(SQLEvent.SET_SAVEPOINT);
			}
			catch (e:Dynamic)
			{
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.SET_SAVEPOINT, "Execution failed"));
			}
			__sqlWorker.sendProgress(event);
		}
	}
	
	private function __createConnection(path:String):Void
	{
		try{
			__connection = Sqlite.open(path);
		}
		catch (e:Dynamic)
		{
			throw new IOError(e);
		}
	}

	private function get_autoCompact():Bool
	{
		var result:ResultSet;
		if (__async){
			__sqlMutex.acquire();
			result = __connection.request("PRAGMA auto_vacuum;");
			__sqlMutex.release();
		} else {
			result = __connection.request("PRAGMA auto_vacuum;");
		}
		
		if (result.hasNext())
		{
			var autoVacuum:Int = result.next().auto_vacuum;

			if (autoVacuum == 0)
			{
				return false;
			}
			else if (autoVacuum == 1)
			{
				return true;
			}
			else if (autoVacuum == 2)
			{
				return true;
			}
		}

		return false;
	}

	private function get_pageSize():UInt
	{
		var result:ResultSet = __connection.request("PRAGMA page_size;");

		if (result.hasNext())
		{
			var pageSize:UInt = result.next().page_size;

			return pageSize;
		}

		return 0;
	}

	private function get_cacheSize():UInt
	{
		var result:ResultSet = __connection.request("PRAGMA cache_size;");

		if (result.hasNext())
		{
			var cacheSize:UInt = result.next().cache_size;
			return cacheSize;
		}

		return 0;
	}

	private function set_cacheSize(value:UInt):UInt
	{
		__connection.request('PRAGMA cache_size = $value;');
		return value;
	}

	private function get_connected():Bool
	{
		if (__connection == null)
		{
			return false;
		}

		try{
			__connection.request("SELECT 1;");
			return true;
		}
		catch (e:Dynamic)
		{
			return false;
		}

		return false;
	}

	private function get_inTransaction():Bool
	{
		return __inTransaction;
	}

	private function get_lastInsertRowID():Float
	{
		return __connection.lastInsertId();
	}

	private function get_totalChanges():Float
	{
		return 0;
	}

	private function __dispatchSQLEvent(type:String):Void
	{
		__dispatchEvent(new SQLEvent(type));
	}
	
	private function __getTables(): Array<String>
	{
		var result:ResultSet = __connection.request("SELECT name FROM sqlite_master WHERE type = 'table';");
		var tables:Array<String> = [];
		while (result.hasNext())
		{
			tables.push(result.next().name);
		}
		return tables;
	}
}