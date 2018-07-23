package format.swf.data.actions.swf6
{
	import format.swf.data.actions.*;
	
	class ActionStrictEquals extends Action implements IAction
	{
		public static inline var CODE:Int = 0x66;
		
		public function ActionStrictEquals(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionStrictEquals]";
		}
	}
}
