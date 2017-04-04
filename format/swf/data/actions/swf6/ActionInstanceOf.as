package format.swf.data.actions.swf6
{
	import format.swf.data.actions.*;
	
	class ActionInstanceOf extends Action implements IAction
	{
		public static inline var CODE:Int = 0x54;
		
		public function ActionInstanceOf(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionInstanceOf]";
		}
	}
}
