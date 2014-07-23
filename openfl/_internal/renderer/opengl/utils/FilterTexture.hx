package openfl._internal.renderer.opengl.utils ;


import lime.graphics.GLRenderbuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import openfl.gl.GLFramebuffer;
import openfl._internal.renderer.opengl.GLRenderer;


class FilterTexture {
	
	
	public var frameBuffer:GLFramebuffer;
	public var gl:GLRenderContext;
	public var renderBuffer:GLRenderbuffer;
	public var scaleMode:Int;
	public var texture:GLTexture;
	public var width:Int;
	public var height:Int;
	
	
	public function new (gl, width, height, scaleMode = 0)
	{
		/**
		* @property gl
		* @type WebGLContext
		*/
		this.gl = gl;

		// next time to create a frame buffer and texture
		this.frameBuffer = gl.createFramebuffer();
		this.texture = gl.createTexture();

		//scaleMode = scaleMode || PIXI.scaleModes.DEFAULT;

		gl.bindTexture(gl.TEXTURE_2D,  this.texture);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, (scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, (scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		//gl.bindFramebuffer(gl.FRAMEBUFFER, this.framebuffer );

		gl.bindFramebuffer(gl.FRAMEBUFFER, this.frameBuffer );
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, this.texture, 0);

		// required for masking a mask??
		this.renderBuffer = gl.createRenderbuffer();
		gl.bindRenderbuffer(gl.RENDERBUFFER, this.renderBuffer);
		gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, this.renderBuffer);
	
		this.resize(width, height);
	}


	public function clear ()
	{
		var gl = this.gl;
		
		gl.clearColor(0,0,0, 0);
		gl.clear(gl.COLOR_BUFFER_BIT);
	}

	public function resize (width, height)
	{
		if(this.width == width && this.height == height) return;

		this.width = width;
		this.height = height;

		var gl = this.gl;

		gl.bindTexture(gl.TEXTURE_2D,  this.texture);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA,  width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);

		// update the stencil buffer width and height
		gl.bindRenderbuffer(gl.RENDERBUFFER, this.renderBuffer);
		gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_STENCIL, width, height);
	}

	public function destroy ()
	{
		var gl = this.gl;
		gl.deleteFramebuffer( this.frameBuffer );
		gl.deleteTexture( this.texture );

		this.frameBuffer = null;
		this.texture = null;
	};
	
	
}
