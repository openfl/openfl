package openfl.display;

#if !flash
import openfl.display3D.Context3D;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
#if lime
import lime.graphics.WebGLRenderContext;
import lime.math.Matrix4;
#end

/**
	**BETA**

	The OpenGL3DRenderer API exposes support for OpenGL render instructions within the
	`RenderEvent.RENDER_OPENGL` event.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class OpenGLRenderer extends DisplayObjectRenderer
{
	/**
		The current OpenGL render context
	**/
	public var gl:#if lime WebGLRenderContext #else Dynamic #end;

	@:noCompletion private function new(context:Context3D, defaultRenderTarget:BitmapData = null)
	{
		super();
	}

	/**
		Applies an alpha value to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyAlpha(alpha:Float):Void {}

	/**
		Binds a BitmapData object as the first active texture of the current active shader,
		if compatible with OpenFL core shaders
	**/
	public function applyBitmapData(bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void {}

	/**
		Applies a color transform value to the active shader, if compatible with OpenFL
		core shaders
	**/
	public function applyColorTransform(colorTransform:ColorTransform):Void {}

	/**
		Applies the "has color transform" uniform value for the active shader, if
		compatible with OpenFL core shaders
	**/
	public function applyHasColorTransform(enabled:Bool):Void {}

	/**
		Applies render matrix to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyMatrix(matrix:Array<Float>):Void {}

	/**
		Converts an OpenFL two-dimensional matrix to a compatible 3D matrix for use with
		OpenGL rendering. Repeated calls to this method will return the same object with
		new values, so it will need to be cloned if the result must be cached
	**/
	public function getMatrix(transform:Matrix):#if lime Matrix4 #else Dynamic #end
	{
		return null;
	}

	/**
		Sets the current active shader, which automatically unbinds the previous shader
		if it was bound using an OpenFL Shader object
	**/
	public function setShader(shader:Shader):Void {}

	/**
		Updates the current OpenGL viewport using the current OpenFL stage coordinates
	**/
	public function setViewport():Void {}

	/**
		Updates the current active shader with cached alpha, color transform,
		bitmap data and other uniform or attribute values. This should be called in advance
		of rendering
	**/
	public function updateShader():Void {}

	/**
		Updates the active shader to expect an alpha array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useAlphaArray():Void {}

	/**
		Updates the active shader to expect a color transform array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useColorTransformArray():Void {}
}
#else
typedef Context3DRenderer = Dynamic;
#end
