package openfl._internal.stage3D.opengl;


import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.WebGLContext;
import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.GLUtils;
import openfl.display3D.textures.VideoTexture;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.net.NetStream)


class GLVideoTexture {
	
	
	public static function create (videoTexture:VideoTexture, renderSession:RenderSession):Void {
		
		var gl = renderSession.gl;
		videoTexture.__textureTarget = gl.TEXTURE_2D;
		
	}
	
	
	public static function getTexture (videoTexture:VideoTexture, renderSession:RenderSession):GLTexture {
		
		#if (js && html5)
		
		if (!videoTexture.__netStream.__video.paused) {
			
			var gl = renderSession.gl;
			
			gl.bindTexture (videoTexture.__textureTarget, videoTexture.__textureID);
			GLUtils.CheckGLError ();
			
			(gl:WebGLContext).texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, videoTexture.__netStream.__video);
			GLUtils.CheckGLError ();
			
		}
		
		#end
		
		return videoTexture.__textureID;
		
	}
	
	
}