package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	import com.codeazur.hxswf.SWFData;
	
	class ActionGotoFrame2 extends Action implements IAction
	{
		public static inline var CODE:Int = 0x9f;
		
		public var sceneBiasFlag:Bool;
		public var playFlag:Bool;
		public var sceneBias:Int;
		
		public function ActionGotoFrame2(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			var flags:Int = data.readUI8();
			sceneBiasFlag = ((flags & 0x02) != 0);
			playFlag = ((flags & 0x01) != 0);
			if (sceneBiasFlag) {
				sceneBias = data.readUI16();
			}
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			var flags:Int = 0;
			if (sceneBiasFlag) { flags |= 0x02; }
			if (playFlag) { flags |= 0x01; }
			body.writeUI8(flags);
			if (sceneBiasFlag) { 
				body.writeUI16(sceneBias);
			}
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGotoFrame2 = new ActionGotoFrame2(code, length, pos);
			action.sceneBiasFlag = sceneBiasFlag;
			action.playFlag = playFlag;
			action.sceneBias = sceneBias;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			var str:String = "[ActionGotoFrame2] " +
				"PlayFlag: " + playFlag + ", ";
				"SceneBiasFlag: " + sceneBiasFlag;
			if (sceneBiasFlag) {
				str += ", " + sceneBias;
			}
			return str;
		}
	}
}
