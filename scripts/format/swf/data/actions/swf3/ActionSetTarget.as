package format.swf.data.actions.swf3
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	
	class ActionSetTarget extends Action implements IAction
	{
		public static inline var CODE:Int = 0x8b;
		
		public var targetName:String;
		
		public function ActionSetTarget(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			targetName = data.readString();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeString(targetName);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionSetTarget = new ActionSetTarget(code, length, pos);
			action.targetName = targetName;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionSetTarget] TargetName: " + targetName;
		}
	}
}
