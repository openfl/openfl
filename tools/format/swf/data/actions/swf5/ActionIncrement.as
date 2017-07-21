package format.swf.data.actions.swf5
{
	import format.swf.data.actions.*;
	
	class ActionIncrement extends Action implements IAction
	{
		public static inline var CODE:Int = 0x50;
		
		public function ActionIncrement(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionIncrement]";
		}
	}
}
