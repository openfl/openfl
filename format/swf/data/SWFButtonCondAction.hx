package format.swf.data;

import format.swf.SWFData;
import format.swf.data.actions.Action;
import format.swf.data.actions.IAction;
import format.swf.utils.StringUtils;
import flash.Vector;

class SWFButtonCondAction
{
	public var condActionSize:Int;
	public var condIdleToOverDown:Bool;
	public var condOutDownToIdle:Bool;
	public var condOutDownToOverDown:Bool;
	public var condOverDownToOutDown:Bool;
	public var condOverDownToOverUp:Bool;
	public var condOverUpToOverDown:Bool;
	public var condOverUpToIdle:Bool;
	public var condIdleToOverUp:Bool;
	public var condOverDownToIdle:Bool;
	public var condKeyPress:Int;

	public var actions(default, null):Vector<IAction>;
	
	public function new(data:SWFData = null) {
		actions = new Vector<IAction>();
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		var flags:Int = (data.readUI8() << 8) | data.readUI8();
		condIdleToOverDown = ((flags & 0x8000) != 0);
		condOutDownToIdle = ((flags & 0x4000) != 0);
		condOutDownToOverDown = ((flags & 0x2000) != 0);
		condOverDownToOutDown = ((flags & 0x1000) != 0);
		condOverDownToOverUp = ((flags & 0x0800) != 0);
		condOverUpToOverDown = ((flags & 0x0400) != 0);
		condOverUpToIdle = ((flags & 0x0200) != 0);
		condIdleToOverUp = ((flags & 0x0100) != 0);
		condOverDownToIdle = ((flags & 0x0001) != 0);
		condKeyPress = (flags & 0xff) >> 1;
		var action:IAction;
		while ((action = data.readACTIONRECORD()) != null) {
			actions.push(action);
		}
		Action.resolveOffsets(actions);
	}
	
	public function publish(data:SWFData):Void {
		var flags1:Int = 0;
		if(condIdleToOverDown) { flags1 |= 0x80; }
		if(condOutDownToIdle) { flags1 |= 0x40; }
		if(condOutDownToOverDown) { flags1 |= 0x20; }
		if(condOverDownToOutDown) { flags1 |= 0x10; }
		if(condOverDownToOverUp) { flags1 |= 0x08; }
		if(condOverUpToOverDown) { flags1 |= 0x04; }
		if(condOverUpToIdle) { flags1 |= 0x02; }
		if(condIdleToOverUp) { flags1 |= 0x01; }
		data.writeUI8(flags1);
		var flags2:Int = condKeyPress << 1;
		if(condOverDownToIdle) { flags2 |= 0x01; }
		data.writeUI8(flags2);
		for(i in 0...actions.length) {
			data.writeACTIONRECORD(actions[i]);
		}
		data.writeUI8(0);
	}
	
	public function clone():SWFButtonCondAction {
		var condAction:SWFButtonCondAction = new SWFButtonCondAction();
		condAction.condActionSize = condActionSize;
		condAction.condIdleToOverDown = condIdleToOverDown;
		condAction.condOutDownToIdle = condOutDownToIdle;
		condAction.condOutDownToOverDown = condOutDownToOverDown;
		condAction.condOverDownToOutDown = condOverDownToOutDown;
		condAction.condOverDownToOverUp = condOverDownToOverUp;
		condAction.condOverUpToOverDown = condOverUpToOverDown;
		condAction.condOverUpToIdle = condOverUpToIdle;
		condAction.condIdleToOverUp = condIdleToOverUp;
		condAction.condOverDownToIdle = condOverDownToIdle;
		condAction.condKeyPress = condKeyPress;
		for(i in 0...actions.length) {
			condAction.actions.push(actions[i].clone());
		}
		return condAction;
	}
	
	public function toString(indent:Int = 0):String {
		var a:Array<String> = [];
		if (condIdleToOverDown) { a.push("idleToOverDown"); }
		if (condOutDownToIdle) { a.push("outDownToIdle"); }
		if (condOutDownToOverDown) { a.push("outDownToOverDown"); }
		if (condOverDownToOutDown) { a.push("overDownToOutDown"); }
		if (condOverDownToOverUp) { a.push("overDownToOverUp"); }
		if (condOverUpToOverDown) { a.push("overUpToOverDown"); }
		if (condOverUpToIdle) { a.push("overUpToIdle"); }
		if (condIdleToOverUp) { a.push("idleToOverUp"); }
		if (condOverDownToIdle) { a.push("overDownToIdle"); }
		var str:String = "Cond: (" + a.join(",") + "), KeyPress: " + condKeyPress;
		for (i in 0...actions.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + actions[i].toString(indent + 2);
		}
		return str;
	}
}