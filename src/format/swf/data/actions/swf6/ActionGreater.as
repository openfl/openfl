package format.swf.data.actions.swf6
{
	import format.swf.data.actions.*;
	
	class ActionGreater extends Action implements IAction
	{
		public static inline var CODE:Int = 0x67;
		
		public function ActionGreater(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionGreater]";
		}
	}
}
