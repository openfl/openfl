package format.swf.data.actions.swf3
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	
	class ActionGotoFrame extends Action implements IAction
	{
		public static inline var CODE:Int = 0x81;
		
		public var frame:Int;
		
		public function ActionGotoFrame(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			frame = data.readUI16();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeUI16(frame);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGotoFrame = new ActionGotoFrame(code, length, pos);
			action.frame = frame;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionGotoFrame] Frame: " + frame;
		}
	}
}
