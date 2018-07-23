package openfl.media; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.utils.Float32Array;
import openfl._internal.renderer.canvas.CanvasVideo;
import openfl._internal.renderer.dom.DOMVideo;
import openfl._internal.renderer.opengl.GLVideo;
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

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.opengl.WebGLContext;
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)
@:access(openfl.net.NetStream)
@:access(openfl.geom.Point)


class Video extends DisplayObject {
	
	
	@:noCompletion private static inline var __bufferStride = 5;
	
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight (get, never):Int;
	public var videoWidth (get, never):Int;
	
	@:noCompletion private var __active:Bool;
	@:noCompletion private var __buffer:GLBuffer;
	@:noCompletion private var __bufferAlpha:Float;
	@:noCompletion private var __bufferColorTransform:ColorTransform;
	@:noCompletion private var __bufferContext:#if (lime >= "7.0.0") RenderContext #else WebGLContext #end;
	@:noCompletion private var __bufferData:Float32Array;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __height:Float;
	@:noCompletion private var __stream:NetStream;
	@:noCompletion private var __texture:GLTexture;
	@:noCompletion private var __textureTime:Float;
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
	
	
	@:noCompletion private function __getBuffer (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end):GLBuffer {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl:WebGLContext = context;
		#end
		
		if (__buffer == null || __bufferContext != context) {
			
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
			
			//__bufferData = new Float32Array ([
				//
				//width, height, 0, uvWidth, uvHeight, alpha, (color transform, color offset...)
				//0, height, 0, 0, uvHeight, alpha, (color transform, color offset...)
				//width, 0, 0, uvWidth, 0, alpha, (color transform, color offset...)
				//0, 0, 0, 0, 0, alpha, (color transform, color offset...)
				//
				//
			//]);
			
			//[ colorTransform.redMultiplier, 0, 0, 0, 0, colorTransform.greenMultiplier, 0, 0, 0, 0, colorTransform.blueMultiplier, 0, 0, 0, 0, colorTransform.alphaMultiplier ];
			//[ colorTransform.redOffset / 255, colorTransform.greenOffset / 255, colorTransform.blueOffset / 255, colorTransform.alphaOffset / 255 ]
			
			__bufferData = new Float32Array (__bufferStride * 4);
			
			__bufferData[0] = width;
			__bufferData[1] = height;
			__bufferData[3] = uvWidth;
			__bufferData[4] = uvHeight;
			__bufferData[__bufferStride + 1] = height;
			__bufferData[__bufferStride + 4] = uvHeight;
			__bufferData[__bufferStride * 2] = width;
			__bufferData[__bufferStride * 2 + 3] = uvWidth;
			
			// for (i in 0...4) {
				
			// 	__bufferData[__bufferStride * i + 5] = alpha;
				
			// 	if (colorTransform != null) {
					
			// 		__bufferData[__bufferStride * i + 6] = colorTransform.redMultiplier;
			// 		__bufferData[__bufferStride * i + 7] = colorTransform.greenMultiplier;
			// 		__bufferData[__bufferStride * i + 8] = colorTransform.blueMultiplier;
			// 		__bufferData[__bufferStride * i + 9] = colorTransform.alphaMultiplier;
			// 		__bufferData[__bufferStride * i + 10] = colorTransform.redOffset / 255;
			// 		__bufferData[__bufferStride * i + 11] = colorTransform.greenOffset / 255;
			// 		__bufferData[__bufferStride * i + 12] = colorTransform.blueOffset / 255;
			// 		__bufferData[__bufferStride * i + 13] = colorTransform.alphaOffset / 255;
					
			// 	}
				
			// }
			
			// __bufferAlpha = alpha;
			// __bufferColorTransform = colorTransform != null ? colorTransform.__clone () : null;
			__bufferContext = context;
			__buffer = gl.createBuffer ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
			gl.bufferData (gl.ARRAY_BUFFER, __bufferData, gl.STATIC_DRAW);
			//gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
		} else {
			
			// if (__bufferAlpha != alpha) {
				
			// 	for (i in 0...4) {
					
			// 		__bufferData[__bufferStride * i + 5] = alpha;
					
			// 	}
				
			// }
			
			// if ((__bufferColorTransform == null && colorTransform != null) || (__bufferColorTransform != null && !__bufferColorTransform.__equals (colorTransform))) {
				
			// 	if (colorTransform != null) {
					
			// 		__bufferColorTransform = colorTransform.__clone ();
					
			// 		for (i in 0...4) {
						
			// 			__bufferData[__bufferStride * i + 6] = colorTransform.redMultiplier;
			// 			__bufferData[__bufferStride * i + 11] = colorTransform.greenMultiplier;
			// 			__bufferData[__bufferStride * i + 16] = colorTransform.blueMultiplier;
			// 			__bufferData[__bufferStride * i + 21] = colorTransform.alphaMultiplier;
			// 			__bufferData[__bufferStride * i + 22] = colorTransform.redOffset / 255;
			// 			__bufferData[__bufferStride * i + 23] = colorTransform.greenOffset / 255;
			// 			__bufferData[__bufferStride * i + 24] = colorTransform.blueOffset / 255;
			// 			__bufferData[__bufferStride * i + 25] = colorTransform.alphaOffset / 255;
						
			// 		}
					
			// 	} else {
					
			// 		for (i in 0...4) {
						
			// 			__bufferData[__bufferStride * i + 6] = 1;
			// 			__bufferData[__bufferStride * i + 11] = 1;
			// 			__bufferData[__bufferStride * i + 16] = 1;
			// 			__bufferData[__bufferStride * i + 21] = 1;
			// 			__bufferData[__bufferStride * i + 22] = 0;
			// 			__bufferData[__bufferStride * i + 23] = 0;
			// 			__bufferData[__bufferStride * i + 24] = 0;
			// 			__bufferData[__bufferStride * i + 25] = 0;
						
			// 		}
					
			// 	}
				
			// }
			
			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
			// gl.bufferData (gl.ARRAY_BUFFER, __bufferData.byteLength, __bufferData, gl.STATIC_DRAW);
			
		}
		
		return __buffer;
		
	}
	
	
	@:noCompletion private function __getTexture (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end):GLTexture {
		
		#if (js && html5)
		
		if (__stream == null || __stream.__video == null) return null;
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl:WebGLContext = context;
		#end
		
		if (__texture == null) {
			
			__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			__textureTime = -1;
			
		}
		
		if (!__stream.__closed && __stream.__video.currentTime != __textureTime) {
			
			var internalFormat = gl.RGBA;
			var format = gl.RGBA;
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, format, gl.UNSIGNED_BYTE, __stream.__video);
			
			__textureTime = __stream.__video.currentTime;
			
		}
		
		return __texture;
		
		#else
		
		return null;
		
		#end
		
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
		
		GLVideo.render (this, renderer);
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		GLVideo.renderMask (this, renderer);
		
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