package openfl.display3D.textures; #if !flash


import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.gl.GLFramebuffer;
import openfl.events.EventDispatcher;


class TextureBase extends EventDispatcher {
	
	
	public var height:Int;
	public var frameBuffer:GLFramebuffer;
	public var glTexture:GLTexture;
	public var width:Int;
	
	
	public function new (glTexture:GLTexture, width:Int = 0, height:Int = 0) {
		
		super ();
		
		this.width = width;
		this.height = height;
		this.glTexture = glTexture;
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteTexture (glTexture);
		
	}
	
	
}


#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end