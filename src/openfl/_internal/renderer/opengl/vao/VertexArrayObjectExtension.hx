package openfl._internal.renderer.opengl.vao;


import lime.graphics.opengl.GLVertexArrayObject;


class VertexArrayObjectExtension implements IVertexArrayObjectContext {
	
	
	private var __vertexArrayObjectsExtension:Dynamic;
	
	
	public function new (extension: Dynamic) {
		
		__vertexArrayObjectsExtension = extension;
		
	}
	
	
	public function bindVertexArray (vao:GLVertexArrayObject):Void {
		
		__vertexArrayObjectsExtension.bindVertexArrayOES (vao);
		
	}
	
	
	public function createVertexArray ():GLVertexArrayObject {
		
		return __vertexArrayObjectsExtension.createVertexArrayOES ();
		
	}
	
	
	public function deleteVertexArray (vao:GLVertexArrayObject):Void {
		
		__vertexArrayObjectsExtension.deleteVertexArrayOES (vao);
		
	}
	
	
	public function isVertexArray (vao:GLVertexArrayObject):Bool {
		
		return __vertexArrayObjectsExtension.isVertexArrayOES (vao);
		
	}
	
	
}
