package format.swf.data.actions.swf4
{
	import com.codeazur.hxswf.SWFData;
	import com.codeazur.hxswf.data.SWFActionValue;
	import format.swf.data.actions.*;
	import com.codeazur.utils.StringUtils;
	
	class ActionPush extends Action implements IAction
	{
		public static inline var CODE:Int = 0x96;
		
		public var values:Array<SWFActionValue>;
		
		public function ActionPush(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
			values = new Array<SWFActionValue>();
		}
		
		override public function parse(data:SWFData):Void {
			var endPosition:Int = data.position + length;
			while (data.position != endPosition) {
				values.push(data.readACTIONVALUE());
			}
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			for (var i:Int = 0; i < values.length; i++) {
				body.writeACTIONVALUE(values[i]);
			}
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionPush = new ActionPush(code, length, pos);
			for (var i:Int = 0; i < values.length; i++) {
				action.values.push(values[i].clone());
			}
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			return "[ActionPush] " + values.join(", ");
		}
	}
}
