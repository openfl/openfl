package format.swf.data.actions.swf6
{
	import format.swf.data.actions.*;
	
	class ActionStringGreater extends Action implements IAction
	{
		public static inline var CODE:Int = 0x68;
		
		public function ActionStringGreater(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionStringGreater]";
		}
	}
}
