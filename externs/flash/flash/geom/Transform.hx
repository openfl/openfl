package flash.geom; #if (!display && flash)


import openfl.display.DisplayObject;


extern class Transform {
	
	
	public var colorTransform:ColorTransform;
	public var concatenatedColorTransform (default, null):ColorTransform;
	public var concatenatedMatrix (default, null):Matrix;
	public var matrix:Matrix;
	@:require(flash10) public var matrix3D:Matrix3D;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var perspectiveProjection:PerspectiveProjection;
	#end
	
	public var pixelBounds (default, null):Rectangle;
	
	public function new (displayObject:DisplayObject);
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function getRelativeMatrix3D (relativeTo:DisplayObject):Matrix3D;
	#end
	
	
}


#else
typedef Transform = openfl.geom.Transform;
#end