package openfl._internal.renderer.opengl.vao;


import lime.graphics.opengl.GLVertexArrayObject;


interface IVertexArrayObjectContext {
	
	
	public function bindVertexArray (vao:GLVertexArrayObject):Void;
	public function createVertexArray ():GLVertexArrayObject;
	public function deleteVertexArray (vao:GLVertexArrayObject):Void;
	public function isVertexArray (vao:GLVertexArrayObject):Bool;
	
	
}
