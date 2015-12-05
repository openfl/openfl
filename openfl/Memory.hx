package openfl; #if (!display && !flash) #if !openfl_legacy


import haxe.io.BytesData;
import openfl.utils.ByteArray;


class Memory {
	
	
	private static var gcRef:ByteArray;
	private static var len:Int;
	
	
	@:noCompletion static private function _setPositionTemporarily<T> (position:Int, action:Void -> T):T {
		
		var oldPosition:Int = gcRef.position;
		gcRef.position = position;
		var value:T = action ();
		gcRef.position = oldPosition;
		
		return value;
		
	}
	
	
	public static #if !debug inline #end function getByte (addr:Int):Int {
		
		#if debug if (addr < 0 || addr + 1 > len) throw("Bad address"); #end
		
		return gcRef[addr];
		
	}
	
	
	public static #if !debug inline #end function getDouble (addr:Int):Float {
		
		#if debug if (addr < 0 || addr + 8 > len) throw ("Bad address"); #end
		
		return _setPositionTemporarily (addr, function () {
			
			return gcRef.readDouble ();
			
		});
		
	}
	
	
	public static #if !debug inline #end function getFloat (addr:Int):Float {
		
		#if debug if (addr < 0 || addr + 4 > len) throw ("Bad address"); #end
		
		return _setPositionTemporarily (addr, function () {
			
			return gcRef.readFloat ();
			
		});
		
	}
	
	
	public static #if !debug inline #end function getI32 (addr:Int):Int {
		
		#if debug if (addr < 0 || addr + 4 > len) throw ("Bad address"); #end
		
		return _setPositionTemporarily(addr, function () {
			
			return gcRef.readInt ();
			
		});
		
	}
	
	
	public static #if !debug inline #end function getUI16 (addr:Int):Int {
		
		#if debug if (addr < 0 || addr + 2 > len) throw ("Bad address"); #end
		
		return _setPositionTemporarily (addr, function () {
			
			return gcRef.readUnsignedShort ();
			
		});
		
	}
	
	
	public static function select (inBytes:ByteArray):Void {
		
		gcRef = inBytes;
		len = (inBytes != null) ? inBytes.length : 0;
		
	}
	
	
	public static #if !debug inline #end function setByte (addr:Int, v:Int):Void {
		
		#if debug if (addr < 0 || addr + 1 > len) throw ("Bad address"); #end
		
		gcRef[addr] = v;
		
	}
	
	
	public static #if !debug inline #end function setDouble (addr:Int, v:Float):Void {
		
		#if debug if (addr < 0 || addr + 8 > len) throw ("Bad address"); #end
		
		_setPositionTemporarily (addr, function () {
			
			gcRef.writeDouble (v);
			
		});
		
	}
	
	
	public static #if !debug inline #end function setFloat (addr:Int, v:Float):Void {
		
		#if debug if (addr < 0 || addr + 4 > len) throw ("Bad address"); #end
		
		_setPositionTemporarily (addr, function () {
			
			gcRef.writeFloat (v);
			
		});
		
	}
	
	
	public static #if !debug inline #end function setI16 (addr:Int, v:Int):Void {
		
		#if debug if (addr < 0 || addr + 2 > len) throw ("Bad address"); #end
		
		_setPositionTemporarily (addr, function () {
			
			gcRef.writeShort (v);
			
		});
		
	}
	
	
	public static #if !debug inline #end function setI32 (addr:Int, v:Int):Void {
		
		#if debug if (addr < 0 || addr + 4 > len) throw ("Bad address"); #end
		
		_setPositionTemporarily (addr, function () {
			
			gcRef.writeInt (v);
			
		});
		
	}
	
	
}


#else
typedef Memory = openfl._legacy.Memory;
#end
#else


import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;

#if flash
@:native("flash.Memory")
#end


extern class Memory {
	
	
	public static inline function getByte (addr:Int):Int {
		
		#if flash
		return untyped __vmem_get__ (0, addr);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getDouble (addr:Int):Float {
		
		#if flash
		return untyped __vmem_get__ (4, addr);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getI32 (addr:Int):Int {
		
		#if flash
		return untyped __vmem_get__ (2, addr);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getFloat (addr:Int):Float {
		
		#if flash
		return untyped __vmem_get__ (3, addr);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getUI16 (addr:Int):Int {
		
		#if flash
		return untyped __vmem_get__ (1, addr);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function select (b:ByteArray):Void {
		
		#if (flash && !display)
		ApplicationDomain.currentDomain.domainMemory = b;
		#end
		
	}
	
	
	public static inline function setByte (addr:Int, v:Int):Void {
		
		#if flash
		untyped __vmem_set__ (0, addr, v);
		#end
		
	}
	
	
	public static inline function setDouble (addr:Int, v:Float):Void {
		
		#if flash
		untyped __vmem_set__ (4, addr, v);
		#end
		
	}
	
	
	public static inline function setFloat (addr:Int, v:Float):Void {
		
		#if flash
		untyped __vmem_set__ (3, addr, v);
		#end
		
	}
	
	
	public static inline function setI16 (addr:Int, v:Int):Void {
		
		#if flash
		untyped __vmem_set__ (1, addr, v);
		#end
		
	}
	
	
	public static inline function setI32 (addr:Int, v:Int):Void {
		
		#if flash
		untyped __vmem_set__ (2, addr, v);
		#end
		
	}
	
	
	public static inline function signExtend1 (v:Int):Int {
		
		#if flash
		return untyped __vmem_sign__ (0, v);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function signExtend8 (v:Int):Int {
		
		#if flash
		return untyped __vmem_sign__ (1, v);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function signExtend16 (v:Int):Int {
		
		#if flash
		return untyped __vmem_sign__ (2, v);
		#else
		return 0;
		#end
		
	}
	
	
}


#end