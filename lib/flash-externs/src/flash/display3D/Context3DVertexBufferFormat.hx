package flash.display3D;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DVertexBufferFormat(String) from String to String

{
	public var BYTES_4 = "bytes4";
	public var FLOAT_1 = "float1";
	public var FLOAT_2 = "float2";
	public var FLOAT_3 = "float3";
	public var FLOAT_4 = "float4";
}
#else
typedef Context3DVertexBufferFormat = openfl.display3D.Context3DVertexBufferFormat;
#end
