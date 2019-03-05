package flash;

#if flash
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;

extern class Memory
{
	public static inline function getByte(addr:Int):Int
	{
		#if flash
		return untyped __vmem_get__(0, addr);
		#else
		return 0;
		#end
	}
	public static inline function getDouble(addr:Int):Float
	{
		#if flash
		return untyped __vmem_get__(4, addr);
		#else
		return 0;
		#end
	}
	public static inline function getI32(addr:Int):Int
	{
		#if flash
		return untyped __vmem_get__(2, addr);
		#else
		return 0;
		#end
	}
	public static inline function getFloat(addr:Int):Float
	{
		#if flash
		return untyped __vmem_get__(3, addr);
		#else
		return 0;
		#end
	}
	public static inline function getUI16(addr:Int):Int
	{
		#if flash
		return untyped __vmem_get__(1, addr);
		#else
		return 0;
		#end
	}
	public static inline function select(b:ByteArray):Void
	{
		#if (flash && !display)
		ApplicationDomain.currentDomain.domainMemory = b;
		#end
	}
	public static inline function setByte(addr:Int, v:Int):Void
	{
		#if flash
		untyped __vmem_set__(0, addr, v);
		#end
	}
	public static inline function setDouble(addr:Int, v:Float):Void
	{
		#if flash
		untyped __vmem_set__(4, addr, v);
		#end
	}
	public static inline function setFloat(addr:Int, v:Float):Void
	{
		#if flash
		untyped __vmem_set__(3, addr, v);
		#end
	}
	public static inline function setI16(addr:Int, v:Int):Void
	{
		#if flash
		untyped __vmem_set__(1, addr, v);
		#end
	}
	public static inline function setI32(addr:Int, v:Int):Void
	{
		#if flash
		untyped __vmem_set__(2, addr, v);
		#end
	}
	public static inline function signExtend1(v:Int):Int
	{
		#if flash
		return untyped __vmem_sign__(0, v);
		#else
		return 0;
		#end
	}
	public static inline function signExtend8(v:Int):Int
	{
		#if flash
		return untyped __vmem_sign__(1, v);
		#else
		return 0;
		#end
	}
	public static inline function signExtend16(v:Int):Int
	{
		#if flash
		return untyped __vmem_sign__(2, v);
		#else
		return 0;
		#end
	}
}
#else
typedef Memory = openfl.Memory;
#end
