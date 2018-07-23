package format.swf.data.actions.swf5
{
	import format.swf.data.actions.*;
	
	class ActionDelete extends Action implements IAction
	{
		public static inline var CODE:Int = 0x3a;
		
		public function ActionDelete(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionDelete]";
		}
	}
}
