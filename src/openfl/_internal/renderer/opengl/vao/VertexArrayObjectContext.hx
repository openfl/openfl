package openfl._internal.renderer.opengl.vao;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLVertexArrayObject;


class VertexArrayObjectContext implements IVertexArrayObjectContext {
	
	
	private var __gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		__gl = gl;
		
	}
	
	
	public function bindVertexArray (vao:GLVertexArrayObject):Void {
		
		__gl.bindVertexArray (vao);
		
	}
	
	
	public function createVertexArray ():GLVertexArrayObject {
		
		return __gl.createVertexArray ();
		
	}
	
	
	public function deleteVertexArray (vao:GLVertexArrayObject):Void {
		
		__gl.deleteVertexArray (vao);
		
	}
	
	
	public function isVertexArray (vao:GLVertexArrayObject):Bool {
		
		return __gl.isVertexArray (vao);
		
	}
	
	
}
