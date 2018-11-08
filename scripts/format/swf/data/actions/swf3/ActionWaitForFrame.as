package format.swf.data.actions.swf3
{
	import format.swf.data.actions.*;
	import com.codeazur.hxswf.SWFData;
	
	class ActionWaitForFrame extends Action implements IAction
	{
		public static inline var CODE:Int = 0x8a;
		
		public var frame:Int;
		public var skipCount:Int;
		
		public function ActionWaitForFrame(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			frame = data.readUI16();
			skipCount = data.readUI8();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeUI16(frame);
			body.writeUI8(skipCount);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionWaitForFrame = new ActionWaitForFrame(code, length, pos);
			action.frame = frame;
			action.skipCount = skipCount;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionWaitForFrame] Frame: " + frame + ", SkipCount: " + skipCount;
		}
	}
}
