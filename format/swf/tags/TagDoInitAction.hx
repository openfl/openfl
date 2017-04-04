package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.actions.IAction;
import format.swf.utils.StringUtils;

class TagDoInitAction extends TagDoAction implements ITag
{
	public static inline var TYPE:Int = 59;
	
	public var spriteId:Int;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DoInitAction";
		version = 6;
		level = 1;
		
		//trace("Hello TagDoInitAction");
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		spriteId = data.readUI16();
		var action:IAction;
		while ((action = data.readACTIONRECORD()) != null) {
			actions.push(action);
		}
	}

	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(spriteId);
		for (i in 0...actions.length) {
			body.writeACTIONRECORD(actions[i]);
		}
		body.writeUI8(0);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"SpriteID: " +spriteId + ", ";
			"Records: " + actions.length;
		for (i in 0...actions.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + actions[i].toString(indent + 2);
		}
		return str;
	}
}