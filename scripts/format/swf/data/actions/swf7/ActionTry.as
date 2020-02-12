package format.swf.data.actions.swf7
{
	import com.codeazur.hxswf.SWFData;
	import format.swf.data.actions.*;
	import com.codeazur.utils.StringUtils;
	
	class ActionTry extends Action implements IAction
	{
		public static inline var CODE:Int = 0x8f;
		
		public var catchInRegisterFlag:Bool;
		public var finallyBlockFlag:Bool;
		public var catchBlockFlag:Bool;
		public var catchName:String;
		public var catchRegister:Int;
		public var tryBody:Array<IAction>;
		public var catchBody:Array<IAction>;
		public var finallyBody:Array<IAction>;
		
		public function ActionTry(code:Int, length:Int, pos:Int)
		{
			super(code, length, pos);
			tryBody = new Array<IAction>();
			catchBody = new Array<IAction>();
			finallyBody = new Array<IAction>();
		}
		
		override public function parse(data:SWFData):Void {
			var flags:Int = data.readUI8();
			catchInRegisterFlag = ((flags & 0x04) != 0);
			finallyBlockFlag = ((flags & 0x02) != 0);
			catchBlockFlag = ((flags & 0x01) != 0);
			var trySize:Int = data.readUI16();
			var catchSize:Int = data.readUI16();
			var finallySize:Int = data.readUI16();
			if (catchInRegisterFlag) {
				catchRegister = data.readUI8();
			} else {
				catchName = data.readString();
			}
			var tryEndPosition:Int = data.position + trySize;
			while (data.position < tryEndPosition) {
				tryBody.push(data.readACTIONRECORD());
			}
			var catchEndPosition:Int = data.position + catchSize;
			while (data.position < catchEndPosition) {
				catchBody.push(data.readACTIONRECORD());
			}
			var finallyEndPosition:Int = data.position + finallySize;
			while (data.position < finallyEndPosition) {
				finallyBody.push(data.readACTIONRECORD());
			}
		}
		
		override public function publish(data:SWFData):Void {
			var i:Int;
			var body:SWFData = new SWFData();
			var flags:Int = 0;
			if (catchInRegisterFlag) { flags |= 0x04; }
			if (finallyBlockFlag) { flags |= 0x02; }
			if (catchBlockFlag) { flags |= 0x01; }
			body.writeUI8(flags);
			var bodyTryActions:SWFData = new SWFData();
			for (i = 0; i < tryBody.length; i++) {
				bodyTryActions.writeACTIONRECORD(tryBody[i]);
			}
			var bodyCatchActions:SWFData = new SWFData();
			for (i = 0; i < catchBody.length; i++) {
				bodyCatchActions.writeACTIONRECORD(catchBody[i]);
			}
			var bodyFinallyActions:SWFData = new SWFData();
			for (i = 0; i < finallyBody.length; i++) {
				bodyFinallyActions.writeACTIONRECORD(finallyBody[i]);
			}
			body.writeUI16(bodyTryActions.length);
			body.writeUI16(bodyCatchActions.length);
			body.writeUI16(bodyFinallyActions.length);
			if (catchInRegisterFlag) {
				body.writeUI8(catchRegister);
			} else {
				body.writeString(catchName);
			}
			body.writeBytes(bodyTryActions);
			body.writeBytes(bodyCatchActions);
			body.writeBytes(bodyFinallyActions);
			write(data, body);
		}
		
		override public function clone():IAction {
			var i:Int;
			var action:ActionTry = new ActionTry(code, length, pos);
			action.catchInRegisterFlag = catchInRegisterFlag;
			action.finallyBlockFlag = finallyBlockFlag;
			action.catchBlockFlag = catchBlockFlag;
			action.catchName = catchName;
			action.catchRegister = catchRegister;
			for (i = 0; i < tryBody.length; i++) {
				action.tryBody.push(tryBody[i].clone());
			}
			for (i = 0; i < catchBody.length; i++) {
				action.catchBody.push(catchBody[i].clone());
			}
			for (i = 0; i < finallyBody.length; i++) {
				action.finallyBody.push(finallyBody[i].clone());
			}
			return action;
		}
		
		override public function toString(indent:Int = 0):String {
			var str:String = "[ActionTry] ";
			str += (catchInRegisterFlag) ? "Register: " + catchRegister : "Name: " + catchName;
			var i:Int;
			if (tryBody.length) {
				str += "\n" + StringUtils.repeat(indent + 2) + "Try:";
				for (i = 0; i < tryBody.length; i++) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + tryBody[i].toString(indent + 4);
				}
			}
			if (catchBody.length) {
				str += "\n" + StringUtils.repeat(indent + 2) + "Catch:";
				for (i = 0; i < catchBody.length; i++) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + catchBody[i].toString(indent + 4);
				}
			}
			if (finallyBody.length) {
				str += "\n" + StringUtils.repeat(indent + 2) + "Finally:";
				for (i = 0; i < finallyBody.length; i++) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + finallyBody[i].toString(indent + 4);
				}
			}
			return str;
		}
	}
}
