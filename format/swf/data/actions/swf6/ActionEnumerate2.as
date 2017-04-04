package format.swf.data.actions.swf6
{
	import format.swf.data.actions.*;
	
	class ActionEnumerate2 extends Action implements IAction
	{
		public static inline var CODE:Int = 0x55;
		
		public function ActionEnumerate2(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionEnumerate2]";
		}
	}
}
