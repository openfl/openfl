package openfl._internal.stage3D.opengl;


import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.GLUtils;
import openfl.display3D.textures.VideoTexture;
import openfl.display.OpenGLRenderer;

#if (lime < "7.0.0")
import lime.graphics.opengl.WebGLContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.net.NetStream)


class GLVideoTexture {
	
	
	public static function create (videoTexture:VideoTexture, renderer:OpenGLRenderer):Void {
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		videoTexture.__textureTarget = gl.TEXTURE_2D;
		
	}
	
	
	public static function getTexture (videoTexture:VideoTexture, renderer:OpenGLRenderer):GLTexture {
		
		#if (js && html5)
		
		if (!videoTexture.__netStream.__video.paused) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl:WebGLContext = renderer.__context;
			#end
			
			gl.bindTexture (videoTexture.__textureTarget, videoTexture.__textureID);
			GLUtils.CheckGLError ();
			
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, videoTexture.__netStream.__video);
			GLUtils.CheckGLError ();
			
		}
		
		#end
		
		return videoTexture.__textureID;
		
	}
	
	
}