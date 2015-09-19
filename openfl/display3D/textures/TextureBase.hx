package openfl.display3D.textures; #if !flash


import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.gl.GLFramebuffer;
import openfl.events.EventDispatcher;


class TextureBase extends EventDispatcher {
	
	public var context:Context3D;
	public var height:Int;
	public var frameBuffer:GLFramebuffer;
	public var glTexture:GLTexture;
	public var width:Int;
	
	
	public function new (context:Context3D, glTexture:GLTexture, width:Int = 0, height:Int = 0) {
		
		super ();
		
		this.context = context;
		this.width = width;
		this.height = height;
		this.glTexture = glTexture;
		
	}
	
	
	public function dispose ():Void {
		
		context.__deleteTexture (this);
		
	}
	
	
}


#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end