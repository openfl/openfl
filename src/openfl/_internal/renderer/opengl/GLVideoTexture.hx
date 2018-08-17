package openfl._internal.renderer.opengl;


import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.opengl.GLUtils;
import openfl.display3D.textures.VideoTexture;
import openfl.display3D.Context3D;
import openfl.display.OpenGLRenderer;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.net.NetStream)


class GLVideoTexture {
	
	
	public static function create (videoTexture:VideoTexture):Void {
		
		var context = videoTexture.__context;
		var gl = context.__gl;
		videoTexture.__textureTarget = gl.TEXTURE_2D;
		
	}
	
	
	public static function getTexture (videoTexture:VideoTexture):GLTexture {
		
		#if (js && html5)
		
		if (!videoTexture.__netStream.__video.paused) {
			
			var context = videoTexture.__context;
			var gl = context.__gl;
			
			context.__bindTexture (videoTexture.__textureTarget, videoTexture.__textureID);
			GLUtils.CheckGLError ();
			
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, videoTexture.__netStream.__video);
			GLUtils.CheckGLError ();
			
		}
		
		#end
		
		return videoTexture.__textureID;
		
	}
	
	
}