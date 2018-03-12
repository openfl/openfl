package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLContextType;
import lime.graphics.opengl.GLVertexArrayObject;


/**
*  VertexArrayObjectUtils is a utility class providing a utility methods to work with VertextArrayObjects.
**/
class VertexArrayObjectUtils {
	
	
	private static var __initialized:Bool = false;
	private static var __enabled:Bool = true;
	private static var __vertexArrayObjectsSupported:Bool = false;
	private static var __vertexArrayObjectsExtension:Dynamic = null;
	
	
	public static inline function bindVAO (gl:GLRenderContext, vao:GLVertexArrayObject):Void {
		
		#if vertex_array_object
		if (!isVertexArrayObjectsSupported(gl)) return;
		
		if (__vertexArrayObjectsExtension != null) {
			
			__vertexArrayObjectsExtension.bindVertexArrayOES (vao);
			
		} else {
			
			gl.bindVertexArray (vao);
			
		}
		#end
		
	}
	
	
	public static function createVAO (gl:GLRenderContext):GLVertexArrayObject {
		
		#if vertex_array_object
		if (!isVertexArrayObjectsSupported(gl)) return null;
		
		if (__vertexArrayObjectsExtension != null) {
			
			return __vertexArrayObjectsExtension.createVertexArrayOES ();
			
		} else {
			
			return gl.createVertexArray ();
			
		}
		#end
		
		return null;
		
	}
	
	
	public static inline function deleteVAO (gl:GLRenderContext, vao:GLVertexArrayObject):Void {
		
		#if vertex_array_object
		if (!isVertexArrayObjectsSupported(gl) || vao == null) return;
		
		if (__vertexArrayObjectsExtension != null) {
			
			__vertexArrayObjectsExtension.deleteVertexArrayOES (vao);
			
		} else {
			
			gl.deleteVertexArray (vao);
			
		}
		#end
		
	}
	
	
	private static inline function __init (gl:GLRenderContext):Void {
		
		__initialized = true;
		#if vertex_array_object
		if (gl.type == GLContextType.WEBGL) { 
			
			if (gl.version == 2) {
				
				__vertexArrayObjectsSupported = true;
				
			} else if (gl.version == 1) {
				
				__vertexArrayObjectsExtension = gl.getExtension ("OES_vertex_array_object");
				__vertexArrayObjectsSupported = __vertexArrayObjectsExtension != null;
				
			}
			
		}
		#end
		
	}
	
	
	public static inline function isVertexArrayObjectsSupported(gl:GLRenderContext):Bool {
		#if vertex_array_object
		if (!__enabled) return false;
		if (!__initialized) __init (gl);
		#end
		
		return __vertexArrayObjectsSupported;
		
	}
	
	
}
