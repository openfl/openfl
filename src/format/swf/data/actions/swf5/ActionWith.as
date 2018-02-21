package format.swf.data.actions.swf5
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	import com.codeazur.utils.StringUtils;
	
	class ActionWith extends Action implements IAction
	{
		public static inline var CODE:Int = 0x94;
		
		public var withBody:Array<IAction>;
		
		public function ActionWith(code:Int, length:Int, pos:Int) {
			super(code, length, pos);
			withBody = new Array<IAction>();
		}
		
		override public function parse(data:SWFData):Void {
			var codeSize:Int = data.readUI16();
			var bodyEndPosition:Int = data.position + codeSize;
			while (data.position < bodyEndPosition) {
				withBody.push(data.readACTIONRECORD());
			}
		}
		
		override public function publish(data:SWFData):Void {
			var body:SWFData = new SWFData();
			var bodyActions:SWFData = new SWFData();
			for (var i:Int = 0; i < withBody.length; i++) {
				bodyActions.writeACTIONRECORD(withBody[i]);
			}
			body.writeUI16(bodyActions.length);
			body.writeBytes(bodyActions);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionWith = new ActionWith(code, length, pos);
			for (var i:Int = 0; i < withBody.length; i++) {
				action.withBody.push(withBody[i].clone());
			}
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			var str:String = "[ActionWith]";
			for (var i:Int = 0; i < withBody.length; i++) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + withBody[i].toString(indent + 4);
			}
			return str;
		}
	}
}
