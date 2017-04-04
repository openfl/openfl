package format.swf.data.actions.swf4
{
	import format.swf.data.actions.*;
	import com.codeazur.hxswf.SWFData;
	
	class ActionJump extends Action implements IAction
	{
		public static inline var CODE:Int = 0x99;
		
		public var branchOffset:Int;
		
		public function ActionJump(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			branchOffset = data.readSI16();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeSI16(branchOffset);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionJump = new ActionJump(code, length, pos);
			action.branchOffset = branchOffset;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionJump] BranchOffset: " + branchOffset;
		}
	}
}
