package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.actions.IAction;
import format.swf.utils.StringUtils;

class TagDoAction implements ITag
{
	public static inline var TYPE:Int = 12;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var actions (default, null):Array<IAction>;
	
	public function new() {
		type = TYPE;
		name = "DoAction";
		version = 3;
		level = 1;
		actions = new Array<IAction>();
		
		//trace("Hello TagDoAction");
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var action:IAction;
		while ((action = data.readACTIONRECORD()) != null) {
			actions.push(action);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		for (i in 0...actions.length) {
			body.writeACTIONRECORD(actions[i]);
		}
		body.writeUI8(0);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		for (i in 0...actions.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + actions[i].toString(indent + 2);
		}
		return str;
	}
}