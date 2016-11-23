package format.swf.data.actions.swf3
{
	import format.swf.data.actions.*;
	
	class ActionStopSounds extends Action implements IAction
	{
		public static inline var CODE:Int = 0x09;
		
		public function ActionStopSounds(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionStopSounds]";
		}
	}
}
