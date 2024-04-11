package openfl.data;
import openfl.utils.Object;
import openfl.errors.ArgumentError;
import openfl.errors.IOError;
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;
import openfl.filesystem.File;
import sys.db.Connection;
import sys.db.ResultSet;
import sys.db.Sqlite;
import sys.thread.Deque;

/**
 * ...
 * @author Christopher Speciale
 */
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

	@:noCompletion private var __connection:Connection;
	private var __openMode:SQLMode;

	public function new()
	{
		super();
	}

	public function close():Void
	{
		__connection.close();
	}

	public function commit():Void
	{
		__connection.commit();
	}

	public function compact():Void
	{
		__connection.request("VACUUM;");
	}

	public function open(reference:Object = null, openMode:SQLMode = CREATE, autoCompact:Bool = false, pageSize:Int = 1024):Void
	{
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
		var result:ResultSet = __connection.request("PRAGMA auto_vacuum;");

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

enum abstract SQLMode(String) from String to SQLMode
{
	var CREATE:String = "create";
	var READ:String = "read";
	var UPDATE:String = "update";
}

@:access(crossbyte.db.SQLConnection)
class SQLStatement extends EventDispatcher
{

	public var executing(get, null):Bool;
	public var itemClass:Class<Dynamic>;
	public var parameters(get, null):Object;
	public var sqlConnection(default, set):SQLConnection;
	public var text:String;

	private var __executing:Bool = false;
	private var __connection:Connection;
	private var __resultSet:ResultSet;
	private var __prefetch:Int = 0;
	private var __resultQueue:Deque<Array<String>>;

	public function new()
	{
		super();
		parameters = new Object();
		__resultQueue = new Deque();
	}

	public function cancel():Void
	{
		if(executing){
			__executing = false;
			__prefetch = 0;
			__resultQueue = new Deque();
			__resultSet = null;
			text = "";
			clearParameters();
		}
	}

	public function clearParameters():Void
	{
		parameters = new Object();
	}

	public function execute(prefetch:Int = -1):Void
	{
		__executing = true;
		
		for (parameter in parameters){
			__connection.addValue(cast parameter, Reflect.field(parameters, parameter));
		}
		
		__resultSet = __connection.request(text);
		__queueResult();
		text = "";
	}

	private function __queueResult():Void
	{
		var results:Array<String> = [];
		
		if (__prefetch == -1)
		{
			while (__resultSet.hasNext())
			{
				results.push(__resultSet.next());
			}
			__resultQueue.push(results);
			__executing = false;
		}
		else if (__prefetch > 0)
		{
			for (i in 0...__prefetch)
			{
				if (__resultSet.hasNext())
				{
					results.push(__resultSet.next());
				}
				else
				{
					__executing = false;
					break;
				}
			}
			__resultQueue.push(results);
		}
		__prefetch = 0;
	}
	
	public function getResult():SQLResult
	{
		var results:Array<String> = __resultQueue.pop(false);
		var complete:Bool = !__executing;
		
		if (results != null){
			var sqlResult:SQLResult = new SQLResult(results, __resultSet.length, complete, __connection.lastInsertId());

			return sqlResult;
		}		
		
		return null;
	}

	public function next(prefetch:Int = -1):Void
	{
		__prefetch = prefetch;
		
		if (__resultSet.hasNext())
		{
			__queueResult();
		} else {
			__executing = false;
			__prefetch = 0;
		}
	}
	private function get_executing():Bool
	{
		return __executing;
	}

	private function get_parameters():Object
	{
		return null;
	}

	private function set_sqlConnection(value:SQLConnection):SQLConnection
	{
		__connection = value.__connection;
		return sqlConnection = value;
	}

}

class SQLResult 
{

	public var complete(default, null):Bool;
	public var data(default, null):Array<String>;
	public var lastInsertRowID(default, null):Float;
	public var rowsAffected(default, null):Float;
	
	public function new(data:Array<String> = null, rowsAffected:Float = 0, complete:Bool = true, rowID:Float = 0) 
	{
		this.data = data;
		this.rowsAffected = rowsAffected;
		this.complete = complete;
		this.lastInsertRowID = rowID;
	}
	
}
