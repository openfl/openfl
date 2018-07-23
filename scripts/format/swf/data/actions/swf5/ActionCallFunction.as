package format.swf.data.actions.swf5
{
	import format.swf.data.actions.*;
	
	class ActionCallFunction extends Action implements IAction
	{
		public static inline var CODE:Int = 0x3d;
		
		public function ActionCallFunction(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionCallFunction]";
		}
	}
}
