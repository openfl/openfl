package openfl.display; #if !flash


import lime.graphics.opengl.ext.KHR_debug;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
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
@:allow(openfl._internal.renderer.opengl)
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
	
	@:noCompletion private var __activeTexture:Int;
	@:noCompletion private var __blendColor:Array<Float>;
	@:noCompletion private var __blendEquation:Int;
	@:noCompletion private var __blendEquationSeparate:Array<Int>;
	@:noCompletion private var __blendFunc:Array<Int>;
	@:noCompletion private var __blendFuncSeparate:Array<Int>;
	@:noCompletion private var __buffers:Map<Int, GLBuffer>;
	@:noCompletion private var __clearColor:Array<Float>;
	@:noCompletion private var __clipRects:Array<Rectangle>;
	@:noCompletion private var __colorMask:Array<Bool>;
	@:noCompletion private var __cullFace:Int;
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
	@:noCompletion private var __enabled:Map<Int, Bool>;
	@:noCompletion private var __flipped:Bool;
	@:noCompletion private var __framebuffers:Map<Int, GLFramebuffer>;
	@:noCompletion private var __gl:#if (lime >= "7.0.0") WebGLRenderContext #else GLRenderContext #end;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __maskShader:GLMaskShader;
	@:noCompletion private var __matrix:Matrix4;
	@:noCompletion private var __maskObjects:Array<DisplayObject>;
	@:noCompletion private var __numClipRects:Int;
	@:noCompletion private var __offsetX:Int;
	@:noCompletion private var __offsetY:Int;
	@:noCompletion private var __program:GLProgram;
	@:noCompletion private var __projection:Matrix4;
	@:noCompletion private var __projectionFlipped:Matrix4;
	@:noCompletion private var __renderbuffers:Map<Int, GLRenderbuffer>;
	@:noCompletion private var __scissorHeight:Int;
	@:noCompletion private var __scissorWidth:Int;
	@:noCompletion private var __scissorX:Int;
	@:noCompletion private var __scissorY:Int;
	@:noCompletion private var __softwareRenderer:DisplayObjectRenderer;
	@:noCompletion private var __stencilFunc:Array<Int>;
	@:noCompletion private var __stencilMask:Int;
	@:noCompletion private var __stencilOp:Array<Int>;
	@:noCompletion private var __stencilReference:Int;
	@:noCompletion private var __tempRect:Rectangle;
	@:noCompletion private var __textures:Map<Int, GLTexture>;
	@:noCompletion private var __updatedStencil:Bool;
	@:noCompletion private var __upscaled:Bool;
	@:noCompletion private var __values:Array<Float>;
	@:noCompletion private var __viewportHeight:Int;
	@:noCompletion private var __viewportWidth:Int;
	@:noCompletion private var __viewportX:Int;
	@:noCompletion private var __viewportY:Int;
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
		
		__activeTexture = -1;
		__blendColor = [ 0, 0, 0, 0 ];
		__blendEquation = -1;
		__blendEquationSeparate = [ -1, -1 ];
		__blendFunc = [ -1, -1 ];
		__blendFuncSeparate = [ -1, -1, -1, -1 ];
		__buffers = new Map ();
		__clearColor = [ 0, 0, 0, 0 ];
		__colorMask = [ true, true, true, true ];
		__cullFace = -1;
		__enabled = new Map ();
		__framebuffers = new Map ();
		__renderbuffers = new Map ();
		__stencilFunc = [ -1, -1, -1 ];
		__stencilMask = -1;
		__stencilOp = [ -1, -1, -1 ];
		__textures = new Map ();
		
		if (Graphics.maxTextureWidth == null) {
			
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = __gl.getParameter (__gl.MAX_TEXTURE_SIZE);
			
		}
		
		__matrix = new Matrix4 ();
		__values = new Array ();
		
		#if gl_debug
		var ext:KHR_debug = __gl.getExtension ("KHR_debug");
		if (ext != null) {
			
			enable (ext.DEBUG_OUTPUT);
			enable (ext.DEBUG_OUTPUT_SYNCHRONOUS);
			
		}
		#end
		
		#if (js && html5)
		__softwareRenderer = new CanvasRenderer (null);
		#else
		__softwareRenderer = new CairoRenderer (null);
		#end
		
		__type = OPENGL;
		
		__setBlendMode (NORMAL);
		enable (__gl.BLEND);
		
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
	
	
	public function activeTexture (texture:Int):Void {
		
		if (__activeTexture != texture) {
			
			__activeTexture = texture;
			__gl.activeTexture (texture);
			
		}
		
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
	
	
	public function bindBuffer (target:Int, buffer:GLBuffer):Void {
		
		if (__buffers[target] != buffer) {
			
			__buffers[target] = buffer;
			__gl.bindBuffer (target, buffer);
			
		}
		
	}
	
	
	public function bindFramebuffer (target:Int, framebuffer:GLFramebuffer):Void {
		
		if (__framebuffers[target] != framebuffer) {
			
			__framebuffers[target] = framebuffer;
			__gl.bindFramebuffer (target, framebuffer);
			
		}
		
	}
	
	
	public function bindRenderbuffer (target:Int, renderbuffer:GLRenderbuffer):Void {
		
		if (__renderbuffers[target] != renderbuffer) {
			
			__renderbuffers[target] = renderbuffer;
			__gl.bindRenderbuffer (target, renderbuffer);
			
		}
		
	}
	
	
	public function bindTexture (target:Int, texture:GLTexture):Void {
		
		if (__textures[target] != texture) {
			
			__textures[target] = texture;
			__gl.bindTexture (target, texture);
			
		}
		
	}
	
	
	public function blendColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		if (__blendColor[0] != red || __blendColor[1] != green || __blendColor[2] != blue || __blendColor[3] != alpha) {
			
			__blendColor[0] = red;
			__blendColor[1] = green;
			__blendColor[2] = blue;
			__blendColor[3] = alpha;
			__gl.blendColor (red, green, blue, alpha);
			
		}
		
	}
	
	
	public function blendEquation (mode:Int):Void {
		
		if (__blendEquation != mode) {
			
			__blendEquation = mode;
			__blendEquationSeparate[0] = -1;
			__blendEquationSeparate[1] = -1;
			__gl.blendEquation (mode);
			
		}
		
	}
	
	
	public function blendEquationSeparate (modeRGB:Int, modeAlpha:Int):Void {
		
		if (__blendEquationSeparate[0] != modeRGB || __blendEquationSeparate[1] != modeAlpha) {
			
			__blendEquationSeparate[0] = modeRGB;
			__blendEquationSeparate[1] = modeAlpha;
			__blendEquation = -1;
			__gl.blendEquationSeparate (modeRGB, modeAlpha);
			
		}
		
	}
	
	
	public function blendFunc (sfactor:Int, dfactor:Int):Void {
		
		if (__blendFunc[0] != sfactor || __blendFunc[1] != dfactor) {
			
			__blendFunc[0] = sfactor;
			__blendFunc[1] = dfactor;
			__blendFuncSeparate[0] = -1;
			__blendFuncSeparate[1] = -1;
			__blendFuncSeparate[2] = -1;
			__blendFuncSeparate[3] = -1;
			__gl.blendFunc (sfactor, dfactor);
			
		}
		
	}
	
	
	public function blendFuncSeparate (srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void {
		
		if (__blendFuncSeparate[0] != srcRGB || __blendFuncSeparate[1] != dstRGB || __blendFuncSeparate[2] != srcAlpha || __blendFuncSeparate[3] != dstAlpha) {
			
			__blendFuncSeparate[0] = srcRGB;
			__blendFuncSeparate[1] = dstRGB;
			__blendFuncSeparate[2] = srcAlpha;
			__blendFuncSeparate[3] = dstAlpha;
			__blendFunc[0] = -1;
			__blendFunc[1] = -1;
			__gl.blendFuncSeparate (srcRGB, dstRGB, srcAlpha, dstAlpha);
			
		}
		
	}
	
	
	public function clearColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		if (__clearColor[0] != red || __clearColor[1] != green || __clearColor[2] != blue || __clearColor[3] != alpha) {
			
			__clearColor[0] = red;
			__clearColor[1] = green;
			__clearColor[2] = blue;
			__clearColor[3] = alpha;
			__gl.clearColor (red, green, blue, alpha);
			
		}
		
	}
	
	
	public function colorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		if (__colorMask[0] != red || __colorMask[1] != green || __colorMask[2] != blue || __colorMask[3] != alpha) {
			
			__colorMask[0] = red;
			__colorMask[1] = green;
			__colorMask[2] = blue;
			__colorMask[3] = alpha;
			__gl.colorMask (red, green, blue, alpha);
			
		}
		
	}
	
	
	public function cullFace (face:Int):Void {
		
		if (__cullFace != face) {
			
			__cullFace = face;
			__gl.cullFace (face);
			
		}
		
	}
	
	
	public function disable (cap:Int):Void {
		
		if (__enabled[cap] == true) {
			
			__enabled[cap] = false;
			__gl.disable (cap);
			
		}
		
	}
	
	
	public function enable (cap:Int):Void {
		
		if (__enabled[cap] != true) {
			
			__enabled[cap] = true;
			__gl.enable (cap);
			
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
	
	
	public function scissor (x:Int, y:Int, width:Int, height:Int):Void {
		
		if (x != __scissorX || y != __scissorY || width != __scissorWidth || height != __scissorHeight) {
			
			__scissorX = x;
			__scissorY = y;
			__scissorWidth = width;
			__scissorHeight = height;
			__gl.scissor (x, y, width, height);
			
		}
		
	}
	
	
	@:deprecated("Use 'useShader' instead") public function setShader (shader:Shader):Void {
		
		useShader (shader);
		
	}
	
	
	@:deprecated("Use 'viewport' instead") public function setViewport ():Void {
		
		viewport ();
		
	}
	
	
	public function stencilFunc (func:Int, ref:Int, mask:Int):Void {
		
		if (__stencilFunc[0] != func || __stencilFunc[1] != ref || __stencilFunc[2] != mask) {
			
			__stencilFunc[0] = func;
			__stencilFunc[1] = ref;
			__stencilFunc[2] = mask;
			__gl.stencilFunc (func, ref, mask);
			
		}
		
	}
	
	
	public function stencilMask (mask:Int):Void {
		
		if (__stencilMask != mask) {
			
			__stencilMask = mask;
			__gl.stencilMask (mask);
			
		}
		
	}
	
	
	public function stencilOp (sfail:Int, dpfail:Int, dppass:Int):Void {
		
		if (__stencilOp[0] != sfail || __stencilOp[1] != dpfail || __stencilOp[2] != dppass) {
			
			__stencilOp[0] = sfail;
			__stencilOp[1] = dpfail;
			__stencilOp[2] = dppass;
			__gl.stencilOp (sfail, dpfail, dppass);
			
		}
		
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
	
	
	public function useProgram (program:GLProgram):Void {
		
		if (__program != program) {
			
			__program = program;
			__gl.useProgram (program);
			
		}
		
	}
	
	
	public function useShader (shader:Shader):Void {
		
		__currentShaderBuffer = null;
		
		if (__currentShader == shader) return;
		
		if (__currentShader != null) {
			
			__currentShader.__disable ();
			
		}
		
		if (shader == null) {
			
			__currentShader = null;
			useProgram (null);
			return;
			
		} else {
			
			__currentShader = shader;
			__initShader (shader);
			useProgram (shader.glProgram);
			__currentShader.__enable ();
			
		}
		
	}
	
	
	public function viewport (x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0):Void {
		
		if (width == 0 || height == 0) {
			
			x = __offsetX;
			y = __offsetY;
			width = __displayWidth;
			height = __displayHeight;
			
		}
		
		if (x != __viewportX || y != __viewportY || width != __viewportWidth || height != __viewportHeight) {
			
			__viewportX = x;
			__viewportY = y;
			__viewportWidth = width;
			__viewportHeight = height;
			__gl.viewport (x, y, width, height);
			
		}
		
	}
	
	
	@:noCompletion private function __cleanup ():Void {
		
		if (__stencilReference > 0) {
			
			__stencilReference = 0;
			disable (__gl.STENCIL_TEST);
			
		}
		
		if (__numClipRects > 0) {
			
			__numClipRects = 0;
			__scissorRect ();
			
		}
		
	}
	
	
	@:noCompletion private override function __clear ():Void {
		
		if (__stage == null || __stage.__transparent) {
			
			clearColor (0, 0, 0, 0);
			
		} else {
			
			clearColor (__stage.__colorSplit[0], __stage.__colorSplit[1], __stage.__colorSplit[2], 1);
			
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
		
		__program = other.__program;
		
	}
	
	
	@:noCompletion private function __copyState (other:OpenGLRenderer):Void {
		
		__activeTexture = other.__activeTexture;
		__blendEquation = other.__blendEquation;
		__cullFace = other.__cullFace;
		// __program = other.__program;
		__scissorHeight = other.__scissorHeight;
		__scissorWidth = other.__scissorWidth;
		__scissorX = other.__scissorX;
		__scissorY = other.__scissorY;
		__stencilMask = other.__stencilMask;
		__viewportHeight = other.__viewportHeight;
		__viewportWidth = other.__viewportWidth;
		__viewportX = other.__viewportX;
		__viewportY = other.__viewportY;
		
		for (i in 0...4) {
			
			__blendColor[i] = other.__blendColor[i];
			if (i < 3) __blendEquationSeparate[i] = other.__blendEquationSeparate[i];
			if (i < 3) __blendFunc[i] = other.__blendFunc[i];
			__blendFuncSeparate[i] = other.__blendFuncSeparate[i];
			__clearColor[i] = other.__clearColor[i];
			__colorMask[i] = other.__colorMask[i];
			if (i < 4) __stencilFunc[i] = other.__stencilFunc[i];
			if (i < 4) __stencilOp[i] = other.__stencilOp[i];
			
		}
		
		// TODO: Better way to handle this?
		
		__buffers = new Map ();
		__enabled = new Map ();
		__framebuffers = new Map ();
		__renderbuffers = new Map ();
		__textures = new Map ();
		
		for (key in other.__buffers.keys ()) {
			
			__buffers[key] = other.__buffers[key];
			
		}
		
		for (key in other.__enabled.keys ()) {
			
			__enabled[key] = other.__enabled[key];
			
		}
		
		for (key in other.__framebuffers.keys ()) {
			
			__framebuffers[key] = other.__framebuffers[key];
			
		}
		
		for (key in other.__renderbuffers.keys ()) {
			
			__renderbuffers[key] = other.__renderbuffers[key];
			
		}
		
		for (key in other.__textures.keys ()) {
			
			__textures[key] = other.__textures[key];
			
		}
		
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
			
			// if (shader.__renderer == null) {
				
				shader.__renderer = this;
				shader.__init ();
				
			// }
			
			//currentShader = shader;
			return shader;
			
		}
		
		return __defaultShader;
		
	}
	
	
	@:noCompletion private function __initDisplayShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			// if (shader.__renderer == null) {
				
				shader.__renderer = this;
				shader.__init ();
				
			// }
			
			//currentShader = shader;
			return shader;
			
		}
		
		return __defaultDisplayShader;
		
	}
	
	
	@:noCompletion private function __initGraphicsShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			// if (shader.__renderer == null) {
				
				shader.__renderer = this;
				shader.__init ();
				
			// }
			
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
			
			stencilOp (__gl.KEEP, __gl.KEEP, __gl.DECR);
			stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
			colorMask (false, false, false, false);
			
			mask.__renderGLMask (this);
			__stencilReference--;
			
			stencilOp (__gl.KEEP, __gl.KEEP, __gl.KEEP);
			stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
			colorMask (true, true, true, true);
			
		} else {
			
			__stencilReference = 0;
			disable (__gl.STENCIL_TEST);
			
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
			
			enable (__gl.STENCIL_TEST);
			stencilMask (0xFF);
			__gl.clear (__gl.STENCIL_BUFFER_BIT);
			__updatedStencil = true;
			
		}
		
		stencilOp (__gl.KEEP, __gl.KEEP, __gl.INCR);
		stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
		colorMask (false, false, false, false);
		
		mask.__renderGLMask (this);
		__maskObjects.push (mask);
		__stencilReference++;
		
		stencilOp (__gl.KEEP, __gl.KEEP, __gl.KEEP);
		stencilFunc (__gl.EQUAL, __stencilReference, 0xFF);
		colorMask (true, true, true, true);
		
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
		disable (__gl.CULL_FACE);
		disable (__gl.DEPTH_TEST);
		disable (__gl.STENCIL_TEST);
		disable (__gl.SCISSOR_TEST);
		
		if (__defaultRenderTarget == null) {
			
			viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);
			
			__upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);
			
			object.__renderGL (this);
			
			if (__offsetX > 0 || __offsetY > 0) {
				
				clearColor (0, 0, 0, 1);
				enable (__gl.SCISSOR_TEST);
				
				if (__offsetX > 0) {
					
					scissor (0, 0, __offsetX, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
					scissor (__offsetX + __displayWidth, 0, __width, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
				}
				
				if (__offsetY > 0) {
					
					scissor (0, 0, __width, __offsetY);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
					scissor (0, __offsetY + __displayHeight, __width, __height);
					__gl.clear (__gl.COLOR_BUFFER_BIT);
					
				}
				
				disable (__gl.SCISSOR_TEST);
				
			}
			
		} else {
			
			viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);
			
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
		
		bindFramebuffer (__gl.FRAMEBUFFER, __defaultRenderTarget.__getFramebuffer (this, false));
		
		if (clear) {
			
			clearColor (0, 0, 0, 0);
			__gl.clear (__gl.COLOR_BUFFER_BIT);
			
		}
		
		var shader = __initShader (shader);
		useShader (shader);
		applyAlpha (1);
		applyBitmapData (source, false);
		applyColorTransform (null);
		applyMatrix (__getMatrix (source.__renderTransform));
		updateShader ();
		
		bindBuffer (__gl.ARRAY_BUFFER, source.getBuffer (this));
		if (shader.__position != null) __gl.vertexAttribPointer (shader.__position.index, 3, __gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
		if (shader.__textureCoord != null) __gl.vertexAttribPointer (shader.__textureCoord.index, 2, __gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		__gl.drawArrays (__gl.TRIANGLE_STRIP, 0, 4);
		
		bindFramebuffer (__gl.FRAMEBUFFER, null);
		
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
	
	
	@:noCompletion private function __restoreState (other:OpenGLRenderer):Void {
		
		if (other.__activeTexture != __activeTexture) {
			if (__activeTexture != -1) {
				__gl.activeTexture (__activeTexture);
			} else {
				__activeTexture = other.__activeTexture;
			}
		}
		
		if (other.__blendEquation != __blendEquation) {
			if (__blendEquation != -1) {
				__gl.blendEquation (__blendEquation);
			} else {
				__blendEquation = other.__blendEquation;
			}
		}
		
		if (other.__cullFace != __cullFace) {
			if (__cullFace != -1) {
				__gl.cullFace (__cullFace);
			} else {
				__cullFace = other.__cullFace;
			}
		}
		
		if (other.__scissorX != __scissorX || other.__scissorY != __scissorY || other.__scissorWidth != __scissorWidth || other.__scissorHeight != __scissorHeight) {
			if (__scissorWidth != 0 || __scissorHeight != 0) {
				__gl.scissor (__scissorX, __scissorY, __scissorWidth, __scissorHeight);
			} else {
				__scissorX = other.__scissorX;
				__scissorY = other.__scissorY;
				__scissorWidth = other.__scissorWidth;
				__scissorHeight = other.__scissorHeight;
			}
		}
		
		if (other.__stencilMask != __stencilMask) {
			if (__stencilMask != -1) {
				__gl.stencilMask (__stencilMask);
			} else {
				__stencilMask = other.__stencilMask;
			}
		}
		
		if (other.__viewportX != __viewportX || other.__viewportY != __viewportY || other.__viewportWidth != __viewportWidth || other.__viewportHeight != __viewportHeight) {
			if (__viewportWidth != 0 || __viewportHeight != 0) {
				__gl.viewport (__viewportX, __viewportY, __viewportWidth, __viewportHeight);
			} else {
				__viewportX = other.__viewportX;
				__viewportY = other.__viewportY;
				__viewportWidth = other.__viewportWidth;
				__viewportHeight = other.__viewportHeight;
			}
		}
		
		if (other.__blendColor[0] != __blendColor[0] || other.__blendColor[1] != __blendColor[1] || other.__blendColor[2] != __blendColor[2] || other.__blendColor[3] != __blendColor[3]) {
			if (__blendColor[0] != -1) {
				__gl.blendColor (__blendColor[0], __blendColor[1], __blendColor[2], __blendColor[3]);
			} else {
				__blendColor[0] = other.__blendColor[0];
				__blendColor[1] = other.__blendColor[1];
				__blendColor[2] = other.__blendColor[2];
				__blendColor[3] = other.__blendColor[3];
			}
		}
		
		if (other.__blendEquationSeparate[0] != __blendEquationSeparate[0] || other.__blendEquationSeparate[1] != __blendEquationSeparate[1]) {
			if (__blendEquationSeparate[0] != -1) {
				__gl.blendEquationSeparate (__blendEquationSeparate[0], __blendEquationSeparate[1]);
			} else {
				__blendEquationSeparate[0] = other.__blendEquationSeparate[0];
				__blendEquationSeparate[1] = other.__blendEquationSeparate[1];
			}
		}
		
		if (other.__blendFunc[0] != __blendFunc[0] || other.__blendFunc[1] != __blendFunc[1]) {
			if (__blendFunc[0] != -1) {
				__gl.blendFunc (__blendFunc[0], __blendFunc[1]);
			} else {
				__blendFunc[0] = other.__blendFunc[0];
				__blendFunc[1] = other.__blendFunc[1];
			}
		}
		
		if (other.__blendFuncSeparate[0] != __blendFuncSeparate[0] || other.__blendFuncSeparate[1] != __blendFuncSeparate[1] || other.__blendFuncSeparate[2] != __blendFuncSeparate[2] || other.__blendFuncSeparate[3] != __blendFuncSeparate[3]) {
			if (__blendFuncSeparate[0] != -1) {
				__gl.blendFuncSeparate (__blendFuncSeparate[0], __blendFuncSeparate[1], __blendFuncSeparate[2], __blendFuncSeparate[3]);
			} else {
				__blendFuncSeparate[0] = other.__blendFuncSeparate[0];
				__blendFuncSeparate[1] = other.__blendFuncSeparate[1];
				__blendFuncSeparate[2] = other.__blendFuncSeparate[2];
				__blendFuncSeparate[3] = other.__blendFuncSeparate[3];
			}
		}
		
		if (other.__clearColor[0] != __clearColor[0] || other.__clearColor[1] != __clearColor[1] || other.__clearColor[2] != __clearColor[2] || other.__clearColor[3] != __clearColor[3]) {
			if (__clearColor[0] != -1) {
				__gl.clearColor (__clearColor[0], __clearColor[1], __clearColor[2], __clearColor[3]);
			} else {
				__clearColor[0] = other.__clearColor[0];
				__clearColor[1] = other.__clearColor[1];
				__clearColor[2] = other.__clearColor[2];
				__clearColor[3] = other.__clearColor[3];
			}
		}
		
		if (other.__colorMask[0] != __colorMask[0] || other.__colorMask[1] != __colorMask[1] || other.__colorMask[2] != __colorMask[2] || other.__colorMask[3] != __colorMask[3]) {
			__gl.colorMask (__colorMask[0], __colorMask[1], __colorMask[2], __colorMask[3]);
		}
		
		if (other.__stencilFunc[0] != __stencilFunc[0] || other.__stencilFunc[1] != __stencilFunc[1] || other.__stencilFunc[2] != __stencilFunc[2]) {
			if (__stencilFunc[0] != -1) {
				__gl.stencilFunc (__stencilFunc[0], __stencilFunc[1], __stencilFunc[2]);
			} else {
				__stencilFunc[0] = other.__stencilFunc[0];
				__stencilFunc[1] = other.__stencilFunc[1];
				__stencilFunc[2] = other.__stencilFunc[2];
			}
		}
		
		if (other.__stencilOp[0] != __stencilOp[0] || other.__stencilOp[1] != __stencilOp[1] || other.__stencilOp[2] != __stencilOp[2]) {
			if (__stencilOp[0] != -1) {
				__gl.stencilOp (__stencilOp[0], __stencilOp[1], __stencilOp[2]);
			} else {
				__stencilOp[0] = other.__stencilOp[0];
				__stencilOp[1] = other.__stencilOp[1];
				__stencilOp[2] = other.__stencilOp[2];
			}
		}
		
		for (key in __buffers.keys ()) {
			if (other.__buffers.exists (key) && other.__buffers[key] != __buffers[key]) {
				if (__buffers[key] != null) {
					__gl.bindBuffer (key, __buffers[key]);
				} else {
					__buffers[key] = other.__buffers[key];
				}
			}
		}
		for (key in other.__buffers.keys ()) {
			if (!__buffers.exists (key)) __buffers[key] = other.__buffers[key];
		}
		
		for (key in __enabled.keys ()) {
			if (other.__enabled.exists (key) && other.__enabled[key] != __enabled[key]) {
				if (__enabled[key] == true) {
					__gl.enable (key);
				} else {
					__gl.disable (key);
				}
			}
		}
		for (key in other.__enabled.keys ()) {
			if (!__enabled.exists (key)) __enabled[key] = other.__enabled[key];
		}
		
		for (key in __framebuffers.keys ()) {
			if (other.__framebuffers.exists (key) && other.__framebuffers[key] != __framebuffers[key]) {
				if (__framebuffers[key] != null) {
					__gl.bindFramebuffer (key, __framebuffers[key]);
				} else {
					__framebuffers[key] = other.__framebuffers[key];
				}
			}
		}
		for (key in other.__framebuffers.keys ()) {
			if (!__framebuffers.exists (key)) __framebuffers[key] = other.__framebuffers[key];
		}
		
		for (key in __renderbuffers.keys ()) {
			if (other.__renderbuffers.exists (key) && other.__renderbuffers[key] != __renderbuffers[key]) {
				if (__renderbuffers[key] != null) {
					__gl.bindRenderbuffer (key, __renderbuffers[key]);
				} else {
					__renderbuffers[key] = other.__renderbuffers[key];
				}
			}
		}
		for (key in other.__renderbuffers.keys ()) {
			if (!__renderbuffers.exists (key)) __renderbuffers[key] = other.__renderbuffers[key];
		}
		
		// TODO: Do we need to rebind textures here?
		
		for (key in __textures.keys ()) {
			if (other.__textures.exists (key) && other.__textures[key] != __textures[key]) {
				if (__textures[key] != null) {
					__gl.bindTexture (key, __textures[key]);
				} else {
					__textures[key] = other.__textures[key];
				}
			}
		}
		for (key in other.__textures.keys ()) {
			if (!__textures.exists (key)) __textures[key] = other.__textures[key];
		}
		
	}
	
	
	@:noCompletion private function __resumeClipAndMask (childRenderer:OpenGLRenderer):Void {
		
		if (__stencilReference > 0) {
			
			enable (__gl.STENCIL_TEST);
			
		} else {
			
			disable (__gl.STENCIL_TEST);
			
		}
		
		if (__numClipRects > 0) {
			
			__scissorRect (__clipRects[__numClipRects - 1]);
			
		} else {
			
			__scissorRect ();
			
		}
		
	}
	
	
	@:noCompletion private function __scissorRect (clipRect:Rectangle = null):Void {
		
		if (clipRect != null) {
			
			enable (__gl.SCISSOR_TEST);
			
			var x = Math.floor (clipRect.x);
			var y = Math.floor (clipRect.y);
			var width = Math.ceil (clipRect.right) - x;
			var height = Math.ceil (clipRect.bottom) - y;
			
			if (width < 0) width = 0;
			if (height < 0) height = 0;
			
			scissor (x, __flipped ? __height - y - height : y, width, height);
			
		} else {
			
			disable (__gl.SCISSOR_TEST);
			
		}
		
	}
	
	
	@:noCompletion private override function __setBlendMode (value:BlendMode):Void {
		
		if (__blendMode == value) return;
		
		__blendMode = value;
		
		switch (value) {
			
			case ADD:
				
				blendEquation (__gl.FUNC_ADD);
				blendFunc (__gl.ONE, __gl.ONE);
			
			case MULTIPLY:
				
				blendEquation (__gl.FUNC_ADD);
				blendFunc (__gl.DST_COLOR, __gl.ONE_MINUS_SRC_ALPHA);
			
			case SCREEN:
				
				blendEquation (__gl.FUNC_ADD);
				blendFunc (__gl.ONE, __gl.ONE_MINUS_SRC_COLOR);
			
			case SUBTRACT:
				
				blendEquation (__gl.FUNC_REVERSE_SUBTRACT);
				blendFunc (__gl.ONE, __gl.ONE);
			
			#if desktop
			case DARKEN:
				
				blendEquation (0x8007); // GL_MIN
			blendFunc (__gl.ONE, __gl.ONE);
				
			case LIGHTEN:
				
				blendEquation (0x8008); // GL_MAX
				blendFunc (__gl.ONE, __gl.ONE);
			#end
			
			default:
				
				blendEquation (__gl.FUNC_ADD);
				blendFunc (__gl.ONE, __gl.ONE_MINUS_SRC_ALPHA);
			
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
		
		useShader (shaderBuffer.shader);
		__currentShaderBuffer = shaderBuffer;
		
	}
	
	
	@:noCompletion private function __suspendClipAndMask ():Void {
		
		if (__stencilReference > 0) {
			
			disable (__gl.STENCIL_TEST);
			
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