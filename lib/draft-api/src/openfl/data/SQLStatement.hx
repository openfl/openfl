package openfl.data;
import openfl.utils.Object;
import openfl.errors.SQLError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.events.SQLErrorEvent;
import openfl.events.SQLEvent;
import sys.db.Connection;
import sys.db.ResultSet;
import sys.thread.Deque;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(openfl.data.SQLConnection)
class SQLStatement extends EventDispatcher
{

	public var executing(get, null):Bool;
	public var itemClass:Class<Dynamic>;
	public var parameters(get, null):Object;
	public var sqlConnection(get, set):SQLConnection;
	public var text:String;

	private var __sqlConnection:SQLConnection;
	private var __executing:Bool = false;
	private var __connection:Connection;
	private var __resultSet:ResultSet;
	private var __prefetch:Int = 0;
	private var __resultQueue:Deque<Array<String>>;
	private var __async:Bool = false;

	public function new()
	{
		super();
		parameters = new Object();
	}

	public function cancel():Void
	{
		if (executing)
		{
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
		__resultQueue = new Deque();

		for (parameter in parameters)
		{
			__connection.addValue(cast parameter, Reflect.field(parameters, parameter));
		}
		if (__async)
		{
			__sqlConnection.__addToQue(__executeAsync(text, this, prefetch));
		}
		else {
			__prefetch = prefetch;
			__resultSet = __connection.request(text);
			__queueResult();
		}

	}

	private function __executeAsync(sql:String, statement:SQLStatement, prefetch:Int):Function
	{
		return function()
		{
			var event:Event;
			var results:ResultSet;
			try
			{
				results = __connection.request(sql);
				event = new SQLEvent(SQLEvent.RESULT);
			}
			catch (e:Dynamic)
			{
				results = null;
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.RESULT, "Execution failed"));
			}

			var message:Object = new Object();
			message.type = 0;
			message.statement = statement;
			message.event = event;
			message.results = results;
			message.prefetch = prefetch;

			__sqlConnection.__sqlWorker.sendProgress(message);
		}
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

		if (results != null)
		{
			var sqlResult:SQLResult = new SQLResult(results, __resultSet.length, complete, __connection.lastInsertId());

			return sqlResult;
		}

		return null;
	}

	public function next(prefetch:Int = -1):Void
	{
		if (__async)
		{
			__sqlConnection.__addToQue(__nextAsync(this, prefetch));
		}
		else {
			if (__resultSet != null)
			{
				__prefetch = prefetch;

				if (__resultSet.hasNext())
				{
					__queueResult();
				}
				else
				{
					__executing = false;
					__prefetch = 0;
				}
			}
			else {
				throw "SQLite Error - invalid result set";
			}
		}
	}

	private function __nextAsync(statement:SQLStatement, prefetch:Int):Function
	{
		return function()
		{
			var event:Event;
			var results:ResultSet;
			var isExecuting:Bool = false;

			try
			{
				if (__resultSet != null)
				{
					var hasNext:Bool = __resultSet.hasNext();
					
					if (hasNext)
					{
						isExecuting = true;
					}
					else
					{
						prefetch = 0;
					}
				}
				event = new SQLEvent(SQLEvent.RESULT);
			}
			catch (e:Dynamic)
			{
				isExecuting = false;
				event = new SQLErrorEvent(SQLErrorEvent.ERROR, new SQLError(SQLEvent.RESULT, "Execution failed"));
			}

			var message:Object = new Object();
			message.type = 1;
			message.statement = statement;
			message.event = event;
			message.prefetch = prefetch;
			message.executing = isExecuting;
			
			__sqlConnection.__sqlWorker.sendProgress(message);
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
		if (value != null)
		{
			__async = value.__async;
			__connection = value.__connection;
		}
		else {
			__connection = null;
			__async = false;
		}
		return __sqlConnection = value;
	}

	private function get_sqlConnection():SQLConnection
	{
		return __sqlConnection;
	}

}