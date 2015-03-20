package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBuffer;
import openfl.utils.ArrayBufferView;

class VertexArray {

	public var gl:GLRenderContext;
	public var glBuffer:GLBuffer;
	public var attributes:Array<VertexAttribute> = [];
	public var buffer:ArrayBuffer;
	public var size:Int = 0;
	public var stride(get, never):Int;

	public var isStatic:Bool = false;
	
	public function new(attributes:Array<VertexAttribute>, ?size:Int = 0, isStatic:Bool = false) {
		this.size = size;
		this.attributes = attributes;
		
		if(size > 0) {
			buffer = new ArrayBuffer(size);
		}
		
		this.isStatic = isStatic;
	}
	
	public inline function bind() {
		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
	}
	
	public inline function unbind() {
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
	}
	
	public function upload(view:ArrayBufferView) {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, view);
	}
	
	public function destroy() {
		gl.deleteBuffer(glBuffer);
		buffer = null;
	}
	
	public function setContext(gl:GLRenderContext, view:ArrayBufferView) {
		this.gl = gl;
		
		glBuffer = gl.createBuffer();
		
		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
		// TODO fix this, it should accept an ArrayBuffer
		gl.bufferData(gl.ARRAY_BUFFER, view, isStatic ? gl.STATIC_DRAW : gl.DYNAMIC_DRAW);
	}
	
	private function get_stride() {
		var s = 0;
		for (a in attributes) {
			if (a.enabled) s += a.elements * 4;
		}
		return s;
	}
}