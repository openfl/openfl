package format.swf.data.actions;

import format.swf.SWFData;
import flash.errors.Error;
import flash.Vector;

class Action implements IAction
{
	public var code (default, null):Int;
	public var length(default, null):Int;
	public var lengthWithHeader(get, null):Int;
	public var pos(default, null):Int;
	
	private function get_lengthWithHeader():Int { return length + (code >= 0x80 ? 3 : 1); }
	
	public function new(code:Int, length:Int, pos:Int) {
		this.code = code;
		this.length = length;
		this.pos = pos;
	}

	public function parse(data:SWFData):Void {
		// Do nothing. Many Actions don't have a payload. 
		// For the ones that have one we override this method.
	}
	
	public function publish(data:SWFData):Void {
		write(data);
	}
	
	public function clone():IAction {
		return new Action(code, length, pos);
	}
	
	private function write(data:SWFData, body:SWFData = null):Void {
		data.writeUI8(code);
		if (code >= 0x80) {
			if (body != null && body.length > 0) {
				length = body.length;
				data.writeUI16(length);
				data.writeBytes(body);
			} else {
				length = 0;
				throw(new Error("Action body null or empty."));
			}
		} else {
			length = 0;
		}
	}
	
	public function toString(indent:Int = 0):String {
		return "[Action] Code: " + StringTools.hex (code) + ", Length: " + length;
	}
	
	public static function resolveOffsets(actions:Vector<IAction>):Void {
		var action:IAction;
		var n:Int = actions.length;
		for (i in 0...n) {
			action = actions[i];
			if (Std.is (action, IActionBranch)) {
				var j:Int = 0;
				var found:Bool = false;
				var actionBranch:IActionBranch = cast action;
				var targetPos:Int = actionBranch.pos + actionBranch.lengthWithHeader + actionBranch.branchOffset;
				if (targetPos <= actionBranch.pos) {
					j = i;
					while (j >= 0) {
						if (targetPos == actions[j].pos) {
							found = true;
							break;
						}
						j--;
					}
				} else {
					while (j < n) {
						if (targetPos == actions[j].pos) {
							found = true;
							break;
						}
						j++;
					}
					if (!found) {
						action = actions[j - 1];
						if (targetPos == action.pos + action.lengthWithHeader) {
							j = -1; // End of execution block
							found = true;
						}
					}
				}
				actionBranch.branchIndex = found ? j : -2;
			}
		}
	}
}