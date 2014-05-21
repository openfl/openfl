package openfl.display;


import openfl.display.Stage;
import openfl.geom.Matrix;


interface IBitmapDrawable {
	
	var __worldTransform:Matrix;
	
	function __renderCanvas (renderSession:RenderSession):Void;
	function __renderMask (renderSession:RenderSession):Void;
	function __updateChildren (transformOnly:Bool):Void;
	
}