package com.codeazur.as3swf.data.actions.swf7
{
	import com.codeazur.as3swf.SWFData;
	import com.codeazur.as3swf.data.SWFRegisterParam;
	import com.codeazur.as3swf.data.actions.Action;
	import com.codeazur.as3swf.data.actions.IAction;
	import com.codeazur.utils.StringUtils;
	
	public class ActionDefineFunction2 extends Action implements IAction
	{
		public static const CODE:uint = 0x8e;
		
		public var functionName:String;
		public var functionParams:Vector.<SWFRegisterParam>;
		public var functionBody:Vector.<IAction>;
		public var registerCount:uint;
		
		public var preloadParent:Boolean;
		public var preloadRoot:Boolean;
		public var preloadSuper:Boolean;
		public var preloadArguments:Boolean;
		public var preloadThis:Boolean;
		public var preloadGlobal:Boolean;
		public var suppressSuper:Boolean;
		public var suppressArguments:Boolean;
		public var suppressThis:Boolean;
		
		public function ActionDefineFunction2(code:uint, length:uint, pos:uint) {
			super(code, length, pos);
			functionParams = new Vector.<SWFRegisterParam>();
			functionBody = new Vector.<IAction>();
		}
		
		override public function parse(data:SWFData):void {
			functionName = data.readString();
			var numParams:uint = data.readUI16();
			registerCount = data.readUI8();
			var flags1:uint = data.readUI8();
			preloadParent = ((flags1 & 0x80) != 0);
			preloadRoot = ((flags1 & 0x40) != 0);
			suppressSuper = ((flags1 & 0x20) != 0);
			preloadSuper = ((flags1 & 0x10) != 0);
			suppressArguments = ((flags1 & 0x08) != 0);
			preloadArguments = ((flags1 & 0x04) != 0);
			suppressThis = ((flags1 & 0x02) != 0);
			preloadThis = ((flags1 & 0x01) != 0);
			var flags2:uint = data.readUI8();
			preloadGlobal = ((flags2 & 0x01) != 0);
			for (var i:uint = 0; i < numParams; i++) {
				functionParams.push(data.readREGISTERPARAM());
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
			body.writeUI8(registerCount);
			var flags1:uint = 0;
			if (preloadParent) { flags1 |= 0x80; }
			if (preloadRoot) { flags1 |= 0x40; }
			if (suppressSuper) { flags1 |= 0x20; }
			if (preloadSuper) { flags1 |= 0x10; }
			if (suppressArguments) { flags1 |= 0x08; }
			if (preloadArguments) { flags1 |= 0x04; }
			if (suppressThis) { flags1 |= 0x02; }
			if (preloadThis) { flags1 |= 0x01; }
			body.writeUI8(flags1);
			var flags2:uint = 0;
			if (preloadGlobal) { flags2 |= 0x01; }
			body.writeUI8(flags2);
			for (i = 0; i < functionParams.length; i++) {
				body.writeREGISTERPARAM(functionParams[i]);
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
			var action:ActionDefineFunction2 = new ActionDefineFunction2(code, length, pos);
			action.functionName = functionName;
			for (i = 0; i < functionParams.length; i++) {
				action.functionParams.push(functionParams[i]);
			}
			for (i = 0; i < functionBody.length; i++) {
				action.functionBody.push(functionBody[i].clone());
			}
			action.registerCount = registerCount;
			action.preloadParent = preloadParent;
			action.preloadRoot = preloadRoot;
			action.preloadSuper = preloadSuper;
			action.preloadArguments = preloadArguments;
			action.preloadThis = preloadThis;
			action.preloadGlobal = preloadGlobal;
			action.suppressSuper = suppressSuper;
			action.suppressArguments = suppressArguments;
			action.suppressThis = suppressThis;
			return action;
		}
		
		override public function toString(indent:uint = 0):String {
			var str:String = "[ActionDefineFunction2] " + 
				((functionName == null || functionName.length == 0) ? "<anonymous>" : functionName) +
				"(" + functionParams.join(", ") + "), ";
			var a:Array = [];
			if (preloadParent) { a.push("preloadParent"); }
			if (preloadRoot) { a.push("preloadRoot"); }
			if (preloadSuper) { a.push("preloadSuper"); }
			if (preloadArguments) { a.push("preloadArguments"); }
			if (preloadThis) { a.push("preloadThis"); }
			if (preloadGlobal) { a.push("preloadGlobal"); }
			if (suppressSuper) { a.push("suppressSuper"); }
			if (suppressArguments) { a.push("suppressArguments"); }
			if (suppressThis) { a.push("suppressThis"); }
			if (a.length == 0) { a.push("none"); }
			str += "Flags: " + a.join(",");
			for (var i:uint = 0; i < functionBody.length; i++) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + functionBody[i].toString(indent + 4);
			}
			return str;
		}
	}
}