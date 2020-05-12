package openfl.display;

#if !flash
#if openfl_gl
import lime.graphics.opengl.ext.KHR_debug;
import lime.graphics.opengl.GL;
import openfl.display._internal.batcher.BatchRenderer;
import openfl._internal.renderer.ShaderBuffer;
import openfl._internal.utils.ObjectPool;
import openfl.display._internal.Context3DAlphaMaskShader;
import openfl.display._internal.Context3DBitmap;
import openfl.display._internal.Context3DBitmapData;
import openfl.display._internal.Context3DBuffer;
import openfl.display._internal.Context3DDisplayObject;
import openfl.display._internal.Context3DGraphics;
import openfl.display._internal.Context3DMaskShader;
import openfl.display._internal.Context3DShape;
import openfl.display._internal.Context3DTextField;
import openfl.display._internal.Context3DTilemap;
import openfl.display._internal.Context3DVideo;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display._BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display._DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObjectRenderer;
import openfl.display.DisplayObjectShader;
import openfl.display.Graphics;
import openfl.display.GraphicsShader;
import openfl.display.IBitmapDrawable;
import openfl.display.OpenGLRenderer as Context3DRendererAPI;
import openfl.display.PixelSnapping;
import openfl.display.Shader;
import openfl.display.Shape;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.Context3D;
import openfl.events.RenderEvent;
import openfl.geom.ColorTransform;
import openfl.geom._ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.media.Video;
import openfl.text.TextField;
#if lime
import lime.graphics.RenderContext;
import lime.math.ARGB;
import lime.math.Matrix4;
import lime.graphics.WebGLRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.ARGB;
import openfl._internal.backend.lime_standalone.RenderContext;
import openfl._internal.backend.lime_standalone.WebGLRenderContext;
import openfl.geom.Matrix3D;
#end
#if openfl_html5
import openfl.display._internal.CanvasRenderer;
#else
import openfl.display._internal.CairoRenderer;
#end
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.GLRenderContext)
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display._internal.CanvasRenderer)
@:access(openfl.display._internal.CairoRenderer)
@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl._internal.renderer.ShaderBuffer)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Shader)
@:access(openfl.display._Shader)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display._ShaderParameter) // TODO: Remove backend references
@:access(openfl.display.Stage3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl.display._internal)
@:allow(openfl.display3D.textures)
@:allow(openfl.display3D)
@:allow(openfl.display)
@:allow(openfl.text)
@SuppressWarnings("checkstyle:FieldDocComment")
class _Context3DRenderer extends _DisplayObjectRenderer
{
	public static var __alphaValue:Array<Float> = [1];
	public static var __childRendererPool:ObjectPool<_Context3DRenderer>;
	public static var __colorMultipliersValue:Array<Float> = [0, 0, 0, 0];
	public static var __colorOffsetsValue:Array<Float> = [0, 0, 0, 0];
	public static var __defaultColorMultipliersValue:Array<Float> = [1, 1, 1, 1];
	public static var __emptyColorValue:Array<Float> = [0, 0, 0, 0];
	public static var __emptyAlphaValue:Array<Float> = [1];
	public static var __hasColorTransformValue:Array<Bool> = [false];
	public static var __scissorRectangle:Rectangle = new Rectangle();
	public static var __textureSizeValue:Array<Float> = [0, 0];

	public var batcher:BatchRenderer = null;
	public var context3D:Context3D;

	public var __alphaMaskShader:Context3DAlphaMaskShader;
	public var __clipRects:Array<Rectangle>;
	#if lime
	public var __limeContext:RenderContext;
	#end
	public var __currentDisplayShader:Shader;
	public var __currentGraphicsShader:Shader;
	public var __currentRenderTarget:BitmapData;
	public var __currentShader:Shader;
	public var __currentShaderBuffer:ShaderBuffer;
	public var __defaultDisplayShader:DisplayObjectShader;
	public var __defaultGraphicsShader:GraphicsShader;
	public var __defaultRenderTarget:BitmapData;
	public var __defaultShader:Shader;
	public var __displayHeight:Int;
	public var __displayWidth:Int;
	public var __flipped:Bool;
	public var __getMatrixHelperMatrix:Matrix = new Matrix();
	public var __gl:WebGLRenderContext;
	public var __height:Int;
	public var __maskShader:Context3DMaskShader;
	public var __matrix:#if (!lime && openfl_html5) Matrix3D #else Matrix4 #end;
	public var __maskObjects:Array<DisplayObject>;
	public var __numClipRects:Int;
	public var __offsetX:Int;
	public var __offsetY:Int;
	public var __projection:#if (!lime && openfl_html5) Matrix3D #else Matrix4 #end;
	public var __projectionFlipped:#if (!lime && openfl_html5) Matrix3D #else Matrix4 #end;
	public var __scrollRectMasks:ObjectPool<Shape>;
	public var __softwareRenderer:DisplayObjectRenderer;
	public var __stencilReference:Int;
	public var __tempColorTransform:ColorTransform;
	public var __tempRect:Rectangle;
	public var __updatedStencil:Bool;
	public var __upscaled:Bool;
	public var __values:Array<Float>;
	public var __width:Int;

	public function new(context:Context3D, defaultRenderTarget:BitmapData = null)
	{
		super(context);

		__init(context, defaultRenderTarget);

		if (Graphics.maxTextureWidth == null)
		{
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = __gl.getParameter(GL.MAX_TEXTURE_SIZE);
		}

		__matrix = new
			#if (!lime && openfl_html5)
			Matrix3D
			#else
			Matrix4
			#end();

		__values = new Array();

		#if gl_debug
		var ext:KHR_debug = __gl.getExtension("KHR_debug");
		if (ext != null)
		{
			__gl.enable(ext.DEBUG_OUTPUT);
			__gl.enable(ext.DEBUG_OUTPUT_SYNCHRONOUS);
		}
		#end

		#if openfl_html5
		__softwareRenderer = new CanvasRenderer(null);
		#else
		__softwareRenderer = new CairoRenderer(null);
		#end

		__type = CONTEXT3D;

		__setBlendMode(NORMAL);
		context3D._.setGLBlend(true);

		__clipRects = new Array();
		__maskObjects = new Array();
		__numClipRects = 0;
		__projection = new
			#if (!lime && openfl_html5)
			Matrix3D
			#else
			Matrix4
			#end();
		__projectionFlipped = new
			#if (!lime && openfl_html5)
			Matrix3D
			#else
			Matrix4
			#end();
		__stencilReference = 0;
		__tempRect = new Rectangle();

		__defaultDisplayShader = new DisplayObjectShader();
		__defaultGraphicsShader = new GraphicsShader();
		__defaultShader = __defaultDisplayShader;

		__initShader(__defaultShader);

		__scrollRectMasks = new ObjectPool<Shape>(function() return new Shape());
		__alphaMaskShader = new Context3DAlphaMaskShader();
		__maskShader = new Context3DMaskShader();

		if (__childRendererPool == null)
		{
			__childRendererPool = new ObjectPool<_Context3DRenderer>(function()
			{
				var renderer = new _Context3DRenderer(context3D, null);
				renderer.__worldTransform = new Matrix();
				renderer.__worldColorTransform = new ColorTransform();
				return renderer;
			});
		}
	}

	public function applyAlpha(alpha:Float):Void
	{
		__alphaValue[0] = alpha;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addFloatOverride("openfl_Alpha", __alphaValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader._.__alpha != null) __currentShader._.__alpha.value = __alphaValue;
		}
	}

	public function applyBitmapData(bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void
	{
		if (__currentShaderBuffer != null)
		{
			if (bitmapData != null)
			{
				__textureSizeValue[0] = bitmapData._.__renderData.textureWidth;
				__textureSizeValue[1] = bitmapData._.__renderData.textureHeight;

				__currentShaderBuffer.addFloatOverride("openfl_TextureSize", __textureSizeValue);
			}
		}
		else if (__currentShader != null)
		{
			if (__currentShader._.__bitmap != null)
			{
				__currentShader._.__bitmap.input = bitmapData;
				__currentShader._.__bitmap.filter = (smooth && __allowSmoothing) ? LINEAR : NEAREST;
				__currentShader._.__bitmap.mipFilter = MIPNONE;
				__currentShader._.__bitmap.wrap = repeat ? REPEAT : CLAMP;
			}

			if (__currentShader._.__texture != null)
			{
				__currentShader._.__texture.input = bitmapData;
				__currentShader._.__texture.filter = (smooth && __allowSmoothing) ? LINEAR : NEAREST;
				__currentShader._.__texture.mipFilter = MIPNONE;
				__currentShader._.__texture.wrap = repeat ? REPEAT : CLAMP;
			}

			if (__currentShader._.__textureSize != null)
			{
				if (bitmapData != null)
				{
					__textureSizeValue[0] = bitmapData._.__renderData.textureWidth;
					__textureSizeValue[1] = bitmapData._.__renderData.textureHeight;

					__currentShader._.__textureSize.value = __textureSizeValue;
				}
				else
				{
					__currentShader._.__textureSize.value = null;
				}
			}
		}
	}

	public function applyColorTransform(colorTransform:ColorTransform):Void
	{
		var enabled = (colorTransform != null && !colorTransform._.__isDefault(true));
		applyHasColorTransform(enabled);

		if (enabled)
		{
			colorTransform._.__setArrays(__colorMultipliersValue, __colorOffsetsValue);

			if (__currentShaderBuffer != null)
			{
				__currentShaderBuffer.addFloatOverride("openfl_ColorMultiplier", __colorMultipliersValue);
				__currentShaderBuffer.addFloatOverride("openfl_ColorOffset", __colorOffsetsValue);
			}
			else if (__currentShader != null)
			{
				if (__currentShader._.__colorMultiplier != null) __currentShader._.__colorMultiplier.value = __colorMultipliersValue;
				if (__currentShader._.__colorOffset != null) __currentShader._.__colorOffset.value = __colorOffsetsValue;
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
				if (__currentShader._.__colorMultiplier != null) __currentShader._.__colorMultiplier.value = __emptyColorValue;
				if (__currentShader._.__colorOffset != null) __currentShader._.__colorOffset.value = __emptyColorValue;
			}
		}
	}

	public function applyHasColorTransform(enabled:Bool):Void
	{
		__hasColorTransformValue[0] = enabled;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addBoolOverride("openfl_HasColorTransform", __hasColorTransformValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader._.__hasColorTransform != null) __currentShader._.__hasColorTransform.value = __hasColorTransformValue;
		}
	}

	public function applyMatrix(matrix:Array<Float>):Void
	{
		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addFloatOverride("openfl_Matrix", matrix);
		}
		else if (__currentShader != null)
		{
			if (__currentShader._.__matrix != null) __currentShader._.__matrix.value = matrix;
		}
	}

	public function getMatrix(transform:Matrix):#if (!lime && openfl_html5) Matrix3D #else Matrix4 #end
	{
		if (__gl != null)
		{
			var values = __getMatrix(transform, AUTO);

			for (i in 0...16)
			{
				#if (!lime && openfl_html5)
				__matrix.rawData[i] = values[i];
				#else
				__matrix[i] = values[i];
				#end
			}

			return __matrix;
		}
		else
		{
			__matrix.identity();
			#if (!lime && openfl_html5)
			__matrix.rawData[0] = transform.a;
			__matrix.rawData[1] = transform.b;
			__matrix.rawData[4] = transform.c;
			__matrix.rawData[5] = transform.d;
			__matrix.rawData[12] = transform.tx;
			__matrix.rawData[13] = transform.ty;
			#else
			__matrix[0] = transform.a;
			__matrix[1] = transform.b;
			__matrix[4] = transform.c;
			__matrix[5] = transform.d;
			__matrix[12] = transform.tx;
			__matrix[13] = transform.ty;
			#end
			return __matrix;
		}
	}

	public function setShader(shader:Shader):Void
	{
		__currentShaderBuffer = null;

		if (__currentShader == shader) return;

		if (__currentShader != null)
		{
			// TODO: Integrate cleanup with Context3D
			// __currentShader._.__disable ();
		}

		if (shader == null)
		{
			__currentShader = null;
			context3D.setProgram(null);
			// context3D._.__flushGLProgram ();
			return;
		}
		else
		{
			__currentShader = shader;
			__initShader(shader);
			context3D.setProgram(shader.program);
			context3D._.flushGLProgram();
			// context3D._.__flushGLTextures ();
			__currentShader._.enable();
			context3D._.__state.shader = shader;
		}
	}

	public function setViewport():Void
	{
		__gl.viewport(__offsetX, __offsetY, __displayWidth, __displayHeight);
	}

	public function updateShader():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader._.__position != null) __currentShader._.__position._.useArray = true;
			if (__currentShader._.__textureCoord != null) __currentShader._.__textureCoord._.useArray = true;
			context3D.setProgram(__currentShader.program);
			context3D._.flushGLProgram();
			context3D._.flushGLTextures();
			__currentShader._.__update();
		}
	}

	public function useAlphaArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader._.__alpha != null) __currentShader._.__alpha._.useArray = true;
		}
	}

	public function useColorTransformArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader._.__colorMultiplier != null) __currentShader._.__colorMultiplier._.useArray = true;
			if (__currentShader._.__colorOffset != null) __currentShader._.__colorOffset._.useArray = true;
		}
	}

	public function __cleanup():Void
	{
		if (__stencilReference > 0)
		{
			__stencilReference = 0;
			context3D.setStencilActions();
			context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (__numClipRects > 0)
		{
			__numClipRects = 0;
			__scissorRect();
		}
	}

	public override function __clear():Void
	{
		if (__stage == null || __stage._.__transparent)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}
		else
		{
			context3D.clear(__stage._.__colorSplit[0], __stage._.__colorSplit[1], __stage._.__colorSplit[2], 1, 0, 0, Context3DClearMask.COLOR);
		}

		__cleared = true;
	}

	public function __clearShader():Void
	{
		if (__currentShader != null)
		{
			if (__currentShaderBuffer == null)
			{
				if (__currentShader._.__bitmap != null) __currentShader._.__bitmap.input = null;
			}
			else
			{
				__currentShaderBuffer.clearOverride();
			}

			if (__currentShader._.__texture != null) __currentShader._.__texture.input = null;
			if (__currentShader._.__textureSize != null) __currentShader._.__textureSize.value = null;
			if (__currentShader._.__hasColorTransform != null) __currentShader._.__hasColorTransform.value = null;
			if (__currentShader._.__position != null) __currentShader._.__position.value = null;
			if (__currentShader._.__matrix != null) __currentShader._.__matrix.value = null;
			__currentShader._.clearUseArray();
		}
	}

	public function __copyShader(other:_Context3DRenderer):Void
	{
		__currentShader = other._.__currentShader;
		__currentShaderBuffer = other._.__currentShaderBuffer;
		__currentDisplayShader = other._.__currentDisplayShader;
		__currentGraphicsShader = other._.__currentGraphicsShader;

		// __gl.glProgram = other._.__gl.glProgram;
	}

	public override function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void
	{
		var clipMatrix = null;

		if (clipRect != null)
		{
			clipMatrix = _Matrix.__pool.get();
			clipMatrix.copyFrom(__worldTransform);
			clipMatrix.invert();
			__pushMaskRect(clipRect, clipMatrix);
		}

		var context = context3D;

		var cacheRTT = context._.__state.renderToTexture;
		var cacheRTTDepthStencil = context._.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context._.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context._.__state.renderToTextureSurfaceSelector;

		var prevRenderTarget = __defaultRenderTarget;
		context.setRenderToTexture(bitmapData.getTexture(context), true);
		__setRenderTarget(bitmapData);

		__render(source);

		if (cacheRTT != null)
		{
			context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			context.setRenderToBackBuffer();
		}

		__setRenderTarget(prevRenderTarget);

		if (clipRect != null)
		{
			__popMaskRect();
			_Matrix.__pool.release(clipMatrix);
		}
	}

	public function __fillRect(bitmapData:BitmapData, rect:Rectangle, color:Int):Void
	{
		if (bitmapData._.__renderData.texture != null)
		{
			var context = bitmapData._.__renderData.texture._.__context;

			var color:ARGB = (color : ARGB);
			var useScissor = !bitmapData.rect.equals(rect);

			var cacheRTT = context._.__state.renderToTexture;
			var cacheRTTDepthStencil = context._.__state.renderToTextureDepthStencil;
			var cacheRTTAntiAlias = context._.__state.renderToTextureAntiAlias;
			var cacheRTTSurfaceSelector = context._.__state.renderToTextureSurfaceSelector;

			context.setRenderToTexture(bitmapData._.__renderData.texture);

			if (useScissor)
			{
				context.setScissorRectangle(rect);
			}

			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, bitmapData.transparent ? color.a / 0xFF : 1, 0, 0, Context3DClearMask.COLOR);

			if (useScissor)
			{
				context.setScissorRectangle(null);
			}

			if (cacheRTT != null)
			{
				context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
			}
			else
			{
				context.setRenderToBackBuffer();
			}
		}
	}

	public function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	public function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__tempColorTransform._.__copyFrom(__worldColorTransform);
			__tempColorTransform._.__combine(value);
			return __tempColorTransform;
		}
		else
		{
			return value;
		}
	}

	public function __getDisplayTransformTempMatrix(transform:Matrix, pixelSnapping:PixelSnapping):Matrix
	{
		var matrix = __getMatrixHelperMatrix;
		matrix.copyFrom(transform);
		// matrix.concat(__worldTransform);

		if (pixelSnapping == ALWAYS
			|| (pixelSnapping == AUTO
				&& matrix.b == 0
				&& matrix.c == 0
				&& (matrix.a < 1.001 && matrix.a > 0.999)
				&& (matrix.d < 1.001 && matrix.d > 0.999)))
		{
			matrix.tx = Math.round(matrix.tx);
			matrix.ty = Math.round(matrix.ty);
		}

		return matrix;
	}

	public function __getMatrix(transform:Matrix, pixelSnapping:PixelSnapping):Array<Float>
	{
		var _matrix = _Matrix.__pool.get();
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
		#if (!lime && openfl_html5)
		__matrix.rawData[0] = _matrix.a;
		__matrix.rawData[1] = _matrix.b;
		__matrix.rawData[4] = _matrix.c;
		__matrix.rawData[5] = _matrix.d;
		__matrix.rawData[12] = _matrix.tx;
		__matrix.rawData[13] = _matrix.ty;
		#else
		__matrix[0] = _matrix.a;
		__matrix[1] = _matrix.b;
		__matrix[4] = _matrix.c;
		__matrix[5] = _matrix.d;
		__matrix[12] = _matrix.tx;
		__matrix[13] = _matrix.ty;
		#end
		__matrix.append(__flipped ? __projectionFlipped : __projection);

		for (i in 0...16)
		{
			#if (!lime && openfl_html5)
			__values[i] = __matrix.rawData[i];
			#else
			__values[i] = __matrix[i];
			#end
		}

		_Matrix.__pool.release(_matrix);

		return __values;
	}

	public function __init(context:Context3D, defaultRenderTarget:BitmapData):Void
	{
		context3D = context;
		#if lime
		__limeContext = context._.limeContext;
		#end
		__gl = cast context._.gl;
		gl = __gl;

		#if !disable_batcher
		if (batcher == null)
		{
			batcher = new BatchRenderer(this, 4096);
		}
		else
		{
			batcher.flush();
		}
		#end

		__defaultRenderTarget = defaultRenderTarget;
		__flipped = (__defaultRenderTarget == null);
	}

	public function __initShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if (shader._.context == null)
			{
				shader._.__init(context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultShader;
	}

	public function __initDisplayShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if (shader._.context == null)
			{
				shader._.__init(context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultDisplayShader;
	}

	public function __initGraphicsShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if (shader._.context == null)
			{
				shader._.__init(context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultGraphicsShader;
	}

	public function __initShaderBuffer(shaderBuffer:ShaderBuffer):Shader
	{
		if (shaderBuffer != null)
		{
			return __initGraphicsShader(shaderBuffer.shader);
		}

		return __defaultGraphicsShader;
	}

	public function __popMask():Void
	{
		if (__stencilReference == 0) return;

		#if !disable_batcher
		batcher.flush();
		#end

		var mask = __maskObjects.pop();

		if (__stencilReference > 1)
		{
			context3D.setStencilActions(FRONT_AND_BACK, EQUAL, DECREMENT_SATURATE, DECREMENT_SATURATE, KEEP);
			context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
			context3D.setColorMask(false, false, false, false);

			__renderMask(mask);

			#if !disable_batcher
			batcher.flush();
			#end

			__stencilReference--;

			context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
			context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
			context3D.setColorMask(true, true, true, true);
		}
		else
		{
			__stencilReference = 0;
			context3D.setStencilActions();
			context3D.setStencilReferenceValue(0, 0, 0);
		}
	}

	public function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (object._.__mask != null)
		{
			__popMask();
		}

		if (handleScrollRect && object._.__scrollRect != null)
		{
			if (object._.__renderTransform.b != 0 || object._.__renderTransform.c != 0)
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

	public function __popMaskRect():Void
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

	public inline function __powerOfTwo(value:Int):Int
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}

	public function __pushMask(mask:DisplayObject):Void
	{
		#if !disable_batcher
		batcher.flush();
		#end

		if (__stencilReference == 0)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
			__updatedStencil = true;
		}

		context3D.setStencilActions(FRONT_AND_BACK, EQUAL, INCREMENT_SATURATE, KEEP, KEEP);
		context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
		context3D.setColorMask(false, false, false, false);

		__renderMask(mask);

		#if !disable_batcher
		batcher.flush();
		#end

		__maskObjects.push(mask);
		__stencilReference++;

		context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
		context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
		context3D.setColorMask(true, true, true, true);
	}

	public function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && object._.__scrollRect != null)
		{
			if (object._.__renderTransform.b != 0 || object._.__renderTransform.c != 0)
			{
				var shape = __scrollRectMasks.get();
				shape.graphics.clear();
				shape.graphics.beginFill(0x00FF00);
				shape.graphics.drawRect(object._.__scrollRect.x, object._.__scrollRect.y, object._.__scrollRect.width, object._.__scrollRect.height);
				shape._.__renderTransform.copyFrom(object._.__renderTransform);
				__pushMask(shape);
			}
			else
			{
				__pushMaskRect(object._.__scrollRect, object._.__renderTransform);
			}
		}

		if (object._.__mask != null)
		{
			__pushMask(object._.__mask);
		}
	}

	public function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		// TODO: Handle rotation?

		if (__numClipRects == __clipRects.length)
		{
			__clipRects[__numClipRects] = new Rectangle();
		}

		var _matrix = _Matrix.__pool.get();
		_matrix.copyFrom(transform);
		_matrix.concat(__worldTransform);

		var clipRect = __clipRects[__numClipRects];
		rect._.__transform(clipRect, _matrix);

		if (__numClipRects > 0)
		{
			var parentClipRect = __clipRects[__numClipRects - 1];
			clipRect._.__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
		}

		if (clipRect.height < 0)
		{
			clipRect.height = 0;
		}

		if (clipRect.width < 0)
		{
			clipRect.width = 0;
		}

		_Matrix.__pool.release(_matrix);

		__scissorRect(clipRect);
		__numClipRects++;
	}

	public override function __render(object:IBitmapDrawable):Void
	{
		context3D.setColorMask(true, true, true, true);
		context3D.setCulling(NONE);
		context3D.setDepthTest(false, ALWAYS);
		context3D.setStencilActions();
		context3D.setStencilReferenceValue(0, 0, 0);
		context3D.setScissorRectangle(null);

		__blendMode = null;
		__setBlendMode(NORMAL);

		if (__defaultRenderTarget == null)
		{
			__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			context3D.setScissorRectangle(__scissorRectangle);

			__upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);

			// TODO: BitmapData render
			if (object != null && object._.__type != null)
			{
				__renderDisplayObject(cast object);
			}

			#if !disable_batcher
			// flush whatever is left in the batch to render
			batcher.flush();
			#end

			// TODO: Handle this in Context3D as a viewport?

			if (__offsetX > 0 || __offsetY > 0)
			{
				// context3D._.__setGLScissorTest (true);

				if (__offsetX > 0)
				{
					// __gl.scissor (0, 0, __offsetX, __height);
					__scissorRectangle.setTo(0, 0, __offsetX, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D._.flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(GL.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (__offsetX + __displayWidth, 0, __width, __height);
					__scissorRectangle.setTo(__offsetX + __displayWidth, 0, __width, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D._.flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(GL.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				if (__offsetY > 0)
				{
					// __gl.scissor (0, 0, __width, __offsetY);
					__scissorRectangle.setTo(0, 0, __width, __offsetY);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D._.flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(GL.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (0, __offsetY + __displayHeight, __width, __height);
					__scissorRectangle.setTo(0, __offsetY + __displayHeight, __width, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D._.flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(GL.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				context3D.setScissorRectangle(null);
			}
		}
		else
		{
			__scissorRectangle.setTo(__offsetX, __offsetY, __displayWidth, __displayHeight);
			context3D.setScissorRectangle(__scissorRectangle);
			// __gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);

			// __upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);

			// TODO: Cleaner approach?

			var cacheMask = object._.__mask;
			var cacheScrollRect = object._.__scrollRect;
			object._.__mask = null;
			object._.__scrollRect = null;

			if (object != null)
			{
				if (object._.__type != null)
				{
					__renderDisplayObject(cast object);
				}
				else
				{
					__renderBitmapData(cast object);
				}
			}

			#if !disable_batcher
			// flush whatever is left in the batch to render
			batcher.flush();
			#end

			object._.__mask = cacheMask;
			object._.__scrollRect = cacheScrollRect;

			context3D.setScissorRectangle(null);
		}

		context3D.present();
	}

	public function __renderBitmap(bitmap:Bitmap):Void
	{
		__updateCacheBitmap(bitmap, false);

		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData.readable)
		{
			bitmap._.__imageVersion = bitmap._.__bitmapData._.__getVersion();
		}

		if (bitmap._.__renderData.cacheBitmap != null && !bitmap._.__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2(bitmap._.__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(bitmap, this);
			Context3DBitmap.render(bitmap, this);
		}
	}

	public function __renderBitmapData(bitmapData:BitmapData):Void
	{
		__setBlendMode(NORMAL);

		var shader = __defaultDisplayShader;
		setShader(shader);
		applyBitmapData(bitmapData, __upscaled);
		applyMatrix(__getMatrix(bitmapData._.__worldTransform, AUTO));
		applyAlpha(__getAlpha(bitmapData._.__worldAlpha));
		applyColorTransform(bitmapData._.__worldColorTransform);
		updateShader();

		// alpha == 1, __worldColorTransform

		var vertexBuffer = bitmapData.getVertexBuffer(context3D);
		if (shader._.__position != null) context3D.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader._.__textureCoord != null) context3D.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = bitmapData.getIndexBuffer(context3D);
		context3D.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		__clearShader();
	}

	public function __renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null && object._.__type != null)
		{
			switch ((object._ : _DisplayObject).__type)
			{
				case BITMAP:
					__renderBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					__renderDisplayObjectContainer(cast object);
				case DISPLAY_OBJECT, SHAPE:
					__renderShape(cast object);
				case SIMPLE_BUTTON:
					__renderSimpleButton(cast object);
				case TEXTFIELD:
					__renderTextField(cast object);
				case TILEMAP:
					__renderTilemap(cast object);
				case VIDEO:
					__renderVideo(cast object);
				#if draft
				case GL_GRAPHICS:
					openfl.display.HWGraphics.render(cast object, this);
				case GEOMETRY:
					openfl.display._internal.Context3DGeometry.render(cast object, this);
				#end
				default:
			}

			if (object._.__customRenderEvent != null)
			{
				var event = object._.__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom(object._.__renderTransform);
				event.objectColorTransform._.__copyFrom(object._.__worldColorTransform);
				event.renderer = this;

				if (!__cleared) __clear();

				setShader(object._.__worldShader);
				context3D._.flushGL();

				event.type = RenderEvent.RENDER_OPENGL;

				__setBlendMode(object._.__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);

				setViewport();
			}
		}
	}

	public function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		container._.__cleanupRemovedChildren();

		if (!container._.__renderable || container._.__worldAlpha <= 0) return;

		__updateCacheBitmap(container, false);

		if (container._.__renderData.cacheBitmap != null && !container._.__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2(container._.__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(container, this);
		}

		if (container._.__renderData.cacheBitmap != null && !container._.__renderData.isCacheBitmapRender) return;

		if (container.numChildren > 0)
		{
			__pushMaskObject(container);
			// renderer.filterManager.pushObject (this);

			var child = container._.__firstChild;
			if (__stage != null)
			{
				while (child != null)
				{
					__renderDisplayObject(child);
					child._.__renderDirty = false;
					child = child._.__nextSibling;
				}

				container._.__renderDirty = false;
			}
			else
			{
				while (child != null)
				{
					__renderDisplayObject(child);
					child = child._.__nextSibling;
				}
			}
		}

		if (container.numChildren > 0)
		{
			__popMaskObject(container);
		}
	}

	public function __renderFilterPass(source:BitmapData, shader:Shader, smooth:Bool, clear:Bool = true):Void
	{
		if (source == null || shader == null) return;
		if (__defaultRenderTarget == null) return;

		var cacheRTT = context3D._.__state.renderToTexture;
		var cacheRTTDepthStencil = context3D._.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context3D._.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context3D._.__state.renderToTextureSurfaceSelector;

		context3D.setRenderToTexture(__defaultRenderTarget.getTexture(context3D), false);

		if (clear)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}

		var shader = __initShader(shader);
		setShader(shader);
		applyAlpha(__getAlpha(1));
		applyBitmapData(source, smooth);
		applyColorTransform(null);
		applyMatrix(__getMatrix(source._.__renderTransform, AUTO));
		updateShader();

		var vertexBuffer = source.getVertexBuffer(context3D);
		if (shader._.__position != null) context3D.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader._.__textureCoord != null) context3D.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = source.getIndexBuffer(context3D);
		context3D.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		if (cacheRTT != null)
		{
			context3D.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			context3D.setRenderToBackBuffer();
		}

		__clearShader();
	}

	public function __renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch ((mask._ : _DisplayObject).__type)
			{
				case BITMAP:
					Context3DBitmap.renderMask(cast mask, this);

				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var container:DisplayObjectContainer = cast mask;
					container._.__cleanupRemovedChildren();

					if (container._.__graphics != null)
					{
						Context3DShape.renderMask(container, this);
					}

					var child = container._.__firstChild;
					while (child != null)
					{
						__renderMask(child);
						child = child._.__nextSibling;
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					__renderMask(button._.__currentState);

				case TEXTFIELD:
					Context3DTextField.renderMask(cast mask, this);
					Context3DShape.renderMask(mask, this);

				case TILEMAP:
					Context3DDisplayObject.renderMask(cast mask, this);
					Context3DTilemap.renderMask(cast mask, this);

				case VIDEO:
					Context3DVideo.renderMask(cast mask, this);

				default:
					if (mask._.__graphics != null)
					{
						Context3DShape.renderMask(mask, this);
					}
			}
		}
	}

	public function __renderShape(shape:DisplayObject):Void
	{
		__updateCacheBitmap(shape, false);

		if (shape._.__renderData.cacheBitmap != null && !shape._.__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2(shape._.__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(shape, this);
		}
	}

	public function __renderSimpleButton(button:SimpleButton):Void
	{
		if (!button._.__renderable || button._.__worldAlpha <= 0 || button._.__currentState == null) return;

		__pushMaskObject(button);
		__renderDisplayObject(button._.__currentState);
		__popMaskObject(button);
	}

	public function __renderTextField(textField:TextField):Void
	{
		__updateCacheBitmap(textField, textField._.__dirty);

		if (textField._.__renderData.cacheBitmap != null && !textField._.__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2(textField._.__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DTextField.render(textField, this);
			Context3DDisplayObject.render(textField, this);
		}
	}

	public function __renderTilemap(tilemap:Tilemap):Void
	{
		__updateCacheBitmap(tilemap, false);

		if (tilemap._.__renderData.cacheBitmap != null && !tilemap._.__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2(tilemap._.__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(tilemap, this);
			Context3DTilemap.render(tilemap, this);
		}
	}

	public function __renderVideo(video:Video):Void
	{
		Context3DVideo.render(video, this);
	}

	public override function __resize(width:Int, height:Int):Void
	{
		__width = width;
		__height = height;

		var w = (__defaultRenderTarget == null) ? __stage.stageWidth : __defaultRenderTarget._.__renderData.textureWidth;
		var h = (__defaultRenderTarget == null) ? __stage.stageHeight : __defaultRenderTarget._.__renderData.textureHeight;

		__offsetX = __defaultRenderTarget == null ? Math.round(__worldTransform._.__transformX(0, 0)) : 0;
		__offsetY = __defaultRenderTarget == null ? Math.round(__worldTransform._.__transformY(0, 0)) : 0;
		__displayWidth = __defaultRenderTarget == null ? Math.round(__worldTransform._.__transformX(w, 0) - __offsetX) : w;
		__displayHeight = __defaultRenderTarget == null ? Math.round(__worldTransform._.__transformY(0, h) - __offsetY) : h;

		#if (!lime && openfl_html5)
		__projection = Matrix3D.createOrtho(0, __displayWidth + __offsetX * 2, 0, __displayHeight + __offsetY * 2, -1000, 1000);
		__projectionFlipped = Matrix3D.createOrtho(0, __displayWidth + __offsetX * 2, __displayHeight + __offsetY * 2, 0, -1000, 1000);
		#else
		__projection.createOrtho(0, __displayWidth + __offsetX * 2, 0, __displayHeight + __offsetY * 2, -1000, 1000);
		__projectionFlipped.createOrtho(0, __displayWidth + __offsetX * 2, __displayHeight + __offsetY * 2, 0, -1000, 1000);
		#end
	}

	public function __resumeClipAndMask(childRenderer:_Context3DRenderer):Void
	{
		if (__stencilReference > 0)
		{
			context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
			context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
		}
		else
		{
			context3D.setStencilActions();
			context3D.setStencilReferenceValue(0, 0, 0);
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

	public function __scissorRect(clipRect:Rectangle = null):Void
	{
		#if !disable_batcher
		batcher.flush();
		#end

		if (clipRect != null)
		{
			var x = Math.floor(clipRect.x);
			var y = Math.floor(clipRect.y);
			var width = (clipRect.width > 0 ? Math.ceil(clipRect.right) - x : 0);
			var height = (clipRect.height > 0 ? Math.ceil(clipRect.bottom) - y : 0);

			if (width < 0) width = 0;
			if (height < 0) height = 0;

			// __scissorRectangle.setTo (x, __flipped ? __height - y - height : y, width, height);
			__scissorRectangle.setTo(x, y, width, height);
			context3D.setScissorRectangle(__scissorRectangle);
		}
		else
		{
			context3D.setScissorRectangle(null);
		}
	}

	public function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;

		switch (value)
		{
			case ADD:
				context3D.setBlendFactors(ONE, ONE);

			case MULTIPLY:
				context3D.setBlendFactors(DESTINATION_COLOR, ONE_MINUS_SOURCE_ALPHA);

			case SCREEN:
				context3D.setBlendFactors(ONE, ONE_MINUS_SOURCE_COLOR);

			case SUBTRACT:
				context3D.setBlendFactors(ONE, ONE);
				context3D._.setGLBlendEquation(GL.FUNC_REVERSE_SUBTRACT);

			#if desktop
			case DARKEN:
				context3D.setBlendFactors(ONE, ONE);
				context3D._.setGLBlendEquation(0x8007); // GL_MIN

			case LIGHTEN:
				context3D.setBlendFactors(ONE, ONE);
				context3D._.setGLBlendEquation(0x8008); // GL_MAX
			#end

			default:
				context3D.setBlendFactors(ONE, ONE_MINUS_SOURCE_ALPHA);
		}
	}

	public function __setRenderTarget(renderTarget:BitmapData):Void
	{
		__defaultRenderTarget = renderTarget;
		__flipped = (renderTarget == null);

		if (renderTarget != null)
		{
			__resize(renderTarget.width, renderTarget.height);
		}
	}

	public function __setShaderBuffer(shaderBuffer:ShaderBuffer):Void
	{
		setShader(shaderBuffer.shader);
		__currentShaderBuffer = shaderBuffer;
	}

	public function __shouldCacheHardware(object:DisplayObject, value:Null<Bool>):Null<Bool>
	{
		if (value == true) return true;

		switch ((object._ : _DisplayObject).__type)
		{
			case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
				if (object._.__filters != null) return true;

				if (value == false || (object._.__graphics != null && !Context3DGraphics.isCompatible(object._.__graphics)))
				{
					value = false;
				}

				var child = object._.__firstChild;
				while (child != null)
				{
					value = __shouldCacheHardware(child, value);
					if (value == true) return true;
					child = child._.__nextSibling;
				}

				return value;

			case TEXTFIELD:
				return value == true ? true : false;

			case TILEMAP:
				return true;

			default:
				if (value == true || object._.__filters != null) return true;

				if (value == false || (object._.__graphics != null && !Context3DGraphics.isCompatible(object._.__graphics)))
				{
					return false;
				}

				return null;
		}
	}

	public inline function __shouldSnapToPixel(bitmap:Bitmap):Bool
	{
		return switch bitmap.pixelSnapping
		{
			case null | NEVER: false;
			case ALWAYS: true;
			case AUTO: Math.abs(bitmap._.__renderTransform.a) == 1 && Math.abs(bitmap._.__renderTransform.d) == 1; // only snap when not scaled/rotated/skewed
		}
	}

	public function __suspendClipAndMask():Void
	{
		if (__stencilReference > 0)
		{
			context3D.setStencilActions();
			context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (__numClipRects > 0)
		{
			__scissorRect();
		}
	}

	public function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		if (object._.__renderData.isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap)
		{
			if (object._.__renderData.cacheBitmapMatrix == null)
			{
				object._.__renderData.cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = #if !openfl_disable_filters object._.__filters != null #else false #end;
			var bitmapMatrix = (object._.__cacheAsBitmapMatrix != null ? object._.__cacheAsBitmapMatrix : object._.__renderTransform);

			var colorTransform = ColorTransform._.__pool.get();
			colorTransform._.__copyFrom(object._.__worldColorTransform);
			if (__worldColorTransform != null) colorTransform._.__combine(__worldColorTransform);

			var needRender = (object._.__renderData.cacheBitmap == null
				|| (object._.__renderDirty && (force || object._.__firstChild != null))
				|| object.opaqueBackground != object._.__renderData.cacheBitmapBackground)
				|| (object._.__graphics != null && object._.__graphics._.__hardwareDirty);

			var rect = null;

			if (!needRender
				&& (bitmapMatrix.a != object._.__renderData.cacheBitmapMatrix.a
					|| bitmapMatrix.b != object._.__renderData.cacheBitmapMatrix.b
					|| bitmapMatrix.c != object._.__renderData.cacheBitmapMatrix.c
					|| bitmapMatrix.d != object._.__renderData.cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (filter in object._.__filters)
				{
					if (filter._.__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !object._.__renderData.cacheBitmap._.__worldTransform.equals(object._.__worldTransform));

			object._.__renderData.cacheBitmapMatrix.copyFrom(bitmapMatrix);
			object._.__renderData.cacheBitmapMatrix.tx = 0;
			object._.__renderData.cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = _Rectangle.__pool.get();

				object._.__getFilterBounds(rect, object._.__renderData.cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (object._.__renderData.cacheBitmapDataTexture != null)
				{
					if (filterWidth > object._.__renderData.cacheBitmapDataTexture.width
						|| filterHeight > object._.__renderData.cacheBitmapDataTexture.height)
					{
						bitmapWidth = __powerOfTwo(filterWidth);
						bitmapHeight = __powerOfTwo(filterHeight);
						needRender = true;
					}
					else
					{
						bitmapWidth = object._.__renderData.cacheBitmapDataTexture.width;
						bitmapHeight = object._.__renderData.cacheBitmapDataTexture.height;
					}
				}
				else
				{
					bitmapWidth = __powerOfTwo(filterWidth);
					bitmapHeight = __powerOfTwo(filterHeight);
				}
			}

			if (needRender)
			{
				updateTransform = true;
				object._.__renderData.cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;

					if (object._.__renderData.cacheBitmapDataTexture == null
						|| bitmapWidth > object._.__renderData.cacheBitmapDataTexture.width
						|| bitmapHeight > object._.__renderData.cacheBitmapDataTexture.height)
					{
						// TODO: Use pool for HW bitmap data
						var texture = context3D.createRectangleTexture(bitmapWidth, bitmapHeight, BGRA, true);
						object._.__renderData.cacheBitmapDataTexture = BitmapData.fromTexture(texture);
					}

					object._.__renderData.cacheBitmapDataTexture.fillRect(rect, 0);

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						object._.__renderData.cacheBitmapDataTexture.fillRect(rect, fillColor);
					}
				}
				else
				{
					ColorTransform._.__pool.release(colorTransform);

					object._.__renderData.cacheBitmap = null;
					object._.__renderData.cacheBitmapData = null;
					object._.__renderData.cacheBitmapDataTexture = null;

					return true;
				}
			}

			if (object._.__renderData.cacheBitmap == null) object._.__renderData.cacheBitmap = new Bitmap();
			object._.__renderData.cacheBitmap.bitmapData = object._.__renderData.cacheBitmapDataTexture;

			if (updateTransform)
			{
				object._.__renderData.cacheBitmap._.__worldTransform.copyFrom(object._.__worldTransform);

				if (bitmapMatrix == object._.__renderTransform)
				{
					object._.__renderData.cacheBitmap._.__renderTransform.identity();
					object._.__renderData.cacheBitmap._.__renderTransform.tx = object._.__renderTransform.tx + offsetX;
					object._.__renderData.cacheBitmap._.__renderTransform.ty = object._.__renderTransform.ty + offsetY;
				}
				else
				{
					object._.__renderData.cacheBitmap._.__renderTransform.copyFrom(object._.__renderData.cacheBitmapMatrix);
					object._.__renderData.cacheBitmap._.__renderTransform.invert();
					object._.__renderData.cacheBitmap._.__renderTransform.concat(object._.__renderTransform);
					object._.__renderData.cacheBitmap._.__renderTransform.tx += offsetX;
					object._.__renderData.cacheBitmap._.__renderTransform.ty += offsetY;
				}
			}

			object._.__renderData.cacheBitmap.smoothing = __allowSmoothing;
			object._.__renderData.cacheBitmap._.__renderable = object._.__renderable;
			object._.__renderData.cacheBitmap._.__worldAlpha = object._.__worldAlpha;
			object._.__renderData.cacheBitmap._.__worldBlendMode = object._.__worldBlendMode;
			object._.__renderData.cacheBitmap._.__worldShader = object._.__worldShader;
			object._.__renderData.cacheBitmap.mask = object._.__mask;

			if (needRender)
			{
				var childRenderer = __childRendererPool.get();
				childRenderer.__init(context3D, object._.__renderData.cacheBitmapDataTexture);

				childRenderer.__stage = object.stage;

				childRenderer.__allowSmoothing = __allowSmoothing;
				(cast childRenderer : _Context3DRenderer)._.__setBlendMode(NORMAL);
				childRenderer.__worldAlpha = 1 / object._.__worldAlpha;

				childRenderer.__worldTransform.copyFrom(object._.__renderTransform);
				childRenderer.__worldTransform.invert();
				childRenderer.__worldTransform.concat(object._.__renderData.cacheBitmapMatrix);
				childRenderer.__worldTransform.tx -= offsetX;
				childRenderer.__worldTransform.ty -= offsetY;

				childRenderer.__worldColorTransform._.__copyFrom(colorTransform);
				childRenderer.__worldColorTransform._.__invert();

				object._.__renderData.isCacheBitmapRender = true;

				var cacheRTT = context3D._.__state.renderToTexture;
				var cacheRTTDepthStencil = context3D._.__state.renderToTextureDepthStencil;
				var cacheRTTAntiAlias = context3D._.__state.renderToTextureAntiAlias;
				var cacheRTTSurfaceSelector = context3D._.__state.renderToTextureSurfaceSelector;

				var cacheBlendMode = __blendMode;
				__suspendClipAndMask();
				childRenderer.__copyShader(this);

				Context3DBitmapData.setUVRect(object._.__renderData.cacheBitmapDataTexture, context3D, 0, 0, filterWidth, filterHeight);
				childRenderer.__setRenderTarget(object._.__renderData.cacheBitmapDataTexture);
				// if (object._.__renderData.cacheBitmapDataTexture.image != null) object._.__renderData.cacheBitmapData._.__renderData.textureVersion = object._.__renderData.cacheBitmapData._.__getVersion() + 1;

				childRenderer.__drawBitmapData(object._.__renderData.cacheBitmapDataTexture, object, null);

				if (hasFilters)
				{
					var needCopyOfOriginal = false;

					for (filter in object._.__filters)
					{
						if (filter._.__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var cacheRenderer = BitmapData._.__hardwareRenderer;
					BitmapData._.__hardwareRenderer = childRenderer;

					var bitmap = context3D._.__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap2 = context3D._.__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap3 = needCopyOfOriginal ? context3D._.__bitmapDataPool.get(filterWidth, filterHeight) : null;

					Context3DBitmapData.setUVRect(bitmap, context3D, 0, 0, filterWidth, filterHeight);
					Context3DBitmapData.setUVRect(bitmap2, context3D, 0, 0, filterWidth, filterHeight);
					if (bitmap3 != null) Context3DBitmapData.setUVRect(bitmap3, context3D, 0, 0, filterWidth, filterHeight);

					childRenderer.__setBlendMode(NORMAL);
					childRenderer.__worldAlpha = 1;
					childRenderer.__worldTransform.identity();
					childRenderer.__worldColorTransform._.__identity();

					var shader, cacheBitmap, firstPass = true;

					for (filter in object._.__filters)
					{
						if (filter._.__preserveObject)
						{
							childRenderer.__setRenderTarget(bitmap3);
							childRenderer.__renderFilterPass(firstPass ? object._.__renderData.cacheBitmapDataTexture : bitmap,
								childRenderer.__defaultDisplayShader, filter._.__smooth);
						}

						for (i in 0...filter._.__numShaderPasses)
						{
							shader = filter._.__initShader(childRenderer, i, filter._.__preserveObject ? bitmap3 : null);
							childRenderer.__setBlendMode(filter._.__shaderBlendMode);
							childRenderer.__setRenderTarget(bitmap2);
							childRenderer.__renderFilterPass(firstPass ? object._.__renderData.cacheBitmapDataTexture : bitmap, shader, filter._.__smooth);

							firstPass = false;
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}

						filter._.__renderDirty = false;
					}

					if (bitmap != null)
					{
						object._.__renderData.cacheBitmapDataTexture.fillRect(object._.__renderData.cacheBitmapDataTexture.rect, 0);
						childRenderer.__setRenderTarget(object._.__renderData.cacheBitmapDataTexture);
						childRenderer.__renderFilterPass(bitmap, childRenderer.__defaultDisplayShader, true);
						// object._.__renderData.cacheBitmap.bitmapData = object._.__renderData.cacheBitmapData;
					}

					context3D._.__bitmapDataPool.release(bitmap);
					context3D._.__bitmapDataPool.release(bitmap2);
					if (bitmap3 != null) context3D._.__bitmapDataPool.release(bitmap3);

					_BitmapData.__hardwareRenderer = cacheRenderer;
				}

				__blendMode = NORMAL;
				__setBlendMode(cacheBlendMode);
				__copyShader(childRenderer);

				if (cacheRTT != null)
				{
					context3D.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
				}
				else
				{
					context3D.setRenderToBackBuffer();
				}

				__resumeClipAndMask(childRenderer);
				setViewport();

				object._.__renderData.isCacheBitmapRender = false;
				__childRendererPool.release(childRenderer);
			}

			if (updateTransform)
			{
				_Rectangle.__pool.release(rect);
			}

			updated = updateTransform;

			_ColorTransform.__pool.release(colorTransform);
		}
		else if (object._.__renderData.cacheBitmap != null)
		{
			object._.__renderData.cacheBitmap = null;
			object._.__renderData.cacheBitmapDataTexture = null;

			updated = true;
		}

		return updated;
	}

	public function __updateShaderBuffer(bufferOffset:Int):Void
	{
		if (__currentShader != null && __currentShaderBuffer != null)
		{
			__currentShader._.updateFromBuffer(__currentShaderBuffer, bufferOffset);
		}
	}
}
#end
#else
typedef Context3DRenderer = Dynamic;
#end
