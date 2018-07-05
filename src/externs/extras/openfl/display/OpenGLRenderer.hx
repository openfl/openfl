package openfl.display;


import lime.math.Matrix4;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if (lime >= "7.0.0")
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.GLRenderContext;
#end


extern class OpenGLRenderer extends DisplayObjectRenderer {
	
	
	public var gl:#if (lime >= "7.0.0") WebGLRenderContext #else GLRenderContext #end;
	
	public function applyAlpha (alpha:Float):Void;
	public function applyBitmapData (bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void;
	public function applyColorTransform (colorTransform:ColorTransform):Void;
	public function applyHasColorTransform (enabled:Bool):Void;
	public function applyMatrix (matrix:Array<Float>):Void;
	public function getMatrix (transform:Matrix):Matrix4;
	public function setShader (shader:Shader):Void;
	public function setViewport ():Void;
	public function updateShader ():Void;
	public function useAlphaArray ():Void;
	public function useColorTransformArray ():Void;
	
	
}