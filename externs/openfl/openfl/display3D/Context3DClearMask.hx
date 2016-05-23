package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DClearMask")
#end


extern class Context3DClearMask {
	
	public static var ALL:Int;
	public static var COLOR:Int;
	public static var DEPTH:Int;
	public static var STENCIL:Int;
	
}