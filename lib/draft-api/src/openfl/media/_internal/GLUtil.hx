package openfl.media._internal;

import lime.graphics.OpenGLES3RenderContext;
import lime.graphics.opengl.GLUniformLocation;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.display3D.textures.TextureBase;

/**
 * ...
 * @author Christopher Speciale
 */
class GLUtil
{
	public static function LUMINANCE(context:Context3D):Int
	{
		@:privateAccess
		return context.gl.LUMINANCE;
	}

	public static function LUMINANCE_ALPHA(context:Context3D):Int
	{
		@:privateAccess
		return context.gl.LUMINANCE_ALPHA;
	}

	public static function RED(context:Context3D):Int
	{
		@:privateAccess
		return (cast context.gl : OpenGLES3RenderContext).RED;
	}

	public static function RG(context:Context3D):Int
	{
		@:privateAccess
		return (cast context.gl : OpenGLES3RenderContext).RG;
	}
}
