package openfl._internal.renderer.opengl.utils ;


import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;


class FilterTexture {
	
	
	public var frameBuffer:GLFramebuffer;
	public var gl:GLRenderContext;
	public var renderBuffer:GLRenderbuffer;
	public var smoothing:Bool;
	public var texture:GLTexture;
	public var width:Int;
	public var height:Int;
	
	
	public function new (gl:GLRenderContext, width:Int, height:Int, smoothing = true) {
		
		this.gl = gl;
		
		frameBuffer = gl.createFramebuffer ();
		texture = gl.createTexture ();
		
		gl.bindTexture (gl.TEXTURE_2D, texture);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, smoothing ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, smoothing ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, frameBuffer);
		gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
		
		renderBuffer = gl.createRenderbuffer ();
		gl.bindRenderbuffer (gl.RENDERBUFFER, renderBuffer);
		gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, renderBuffer);
		
		resize (width, height);
		
	}
	
	
	public function clear ():Void {
		
		var gl = this.gl;
		
		gl.clearColor (0, 0, 0, 0);
		gl.clear (gl.COLOR_BUFFER_BIT);
		
	}
	
	
	public function destroy ():Void {
		
		var gl = this.gl;
		gl.deleteFramebuffer (frameBuffer);
		gl.deleteTexture (texture);
		
		frameBuffer = null;
		texture = null;
		
	}
	
	
	public function resize (width:Int, height:Int):Void {
		
		if (this.width == width && this.height == height) return;
		
		this.width = width;
		this.height = height;
		
		var gl = this.gl;
		
		gl.bindTexture (gl.TEXTURE_2D, texture);
		gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
		
		gl.bindRenderbuffer (gl.RENDERBUFFER, renderBuffer);
		gl.renderbufferStorage (gl.RENDERBUFFER, gl.DEPTH_STENCIL, width, height);
		
	}
	
	
}