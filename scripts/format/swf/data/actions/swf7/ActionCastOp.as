package format.swf.data.actions.swf7
{
	import format.swf.data.actions.*;
	
	class ActionCastOp extends Action implements IAction
	{
		public static inline var CODE:Int = 0x2b;
		
		public function ActionCastOp(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionCastOp]";
		}
	}
}
