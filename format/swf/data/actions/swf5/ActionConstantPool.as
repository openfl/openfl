package format.swf.data.actions.swf5
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	import com.codeazur.utils.StringUtils;
	
	class ActionConstantPool extends Action implements IAction
	{
		public static inline var CODE:Int = 0x88;
		
		public var constants:Array<String>;
		
		public function ActionConstantPool(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
			constants = new Array<String>();
		}
		
		override public function parse(data:SWFData):Void {
			var count:Int = data.readUI16();
			for (var i:Int = 0; i < count; i++) {
				constants.push(data.readString());
			}
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeUI16(constants.length);
			for (var i:Int = 0; i < constants.length; i++) {
				body.writeString(constants[i]);
			}
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionConstantPool = new ActionConstantPool(code, length, pos);
			for (var i:Int = 0; i < constants.length; i++) {
				action.constants.push(constants[i]);
			}
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			var str:String = "[ActionConstantPool] Values: " + constants.length;
			for (var i:Int = 0; i < constants.length; i++) {
				str += "\n" + StringUtils.repeat(indent + 4) + i + ": " + StringUtils.simpleEscape(constants[i]);
			}
			return str;
		}
	}
}
