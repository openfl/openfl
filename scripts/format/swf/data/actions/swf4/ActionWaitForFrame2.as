package format.swf.data.actions.swf4
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	
	class ActionWaitForFrame2 extends Action implements IAction
	{
		public static inline var CODE:Int = 0x8d;
		
		public var skipCount:Int;
		
		public function ActionWaitForFrame2(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			skipCount = data.readUI8();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeUI8(skipCount);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionWaitForFrame2 = new ActionWaitForFrame2(code, length, pos);
			action.skipCount = skipCount;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionWaitForFrame2] SkipCount: " + skipCount;
		}
	}
}
