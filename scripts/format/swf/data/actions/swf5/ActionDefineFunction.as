package com.codeazur.as3swf.data.actions.swf5
{
	import com.codeazur.as3swf.SWFData;
	import com.codeazur.as3swf.data.actions.Action;
	import com.codeazur.as3swf.data.actions.IAction;
	import com.codeazur.utils.StringUtils;
	
	public class ActionDefineFunction extends Action implements IAction
	{
		public static const CODE:uint = 0x9b;
		
		public var functionName:String;
		public var functionParams:Vector.<String>;
		public var functionBody:Vector.<IAction>;
		
		public function ActionDefineFunction(code:uint, length:uint, pos:uint) {
			super(code, length, pos);
			functionParams = new Vector.<String>();
			functionBody = new Vector.<IAction>();
		}
		
		override public function parse(data:SWFData):void {
			functionName = data.readString();
			var count:uint = data.readUI16();
			for (var i:uint = 0; i < count; i++) {
				functionParams.push(data.readString());
			}
			var codeSize:uint = data.readUI16();
			var bodyEndPosition:uint = data.position + codeSize;
			while (data.position < bodyEndPosition) {
				functionBody.push(data.readACTIONRECORD());
			}
		}
		
		override public function publish(data:SWFData):void {
			var i:uint;
			var body:SWFData = new SWFData();
			body.writeString(functionName);
			body.writeUI16(functionParams.length);
			for (i = 0; i < functionParams.length; i++) {
				body.writeString(functionParams[i]);
			}
			var bodyActions:SWFData = new SWFData();
			for (i = 0; i < functionBody.length; i++) {
				bodyActions.writeACTIONRECORD(functionBody[i]);
			}
			body.writeUI16(bodyActions.length);
			write(data, body);
			data.writeBytes(bodyActions);
		}
		
		override public function clone():IAction {
			var i:uint;
			var action:ActionDefineFunction = new ActionDefineFunction(code, length, pos);
			action.functionName = functionName;
			for (i = 0; i < functionParams.length; i++) {
				action.functionParams.push(functionParams[i]);
			}
			for (i = 0; i < functionBody.length; i++) {
				action.functionBody.push(functionBody[i].clone());
			}
			return action;
		}
		
		override public function toString(indent:uint = 0):String {
			var str:String = "[ActionDefineFunction] " + 
				((functionName == null || functionName.length == 0) ? "<anonymous>" : functionName) +
				"(" + functionParams.join(", ") + ")";
			for (var i:uint = 0; i < functionBody.length; i++) {
				if(functionBody[i]) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + functionBody[i].toString(indent + 4);
				}
			}
			return str;
		}
	}
}