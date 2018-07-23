package openfl._internal.stage3D.opengl;


import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
import openfl._internal.stage3D.GLUtils;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.IndexBuffer3D;
import openfl.display.OpenGLRenderer;
import openfl.utils.ByteArray;
import openfl.Vector;

#if (lime >= "7.0.0")
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.opengl.WebGLContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display.DisplayObjectRenderer)


class GLIndexBuffer3D {
	
	
	public static function create (indexBuffer:IndexBuffer3D, renderer:OpenGLRenderer, bufferUsage:Context3DBufferUsage):Void {
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		indexBuffer.__elementType = gl.UNSIGNED_SHORT;
		
		indexBuffer.__id = gl.createBuffer ();
		GLUtils.CheckGLError ();
		
		indexBuffer.__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
		
		// __context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_INDEX_BUFFER);
		// __memoryUsage = 0;
		
	}
	
	
	public static function dispose (indexBuffer:IndexBuffer3D, renderer:OpenGLRenderer):Void {
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		gl.deleteBuffer (indexBuffer.__id);
		
		// __context.__statsDecrement(Context3D.Context3DTelemetry.COUNT_INDEX_BUFFER);
		// __context.__statsSubtract(Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, __memoryUsage);
		// __memoryUsage = 0;
		
	}
	
	
	public static function uploadFromByteArray (indexBuffer:IndexBuffer3D, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		var offset = byteArrayOffset + startOffset * 2;
		
		uploadFromTypedArray (indexBuffer, renderer, new Int16Array (data.toArrayBuffer (), offset, count));
		
	}
	
	
	public static function uploadFromTypedArray (indexBuffer:IndexBuffer3D, renderer:OpenGLRenderer, data:ArrayBufferView):Void {
		
		if (data == null) return;
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl:WebGLContext = renderer.__context;
		#end
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer.__id);
		GLUtils.CheckGLError ();
		
		gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, data, indexBuffer.__usage);
		GLUtils.CheckGLError ();
		
		// if (data.byteLength != __memoryUsage) {
			
		// 	__context.__statsAdd (Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, data.byteLength - __memoryUsage);
		// 	__memoryUsage = data.byteLength;
			
		// }
		
	}
	
	
	public static function uploadFromVector (indexBuffer:IndexBuffer3D, renderer:OpenGLRenderer, data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		// TODO: Optimize more
		
		if (data == null) return;
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		var length = startOffset + count;
		var existingInt16Array = indexBuffer.__tempInt16Array;
		
		if (indexBuffer.__tempInt16Array == null || indexBuffer.__tempInt16Array.length < count) {
			
			indexBuffer.__tempInt16Array = new Int16Array (count);
			
			if (existingInt16Array != null) {
				
				indexBuffer.__tempInt16Array.set (existingInt16Array);
				
			}
			
		}
		
		for (i in startOffset...length) {
			
			indexBuffer.__tempInt16Array[i - startOffset] = data[i];
			
		}
		
		uploadFromTypedArray (indexBuffer, renderer, indexBuffer.__tempInt16Array);
		
	}
	
	
}