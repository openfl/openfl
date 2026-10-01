package openfl.display;

#if !flash
import openfl.display._internal.Context3DBitmap;
import openfl.display._internal.Context3DBitmapData;
import openfl.display._internal.Context3DDisplayObject;
import openfl.display._internal.Context3DDisplayObjectContainer;
import openfl.display._internal.Context3DGraphics;
import openfl.display._internal.Context3DMaskShader;
import openfl.display._internal.Context3DSimpleButton;
import openfl.display._internal.Context3DTextField;
import openfl.display._internal.Context3DTilemap;
import openfl.display._internal.Context3DVideo;
import openfl.display._internal.ShaderBuffer;
import openfl.utils.ObjectPool;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display._internal.BlendModeShader;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.opengl.ext.KHR_debug;
import lime.graphics.WebGLRenderContext;
import lime.math.Matrix4;
#end

/**
	**BETA**

	The OpenGLRenderer API exposes support for OpenGL render instructions within the
	`RenderEvent.RENDER_OPENGL` event.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.GLRenderContext)
@:access(openfl.display._internal.ShaderBuffer)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl.display.Bitmap)
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
@:allow(openfl.display._internal)
@:allow(openfl.display3D.textures)
@:allow(openfl.display3D)
@:allow(openfl.display)
@:allow(openfl.text)
class OpenGLRenderer extends DisplayObjectRenderer
{
	@:noCompletion private static var __alphaValue:Array<Float> = [1];
	@:noCompletion private static var __colorMultipliersValue:Array<Float> = [0, 0, 0, 0];
	@:noCompletion private static var __colorOffsetsValue:Array<Float> = [0, 0, 0, 0];
	@:noCompletion private static var __defaultColorMultipliersValue:Array<Float> = [1, 1, 1, 1];
	@:noCompletion private static var __emptyColorValue:Array<Float> = [0, 0, 0, 0];
	@:noCompletion private static var __emptyAlphaValue:Array<Float> = [1];
	@:noCompletion private static var __discardTransparentValue:Array<Bool> = [false];
	@:noCompletion private static var __hasCoverageValue:Array<Bool> = [false];
	@:noCompletion private static var __hasColorTransformValue:Array<Bool> = [false];
	@:noCompletion private static var __scissorRectangle:Rectangle = new Rectangle();
	@:noCompletion private static var __textureSizeValue:Array<Float> = [0, 0];

	/**
		The current OpenGL render context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var gl:#if lime WebGLRenderContext #else Dynamic #end;

	@:noCompletion private static var __staticDefaultDisplayShader:DisplayObjectShader;
	@:noCompletion private static var __staticDefaultGraphicsShader:GraphicsShader;
	@:noCompletion private static var __staticMaskShader:Context3DMaskShader;

	@:noCompletion private var __context3D:Context3D;
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
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __gl:#if lime WebGLRenderContext #else Dynamic #end;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __maskShader:Context3DMaskShader;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __matrix:#if lime Matrix4 #else Dynamic #end;
	@:noCompletion private var __maskObjects:Array<DisplayObject>;
	@:noCompletion private var __numClipRects:Int;
	@:noCompletion private var __offsetX:Int;
	@:noCompletion private var __offsetY:Int;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __projection:#if lime Matrix4 #else Dynamic #end;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __projectionFlipped:#if lime Matrix4 #else Dynamic #end;
	@:noCompletion private var __scrollRectMasks:ObjectPool<Shape>;
	@:noCompletion private var __softwareRenderer:DisplayObjectRenderer;
	@:noCompletion private var __stencilReference:Int;
	@:noCompletion private var __tempRect:Rectangle;
	@:noCompletion private var __updatedStencil:Bool;
	@:noCompletion private var __upscaled:Bool;
	@:noCompletion private var __values:Array<Float>;
	@:noCompletion private var __width:Int;
	@:noCompletion private var __groupOffsetX:Int = 0;
	@:noCompletion private var __groupOffsetY:Int = 0;

	// group scratch buffers (object, backdrop, ALPHA coverage, touched) and clip stacks per nesting
	// level, shared by every renderer on the context: a cacheAsBitmap child renderer can run inside a group
	@:noCompletion private static var __groupClipRects:Array<Array<Rectangle>> = [];
	@:noCompletion private static var __groupDepth:Int = 0;
	@:noCompletion private static var __groupScratchBuffers:Array<BitmapData> = [];

	// the current group's touched buffer (see __touch), once built
	@:noCompletion private var __touched:BitmapData;

	@:noCompletion private static var __staticBlendShader:BlendModeShader;
	@:noCompletion private static var __staticWhite:BitmapData;

	// __renderDrawableDirect draws coverage instead of objects (see __drawCoverage)
	@:noCompletion private var __coverageOnly:Bool;

	@:noCompletion private static var __invertSilhouette:ColorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 0);

	@:noCompletion private function new(context:Context3D, defaultRenderTarget:BitmapData = null)
	{
		super();

		__context3D = context;
		__context = context.__context;

		gl = context.__context.webgl;
		__gl = gl;

		this.__defaultRenderTarget = defaultRenderTarget;
		this.__flipped = (__defaultRenderTarget == null);

		if (Graphics.maxTextureWidth == null)
		{
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = __gl.getParameter(__gl.MAX_TEXTURE_SIZE);
		}

		#if lime
		__matrix = new Matrix4();
		#end

		__values = new Array();

		#if gl_debug
		var ext:KHR_debug = __gl.getExtension("KHR_debug");
		if (ext != null)
		{
			gl.enable(ext.DEBUG_OUTPUT);
			gl.enable(ext.DEBUG_OUTPUT_SYNCHRONOUS);
		}
		#end

		#if (js && html5)
		__softwareRenderer = new CanvasRenderer(null);
		#else
		__softwareRenderer = new CairoRenderer(null);
		#end

		#if lime
		__type = OPENGL;
		#end

		__setBlendMode(NORMAL);
		__context3D.__setGLBlend(true);

		__clipRects = new Array();
		__maskObjects = new Array();
		__numClipRects = 0;
		#if lime
		__projection = new Matrix4();
		__projectionFlipped = new Matrix4();
		#end
		__stencilReference = 0;
		__tempRect = new Rectangle();

		if (__staticDefaultDisplayShader == null) __staticDefaultDisplayShader = new DisplayObjectShader();
		if (__staticDefaultGraphicsShader == null) __staticDefaultGraphicsShader = new GraphicsShader();
		if (__staticMaskShader == null) __staticMaskShader = new Context3DMaskShader();

		__defaultDisplayShader = __staticDefaultDisplayShader;
		__defaultGraphicsShader = __staticDefaultGraphicsShader;
		__defaultShader = __defaultDisplayShader;

		__initShader(__defaultShader);

		__scrollRectMasks = new ObjectPool<Shape>(function() return new Shape());
		__maskShader = __staticMaskShader;
	}

	/**
		Applies an alpha value to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyAlpha(alpha:Float):Void
	{
		// the coverage pass of an ALPHA group draws everything opaque (see __drawCoverage)
		__alphaValue[0] = __coverageOnly ? 1 : alpha * __worldAlpha;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addFloatOverride("openfl_Alpha", __alphaValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__alpha != null) __currentShader.__alpha.value = __alphaValue;
		}
	}

	/**
		Binds a BitmapData object as the first active texture of the current active shader,
		if compatible with OpenFL core shaders
	**/
	public function applyBitmapData(bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void
	{
		// every quad starts as a bitmap: its transparent texels count as covered (see applyDiscardTransparent)
		applyDiscardTransparent(false);
		applyCoverage(null);

		if (__currentShaderBuffer != null)
		{
			if (bitmapData != null)
			{
				__textureSizeValue[0] = bitmapData.__textureWidth;
				__textureSizeValue[1] = bitmapData.__textureHeight;

				__currentShaderBuffer.addFloatOverride("openfl_TextureSize", __textureSizeValue);
			}
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__bitmap != null)
			{
				__currentShader.__bitmap.input = bitmapData;
				__currentShader.__bitmap.filter = (smooth && __allowSmoothing) ? LINEAR : NEAREST;
				__currentShader.__bitmap.mipFilter = MIPNONE;
				__currentShader.__bitmap.wrap = repeat ? REPEAT : CLAMP;
			}

			if (__currentShader.__texture != null)
			{
				__currentShader.__texture.input = bitmapData;
				__currentShader.__texture.filter = (smooth && __allowSmoothing) ? LINEAR : NEAREST;
				__currentShader.__texture.mipFilter = MIPNONE;
				__currentShader.__texture.wrap = repeat ? REPEAT : CLAMP;
			}

			if (__currentShader.__textureSize != null)
			{
				if (bitmapData != null)
				{
					__textureSizeValue[0] = bitmapData.__textureWidth;
					__textureSizeValue[1] = bitmapData.__textureHeight;

					__currentShader.__textureSize.value = __textureSizeValue;
				}
				else
				{
					__currentShader.__textureSize.value = null;
				}
			}
		}
	}

	/**
		Applies a color transform value to the active shader, if compatible with OpenFL
		core shaders
	**/
	public function applyColorTransform(colorTransform:ColorTransform):Void
	{
		if (__blendMode == INVERT)
		{
			// INVERT only uses the object's alpha: draw it as a white silhouette (see __setBlendMode)
			colorTransform = __invertSilhouette;
		}

		var enabled = (colorTransform != null && !colorTransform.__isDefault(true) && !__coverageOnly);
		applyHasColorTransform(enabled);

		if (enabled)
		{
			colorTransform.__setArrays(__colorMultipliersValue, __colorOffsetsValue);

			if (__currentShaderBuffer != null)
			{
				__currentShaderBuffer.addFloatOverride("openfl_ColorMultiplier", __colorMultipliersValue);
				__currentShaderBuffer.addFloatOverride("openfl_ColorOffset", __colorOffsetsValue);
			}
			else if (__currentShader != null)
			{
				if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.value = __colorMultipliersValue;
				if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.value = __colorOffsetsValue;
			}
		}
		else
		{
			if (__currentShaderBuffer != null)
			{
				__currentShaderBuffer.addFloatOverride("openfl_ColorMultiplier", __emptyColorValue);
				__currentShaderBuffer.addFloatOverride("openfl_ColorOffset", __emptyColorValue);
			}
			else if (__currentShader != null)
			{
				if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.value = __emptyColorValue;
				if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.value = __emptyColorValue;
			}
		}
	}

	/**
		Sets the coverage of the shape being drawn under ALPHA, its fills rendered fully opaque
		(`Graphics.__coverage`), or null for none. With a coverage, the display shader keeps
		`1 - coverage + alpha` of the backdrop, which is what Flash does at an anti-aliased edge, rather
		than using the shape's alpha alone. `applyBitmapData` resets it to null.
	**/
	public function applyCoverage(bitmapData:BitmapData):Void
	{
		__hasCoverageValue[0] = bitmapData != null;

		if (__currentShader != null)
		{
			if (__currentShader.__coverage != null) __currentShader.__coverage.input = bitmapData;
			if (__currentShader.__hasCoverage != null) __currentShader.__hasCoverage.value = __hasCoverageValue;
		}
	}

	/**
		Tells the display shader to skip texels with alpha 0 instead of drawing them as transparent.

		Flash's ALPHA only affects the pixels an object covers. A Bitmap covers its whole rectangle, so
		even its transparent pixels cut into the backdrop. A shape's texture is transparent wherever
		nothing was drawn, and those texels lie outside the shape, so they must leave the backdrop
		alone. `applyBitmapData` resets this to false.
	**/
	public function applyDiscardTransparent(enabled:Bool):Void
	{
		__discardTransparentValue[0] = enabled;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addBoolOverride("openfl_DiscardTransparent", __discardTransparentValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__discardTransparent != null) __currentShader.__discardTransparent.value = __discardTransparentValue;
		}
	}

	/**
		Applies the "has color transform" uniform value for the active shader, if
		compatible with OpenFL core shaders
	**/
	public function applyHasColorTransform(enabled:Bool):Void
	{
		__hasColorTransformValue[0] = enabled;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addBoolOverride("openfl_HasColorTransform", __hasColorTransformValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__hasColorTransform != null) __currentShader.__hasColorTransform.value = __hasColorTransformValue;
		}
	}

	/**
		Applies render matrix to the active shader, if compatible with OpenFL core shaders
	**/
	public function applyMatrix(matrix:Array<Float>):Void
	{
		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addFloatOverride("openfl_Matrix", matrix);
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__matrix != null) __currentShader.__matrix.value = matrix;
		}
	}

	/**
		Converts an OpenFL two-dimensional matrix to a compatible 3D matrix for use with
		OpenGL rendering. Repeated calls to this method will return the same object with
		new values, so it will need to be cloned if the result must be cached
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function getMatrix(transform:Matrix):#if lime Matrix4 #else Dynamic #end
	{
		if (gl != null)
		{
			var values = __getMatrix(transform, AUTO);

			for (i in 0...16)
			{
				__matrix[i] = values[i];
			}

			return __matrix;
		}
		else
		{
			__matrix.identity();
			__matrix[0] = transform.a;
			__matrix[1] = transform.b;
			__matrix[4] = transform.c;
			__matrix[5] = transform.d;
			__matrix[12] = transform.tx;
			__matrix[13] = transform.ty;

			return __matrix;
		}
	}

	/**
		Sets the current active shader, which automatically unbinds the previous shader
		if it was bound using an OpenFL Shader object
	**/
	public function setShader(shader:Shader):Void
	{
		__currentShaderBuffer = null;

		if (__currentShader == shader) return;

		if (__currentShader != null)
		{
			// TODO: Integrate cleanup with Context3D
			// __currentShader.__disable ();
		}

		if (shader == null)
		{
			__currentShader = null;
			__context3D.setProgram(null);
			// __context3D.__flushGLProgram ();
			return;
		}
		else
		{
			__currentShader = shader;
			__initShader(shader);
			__context3D.setProgram(shader.program);
			__context3D.__flushGLProgram();
			// __context3D.__flushGLTextures ();
			__currentShader.__enable();
			__context3D.__state.shader = shader;
		}
	}

	/**
		Updates the current OpenGL viewport using the current OpenFL stage coordinates
	**/
	public function setViewport():Void
	{
		__gl.viewport(__offsetX, __offsetY, __displayWidth, __displayHeight);
	}

	/**
		Updates the current active shader with cached alpha, color transform,
		bitmap data and other uniform or attribute values. This should be called in advance
		of rendering
	**/
	public function updateShader():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__position != null) __currentShader.__position.__useArray = true;
			if (__currentShader.__textureCoord != null) __currentShader.__textureCoord.__useArray = true;
			__context3D.setProgram(__currentShader.program);
			__context3D.__flushGLProgram();
			__context3D.__flushGLTextures();
			__currentShader.__update();
		}
	}

	/**
		Updates the active shader to expect an alpha array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useAlphaArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__alpha != null) __currentShader.__alpha.__useArray = true;
		}
	}

	/**
		Updates the active shader to expect a color transform array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public function useColorTransformArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.__useArray = true;
			if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.__useArray = true;
		}
	}

	@:noCompletion private function __cleanup():Void
	{
		if (__stencilReference > 0)
		{
			__stencilReference = 0;
			__context3D.setStencilActions();
			__context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (__numClipRects > 0)
		{
			__numClipRects = 0;
			__scissorRect();
		}
	}

	@:noCompletion private override function __clear():Void
	{
		if (__stage == null || __stage.__transparent)
		{
			__context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}
		else
		{
			__context3D.clear(__stage.__colorSplit[0], __stage.__colorSplit[1], __stage.__colorSplit[2], 1, 0, 0, Context3DClearMask.COLOR);
		}

		__cleared = true;
	}

	@:noCompletion private function __clearShader():Void
	{
		if (__currentShader != null)
		{
			if (__currentShaderBuffer == null)
			{
				if (__currentShader.__bitmap != null) __currentShader.__bitmap.input = null;
			}
			else
			{
				__currentShaderBuffer.clearOverride();
			}

			if (__currentShader.__texture != null) __currentShader.__texture.input = null;
			if (__currentShader.__textureSize != null) __currentShader.__textureSize.value = null;
			if (__currentShader.__hasColorTransform != null) __currentShader.__hasColorTransform.value = null;
			if (__currentShader.__position != null) __currentShader.__position.value = null;
			if (__currentShader.__matrix != null) __currentShader.__matrix.value = null;
			__currentShader.__clearUseArray();
		}
	}

	@:noCompletion private function __copyShader(other:OpenGLRenderer):Void
	{
		__currentShader = other.__currentShader;
		__currentShaderBuffer = other.__currentShaderBuffer;
		__currentDisplayShader = other.__currentDisplayShader;
		__currentGraphicsShader = other.__currentGraphicsShader;

		// __gl.glProgram = other.__gl.glProgram;
	}

	@:noCompletion private function __getMatrix(transform:Matrix, pixelSnapping:PixelSnapping):Array<Float>
	{
		var _matrix = Matrix.__pool.get();
		_matrix.copyFrom(transform);
		_matrix.concat(__worldTransform);

		if (pixelSnapping == ALWAYS
			|| (pixelSnapping == AUTO
				&& _matrix.b == 0
				&& _matrix.c == 0
				&& (_matrix.a < 1.001 && _matrix.a > 0.999)
				&& (_matrix.d < 1.001 && _matrix.d > 0.999)))
		{
			_matrix.tx = Math.round(_matrix.tx);
			_matrix.ty = Math.round(_matrix.ty);
		}

		__matrix.identity();
		__matrix[0] = _matrix.a;
		__matrix[1] = _matrix.b;
		__matrix[4] = _matrix.c;
		__matrix[5] = _matrix.d;
		__matrix[12] = _matrix.tx;
		__matrix[13] = _matrix.ty;
		__matrix.append(__flipped ? __projectionFlipped : __projection);

		for (i in 0...16)
		{
			__values[i] = __matrix[i];
		}

		Matrix.__pool.release(_matrix);

		return __values;
	}

	@:noCompletion private function __initShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = __context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultShader;
	}

	@:noCompletion private function __initDisplayShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = __context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultDisplayShader;
	}

	@:noCompletion private function __initGraphicsShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = __context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultGraphicsShader;
	}

	@:noCompletion private function __initShaderBuffer(shaderBuffer:ShaderBuffer):Shader
	{
		if (shaderBuffer != null)
		{
			return __initGraphicsShader(shaderBuffer.shader);
		}

		return __defaultGraphicsShader;
	}

	@:noCompletion private override function __popMask():Void
	{
		if (__stencilReference == 0) return;

		var mask = __maskObjects.pop();

		if (__stencilReference > 1)
		{
			__context3D.setStencilActions(FRONT_AND_BACK, EQUAL, DECREMENT_SATURATE, DECREMENT_SATURATE, KEEP);
			__context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
			__context3D.setColorMask(false, false, false, false);

			__renderDrawableMask(mask);
			__stencilReference--;

			__context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
			__context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
			__context3D.setColorMask(true, true, true, true);
		}
		else
		{
			__stencilReference = 0;
			__context3D.setStencilActions();
			__context3D.setStencilReferenceValue(0, 0, 0);
		}
	}

	@:noCompletion private override function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (object.__mask != null)
		{
			__popMask();
		}

		if (handleScrollRect && object.__scrollRect != null)
		{
			if (object.__renderTransform.b != 0 || object.__renderTransform.c != 0)
			{
				__scrollRectMasks.release(cast __maskObjects[__maskObjects.length - 1]);
				__popMask();
			}
			else
			{
				__popMaskRect();
			}
		}
	}

	@:noCompletion private override function __popMaskRect():Void
	{
		if (__numClipRects > 0)
		{
			__numClipRects--;

			if (__numClipRects > 0)
			{
				__scissorRect(__clipRects[__numClipRects - 1]);
			}
			else
			{
				__scissorRect();
			}
		}
	}

	@:noCompletion private override function __pushMask(mask:DisplayObject):Void
	{
		if (__stencilReference == 0)
		{
			__context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
			__updatedStencil = true;
		}

		__context3D.setStencilActions(FRONT_AND_BACK, EQUAL, INCREMENT_SATURATE, KEEP, KEEP);
		__context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
		__context3D.setColorMask(false, false, false, false);

		__renderDrawableMask(mask);
		__maskObjects.push(mask);
		__stencilReference++;

		__context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
		__context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
		__context3D.setColorMask(true, true, true, true);
	}

	@:noCompletion private override function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && object.__scrollRect != null)
		{
			if (object.__renderTransform.b != 0 || object.__renderTransform.c != 0)
			{
				var shape = __scrollRectMasks.get();
				shape.graphics.clear();
				shape.graphics.beginFill(0x00FF00);
				shape.graphics.drawRect(object.__scrollRect.x, object.__scrollRect.y, object.__scrollRect.width, object.__scrollRect.height);
				shape.__renderTransform.copyFrom(object.__renderTransform);
				__pushMask(shape);
			}
			else
			{
				__pushMaskRect(object.__scrollRect, object.__renderTransform);
			}
		}

		if (object.__mask != null)
		{
			__pushMask(object.__mask);
		}
	}

	@:noCompletion private override function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		// TODO: Handle rotation?

		if (__numClipRects == __clipRects.length)
		{
			__clipRects[__numClipRects] = new Rectangle();
		}

		var _matrix = Matrix.__pool.get();
		_matrix.copyFrom(transform);
		_matrix.concat(__worldTransform);

		var clipRect = __clipRects[__numClipRects];
		rect.__transform(clipRect, _matrix);

		if (__numClipRects > 0)
		{
			var parentClipRect = __clipRects[__numClipRects - 1];
			clipRect.__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
		}

		if (clipRect.height < 0)
		{
			clipRect.height = 0;
		}

		if (clipRect.width < 0)
		{
			clipRect.width = 0;
		}

		Matrix.__pool.release(_matrix);

		__scissorRect(clipRect);
		__numClipRects++;
	}

	@:noCompletion private override function __render(object:IBitmapDrawable):Void
	{
		__resetBufferLevel();
		__context3D.setColorMask(true, true, true, true);
		__context3D.setCulling(NONE);
		__context3D.setDepthTest(false, ALWAYS);
		__context3D.setStencilActions();
		__context3D.setStencilReferenceValue(0, 0, 0);
		__context3D.setScissorRectangle(null);

		__blendMode = null;
		__setBlendMode(NORMAL);

		if (__defaultRenderTarget == null)
		{
			#if openfl_dpi_aware
			__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			#else
			if (__context3D.__backBufferWantsBestResolution)
			{
				__scissorRectangle.setTo(__offsetX / __pixelRatio, __offsetY / __pixelRatio, __displayWidth / __pixelRatio, __displayHeight / __pixelRatio);
			}
			else
			{
				__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			}
			#end
			__context3D.setScissorRectangle(__scissorRectangle);

			__upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);

			// the root is rendered as it is (see __renderRoot), unless BitmapData.draw gave a blend mode:
			// then the root is composited with it, as one object
			if (__overrideBlendMode != null && __overrideBlendMode != NORMAL) __renderDrawable(object);
			else
				__renderRoot(object);

			// TODO: Handle this in Context3D as a viewport?

			if (__offsetX > 0 || __offsetY > 0)
			{
				// __context3D.__setGLScissorTest (true);

				if (__offsetX > 0)
				{
					// __gl.scissor (0, 0, __offsetX, __height);
					__scissorRectangle.setTo(0, 0, __offsetX, __height);
					__context3D.setScissorRectangle(__scissorRectangle);

					__context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// __context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (__offsetX + __displayWidth, 0, __width, __height);
					__scissorRectangle.setTo(__offsetX + __displayWidth, 0, __width, __height);
					__context3D.setScissorRectangle(__scissorRectangle);

					__context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// __context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				if (__offsetY > 0)
				{
					// __gl.scissor (0, 0, __width, __offsetY);
					__scissorRectangle.setTo(0, 0, __width, __offsetY);
					__context3D.setScissorRectangle(__scissorRectangle);

					__context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// __context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (0, __offsetY + __displayHeight, __width, __height);
					__scissorRectangle.setTo(0, __offsetY + __displayHeight, __width, __height);
					__context3D.setScissorRectangle(__scissorRectangle);

					__context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// __context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				__context3D.setScissorRectangle(null);
			}
		}
		else
		{
			#if openfl_dpi_aware
			__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			#else
			if (__context3D.__backBufferWantsBestResolution)
			{
				__scissorRectangle.setTo(__offsetX / __pixelRatio, __offsetY / __pixelRatio, __displayWidth / __pixelRatio, __displayHeight / __pixelRatio);
			}
			else
			{
				__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			}
			#end
			__context3D.setScissorRectangle(__scissorRectangle);
			// __gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);

			// __upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);

			// TODO: Cleaner approach?

			var cacheMask = object.__mask;
			var cacheScrollRect = object.__scrollRect;
			object.__mask = null;
			object.__scrollRect = null;

			__renderRoot(object);

			object.__mask = cacheMask;
			object.__scrollRect = cacheScrollRect;
		}

		__context3D.present();
	}

	/**
		Renders the root of a render. Its own blend mode is for whoever composites the result: the
		renderer that draws a cache bitmap applies it to the bitmap, and `BitmapData.draw` ignores it,
		as Flash does. Applied inside the render, against a transparent target, MULTIPLY, SUBTRACT,
		ERASE and ALPHA would leave a cache bitmap empty. So the root's mode counts as the group's mode
		here, as inside any group: the root and the children that only inherit its mode draw NORMAL
		(see `__effectiveBlendMode`). A blend mode given to `BitmapData.draw` replaces the root's own
		and is left as it is.
	**/
	@:noCompletion private function __renderRoot(object:IBitmapDrawable):Void
	{
		var groupBlendMode = __groupBlendMode;
		if (object.__drawableType != BITMAP_DATA && __overrideBlendMode == null)
		{
			var displayObject:DisplayObject = cast object;
			__groupBlendMode = displayObject.__worldBlendMode;
		}
		__renderDrawableDirect(object);
		__groupBlendMode = groupBlendMode;
	}

	@:noCompletion private function __renderDrawable(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		// the coverage pass of an ALPHA group draws everything as it is (see __coverageOnly)
		if (object.__drawableType != BITMAP_DATA && !__coverageOnly)
		{
			var displayObject:DisplayObject = cast object;

			// LAYER composes the subtree offscreen; the modes that need the backdrop as a
			// shader input are composed the same way (see __renderGroup)
			if (displayObject.__blendMode == LAYER && (__overrideBlendMode == null || __overrideBlendMode == NORMAL))
			{
				__renderGroup(displayObject, LAYER);
				__touch(displayObject, true);
				return;
			}

			var blendMode = __effectiveBlendMode(displayObject);
			// a cutter is not drawn straight on the stage (see __drawsOntoStage)
			if ((blendMode == ERASE || blendMode == ALPHA) && __drawsOntoStage()) return;

			if (__needsBlendShader(blendMode))
			{
				// one piece composes straight from its texture, anything else as a group
				if (__isBlendLeaf(displayObject) && displayObject.__worldShader == null && __leafHasTexture(displayObject))
				{
					__compositeLeaf(displayObject, blendMode);
				}
				else
				{
					__renderGroup(displayObject, blendMode);
				}
				__touch(displayObject, true);
				return;
			}
			if (__needsWholeObjectGroup(displayObject, blendMode))
			{
				__renderGroup(displayObject, blendMode);
				__touch(displayObject, true);
				return;
			}
		}

		__renderDrawableDirect(object);
		if (object.__drawableType != BITMAP_DATA) __touch(cast object);
	}

	/**
		Whether an object has to be rendered into a group before it is blended, so that it blends as one
		piece the way Flash does.

		A Bitmap or a cached texture is a single quad, so the blend factors already treat it as a whole.
		A container with several pieces, or graphics that are drawn directly as several fills or a batch
		of quads, would otherwise be blended piece by piece, and a second fill would blend onto the
		first instead of covering it. Those are rendered like a LAYER first, and the result is then
		drawn with the blend mode.
	**/
	@:noCompletion private function __needsWholeObjectGroup(displayObject:DisplayObject, blendMode:BlendMode):Bool
	{
		if (blendMode == NORMAL || blendMode == LAYER || blendMode == null) return false;

		var pieces = 0;
		var graphics = displayObject.__graphics;
		if (graphics != null && graphics.__commands.length > 0)
		{
			if (graphics.__bitmap != null)
			{
				pieces = 1;
			}
			else
			{
				for (type in graphics.__commands.types)
				{
					switch (type)
					{
						case BEGIN_FILL, BEGIN_BITMAP_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
							pieces++;
						case DRAW_QUADS, DRAW_TRIANGLES:
							pieces += 2;
						default:
					}
				}
			}
		}
		if (displayObject.__children != null) pieces += displayObject.__children.length;
		return pieces > 1;
	}

	/**
		Whether `blendMode` needs `BlendModeShader` and a backdrop copy instead of blend factors: always
		for DIFFERENCE, DARKEN, LIGHTEN, HARDLIGHT and OVERLAY, which blend factors cannot express, and
		for MULTIPLY, SUBTRACT, INVERT, ERASE and ALPHA on a transparent target
		(see `__backdropIsOpaque`), where the result depends on the backdrop's alpha or coverage. Groups
		reset the cached blend mode, so an answer is never reused at another depth.
	**/
	@:noCompletion private function __needsBlendShader(blendMode:BlendMode):Bool
	{
		return switch (blendMode)
		{
			case DIFFERENCE, DARKEN, LIGHTEN, HARDLIGHT, OVERLAY: true;
			case MULTIPLY, SUBTRACT, INVERT, ERASE, ALPHA: !__backdropIsOpaque();
			default: false;
		}
	}

	/**
		Whether the current target is fully opaque, so that a composite can work on it directly without
		having to preserve its alpha.

		That is the case when drawing straight onto an opaque stage, and when drawing into an opaque
		BitmapData with `BitmapData.draw`. It is not the case inside any group this renderer has opened,
		on a transparent stage, or while rendering the cache bitmap of an object with filters or
		cacheAsBitmap, whose renderer is given the stage as well but actually draws into a transparent
		bitmap.
	**/
	@:noCompletion private inline function __backdropIsOpaque():Bool
	{
		return __layerDepth == 0 && (__stage != null ? (!__stage.__transparent && __stage.__renderer == this) : !__transparent);
	}

	@:noCompletion private static function __shaderModeId(blendMode:BlendMode):Int
	{
		return switch (blendMode)
		{
			case MULTIPLY: 1;
			case DARKEN: 2;
			case LIGHTEN: 3;
			case HARDLIGHT: 4;
			case OVERLAY: 5;
			case SUBTRACT: 6;
			case INVERT: 7;
			case ERASE: 8;
			case ALPHA: 9;
			default: 0; // DIFFERENCE
		}
	}

	/**
		Renders `displayObject` into a group the size of its bounds, then combines that group with the
		target according to `blendMode`.

		The group is a scratch texture. LAYER, and the modes that can be done with blend factors on this
		target (see `__needsBlendShader`), are a single draw of the texture with the mode's blend
		factors. The other modes go through `BlendModeShader`, which reads the texture and a copy of the
		backdrop and gives the Flash result: the mode applied to the unpremultiplied colors, mixed in by
		the object's alpha.
	**/
	@:noCompletion private function __renderGroup(displayObject:DisplayObject, blendMode:BlendMode):Void
	{
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		var bounds = Rectangle.__pool.get();
		var visible = __getGroupBounds(displayObject, bounds);
		var x0 = Std.int(bounds.x),
			y0 = Std.int(bounds.y),
			width = Std.int(bounds.width),
			height = Std.int(bounds.height);
		Rectangle.__pool.release(bounds);
		if (!visible) return;

		var level = __groupDepth * 4;
		var scratchBuffer = __getGroupScratchBuffer(level, width, height);
		var backdrop = __groupScratchBuffers[level + 1];
		var shaded = __needsBlendShader(blendMode);

		__renderIntoGroup(displayObject, scratchBuffer, x0, y0, width, height, blendMode);

		// the group leaves the target as it was, so the backdrop is copied now: a composite inside
		// the group hands the shared blend shader its own backdrop, and this one must come last
		if (shaded) __copyBackdrop(backdrop, x0, y0, width, height);

		scratchBuffer.__setUVRect(__context3D, 0, 0, width, height);

		// Flash's ALPHA masks with what the object's leaves cover, a Bitmap its footprint and
		// a shape its fills, and leaves the rest of the object's box alone: the coverage is
		// rendered into a third scratch buffer and the shader keeps 1 - coverage + alpha. A
		// shape without a coverage render (html5) falls back to leaving its empty texels alone. A
		// text field has none either, but its bitmap is its coverage (see __drawCoverage)
		var coverage:BitmapData = null;
		var discardTransparent = false;
		if (blendMode == ALPHA)
		{
			var graphics = displayObject.__graphics;
			var isShape = graphics != null && (displayObject.__children == null || displayObject.__children.length == 0);
			if (isShape && graphics.__coverage == null && !graphics.__managed)
			{
				discardTransparent = true;
			}
			else if (__alphaNeedsMask(displayObject))
			{
				coverage = __groupScratchBuffers[level + 2];
				__renderIntoGroup(displayObject, coverage, x0, y0, width, height, blendMode, true);
				coverage.__setUVRect(__context3D, 0, 0, width, height);
			}
		}

		if (shaded)
		{
			__compositeWithShader(scratchBuffer, backdrop, displayObject, x0, y0, blendMode, discardTransparent, coverage);
		}
		else
		{
			__compositeDirect(scratchBuffer, displayObject, x0, y0, blendMode, discardTransparent, coverage);
		}
	}

	/**
		Works out the rectangle a group needs on the target: the object's bounds including filters,
		rounded out to whole pixels and clamped to the target, which inside a group is the enclosing
		group. It is also clamped to the current clip rectangle. Returns false if nothing of it is left.
	**/
	@:noCompletion private function __getGroupBounds(displayObject:DisplayObject, bounds:Rectangle):Bool
	{
		displayObject.__getFilterBounds(bounds, displayObject.__renderTransform);
		bounds.__transform(bounds, __worldTransform);
		return __clampGroupBounds(bounds);
	}

	/**
		Rounds a rectangle in target pixels out to whole pixels and clamps it to the target and the
		current clip rectangle. Returns false if nothing of it is left.
	**/
	@:noCompletion private function __clampGroupBounds(bounds:Rectangle):Bool
	{
		var x0 = Math.floor(bounds.x), y0 = Math.floor(bounds.y);
		var x1 = Math.ceil(bounds.right), y1 = Math.ceil(bounds.bottom);

		if (x0 < __groupOffsetX) x0 = __groupOffsetX;
		if (y0 < __groupOffsetY) y0 = __groupOffsetY;
		if (x1 > __groupOffsetX + __displayWidth) x1 = __groupOffsetX + __displayWidth;
		if (y1 > __groupOffsetY + __displayHeight) y1 = __groupOffsetY + __displayHeight;

		if (__numClipRects > 0)
		{
			var clipRect = __clipRects[__numClipRects - 1];
			if (x0 < clipRect.x) x0 = Math.floor(clipRect.x);
			if (y0 < clipRect.y) y0 = Math.floor(clipRect.y);
			if (x1 > clipRect.right) x1 = Math.ceil(clipRect.right);
			if (y1 > clipRect.bottom) y1 = Math.ceil(clipRect.bottom);
		}

		bounds.setTo(x0, y0, x1 - x0, y1 - y0);
		return bounds.width > 0 && bounds.height > 0;
	}

	/**
		Renders `displayObject` into `scratchBuffer`, with the projection and scissor rectangles shifted
		so that (x0, y0) of the target is the texture origin. The ancestors' masks and clips are
		suspended, since they apply to the finished group. With `coverageOnly`, the group gets the
		object's coverage instead of its pixels.

		The group is a buffer of its own: children keep their own modes (those that only inherit
		`blendMode` draw as NORMAL), the object's alpha is divided out to be applied once to the result,
		and touches are tracked (see `__touch`). A mode given to `BitmapData.draw` applies to the root
		only.
	**/
	@:noCompletion private function __renderIntoGroup(displayObject:DisplayObject, scratchBuffer:BitmapData, x0:Int, y0:Int, width:Int, height:Int,
			blendMode:BlendMode, coverageOnly:Bool = false):Void
	{
		var context = __context3D;
		var cacheCoverageOnly = __coverageOnly;
		__coverageOnly = coverageOnly;
		var shaded = __needsBlendShader(blendMode);

		__groupDepth++;
		__layerDepth++;
		var parentLevel = __bufferLevel, parentDrawn = __bufferHasContent;
		__openBuffer();

		var cacheRTT = context.__state.renderToTexture;
		var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

		var cacheFlipped = __flipped;
		var cacheDisplayWidth = __displayWidth,
			cacheDisplayHeight = __displayHeight;
		var cacheOffsetX = __groupOffsetX, cacheOffsetY = __groupOffsetY;
		var cacheClipRects = __clipRects, cacheNumClipRects = __numClipRects;
		var cacheStencilReference = __stencilReference;
		var cacheOverrideBlendMode = __overrideBlendMode;
		var cacheGroupBlendMode = __groupBlendMode;
		var cacheWorldAlpha = __worldAlpha;
		// a group tracks what its children touch, from the moment a child needs it (see __ensureTouched)
		var cacheTouchedRoot = __touchedGroup,
			cacheTouched = __touched,
			cacheTouchedActive = __touchedBuilt;
		__touchedGroup = displayObject;
		__touched = null;
		__touchedBuilt = false;

		__suspendClipAndMask();
		if (__groupClipRects[__groupDepth] == null) __groupClipRects[__groupDepth] = [];
		__clipRects = __groupClipRects[__groupDepth];
		__numClipRects = 0;
		__stencilReference = 0;

		context.setRenderToTexture(scratchBuffer.getTexture(context), true);

		// clear only the group's area: the scratch buffer can be as large as the target
		__scissorRectangle.setTo(0, 0, width, height);
		context.setScissorRectangle(__scissorRectangle);
		context.__clear(true, 0, 0, 0, 0, 0, 0, Context3DClearMask.ALL);
		context.setScissorRectangle(null);

		__flipped = false;
		__groupOffsetX = x0;
		__groupOffsetY = y0;
		__displayWidth = scratchBuffer.width;
		__displayHeight = scratchBuffer.height;
		__projection.createOrtho(x0, x0 + scratchBuffer.width, y0, y0 + scratchBuffer.height, -1000, 1000);

		// the object's alpha applies once, to the composite (see __renderGroup): divided out here.
		// The coverage pass draws every leaf opaque, so it takes no alpha at all
		__worldAlpha = coverageOnly ? 1 : 1 / displayObject.__worldAlpha;
		// the mode this group is composited with: children that only inherit it render NORMAL, the
		// others with their own modes into the group, and shapes rendered inside know whether their
		// coverage is wanted (__isCompositedWithAlpha). A mode given to BitmapData.draw applies to
		// the root as one object, not to its children
		if (blendMode != LAYER) __groupBlendMode = blendMode;
		__overrideBlendMode = null;

		__blendMode = null;
		__setBlendMode(NORMAL);
		__renderDrawableDirect(displayObject);

		__worldAlpha = cacheWorldAlpha;
		__touchedGroup = cacheTouchedRoot;
		__touched = cacheTouched;
		__touchedBuilt = cacheTouchedActive;
		__overrideBlendMode = cacheOverrideBlendMode;
		__groupBlendMode = cacheGroupBlendMode;
		__blendMode = null;

		// the object's alpha applies once, to the whole object: __compositeDirect draws with it,
		// the shader groups get the group scaled by it here, while it is still the render target
		if (shaded && !coverageOnly && displayObject.__worldAlpha < 1) __scaleScratchAlpha(x0, y0, width, height, displayObject.__worldAlpha);

		__restoreRenderTarget(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);

		__flipped = cacheFlipped;
		__groupOffsetX = cacheOffsetX;
		__groupOffsetY = cacheOffsetY;
		__displayWidth = cacheDisplayWidth;
		__displayHeight = cacheDisplayHeight;
		__projection.createOrtho(cacheOffsetX, cacheOffsetX + cacheDisplayWidth, cacheOffsetY, cacheOffsetY + cacheDisplayHeight, -1000, 1000);
		__clipRects = cacheClipRects;
		__numClipRects = cacheNumClipRects;
		__stencilReference = cacheStencilReference;

		__resumeClipAndMask(this);
		__coverageOnly = cacheCoverageOnly;

		__closeBuffer(parentLevel, parentDrawn);
		__groupDepth--;
		__layerDepth--;
	}

	/**
		Draws a finished group onto the target as one image, with the object's alpha applied once to the
		whole of it. The blend factors of `blendMode` do the blending. This handles LAYER, ADD and
		SCREEN, and also MULTIPLY, SUBTRACT, INVERT, ERASE and ALPHA when the target is opaque
		(see `__needsBlendShader`).
	**/
	@:noCompletion private function __compositeDirect(scratchBuffer:BitmapData, displayObject:DisplayObject, x0:Int, y0:Int, blendMode:BlendMode,
			discardTransparent:Bool, coverage:BitmapData):Void
	{
		__setBlendMode(blendMode);

		__drawGroupScratchBuffer(scratchBuffer, x0, y0, __defaultDisplayShader, displayObject.__worldAlpha, discardTransparent, coverage);
	}

	/**
		Draws a finished group onto the target through `BlendModeShader`, for the modes listed in
		`__needsBlendShader`. The shader reads the group and a copy of the backdrop and writes the
		finished pixel.
	**/
	@:noCompletion private function __compositeWithShader(scratchBuffer:BitmapData, backdrop:BitmapData, displayObject:DisplayObject, x0:Int, y0:Int,
			blendMode:BlendMode, discardTransparent:Bool, coverage:BitmapData):Void
	{
		var shader = __prepareBlendShader(displayObject, blendMode, 1, discardTransparent, coverage);

		// the shader writes the finished pixel
		__context3D.setBlendFactors(ONE, ZERO);
		__drawGroupScratchBuffer(scratchBuffer, x0, y0, shader, 1);
	}

	/**
		Prepares the blend shader for one composite (see `BlendModeShader.prepare`; `__copyBackdrop` gave
		it the backdrop), with the touched buffer where the mode reads it: SUBTRACT, INVERT, and cutters
		where `__cutterShowsAsIs` holds. Otherwise every pixel counts as covered.
	**/
	@:noCompletion private function __prepareBlendShader(displayObject:DisplayObject, blendMode:BlendMode, alpha:Float, discardTransparent:Bool,
			coverage:BitmapData):BlendModeShader
	{
		var shader = __staticBlendShader;
		shader.prepare(__shaderModeId(blendMode), alpha, discardTransparent, coverage);
		var reads = blendMode == SUBTRACT || blendMode == INVERT || ((blendMode == ERASE || blendMode == ALPHA) && __cutterShowsAsIs());
		if (reads) __ensureTouched(displayObject);
		shader.setTouched(reads && __touchedBuilt ? __touched : null);
		return shader;
	}

	/**
		Puts the render target back after a group or the touched buffer: `texture`, or the back buffer
		with null.
	**/
	@:noCompletion private function __restoreRenderTarget(texture:TextureBase, depthStencil:Bool, antiAlias:Int, surfaceSelector:Int):Void
	{
		if (texture != null) __context3D.setRenderToTexture(texture, depthStencil, antiAlias, surfaceSelector);
		else
			__context3D.setRenderToBackBuffer();
	}

	/**
		Builds the group's touched buffer on first use (see `__touch`): the coverage of everything drawn
		into the group before `displayObject`. Objects drawn afterwards add themselves.
	**/
	@:noCompletion private function __ensureTouched(displayObject:DisplayObject):Void
	{
		if (__touchedGroup == null || __touchedBuilt) return;

		var level = (__groupDepth - 1) * 4 + 3;
		var touched = __groupScratchBuffers[level];
		var width = __displayWidth, height = __displayHeight;
		if (touched == null || touched.width < width || touched.height < height || touched.__textureContext != __context3D.__context)
		{
			if (touched != null) touched.dispose();
			touched = new BitmapData(width, height, true, 0);
			touched.readable = false;
			touched.getTexture(__context3D);
			__groupScratchBuffers[level] = touched;
		}
		__touched = touched;
		__touchedBuilt = true;
		__drawIntoTouched(true, function() __walkTouched(__touchedGroup, displayObject));
	}

	@:noCompletion private override function __drawTouched(displayObject:DisplayObject, graphicsOnly:Bool):Void
	{
		__drawIntoTouched(false, function()
		{
			if (graphicsOnly) __drawGraphicsCoverage(displayObject);
			else
				__drawCoverage(displayObject);
		});
	}

	/**
		Runs `draw` into the touched buffer in the coverage pass state (see `__coverageOnly`), clearing
		it first with `clear`. Clips and the stencil are suspended, since the buffer has no stencil.
	**/
	@:noCompletion private function __drawIntoTouched(clear:Bool, draw:Void->Void):Void
	{
		var context = __context3D;
		var cacheRTT = context.__state.renderToTexture;
		var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;
		var cacheCoverageOnly = __coverageOnly;

		// the buffer has no stencil of its own and no clip: a mask or scrollRect in force on the
		// target must not cut what is drawn into it
		__suspendClipAndMask();
		context.setRenderToTexture(__touched.getTexture(context), true);
		if (clear) context.__clear(false, 0, 0, 0, 0, 0, 0, Context3DClearMask.ALL);
		__coverageOnly = true;
		__blendMode = null;
		__setBlendMode(NORMAL);

		draw();

		__coverageOnly = cacheCoverageOnly;
		__blendMode = null;
		__restoreRenderTarget(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		__resumeClipAndMask(this);
		__clearShader();
	}

	/**
		Whether a single-piece object can be drawn from a texture of its own. A Bitmap always can. A
		shape can when its graphics have been, or will be, rendered to a texture. It cannot when they
		are drawn directly as triangles, since that path draws several pieces straight onto the target
		and leaves no texture to read.
	**/
	@:noCompletion private function __leafHasTexture(displayObject:DisplayObject):Bool
	{
		var graphics = displayObject.__graphics;
		if (graphics == null) return true; // a Bitmap
		return (graphics.__bitmap != null && !graphics.__dirty) || !Context3DGraphics.isCompatible(graphics);
	}

	/**
		Blends a single-piece object through `BlendModeShader`, for the modes listed in
		`__needsBlendShader`. The shader reads the object's own texture, drawn with the object's own
		matrix, together with a copy of the backdrop under its bounds. There is no group to render or
		clear, and a shape's coverage is its coverage texture, so no separate coverage pass is needed
		either.
	**/
	@:noCompletion private function __compositeLeaf(displayObject:DisplayObject, blendMode:BlendMode):Void
	{
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		var texture:BitmapData = null;
		var coverage:BitmapData = null;
		var smooth = true;
		var pixelSnapping:PixelSnapping = AUTO;
		var matrix = Matrix.__pool.get();
		var graphics = displayObject.__graphics;

		if (graphics == null)
		{
			var bitmap:Bitmap = cast displayObject;
			var bitmapData = bitmap.__bitmapData;
			if (bitmapData != null && bitmapData.__isValid)
			{
				if (bitmapData.image != null) bitmap.__imageVersion = bitmapData.image.version;
				texture = bitmapData;
				matrix.copyFrom(bitmap.__renderTransform);
				pixelSnapping = bitmap.pixelSnapping;
				smooth = __allowSmoothing && (bitmap.smoothing || __upscaled);
			}
		}
		else
		{
			// renders the graphics to their texture when dirty (the texture path draws nothing here)
			Context3DGraphics.render(graphics, this, blendMode == ALPHA);
			if (graphics.__bitmap != null && graphics.__visible)
			{
				texture = graphics.__bitmap;
				matrix.scale(1 / graphics.__bitmapScaleX, 1 / graphics.__bitmapScaleY);
				matrix.concat(graphics.__worldTransform);
				if (blendMode == ALPHA) coverage = graphics.__coverage;
			}
		}

		if (texture != null)
		{
			// the backdrop copy covers the quad as drawn: the whole texture (a shape's has a padding
			// pixel past its bounds) under the placement __getMatrix snaps
			var placement = Matrix.__pool.get();
			placement.copyFrom(matrix);
			placement.concat(__worldTransform);
			if (pixelSnapping == ALWAYS
				|| (pixelSnapping == AUTO
					&& placement.b == 0
					&& placement.c == 0
					&& (placement.a < 1.001 && placement.a > 0.999)
					&& (placement.d < 1.001 && placement.d > 0.999)))
			{
				placement.tx = Math.round(placement.tx);
				placement.ty = Math.round(placement.ty);
			}
			var bounds = Rectangle.__pool.get();
			bounds.setTo(0, 0, texture.width, texture.height);
			bounds.__transform(bounds, placement);
			Matrix.__pool.release(placement);
			var visible = __clampGroupBounds(bounds);
			var x0 = Std.int(bounds.x),
				y0 = Std.int(bounds.y),
				width = Std.int(bounds.width),
				height = Std.int(bounds.height);
			Rectangle.__pool.release(bounds);

			if (visible)
			{
				var level = __groupDepth * 4;
				__getGroupScratchBuffer(level, width, height);
				var backdrop = __groupScratchBuffers[level + 1];
				__copyBackdrop(backdrop, x0, y0, width, height);

				var shader = __prepareBlendShader(displayObject, blendMode,
					__getAlpha(displayObject.__worldAlpha), graphics != null && blendMode == ALPHA && coverage == null, coverage);

				var context = __context3D;
				context.setBlendFactors(ONE, ZERO);
				__blendMode = null;

				var blendShader = __initShader(shader);
				setShader(blendShader);
				applyBitmapData(texture, smooth);
				applyMatrix(__getMatrix(matrix, pixelSnapping));
				applyAlpha(1);
				applyColorTransform(null);
				updateShader();

				var vertexBuffer = texture.getVertexBuffer(context);
				if (blendShader.__position != null) context.setVertexBufferAt(blendShader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (blendShader.__textureCoord != null) context.setVertexBufferAt(blendShader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				context.drawTriangles(texture.getIndexBuffer(context));

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				__clearShader();
			}
		}

		Matrix.__pool.release(matrix);
		__renderEvent(displayObject);
	}

	/**
		Copies the part of the target under the group into `backdrop`, and hands that texture to the
		blend shader, which reads it as the backdrop. The window's framebuffer is stored bottom-up, so
		there the copy is taken from the flipped position.
	**/
	@:noCompletion private function __copyBackdrop(backdrop:BitmapData, x:Int, y:Int, width:Int, height:Int):Void
	{
		var context = __context3D;
		context.__flushGLFramebuffer();
		context.__bindGLTexture2D(backdrop.getTexture(context).__getTexture());

		x -= __groupOffsetX;
		y -= __groupOffsetY;

		// the renderer already works in the framebuffer's pixels (the stage scales its display
		// matrix by the window scale); the window framebuffer is bottom-up
		if (context.__state.renderToTexture == null)
		{
			y = Std.int(context.__stage.window.height * context.__stage.window.scale) - height - y;
		}

		__gl.copyTexSubImage2D(__gl.TEXTURE_2D, 0, 0, 0, x, y, width, height);

		if (__staticBlendShader == null) __staticBlendShader = new BlendModeShader();
		__staticBlendShader.setBackdrop(backdrop, x, y);
	}

	@:noCompletion private function __drawGroupScratchBuffer(scratchBuffer:BitmapData, x:Int, y:Int, shader:Shader, alpha:Float,
			discardTransparent:Bool = false, coverage:BitmapData = null):Void
	{
		var context = __context3D;
		shader = __initShader(shader);
		setShader(shader);
		applyBitmapData(scratchBuffer, false);
		applyDiscardTransparent(discardTransparent);
		applyCoverage(coverage);

		// place the scratchBuffer buffer at (x, y) in target pixels: __getMatrix appends __worldTransform
		var inverse = Matrix.__pool.get();
		inverse.copyFrom(__worldTransform);
		inverse.invert();

		var placement = Matrix.__pool.get();
		placement.identity();
		placement.translate(x, y);
		placement.concat(inverse);

		applyMatrix(__getMatrix(placement, ALWAYS));

		Matrix.__pool.release(placement);
		Matrix.__pool.release(inverse);

		applyAlpha(alpha);
		applyColorTransform(null);
		updateShader();

		var vertexBuffer = scratchBuffer.getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = scratchBuffer.getIndexBuffer(context);
		context.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		__clearShader();
	}

	@:noCompletion private function __getGroupScratchBuffer(level:Int, width:Int, height:Int):BitmapData
	{
		var scratchBuffer = __groupScratchBuffers[level];

		if (scratchBuffer == null
			|| scratchBuffer.width < width
			|| scratchBuffer.height < height
			|| scratchBuffer.__textureContext != __context3D.__context)
		{
			if (scratchBuffer != null)
			{
				if (scratchBuffer.width > width) width = scratchBuffer.width;
				if (scratchBuffer.height > height) height = scratchBuffer.height;
				scratchBuffer.dispose();
				__groupScratchBuffers[level + 1].dispose();
				__groupScratchBuffers[level + 2].dispose();
				if (__groupScratchBuffers[level + 3] != null)
				{
					__groupScratchBuffers[level + 3].dispose();
					__groupScratchBuffers[level + 3] = null;
				}
			}

			// the object, its backdrop and its coverage share one size so one set of texture
			// coordinates fits all three; the fourth slot is the touched buffer (see __ensureTouched)
			for (i in 0...3)
			{
				var bitmapData = new BitmapData(width, height, true, 0);
				bitmapData.readable = false; // texture only, once uploaded
				bitmapData.getTexture(__context3D); // created now: the context check above relies on it
				__groupScratchBuffers[level + i] = bitmapData;
			}
		}

		return __groupScratchBuffers[level];
	}

	/**
		Draws the area covered by `displayObject` and its descendants into the current target, opaque,
		for ALPHA's coverage pass and the touched buffer: graphics through `__drawGraphicsCoverage`,
		other leaves as their bounding box.
	**/
	@:noCompletion private function __drawCoverage(displayObject:DisplayObject):Void
	{
		if (!displayObject.__renderable) return;
		var graphics = displayObject.__graphics;
		var matrix = Matrix.__pool.get();

		if (graphics != null) __drawGraphicsCoverage(displayObject);

		if (displayObject.__children != null)
		{
			for (child in displayObject.__children)
				__drawCoverage(child);
		}
		else if (graphics == null)
		{
			var bounds = Rectangle.__pool.get();
			displayObject.__getBounds(bounds, Matrix.__identity);
			matrix.scale(bounds.width, bounds.height);
			matrix.translate(bounds.x, bounds.y);
			matrix.concat(displayObject.__renderTransform);
			__drawCoverageQuad(__white(), __white(), matrix);
			Rectangle.__pool.release(bounds);
		}

		Matrix.__pool.release(matrix);
	}

	/**
		Multiplies the color and alpha of the group being rendered by `alpha`, over the rectangle at
		(x, y) in target pixels. It draws one quad with the blend factors (ZERO, SOURCE_ALPHA).
	**/
	@:noCompletion private function __scaleScratchAlpha(x:Int, y:Int, width:Int, height:Int, alpha:Float):Void
	{
		var context = __context3D;
		context.setBlendFactors(ZERO, SOURCE_ALPHA);
		__blendMode = null;

		var white = __white();
		var shader = __initDisplayShader(null);
		setShader(shader);
		applyBitmapData(white, false);
		var matrix = Matrix.__pool.get();
		matrix.scale(width, height);
		matrix.translate(x, y);
		var inverse = Matrix.__pool.get();
		inverse.copyFrom(__worldTransform);
		inverse.invert();
		matrix.concat(inverse);
		applyMatrix(__getMatrix(matrix, ALWAYS));
		Matrix.__pool.release(inverse);
		Matrix.__pool.release(matrix);
		applyAlpha(alpha);
		applyColorTransform(null);
		updateShader();
		var vertexBuffer = white.getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		context.drawTriangles(white.getIndexBuffer(context));
		__clearShader();
	}

	/**
		Draws the area covered by the graphics of `displayObject` into the current target, opaque
		(see `__drawCoverage`): a shape's coverage render, made if missing, or for a text field the
		alpha of its bitmap, which it draws in opaque colors. Without either, the whole bitmap. A shape
		drawn as triangles draws its fills directly.
	**/
	@:noCompletion private function __drawGraphicsCoverage(displayObject:DisplayObject):Void
	{
		var graphics = displayObject.__graphics;
		// the direct triangle path draws its fills straight into the pass, opaque (applyAlpha and
		// applyColorTransform see __coverageOnly); otherwise the render leaves a texture to draw,
		// and a coverage render of the fills, made now if the shape has none yet
		Context3DGraphics.render(graphics, this, true);
		if (graphics.__bitmap != null && graphics.__visible)
		{
			var matrix = Matrix.__pool.get();
			matrix.scale(1 / graphics.__bitmapScaleX, 1 / graphics.__bitmapScaleY);
			matrix.concat(graphics.__worldTransform);
			// a text field draws straight into its bitmap, in colors that are always opaque, so
			// the bitmap's own alpha is its coverage
			var texture = graphics.__coverage != null ? graphics.__coverage : (graphics.__managed ? graphics.__bitmap : __white());
			__drawCoverageQuad(graphics.__bitmap, texture, matrix);
			Matrix.__pool.release(matrix);
		}
	}

	/**
		A 1x1 opaque white texture, for quads that only cover an area: leaf footprints and graphics
		without a coverage render (see `__drawCoverage`), and `__scaleScratchAlpha`.
	**/
	@:noCompletion private static function __white():BitmapData
	{
		if (__staticWhite == null) __staticWhite = new BitmapData(1, 1, false, 0xFFFFFF);
		return __staticWhite;
	}

	/**
		Draws an opaque quad the size of `geometry`, placed with `matrix` and filled from `texture`.
	**/
	@:noCompletion private function __drawCoverageQuad(geometry:BitmapData, texture:BitmapData, matrix:Matrix):Void
	{
		var context = __context3D;
		var shader = __initDisplayShader(null);
		setShader(shader);
		applyBitmapData(texture, false);
		applyMatrix(__getMatrix(matrix, AUTO));
		applyAlpha(1);
		applyColorTransform(null);
		updateShader();

		var vertexBuffer = geometry.getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		context.drawTriangles(geometry.getIndexBuffer(context));

		__clearShader();
	}

	@:noCompletion private function __renderDrawableDirect(object:IBitmapDrawable):Void
	{
		if (__coverageOnly && object.__drawableType != BITMAP_DATA)
		{
			__drawCoverage(cast object);
			return;
		}

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				Context3DBitmapData.renderDrawable(cast object, this);
			case STAGE, SPRITE:
				Context3DDisplayObjectContainer.renderDrawable(cast object, this);
			case BITMAP:
				Context3DBitmap.renderDrawable(cast object, this);
			case SHAPE:
				Context3DDisplayObject.renderDrawable(cast object, this);
			case SIMPLE_BUTTON:
				Context3DSimpleButton.renderDrawable(cast object, this);
			case TEXT_FIELD:
				Context3DTextField.renderDrawable(cast object, this);
			case VIDEO:
				Context3DVideo.renderDrawable(cast object, this);
			case TILEMAP:
				Context3DTilemap.renderDrawable(cast object, this);
			default:
		}
	}

	@:noCompletion private function __renderDrawableMask(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				Context3DBitmapData.renderDrawableMask(cast object, this);
			case STAGE, SPRITE:
				Context3DDisplayObjectContainer.renderDrawableMask(cast object, this);
			case BITMAP:
				Context3DBitmap.renderDrawableMask(cast object, this);
			case SHAPE:
				Context3DDisplayObject.renderDrawableMask(cast object, this);
			case SIMPLE_BUTTON:
				Context3DSimpleButton.renderDrawableMask(cast object, this);
			case TEXT_FIELD:
				Context3DTextField.renderDrawableMask(cast object, this);
			case VIDEO:
				Context3DVideo.renderDrawableMask(cast object, this);
			case TILEMAP:
				Context3DTilemap.renderDrawableMask(cast object, this);
			default:
		}
	}

	@:noCompletion private function __renderFilterPass(source:BitmapData, shader:Shader, smooth:Bool, clear:Bool = true):Void
	{
		if (source == null || shader == null) return;
		if (__defaultRenderTarget == null) return;

		var cacheRTT = __context3D.__state.renderToTexture;
		var cacheRTTDepthStencil = __context3D.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = __context3D.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = __context3D.__state.renderToTextureSurfaceSelector;

		__context3D.setRenderToTexture(__defaultRenderTarget.getTexture(__context3D), false);

		if (clear)
		{
			__context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}

		var shader = __initShader(shader);
		setShader(shader);
		applyAlpha(1);
		applyBitmapData(source, smooth);
		applyColorTransform(null);
		applyMatrix(__getMatrix(source.__renderTransform, AUTO));
		updateShader();

		var vertexBuffer = source.getVertexBuffer(__context3D);
		if (shader.__position != null) __context3D.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) __context3D.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = source.getIndexBuffer(__context3D);
		__context3D.drawTriangles(indexBuffer);

		if (cacheRTT != null)
		{
			__context3D.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			__context3D.setRenderToBackBuffer();
		}

		__clearShader();
	}

	@:noCompletion private override function __resize(width:Int, height:Int):Void
	{
		__width = width;
		__height = height;

		__offsetX = 0;
		__offsetY = 0;
		__displayWidth = (__defaultRenderTarget == null) ? width : __defaultRenderTarget.width;
		__displayHeight = (__defaultRenderTarget == null) ? height : __defaultRenderTarget.height;

		__projection.createOrtho(0, __displayWidth + __offsetX * 2, 0, __displayHeight + __offsetY * 2, -1000, 1000);
		__projectionFlipped.createOrtho(0, __displayWidth + __offsetX * 2, __displayHeight + __offsetY * 2, 0, -1000, 1000);
	}

	@:noCompletion private function __resumeClipAndMask(childRenderer:OpenGLRenderer):Void
	{
		if (__stencilReference > 0)
		{
			__context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
			__context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
		}
		else
		{
			__context3D.setStencilActions();
			__context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (__numClipRects > 0)
		{
			__scissorRect(__clipRects[__numClipRects - 1]);
		}
		else
		{
			__scissorRect();
		}
	}

	@:noCompletion private function __scissorRect(clipRect:Rectangle = null):Void
	{
		if (clipRect != null)
		{
			// inside a group the target is the group's scratch buffer, whose origin is the group's
			// box: the offset comes off before the scale below, since the flush scales the result
			var left = clipRect.x - __groupOffsetX,
				top = clipRect.y - __groupOffsetY;
			var right = clipRect.right - __groupOffsetX,
				bottom = clipRect.bottom - __groupOffsetY;
			var x = Math.ffloor(left);
			var y = Math.ffloor(top);
			var width = (clipRect.width > 0 ? Math.fceil(right) - x : 0);
			var height = (clipRect.height > 0 ? Math.fceil(bottom) - y : 0);
			#if !openfl_dpi_aware
			if (__context3D.__backBufferWantsBestResolution)
			{
				var uv = 1.5 / __pixelRatio;
				x = left / __pixelRatio;
				y = top / __pixelRatio;
				width = (clipRect.width > 0 ? (right / __pixelRatio) - x + uv : 0);
				height = (clipRect.height > 0 ? (bottom / __pixelRatio) - y + uv : 0);
			}
			#end

			if (width < 0) width = 0;
			if (height < 0) height = 0;

			// __scissorRectangle.setTo (x, __flipped ? __height - y - height : y, width, height);
			__scissorRectangle.setTo(x, y, width, height);
			__context3D.setScissorRectangle(__scissorRectangle);
		}
		else
		{
			__context3D.setScissorRectangle(null);
		}
	}

	@:noCompletion private override function __setBlendMode(value:BlendMode, force:Bool = false):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (value == __groupBlendMode) value = NORMAL;
		if (!force && __blendMode == value) return;

		__blendMode = value;

		switch (value)
		{
			case ADD:
				__context3D.setBlendFactors(ONE, ONE);

			case MULTIPLY:
				__context3D.setBlendFactors(DESTINATION_COLOR, ONE_MINUS_SOURCE_ALPHA);

			case SCREEN:
				__context3D.setBlendFactors(ONE, ONE_MINUS_SOURCE_COLOR);

			case SUBTRACT:
				__context3D.setBlendFactorsSeparate(ONE, ONE, ZERO, ONE);
				__context3D.__setGLBlendEquation(__gl.FUNC_REVERSE_SUBTRACT, __gl.FUNC_ADD);

			case ERASE:
				if (__backdropIsOpaque()) __context3D.setBlendFactorsSeparate(ZERO, ONE_MINUS_SOURCE_ALPHA, ZERO, ONE);
				else
					__context3D.setBlendFactors(ZERO, ONE_MINUS_SOURCE_ALPHA);

			case ALPHA:
				if (__backdropIsOpaque()) __context3D.setBlendFactorsSeparate(ZERO, SOURCE_ALPHA, ZERO, ONE);
				else
					__context3D.setBlendFactors(ZERO, SOURCE_ALPHA);

			case INVERT:
				__context3D.setBlendFactorsSeparate(ONE_MINUS_DESTINATION_COLOR, ONE_MINUS_SOURCE_ALPHA, ONE, ONE_MINUS_SOURCE_ALPHA);

			// DIFFERENCE, DARKEN, LIGHTEN, HARDLIGHT and OVERLAY are composed by
			// __renderGroup with BlendModeShader and never drawn directly, and so are
			// MULTIPLY, SUBTRACT, INVERT, ERASE and ALPHA off the opaque stage

			// LAYER, NORMAL
			default:
				__context3D.setBlendFactors(ONE, ONE_MINUS_SOURCE_ALPHA);
		}
	}

	@:noCompletion private function __setRenderTarget(renderTarget:BitmapData):Void
	{
		__defaultRenderTarget = renderTarget;
		__flipped = (renderTarget == null);

		if (renderTarget != null)
		{
			__resize(renderTarget.width, renderTarget.height);
		}
	}

	@:noCompletion private function __setShaderBuffer(shaderBuffer:ShaderBuffer):Void
	{
		setShader(shaderBuffer.shader);
		__currentShaderBuffer = shaderBuffer;
	}

	@:noCompletion private function __suspendClipAndMask():Void
	{
		if (__stencilReference > 0)
		{
			__context3D.setStencilActions();
			__context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (__numClipRects > 0)
		{
			__scissorRect();
		}
	}

	@:noCompletion private function __updateShaderBuffer(bufferOffset:Int):Void
	{
		if (__currentShader != null && __currentShaderBuffer != null)
		{
			__currentShader.__updateFromBuffer(__currentShaderBuffer, bufferOffset);
		}
	}
}
#else
typedef OpenGLRenderer = Dynamic;
#end
