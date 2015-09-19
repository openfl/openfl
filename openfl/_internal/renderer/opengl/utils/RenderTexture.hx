package openfl._internal.renderer.opengl.utils ;


import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import openfl.display.BitmapData.TextureUvs;


class RenderTexture {
	
	
	public var gl:GLRenderContext;
	public var frameBuffer:GLFramebuffer;
	public var renderBuffer:GLRenderbuffer;
	public var texture:GLTexture;
	public var smoothing:Bool;
	public var width:Int;
	public var height:Int;
	public var powerOfTwo:Bool = true;
	
	private var __width:Int;
	private var __height:Int;
	private var __uvData:TextureUvs;
	
	public function new (gl:GLRenderContext, width:Int, height:Int, smoothing:Bool = true, powerOfTwo:Bool = true) {
		
		this.gl = gl;
		this.powerOfTwo = powerOfTwo;
		
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
	
	
	public function clear (?r:Float = 0, ?g:Float = 0, ?b:Float = 0, ?a:Float = 0, ?mask:Null<Int>):Void {
		
		gl.clearColor (r, g, b, a);
		gl.clear (mask == null ? gl.COLOR_BUFFER_BIT : mask);
		
	}
	
	
	public function destroy ():Void {
		
		if(frameBuffer != null) gl.deleteFramebuffer (frameBuffer);
		if(texture != null) gl.deleteTexture (texture);
		
		frameBuffer = null;
		texture = null;
		
	}
	
	
	public function resize (width:Int, height:Int):Void {
		
		if (this.width == width && this.height == height) return;
		
		this.width = width;
		this.height = height;
		
		var pow2W = width;
		var pow2H = height;
		
		if (powerOfTwo) {
			pow2W = powOfTwo(width);
			pow2H = powOfTwo(height);
		}

		var lastW = __width;
		var lastH = __height;
		
		__width = pow2W;
		__height = pow2H;
		
		createUVs();
		
		if (lastW == pow2W && lastH == pow2H) return;
		
		gl.bindTexture (gl.TEXTURE_2D, texture);
		gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, __width, __height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
		
		gl.bindRenderbuffer (gl.RENDERBUFFER, renderBuffer);
		gl.renderbufferStorage (gl.RENDERBUFFER, gl.DEPTH_STENCIL, __width, __height);
		
	}
	
	private function createUVs() {
		if (__uvData == null) __uvData = new TextureUvs();
		var w = width / __width;
		var h = height / __height;
		__uvData.x0 = 0;
		__uvData.y0 = 0;
		__uvData.x1 = w;
		__uvData.y1 = 0;
		__uvData.x2 = w;
		__uvData.y2 = h;
		__uvData.x3 = 0;
		__uvData.y3 = h;
		
	}
	
	private inline function powOfTwo(value:Int) {
		var n = 1;
		while (n < value) n <<= 1;
		return n;
	}
}