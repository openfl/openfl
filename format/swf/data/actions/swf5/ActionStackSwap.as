package format.swf.data.actions.swf5
{
	import format.swf.data.actions.*;
	
	class ActionStackSwap extends Action implements IAction
	{
		public static inline var CODE:Int = 0x4d;
		
		public function ActionStackSwap(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionStackSwap]";
		}
	}
}
