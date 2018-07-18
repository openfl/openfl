package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	
	class ActionMBAsciiToChar extends Action implements IAction
	{
		public static inline var CODE:Int = 0x37;
		
		public function ActionMBAsciiToChar(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionMBAsciiToChar]";
		}
	}
}
