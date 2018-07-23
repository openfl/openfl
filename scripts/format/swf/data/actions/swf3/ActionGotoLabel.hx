package format.swf.data.actions.swf3
{
	import format.swf.data.actions.*;
	import com.codeazur.hxswf.SWFData;
	
	class ActionGotoLabel extends Action implements IAction
	{
		public static inline var CODE:Int = 0x8c;
		
		public var label:String;
		
		public function ActionGotoLabel(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
		}
		
		override public function parse(data:SWFData):Void {
			label = data.readString();
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			body.writeString(label);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGotoLabel = new ActionGotoLabel(code, length, pos);
			action.label = label;
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionGotoLabel] Label: " + label;
		}
	}
}
