package openfl.display; #if !flash


import lime.graphics.opengl.ext.KHR_debug;
import lime.graphics.opengl.GLFramebuffer;
import lime.math.Matrix4;
import lime.utils.Float32Array;
import openfl._internal.renderer.opengl.GLMaskShader;
import openfl._internal.renderer.ShaderBuffer;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;
import openfl.display.Graphics;
import openfl.display.GraphicsShader;
import openfl.display.Stage;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if (lime < "7.0.0")
@:access(lime._backend.html5.HTML5GLRenderContext)
#end

@:access(lime.graphics.GLRenderContext)
@:access(openfl._internal.renderer.ShaderBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Shader)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display.Stage3D)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl._internal.renderer.opengl)
@:allow(openfl._internal.stage3D.opengl)
@:allow(openfl.display3D.textures)
@:allow(openfl.display3D)
@:allow(openfl.display)


class OpenGLRenderer extends DisplayObjectRenderer {
	
	
	@:noCompletion private static var __alphaValue = [ 1. ];
	@:noCompletion private static var __colorMultipliersValue = [ 0, 0, 0, 0. ];
	@:noCompletion private static var __colorOffsetsValue = [ 0, 0, 0, 0. ];
	@:noCompletion private static var __defaultColorMultipliersValue = [ 1, 1, 1, 1. ];
	@:noCompletion private static var __emptyColorValue = [ 0, 0, 0, 0. ];
	@:noCompletion private static var __emptyAlphaValue = [ 1. ];
	@:noCompletion private static var __hasColorTransformValue = [ false ];
	@:noCompletion private static var __textureSizeValue = [ 0, 0. ];
	
	#if (lime >= "7.0.0")
	public var gl:WebGLRenderContext;
	#elseif openfljs
	public var gl:js.html.webgl.RenderingContext;
	#else
	public var gl:GLRenderContext;
	#end
	
	@:noCompletion private var __clipRects:Array<Rectangle>;
	@:noCompletion private var __currentDisplayShader:Shader;
	@:noCompletion private var __currentGraphicsShader:Shader;
	@:noCompletion private var __currentRenderTarget:BitmapData;
	@:noCompletion private var __currentShader:Shader;
	@:noCompletion private var __currentShaderBuffer:ShaderBuffer;
	@:noCompletion private var __defaultDisplayShader:DisplayObjectShader;
	@:noCompletion private var __defaultGraphicsShader:GraphicsShader;
	@:noCompletion private var __defaultRenderTarget:BitmapData;
	@:noCompletion private var __defaultShader:Shader;
	@:noCompletion private var __displayHeight:Int;
	@:noCompletion private var __displayWidth:Int;
	@:noCompletion private var __flipped:Bool;
	@:noCompletion private var __gl:#if (lime >= "7.0.0") WebGLRenderContext #else GLRenderContext #end;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __maskShader:GLMaskShader;
	@:noCompletion private var __matrix:Matrix4;
	@:noCompletion private var __maskObjects:Array<DisplayObject>;
	@:noCompletion private var __numClipRects:Int;
	@:noCompletion private var __offsetX:Int;
	@:noCompletion private var __offsetY:Int;
	@:noCompletion private var __projection:Matrix4;
	@:noCompletion private var __projectionFlipped:Matrix4;
	@:noCompletion private var __softwareRenderer:DisplayObjectRenderer;
	@:noCompletion private var __stencilReference:Int;
	@:noCompletion private var __tempRect:Rectangle;
	@:noCompletion private var __updatedStencil:Bool;
	@:noCompletion private var __upscaled:Bool;
	@:noCompletion private var __values:Array<Float>;
	@:noCompletion private var __width:Int;
	
	
	@:noCompletion private function new (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end, ?defaultRenderTarget:BitmapData) {
		
		super ();
		
		#if (lime >= "7.0.0")
		gl = context.webgl;
		__gl = gl;
		#else
		gl = #if openfljs context.__context #else context #end;
		__gl = context;
		#end
		
		__context = context;
		
		this.__defaultRenderTarget = defaultRenderTarget;
		this.__flipped = (__defaultRenderTarget == null);
		
		if (Graphics.maxTextureWidth == null) {
			
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = __gl.getParameter (__gl.MAX_TEXTURE_SIZE);
			
		}
		
		__matrix = new Matrix4 ();
		__values = new Array ();
		
		#if gl_debug
		var ext:KHR_debug = __gl.getExtension ("KHR_debug");
		if (ext != null) {
			
			__gl.enable (ext.DEBUG_OUTPUT);
			__gl.enable (ext.DEBUG_OUTPUT_SYNCHRONOUS);
			
		}
		#end
		
		#if (js && html5)
		__softwareRenderer = new CanvasRenderer (null);
		#else
		__softwareRenderer = new CairoRenderer (null);
		#end
		
		__type = OPENGL;
		
		__setBlendMode (NORMAL);
		__gl.enable (__gl.BLEND);
		
		__clipRects = new Array ();
		__maskObjects = new Array ();
		__numClipRects = 0;
		__projection = new Matrix4 ();
		__projectionFlipped = new Matrix4 ();
		__stencilReference = 0;
		__tempRect = new Rectangle ();
		
		__defaultDisplayShader = new DisplayObjectShader ();
		__defaultGraphicsShader = new GraphicsShader ();
		__defaultShader = __defaultDisplayShader;
		
		__initShader (__defaultShader);
		
		__maskShader = new GLMaskShader ();
		
	}
	
	
	public function applyAlpha (alpha:Float):Void {
		
		__alphaValue[0] = alpha;
		
		if (__currentShaderBuffer != null) {
			
			__currentShaderBuffer.addOverride ("openfl_Alpha", __alphaValue);
			
		} else if (__currentShader != null) {
			
			if (__currentShader.__alpha != null) __currentShader.__alpha.value = __alphaValue;
			
		}
		
	}
	
	
	public function applyBitmapData (bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void {
		
		if (__currentShaderBuffer != null) {
			
			if (bitmapData != null) {
				
				__textureSizeValue[0] = bitmapData.__textureWidth;
				__textureSizeValue[1] = bitmapData.__textureHeight;
				
				__currentShaderBuffer.addOverride ("openfl_TextureSize", __textureSizeValue);
				
			}
			
		} else if (__currentShader != null) {
			
			if (__currentShader.__bitmap != null) {
				
				__currentShader.__bitmap.input = bitmapData;
				__currentShader.__bitmap.filter = smooth ? LINEAR : NEAREST;
				__currentShader.__bitmap.mipFilter = MIPNONE;
				__currentShader.__bitmap.wrap = repeat ? REPEAT : CLAMP;
				
			}
			
			if (__currentShader.__texture != null) {
				
				__currentShader.__texture.input = bitmapData;
				__currentShader.__texture.filter = smooth ? LINEAR : NEAREST;
				__currentShader.__texture.mipFilter = MIPNONE;
				__currentShader.__texture.wrap = repeat ? REPEAT : CLAMP;
				
			}
			
			if (__currentShader.__textureSize != null) {
				
				if (bitmapData != null) {
					
					__textureSizeValue[0] = bitmapData.__textureWidth;
					__textureSizeValue[1] = bitmapData.__textureHeight;
					
					__currentShader.__textureSize.value = __textureSizeValue;
					
				} else {
					
					__currentShader.__textureSize.value = null;
					
				}
				
			}
			
		}
		
	}
	
	
	public function applyColorTransform (colorTransform:ColorTransform):Void {
		
		var enabled = (colorTransform != null && !colorTransform.__isDefault ());
		applyHasColorTransform (enabled);
		
		if (enabled) {
			
			colorTransform.__setArrays (__colorMultipliersValue, __colorOffsetsValue);
			
			if (__currentShaderBuffer != null) {
				
				__currentShaderBuffer.addOverride ("openfl_ColorMultiplier", __colorMultipliersValue);
				__currentShaderBuffer.addOverride ("openfl_ColorOffset", __colorOffsetsValue);
				
			} else if (__currentShader != null) {
				
				if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.value = __colorMultipliersValue;
				if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.value = __colorOffsetsValue;
				
			}
			
		} else {
			
			if (__currentShaderBuffer != null) {
				
				__currentShaderBuffer.addOverride ("openfl_ColorMultiplier", __emptyColorValue);
				__currentShaderBuffer.addOverride ("openfl_ColorOffset", __emptyColorValue);
				
			} else if (__currentShader != null) {
				
				if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.value = __emptyColorValue;
				if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.value = __emptyColorValue;
				
			}
			
		}
		
	}
	
	
	public function applyHasColorTransform (enabled:Bool):Void {
		
		__hasColorTransformValue[0] = enabled;
		
		if (__currentShaderBuffer != null) {
			
			__currentShaderBuffer.addOverride ("openfl_HasColorTransform", __hasColorTransformValue);
			
		} else if (__currentShader != null) {
			
			if (__currentShader.__hasColorTransform != null) __currentShader.__hasColorTransform.value = __hasColorTransformValue;
			
		}
		
	}
	
	
	public function applyMatrix (matrix:Array<Float>):Void {
		
		if (__currentShaderBuffer != null) {
			
			__currentShaderBuffer.addOverride ("openfl_Matrix", matrix);
			
		} else if (__currentShader != null) {
			
			if (__currentShader.__matrix != null) __currentShader.__matrix.value = matrix;
			
		}
		
	}
	
	
	public function getMatrix (transform:Matrix):Matrix4 {
		
		if (gl != null) {
			
			var values = __getMatrix (transform);
			
			for (i in 0...16) {
				
				__matrix[i] = values[i];
				
			}
			
			return __matrix;
			
		} else {
			
			__matrix.identity ();
			__matrix[0] = transform.a;
			__matrix[1] = transform.b;
			__matrix[4] = transform.c;
			__matrix[5] = transform.d;
			__matrix[12] = transform.tx;
			__matrix[13] = transform.ty;
			
			return __matrix;
			
		}
		
	}
	
	
	public function setShader (shader:Shader):Void {
		
		__currentShaderBuffer = null;
		
		if (__currentShader == shader) return;
		
		if (__currentShader != null) {
			
			__currentShader.__disable ();
			
		}
		
		if (shader == null) {
			
			__currentShader = null;
			__gl.useProgram (null);
			return;
			
		} else {
			
			__currentShader = shader;
			__initShader (shader);
			__gl.useProgram (shader.glProgram);
			__currentShader.__enable ();
			
		}
		
	}
	
	
	public function setViewport ():Void {
		
		__gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);
		
	}
	
	
	public function updateShader ():Void {
		
		if (__currentShader != null) {
			
			if (__currentShader.__position != null) __currentShader.__position.__useArray = true;
			if (__currentShader.__textureCoord != null) __currentShader.__textureCoord.__useArray = true;
			__currentShader.__update ();
			
		}
		
	}
	
	
	public function useAlphaArray ():Void {
		
		if (__currentShader != null) {
			
			if (__currentShader.__alpha != null) __currentShader.__alpha.__useArray = true;
			
		}
		
	}
	
	
	public function useColorTransformArray ():Void {
		
		if (__currentShader != null) {
			
			if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.__useArray = true;
			if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.__useArray = true;
			
		}
		
	}
	
	
	@:noCompletion private function __cleanup ():Void {
		
		if (__stencilReference > 0) {
			
			__stencilReference = 0;
			__gl.disable (__gl.STENCIL_TEST);
			
		}
		
		if (__numClipRects > 0) {
			
			__numClipRects = 0;
			__scissorRect ();
			
		}
		
	}
	
	
	@:noCompletion private override function __clear ():Void {
		
		if (__stage == null || __stage.__transparent) {
			
			__gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			__gl.clearColor (__stage.__colorSplit[0], __stage.__colorSplit[1], __stage.__colorSplit[2], 1);
			
		}
		
		__gl.clear (__gl.COLOR_BUFFER_BIT);
		
	}
	
	
	@:noCompletion private function __clearShader ():Void {
		
		if (__currentShader != null) {
			
			if (__currentShaderBuffer == null) {
				
				if (__currentShader.__bitmap != null) __currentShader.__bitmap.input = null;
				
			} else {
				
				__currentShaderBuffer.clearOverride ();
				
			}
			
			if (__currentShader.__texture != null) __currentShader.__texture.input = null;
			if (__currentShader.__textureSize != null) __currentShader.__textureSize.value = null;
			if (__currentShader.__hasColorTransform != null) __currentShader.__hasColorTransform.value = null;
			if (__currentShader.__position != null) __currentShader.__position.value = null;
			if (__currentShader.__matrix != null) __currentShader.__matrix.value = null;
			__currentShader.__clearUseArray ();
			
		}
		
	}
	
	
	@:noCompletion private function __copyShader (other:OpenGLRenderer):Void {
		
		__currentShader = other.__currentShader;
		__currentShaderBuffer = other.__currentShaderBuffer;
		__currentDisplayShader = other.__currentDisplayShader;
		__currentGraphicsShader = other.__currentGraphicsShader;
		
	}
	
	
	@:noCompletion private function __getMatrix (transform:Matrix):Array<Float> {
		
		var _matrix = Matrix.__pool.get ();
		_matrix.copyFrom (transform);
		_matrix.concat (__worldTransform);
		
		if (__roundPixels) {
			
			_matrix.tx = Math.round (_matrix.tx);
			_matrix.ty = Math.round (_matrix.ty);
			
		}
		
		__matrix.identity ();
		__matrix[0] = _matrix.a;
		__matrix[1] = _matrix.b;
		__matrix[4] = _matrix.c;
		__matrix[5] = _matrix.d;
		__matrix[12] = _matrix.tx;
		__matrix[13] = _matrix.ty;
		__matrix.append (__flipped ? __projectionFlipped : __projection);
		
		for (i in 0...16) {
			
			__values[i] = __matrix[i];
			
		}
		
		Matrix.__pool.release (_matrix);
		
		return __values;
		
	}
	
	
	@:noCompletion private function __initShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.__context == null) {
				
				shader.__context = __context;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return __defaultShader;
		
	}
	
	
	@:noCompletion private function __initDisplayShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.__context == null) {
				
				shader.__context = __context;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return __defaultDisplayShader;
		
	}
	
	
	@:noCompletion private function __initGraphicsShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.__context == null) {
				
				shader.__context = __context;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return __defaultGraphicsShader;
		
	}
	
	
	@:noCompletion private function __initShaderBuffer (shaderBuffer:ShaderBuffer):Shader {
		
		if (shaderBuffer != null) {
			
			return __initGraphicsShader (shaderBuffer.shader);
			
		}
		
		return __defaultGraphicsShader;
		
	}
	
	
	@:noCompletion private override function __popMask ():Void {
		
		if (__stencilReference == 0) return;
		
		var mask = __maskObjects.pop ();
		
		if (__stencilReference > 1) {
			
			__gl.stencilOp (__gl.KEEP, __gl.KEEP, __gl.DECR);
			__gl.stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
			__gl.colorMask (false, false, false, false);
			
			mask.__renderGLMask (this);
			__stencilReference--;
			
			__gl.stencilOp (__gl.KEEP, __gl.KEEP, __gl.KEEP);
			__gl.stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
			__gl.colorMask (true, true, true, true);
			
		} else {
			
			__stencilReference = 0;
			__gl.disable (__gl.STENCIL_TEST);
			
		}
		
	}
	
	
	@:noCompletion private override function __popMaskObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (object.__mask != null) {
			
			__popMask ();
			
		}
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			__popMaskRect ();
			
		}
		
	}
	
	
	@:noCompletion private override function __popMaskRect ():Void {
		
		if (__numClipRects > 0) {
			
			__numClipRects--;
			
			if (__numClipRects > 0) {
				
				__scissorRect (__clipRects[__numClipRects - 1]);
				
			} else {
				
				__scissorRect ();
				
			}
			
		}
		
	}
	
	
	@:noCompletion private override function __pushMask (mask:DisplayObject):Void {
		
		if (__stencilReference == 0) {
			
			__gl.enable (__gl.STENCIL_TEST);
			__gl.stencilMask (0xFF);
			__gl.clear (__gl.STENCIL_BUFFER_BIT);
			__updatedStencil = true;
			
		}
		
		__gl.stencilOp (__gl.KEEP, __gl.KEEP, __gl.INCR);
		__gl.stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
		__gl.colorMask (false, false, false, false);
		
		mask.__renderGLMask (this);
		__maskObjects.push (mask);
		__stencilReference++;
		
		__gl.stencilOp (__gl.KEEP, __gl.KEEP, __gl.KEEP);
		__gl.stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
		__gl.colorMask (true, true, true, true);
		
	}
	
	
	@:noCompletion private override function __pushMaskObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			__pushMaskRect (object.__scrollRect, object.__renderTransform);
			
		}
		
		if (object.__mask != null) {
			
			__pushMask (object.__mask);
			
		}
		
	}
	
	
	@:noCompletion private override function __pushMaskRect (rect:Rectangle, transform:Matrix):Void {
		
		// TODO: Handle rotation?
		
		if (__numClipRects == __clipRects.length) {
			
			__clipRects[__numClipRects] = new Rectangle ();
			
		}
		
		var _matrix = Matrix.__pool.get ();
		_matrix.copyFrom (transform);
		_matrix.concat (__worldTransform);
		
		var clipRect = __clipRects[__numClipRects];
		rect.__transform (clipRect, _matrix);
		
		if (__numClipRects > 0) {
			
			var parentClipRect = __clipRects[__numClipRects - 1];
			clipRect.__contract (parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
			
		}
		
		if (clipRect.height < 0) {
			
			clipRect.height = 0;
			
		}
		
		if (clipRect.width < 0) {
			
			clipRect.width = 0;
			
		}
		
		Matrix.__pool.release (_matrix);
		
		__scissorRect (clipRect);
		__numClipRects++;
		
	}
	
	
	@:noCompletion private override function __render (object:IBitmapDrawable):Void {
		
		// TODO: Handle restoration of state after Stage3D render better?
		__gl.disable (gl.CULL_FACE);
		
		if (__defaultRenderTarget == null) {
			
			__gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);
			
			__upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);
			
			object.__renderGL (this);
			
			if (__offsetX > 0 || __offsetY > 0) {
				
				__gl.clearColor (0, 0, 0, 1);
				__gl.enable (__gl.SCISSOR_TEST);
				
				if (__offsetX > 0) {
					
					__gl.scissor (0, 0, __offsetX, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
					__gl.scissor (__offsetX + __displayWidth, 0, __width, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
				}
				
				if (__offsetY > 0) {
					
					__gl.scissor (0, 0, __width, __offsetY);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
					__gl.scissor (0, __offsetY + __displayHeight, __width, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
				}
				
				__gl.disable (__gl.SCISSOR_TEST);
				
			}
			
		} else {
			
			__gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);
			
			// __upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);
			
			// TODO: Cleaner approach?
			
			var cacheMask = object.__mask;
			var cacheScrollRect = object.__scrollRect;
			object.__mask = null;
			object.__scrollRect = null;
			
			object.__renderGL (this);
			
			object.__mask = cacheMask;
			object.__scrollRect = cacheScrollRect;
			
		}
		
	}
	
	
	@:noCompletion private function __renderFilterPass (source:BitmapData, shader:Shader, clear:Bool = true):Void {
		
		if (source == null || shader == null) return;
		if (__defaultRenderTarget == null) return;
		
		__gl.bindFramebuffer (__gl.FRAMEBUFFER, __defaultRenderTarget.__getFramebuffer (__context, false));
		
		if (clear) {
			
			__gl.clearColor (0, 0, 0, 0);
			__gl.clear (__gl.COLOR_BUFFER_BIT);
			
		}
		
		var shader = __initShader (shader);
		setShader (shader);
		applyAlpha (1);
		applyBitmapData (source, false);
		applyColorTransform (null);
		applyMatrix (__getMatrix (source.__renderTransform));
		updateShader ();
		
		__gl.bindBuffer (__gl.ARRAY_BUFFER, source.getBuffer (__context));
		if (shader.__position != null) __gl.vertexAttribPointer (shader.__position.index, 3, __gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
		if (shader.__textureCoord != null) __gl.vertexAttribPointer (shader.__textureCoord.index, 2, __gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		__gl.drawArrays (__gl.TRIANGLE_STRIP, 0, 4);
		
		__gl.bindFramebuffer (__gl.FRAMEBUFFER, null);
		
		__clearShader ();
		
	}
	
	
	@:noCompletion private override function __renderStage3D (stage:Stage):Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderGL (stage, this);
			
		}
		
	}
	
	
	@:noCompletion private override function __resize (width:Int, height:Int):Void {
		
		__width = width;
		__height = height;
		
		var w = (__defaultRenderTarget == null) ? __stage.stageWidth : __defaultRenderTarget.width;
		var h = (__defaultRenderTarget == null) ? __stage.stageHeight : __defaultRenderTarget.height;
		
		__offsetX = __defaultRenderTarget == null ? Math.round (__worldTransform.__transformX (0, 0)) : 0;
		__offsetY = __defaultRenderTarget == null ? Math.round (__worldTransform.__transformY (0, 0)) : 0;
		__displayWidth = __defaultRenderTarget == null ? Math.round (__worldTransform.__transformX (w, 0) - __offsetX) : w;
		__displayHeight = __defaultRenderTarget == null ? Math.round (__worldTransform.__transformY (0, h) - __offsetY) : h;
		
		#if (lime >= "7.0.0")
		__projection.createOrtho (__offsetX, __displayWidth + __offsetX, __offsetY, __displayHeight + __offsetY, -1000, 1000);
		__projectionFlipped.createOrtho (__offsetX, __displayWidth + __offsetX, __displayHeight + __offsetY, __offsetY, -1000, 1000);
		#else
		__projection = Matrix4.createOrtho (__offsetX, __displayWidth + __offsetX, __offsetY, __displayHeight + __offsetY, -1000, 1000);
		__projectionFlipped = Matrix4.createOrtho (__offsetX, __displayWidth + __offsetX, __displayHeight + __offsetY, __offsetY, -1000, 1000);
		#end
		
	}
	
	
	@:noCompletion private function __resumeClipAndMask (childRenderer:OpenGLRenderer):Void {
		
		if (__stencilReference > 0) {
			
			__gl.enable (__gl.STENCIL_TEST);
			
		} else {
			
			__gl.disable (__gl.STENCIL_TEST);
			
		}
		
		if (__numClipRects > 0) {
			
			__scissorRect (__clipRects[__numClipRects - 1]);
			
		} else {
			
			__scissorRect ();
			
		}
		
	}
	
	
	@:noCompletion private function __scissorRect (clipRect:Rectangle = null):Void {
		
		if (clipRect != null) {
			
			__gl.enable (__gl.SCISSOR_TEST);
			
			var x = Math.floor (clipRect.x);
			var y = Math.floor (clipRect.y);
			var width = Math.ceil (clipRect.right) - x;
			var height = Math.ceil (clipRect.bottom) - y;
			
			if (width < 0) width = 0;
			if (height < 0) height = 0;
			
			__gl.scissor (x, __flipped ? __height - y - height : y, width, height);
			
		} else {
			
			__gl.disable (__gl.SCISSOR_TEST);
			
		}
		
	}
	
	
	@:noCompletion private override function __setBlendMode (value:BlendMode):Void {
		
		if (__blendMode == value) return;
		
		__blendMode = value;
		
		switch (value) {
			
			case ADD:
				
				__gl.blendEquation (__gl.FUNC_ADD);
				__gl.blendFunc (__gl.ONE, __gl.ONE);
			
			case MULTIPLY:
				
				__gl.blendEquation (__gl.FUNC_ADD);
				__gl.blendFunc (__gl.DST_COLOR, __gl.ONE_MINUS_SRC_ALPHA);
			
			case SCREEN:
				
				__gl.blendEquation (__gl.FUNC_ADD);
				__gl.blendFunc (__gl.ONE, __gl.ONE_MINUS_SRC_COLOR);
			
			case SUBTRACT:
				
				__gl.blendEquation (__gl.FUNC_REVERSE_SUBTRACT);
				__gl.blendFunc (__gl.ONE, __gl.ONE);
			
			#if desktop
			case DARKEN:
				
				__gl.blendEquation (0x8007); // GL_MIN
				__gl.blendFunc (__gl.ONE, __gl.ONE);
				
			case LIGHTEN:
				
				__gl.blendEquation (0x8008); // GL_MAX
				__gl.blendFunc (__gl.ONE, __gl.ONE);
			#end
			
			default:
				
				__gl.blendEquation (__gl.FUNC_ADD);
				__gl.blendFunc (__gl.ONE, __gl.ONE_MINUS_SRC_ALPHA);
			
		}
		
	}
	
	
	@:noCompletion private function __setRenderTarget (renderTarget:BitmapData):Void {
		
		__defaultRenderTarget = renderTarget;
		__flipped = (renderTarget == null);
		
		if (renderTarget != null) {
			
			__resize (renderTarget.width, renderTarget.height);
			
		}
		
	}
	
	
	@:noCompletion private function __setShaderBuffer (shaderBuffer:ShaderBuffer):Void {
		
		setShader (shaderBuffer.shader);
		__currentShaderBuffer = shaderBuffer;
		
	}
	
	
	@:noCompletion private function __suspendClipAndMask ():Void {
		
		if (__stencilReference > 0) {
			
			__gl.disable (__gl.STENCIL_TEST);
			
		}
		
		if (__numClipRects > 0) {
			
			__scissorRect ();
			
		}
		
	}
	
	
	@:noCompletion private function __updateShaderBuffer ():Void {
		
		if (__currentShader != null && __currentShaderBuffer != null) {
			
			__currentShader.__updateFromBuffer (__currentShaderBuffer);
			
		}
		
	}
	
	
}


#else
typedef OpenGLRenderer = Dynamic;
#end