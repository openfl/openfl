package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	
	class ActionAdd extends Action implements IAction
	{
		public static inline var CODE:Int = 0x0a;
		
		public function ActionAdd(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionAdd]";
		}
	}
}
