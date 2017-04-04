package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	
	class ActionCall extends Action implements IAction
	{
		public static inline var CODE:Int = 0x9e;
		
		public function ActionCall(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionCall]";
		}
	}
}
