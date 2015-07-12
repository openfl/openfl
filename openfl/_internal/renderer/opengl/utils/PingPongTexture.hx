package openfl._internal.renderer.opengl.utils;
import lime.graphics.GLRenderContext;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLTexture;

/**
 * ...
 * @author MrCdK
 */
class PingPongTexture
{
	
	public var gl:GLRenderContext;
	public var renderTexture(get, set):RenderTexture;
	public var oldRenderTexture(get, set):RenderTexture;
	public var framebuffer(get, never):GLFramebuffer;
	public var texture(get, never):GLTexture;
	public var width:Int;
	public var height:Int;
	public var smoothing:Bool;
	public var useOldTexture:Bool = false;
	public var powerOfTwo:Bool = true;

	private var __swapped:Bool = false;
	private var __texture0:RenderTexture;
	private var __texture1:RenderTexture;
	private var __otherTexture(get, never):RenderTexture;
	
	public function new(gl:GLRenderContext, width:Int, height:Int, smoothing:Bool = true, powerOfTwo:Bool = true) {
		this.gl = gl;
		this.width = width;
		this.height = height;
		this.smoothing = smoothing;
		this.powerOfTwo = powerOfTwo;
		
		renderTexture = new RenderTexture(gl, width, height, smoothing, powerOfTwo);
	}
	
	public function swap() {
		__swapped = !__swapped;
		if (renderTexture == null) {
			renderTexture = new RenderTexture(gl, width, height, smoothing, powerOfTwo);
		}
	}
	
	public inline function clear (?r:Float = 0, ?g:Float = 0, ?b:Float = 0, ?a:Float = 0, ?mask:Null<Int>):Void {
		
		renderTexture.clear(r, g, b, a, mask);
		
	}
	
	public function resize(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		renderTexture.resize(width, height);
	}
	
	public function destroy() {
		if (__texture0 != null) {
			__texture0.destroy();
			__texture0 = null;
		}
		if (__texture1 != null) {
			__texture1.destroy();
			__texture1 = null;
		}
		__swapped = false;
	}
	
	inline function get_renderTexture() {
		return __swapped ? __texture1 : __texture0;
	}
	
	inline function set_renderTexture(v) {
		return {
			if (__swapped) 
				__texture1 = v;
			else 
				__texture0 = v;
		};
	}
	
	inline function get_oldRenderTexture() {
		return __swapped ? __texture0 : __texture1;
	}
	
	inline function set_oldRenderTexture(v) {
		return {
			if (__swapped) 
				__texture0 = v;
			else 
				__texture1 = v;
		};
	}
	
	inline function get_framebuffer() {
		return renderTexture.frameBuffer;
	}
	
	inline function get_texture() {
		return useOldTexture ? __otherTexture.texture : renderTexture.texture;
	}
	
	inline function get___otherTexture() {
		return __swapped ? __texture0 : __texture1;
	}
}