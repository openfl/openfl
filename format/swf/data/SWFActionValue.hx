package format.swf.data;

import flash.errors.Error;
import format.swf.SWFData;
import format.swf.data.consts.ActionValueType;
import format.swf.utils.StringUtils;

import flash.utils.ByteArray;
import flash.utils.Endian;

class SWFActionValue
{
	public var type:Int;
	public var string:String;
	public var number:Float;
	public var register:Int;
	public var boolean:Bool;
	public var integer:Int;
	public var constant:Int;
	
	private static var ba:ByteArray = initTmpBuffer();
	
	private static function initTmpBuffer():ByteArray {
		var baTmp:ByteArray = new ByteArray();
		baTmp.endian = Endian.LITTLE_ENDIAN;
		baTmp.length = 8;
		return baTmp;
	}
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		type = data.readUI8();
		switch (type) {
			case ActionValueType.STRING: string = data.readSTRING();
			case ActionValueType.FLOAT: number = data.readFLOAT();
			case ActionValueType.NULL:
			case ActionValueType.UNDEFINED:
			case ActionValueType.REGISTER: register = data.readUI8();
			case ActionValueType.BOOLEAN: boolean = (data.readUI8() != 0);
			case ActionValueType.DOUBLE:
				ba.position = 0;
				ba[4] = data.readUI8();
				ba[5] = data.readUI8();
				ba[6] = data.readUI8();
				ba[7] = data.readUI8();
				ba[0] = data.readUI8();
				ba[1] = data.readUI8();
				ba[2] = data.readUI8();
				ba[3] = data.readUI8();
				number = ba.readDouble();
			case ActionValueType.INTEGER: integer = data.readUI32();
			case ActionValueType.CONSTANT_8: constant = data.readUI8();
			case ActionValueType.CONSTANT_16: constant = data.readUI16();
			default:
				throw(new Error("Unknown ActionValueType: " + type));
		}
	}
	
	public function publish(data:SWFData):Void {
		data.writeUI8(type);
		switch (type) {
			case ActionValueType.STRING: data.writeSTRING(string);
			case ActionValueType.FLOAT: data.writeFLOAT(number);
			case ActionValueType.NULL:
			case ActionValueType.UNDEFINED:
			case ActionValueType.REGISTER: data.writeUI8(register);
			case ActionValueType.BOOLEAN: data.writeUI8(boolean ? 1 : 0);
			case ActionValueType.DOUBLE:
				ba.position = 0;
				ba.writeDouble(number);
				data.writeUI8(ba[4]);
				data.writeUI8(ba[5]);
				data.writeUI8(ba[6]);
				data.writeUI8(ba[7]);
				data.writeUI8(ba[0]);
				data.writeUI8(ba[1]);
				data.writeUI8(ba[2]);
				data.writeUI8(ba[3]);
			case ActionValueType.INTEGER: data.writeUI32(integer);
			case ActionValueType.CONSTANT_8: data.writeUI8(constant);
			case ActionValueType.CONSTANT_16: data.writeUI16(constant);
			default:
				throw(new Error("Unknown ActionValueType: " + type));
		}
	}
	
	public function clone():SWFActionValue {
		var value:SWFActionValue = new SWFActionValue();
		switch (type) {
			case ActionValueType.FLOAT, ActionValueType.DOUBLE:
				value.number = number;
			case ActionValueType.CONSTANT_8, ActionValueType.CONSTANT_16:
				value.constant = constant;
			case ActionValueType.NULL:
			case ActionValueType.UNDEFINED:
			case ActionValueType.STRING: value.string = string;
			case ActionValueType.REGISTER: value.register = register;
			case ActionValueType.BOOLEAN: value.boolean = boolean;
			case ActionValueType.INTEGER: value.integer = integer;
			default:
				throw(new Error("Unknown ActionValueType: " + type));
		}
		return value;
	}
	
	public function toString():String {
		var str:String = "";
		switch (type) {
			case ActionValueType.STRING: str = StringUtils.simpleEscape(string) + " (string)";
			case ActionValueType.FLOAT: str = number + " (float)";
			case ActionValueType.NULL: str = "null"; 
			case ActionValueType.UNDEFINED: str = "undefined"; 
			case ActionValueType.REGISTER: str = register + " (register)";
			case ActionValueType.BOOLEAN: str = boolean + " (boolean)";
			case ActionValueType.DOUBLE: str = number + " (double)";
			case ActionValueType.INTEGER: str = integer + " (integer)";
			case ActionValueType.CONSTANT_8: str = constant + " (constant8)";
			case ActionValueType.CONSTANT_16: str = constant + " (constant16)";
			default:
				str = "unknown";
		}
		return str;
	}
}