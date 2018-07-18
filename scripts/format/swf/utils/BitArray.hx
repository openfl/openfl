package format.swf.utils;

import openfl.utils.ByteArray;
import haxe.crypto.BaseCode;

class BitArray extends ByteArrayData
{
	private var bitsPending:Int = 0;
	
	public function readBits(bits:Int, bitBuffer:Int = 0):Int {
		if (bits == 0) { return bitBuffer; }
		var partial:Int;
		var bitsConsumed:Int;
		if (bitsPending > 0) {
			var byte:Int = this.get (position - 1) & (0xff >> (8 - bitsPending));
			bitsConsumed = Std.int (Math.min(bitsPending, bits));
			bitsPending -= bitsConsumed;
			partial = byte >> bitsPending;
		} else {
			bitsConsumed = Std.int (Math.min(8, bits));
			bitsPending = 8 - bitsConsumed;
			partial = readUnsignedByte() >> bitsPending;
		}
		bits -= bitsConsumed;
		bitBuffer = (bitBuffer << bitsConsumed) | partial;
		return (bits > 0) ? readBits(bits, bitBuffer) : bitBuffer;
	}
	
	public function writeBits(bits:Int, value:Int):Void {
		if (bits == 0) { return; }
		value &= (0xffffffff >>> (32 - bits));
		var bitsConsumed:Int;
		if (bitsPending > 0) {
			#if cpp
			if (bitsPending > bits) {
				position --;
				var setValue = readInt();
				setValue |= value << (bitsPending - bits);
				position --;
				writeInt (setValue);
				bitsConsumed = bits;
				bitsPending -= bits;
			} else if (bitsPending == bits) {
				position --;
				var setValue = readInt();
				setValue |= value;
				position --;
				writeInt(setValue);
				bitsConsumed = bits;
				bitsPending = 0;
			} else {
				position --;
				var setValue = readInt();
				setValue |= value >> (bits - bitsPending);
				position --;
				writeInt (setValue);
				bitsConsumed = bitsPending;
				bitsPending = 0;
			}
			#else
			if (bitsPending > bits) {
				this.set (position - 1, this.get (position - 1) | value << (bitsPending - bits));
				bitsConsumed = bits;
				bitsPending -= bits;
			} else if (bitsPending == bits) {
				this.set (position - 1, this.get (position - 1) | value);
				bitsConsumed = bits;
				bitsPending = 0;
			} else {
				this.set (position - 1, this.get (position - 1) | value >> (bits - bitsPending));
				bitsConsumed = bitsPending;
				bitsPending = 0;
			}
			#end
		} else {
			bitsConsumed = Std.int (Math.min(8, bits));
			bitsPending = 8 - bitsConsumed;
			writeByte((value >> (bits - bitsConsumed)) << bitsPending);
		}
		bits -= bitsConsumed;
		if (bits > 0) {
			writeBits(bits, value);
		}
	}
	
	public function resetBitsPending():Void {
		bitsPending = 0;
	}
	
	public function calculateMaxBits(signed:Bool, values:Array<Int>):Int {
		var b:Int = 0;
		//var vmax:Int = int.MIN_VALUE;
		var vmax:Int = Std.int (SWFData.MIN_FLOAT_VALUE);
		if(!signed) {
			for (usvalue in values) {
				b |= usvalue;
			}
		} else {
			for (svalue in values) {
				if(svalue >= 0) {
					b |= svalue;
				} else {
					b |= ~svalue << 1;
				}
				if(vmax < svalue) {
					vmax = svalue;
				}
			}
		}
		var bits:Int = 0;
		if(b > 0) {
			bits = BaseCode.encode (Std.string (b), "01").length;
			if(signed && vmax > 0 && BaseCode.encode (Std.string (vmax), "01").length >= bits) {
				bits++;
			}
		}
		return bits;
	}
	
	#if flash
	private function get (pos:UInt):UInt {
		return this[pos];
	}
	
	private function set (pos:UInt, value:UInt):UInt {
		return this[pos] = value;
	}
	#end
}