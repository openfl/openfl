package format.swf.data.actions.swf3
{
	import format.swf.data.actions.*;
	
	class ActionToggleQuality extends Action implements IAction
	{
		public static inline var CODE:Int = 0x08;
		
		public function ActionToggleQuality(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionToggleQuality]";
		}
	}
}
