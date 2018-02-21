package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	
	class ActionAsciiToChar extends Action implements IAction
	{
		public static inline var CODE:Int = 0x33;
		
		public function ActionAsciiToChar(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionAsciiToChar]";
		}
	}
}
