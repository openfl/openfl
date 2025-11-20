package openfl.errors;

/**
 * ...
 * @author Christopher Speciale
 */
class SQLError extends Error
{
	
	public var detailArguments(default, null):Array<String>;
	public var detailID(default, null):Int;
	public var operation(default, null):String;
	
	private var __details:String;
	
	public function new(operation:String, details:String = "", message:String = "", id:Int = 0, detailID:Int = -1, detailArgs:Array<String> = null) 
	{
		super(message, id);
		detailArguments = detailArgs;
		this.detailID = detailID;
		this.operation = operation;
		this.__details = details;
	}
	
	override public function details():String{
		return __details;
	}
	override public function toString():String 
	{
		return super.toString();
	}
	
}