package openfl.display;

import openfl.display3D.Context3D;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
#if lime
import lime.math.Matrix4;
import lime.graphics.WebGLRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.WebGLRenderContext in WebGLRenderingContext;
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
	public var gl(get, set):WebGLRenderContext;

	@:noCompletion private function new(context:Context3D, defaultRenderTarget:BitmapData = null)
	{
		if (_ == null)
		{
			_ = new _OpenGLRenderer(this, context, defaultRenderTarget);
		}

		super();
	}

	/**
		Applies an alpha value to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyAlpha(alpha:Float):Void
	{
		(_ : _OpenGLRenderer).applyAlpha(alpha);
	}

	/**
		Binds a BitmapData object as the first active texture of the current active shader,
		if compatible with OpenFL core shaders
	**/
	public function applyBitmapData(bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void
	{
		(_ : _OpenGLRenderer).applyBitmapData(bitmapData, smooth, repeat);
	}

	/**
		Applies a color transform value to the active shader, if compatible with OpenFL
		core shaders
	**/
	public function applyColorTransform(colorTransform:ColorTransform):Void
	{
		(_ : _OpenGLRenderer).applyColorTransform(colorTransform);
	}

	/**
		Applies the "has color transform" uniform value for the active shader, if
		compatible with OpenFL core shaders
	**/
	public function applyHasColorTransform(enabled:Bool):Void
	{
		(_ : _OpenGLRenderer).applyHasColorTransform(enabled);
	}

	/**
		Applies render matrix to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyMatrix(matrix:Array<Float>):Void
	{
		(_ : _OpenGLRenderer).applyMatrix(matrix);
	}

	/**
		Converts an OpenFL two-dimensional matrix to a compatible 3D matrix for use with
		OpenGL rendering. Repeated calls to this method will return the same object with
		new values, so it will need to be cloned if the result must be cached
	**/
	public function getMatrix(transform:Matrix):#if lime Matrix4 #else Dynamic #end
	{
		return (_ : _OpenGLRenderer).getMatrix(transform);
	}

	/**
		Sets the current active shader, which automatically unbinds the previous shader
		if it was bound using an OpenFL Shader object
	**/
	public function setShader(shader:Shader):Void
	{
		(_ : _OpenGLRenderer).setShader(shader);
	}

	/**
		Updates the current OpenGL viewport using the current OpenFL stage coordinates
	**/
	public function setViewport():Void
	{
		(_ : _OpenGLRenderer).setViewport();
	}

	/**
		Updates the current active shader with cached alpha, color transform,
		bitmap data and other uniform or attribute values. This should be called in advance
		of rendering
	**/
	public function updateShader():Void
	{
		(_ : _OpenGLRenderer).updateShader();
	}

	/**
		Updates the active shader to expect an alpha array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useAlphaArray():Void
	{
		(_ : _OpenGLRenderer).useAlphaArray();
	}

	/**
		Updates the active shader to expect a color transform array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useColorTransformArray():Void
	{
		(_ : _OpenGLRenderer).useColorTransformArray();
	}
}
