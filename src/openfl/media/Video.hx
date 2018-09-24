package openfl.media; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.RenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.canvas.CanvasVideo;
import openfl._internal.renderer.dom.DOMVideo;
import openfl._internal.renderer.context3D.Context3DVideo;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.CanvasRenderer;
import openfl.display.CairoRenderer;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectShader;
import openfl.display.DOMRenderer;
import openfl.display.Graphics;
import openfl.display.OpenGLRenderer;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:access(openfl.net.NetStream)


class Video extends DisplayObject {
	
	
	@:noCompletion private static inline var __vertexBufferStride = 5;
	
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight (get, never):Int;
	public var videoWidth (get, never):Int;
	
	@:noCompletion private var __active:Bool;
	@:noCompletion private var __buffer:GLBuffer;
	@:noCompletion private var __bufferAlpha:Float;
	@:noCompletion private var __bufferColorTransform:ColorTransform;
	@:noCompletion private var __bufferContext:RenderContext;
	@:noCompletion private var __bufferData:Float32Array;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __height:Float;
	@:noCompletion private var __indexBuffer:IndexBuffer3D;
	@:noCompletion private var __indexBufferContext:RenderContext;
	@:noCompletion private var __indexBufferData:UInt16Array;
	@:noCompletion private var __stream:NetStream;
	@:noCompletion private var __texture:RectangleTexture;
	@:noCompletion private var __textureTime:Float;
	@:noCompletion private var __uvRect:Rectangle;
	@:noCompletion private var __vertexBuffer:VertexBuffer3D;
	@:noCompletion private var __vertexBufferContext:RenderContext;
	@:noCompletion private var __vertexBufferData:Float32Array;
	@:noCompletion private var __width:Float;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (Video.prototype, {
			"videoHeight": { get: untyped __js__ ("function () { return this.get_videoHeight (); }") },
			"videoWidth": { get: untyped __js__ ("function () { return this.get_videoWidth (); }") },
		});
		
	}
	#end
	
	
	public function new (width:Int = 320, height:Int = 240):Void {
		
		super ();
		
		__width = width;
		__height = height;
		
		__textureTime = -1;
		
		smoothing = false;
		deblocking = 0;
		
	}
	
	
	public function attachNetStream (netStream:NetStream):Void {
		
		__stream = netStream;
		
		#if (js && html5)
		if (__stream != null && __stream.__video != null && !__stream.__closed) {
			
			__stream.__video.play ();
			
		}
		#end
		
	}
	
	
	public function clear ():Void {
		
		
		
	}
	
	
	@:noCompletion private override function __enterFrame (deltaTime:Int):Void {
		
		#if (js && html5)
		
		if (__renderable && __stream != null) {
			
			__setRenderDirty ();
			
		}
		
		#end
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__pool.get ();
		bounds.setTo (0, 0, __width, __height);
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
		Rectangle.__pool.release (bounds);
		
	}
	
	
	@:noCompletion private function __getIndexBuffer (context:Context3D):IndexBuffer3D {
		
		var gl = context.gl;
		
		if (__indexBuffer == null || __indexBufferContext != context.__context) {
			
			// TODO: Use shared buffer on context
			
			__indexBufferData = new UInt16Array (6);
			__indexBufferData[0] = 0;
			__indexBufferData[1] = 1;
			__indexBufferData[2] = 2;
			__indexBufferData[3] = 2;
			__indexBufferData[4] = 1;
			__indexBufferData[5] = 3;
			
			__indexBufferContext = context.__context;
			__indexBuffer = context.createIndexBuffer (6);
			__indexBuffer.uploadFromTypedArray (__indexBufferData);
			
		}
		
		return __indexBuffer;
		
	}
	
	
	@:noCompletion private function __getTexture (context:Context3D):RectangleTexture {
		
		#if (js && html5)
		
		if (__stream == null || __stream.__video == null) return null;
		
		var gl = context.__context.webgl;
		var internalFormat = gl.RGBA;
		var format = gl.RGBA;
		
		if (!__stream.__closed && __stream.__video.currentTime != __textureTime) {
			
			if (__texture == null) {
				trace ("CREATE VIDEO TEXTURE");
				
				__texture = context.createRectangleTexture (__stream.__video.videoWidth, __stream.__video.videoHeight, BGRA, false);
				trace (__stream.__video.videoWidth, __stream.__video.videoHeight);
			}
			
			context.__bindGLTexture2D (__texture.__textureID);
			gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, format, gl.UNSIGNED_BYTE, __stream.__video);
			
			__textureTime = __stream.__video.currentTime;
			
		}
		
		return __texture;
		
		#else
		
		return null;
		
		#end
		
	}
	
	
	
	
	@:noCompletion private function __getVertexBuffer (context:Context3D):VertexBuffer3D {
		
		var gl = context.gl;
		
		if (__vertexBuffer == null || __vertexBufferContext != context.__context) {
			
			#if openfl_power_of_two
			
			var newWidth = 1;
			var newHeight = 1;
			
			while (newWidth < width) {
				
				newWidth <<= 1;
				
			}
			
			while (newHeight < height) {
				
				newHeight <<= 1;
				
			}
			
			var uvWidth = width / newWidth;
			var uvHeight = height / newHeight;
			
			#else
			
			var uvWidth = 1;
			var uvHeight = 1;
			
			#end
			
			__vertexBufferData = new Float32Array (__vertexBufferStride * 4);
			
			__vertexBufferData[0] = width;
			__vertexBufferData[1] = height;
			__vertexBufferData[3] = uvWidth;
			__vertexBufferData[4] = uvHeight;
			__vertexBufferData[__vertexBufferStride + 1] = height;
			__vertexBufferData[__vertexBufferStride + 4] = uvHeight;
			__vertexBufferData[__vertexBufferStride * 2] = width;
			__vertexBufferData[__vertexBufferStride * 2 + 3] = uvWidth;
			
			__vertexBufferContext = context.__context;
			__vertexBuffer = context.createVertexBuffer (3, __vertexBufferStride);
			__vertexBuffer.uploadFromTypedArray (__vertexBufferData);
			
		}
		
		return __vertexBuffer;
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __width && py <= __height) {
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var point = Point.__pool.get ();
		point.setTo (x, y);
		
		__globalToLocal (point, point);
		
		var hit = (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height);
		
		Point.__pool.release (point);
		return hit;
		
	}
	
	
	@:noCompletion private override function __renderCanvas (renderer:CanvasRenderer):Void {
		
		CanvasVideo.render (this, renderer);
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderDOM (renderer:DOMRenderer):Void {
		
		DOMVideo.render (this, renderer);
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderGL (renderer:OpenGLRenderer):Void {
		
		Context3DVideo.render (this, renderer);
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		Context3DVideo.renderMask (this, renderer);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private override function get_height ():Float {
		
		return __height * scaleY;
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		if (scaleY != 1 || value != __height) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleY = 1;
		return __height = value;
		
	}
	
	
	@:noCompletion private function get_videoHeight ():Int {
		
		#if (js && html5)
		if (__stream != null && __stream.__video != null) {
			
			return Std.int (__stream.__video.videoHeight);
			
		}
		#end
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_videoWidth ():Int {
		
		#if (js && html5)
		if (__stream != null && __stream.__video != null) {
			
			return Std.int (__stream.__video.videoWidth);
			
		}
		#end
		
		return 0;
		
	}
	
	
	@:noCompletion private override function get_width ():Float {
		
		return __width * __scaleX;
		
	}
	
	
	@:noCompletion private override function set_width (value:Float):Float {
		
		if (__scaleX != 1 || __width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleX = 1;
		return __width = value;
		
	}
	
	
}


#else
typedef Video = flash.media.Video;
#end