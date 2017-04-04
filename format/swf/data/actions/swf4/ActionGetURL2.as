package format.swf.data.actions.swf4
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	
	class ActionGetURL2 extends Action implements IAction
	{
		public static inline var CODE:Int = 0x9a;
		
		public var sendVarsMethod:Int;
		public var reserved:Int;
		public var loadTargetFlag:Bool;
		public var loadVariablesFlag:Bool;
		
		public function ActionGetURL2(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			sendVarsMethod = data.readUB(2);
			reserved = data.readUB(4); // reserved, always 0
			loadTargetFlag = (data.readUB(1) == 1);
			loadVariablesFlag = (data.readUB(1) == 1);
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeUB(2, sendVarsMethod);
			body.writeUB(4, reserved); // reserved, always 0
			body.writeUB(1, loadTargetFlag ? 1 : 0);
			body.writeUB(1, loadVariablesFlag ? 1 : 0);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGetURL2 = new ActionGetURL2(code, length, pos);
			action.sendVarsMethod = sendVarsMethod;
			action.reserved = reserved;
			action.loadTargetFlag = loadTargetFlag;
			action.loadVariablesFlag = loadVariablesFlag;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionGetURL2] " +
				"SendVarsMethod: " + sendVarsMethod + " (" + sendVarsMethodToString() + "), " +
				"Reserved: " + reserved + ", " +
				"LoadTargetFlag: " + loadTargetFlag + ", " +
				"LoadVariablesFlag: " + loadVariablesFlag;
		}
		
		public function sendVarsMethodToString():String {
			if (!sendVarsMethod) {
				return "None";
			}
			else if (sendVarsMethod == 1) {
				return "GET";
			}
			else if (sendVarsMethod == 2) {
				return "POST";
			}
			else {
				throw new Error("sendVarsMethod is only defined for values of 0, 1, and 2.");
			}
		}
	}
}
