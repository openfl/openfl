package openfl._internal.renderer.context3D;

import haxe.ds.IntMap;
#if !flash
import lime.graphics.opengl.ext.KHR_debug;
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.math.ARGB;
import lime.math.Matrix4;
import lime.utils.Float32Array;
import openfl._internal.renderer.context3D.batcher.BatchRenderer;
import openfl._internal.renderer.ShaderBuffer;
import openfl._internal.utils.ObjectPool;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
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
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.Video;
import openfl.text.TextField;
#if (js && html5)
import lime._internal.graphics.ImageCanvasUtil;
import openfl._internal.renderer.canvas.CanvasRenderer;
#else
import lime.graphics.cairo.Cairo;
import openfl._internal.renderer.cairo.CairoRenderer;
#end
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.GLRenderContext)
@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.renderer.canvas.CanvasRenderer)
@:access(openfl._internal.renderer.cairo.CairoRenderer)
@:access(openfl._internal.renderer.context3D.Context3DGraphics)
@:access(openfl._internal.renderer.ShaderBuffer)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Shader)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display.Stage3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl._internal.renderer.context3D)
@:allow(openfl.display3D.textures)
@:allow(openfl.display3D)
@:allow(openfl.display)
@:allow(openfl.text)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DRenderer extends Context3DRendererAPI
{
	private static var __alphaValue:Array<Float> = [1];
	private static var __childRendererPool:ObjectPool<Context3DRenderer>;
	private static var __colorMultipliersValue:Array<Float> = [0, 0, 0, 0];
	private static var __colorOffsetsValue:Array<Float> = [0, 0, 0, 0];
	private static var __defaultColorMultipliersValue:Array<Float> = [1, 1, 1, 1];
	private static var __emptyColorValue:Array<Float> = [0, 0, 0, 0];
	private static var __emptyAlphaValue:Array<Float> = [1];
	private static var __hasColorTransformValue:Array<Bool> = [false];
	private static var __scissorRectangle:Rectangle = new Rectangle();
	private static var __textureSizeValue:Array<Float> = [0, 0];

	public var batcher:BatchRenderer;
	public var context3D:Context3D;

	private var __alphaMaskShader:Context3DAlphaMaskShader;
	private var __clipRects:Array<Rectangle>;
	private var __context:RenderContext;
	private var __currentDisplayShader:Shader;
	private var __currentGraphicsShader:Shader;
	private var __currentRenderTarget:BitmapData;
	private var __currentShader:Shader;
	private var __currentShaderBuffer:ShaderBuffer;
	private var __defaultDisplayShader:DisplayObjectShader;
	private var __defaultGraphicsShader:GraphicsShader;
	private var __defaultRenderTarget:BitmapData;
	private var __defaultShader:Shader;
	private var __displayHeight:Int;
	private var __displayWidth:Int;
	private var __flipped:Bool;
	private var __getMatrixHelperMatrix:Matrix = new Matrix();
	private var __gl:WebGLRenderContext;
	private var __height:Int;
	private var __maskShader:Context3DMaskShader;
	private var __matrix:Matrix4;
	private var __maskObjects:Array<DisplayObject>;
	private var __numClipRects:Int;
	private var __offsetX:Int;
	private var __offsetY:Int;
	private var __projection:Matrix4;
	private var __projectionFlipped:Matrix4;
	private var __scrollRectMasks:ObjectPool<Shape>;
	private var __softwareRenderer:DisplayObjectRenderer;
	private var __stencilReference:Int;
	private var __tempColorTransform:ColorTransform;
	private var __tempRect:Rectangle;
	private var __updatedStencil:Bool;
	private var __upscaled:Bool;
	private var __values:Array<Float>;
	private var __width:Int;

	private function new(context:Context3D, defaultRenderTarget:BitmapData = null)
	{
		super(context);

		__init(context, defaultRenderTarget);

		if (Graphics.maxTextureWidth == null)
		{
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = __gl.getParameter(__gl.MAX_TEXTURE_SIZE);
		}

		__matrix = new Matrix4();

		__values = new Array();

		#if gl_debug
		var ext:KHR_debug = __gl.getExtension("KHR_debug");
		if (ext != null)
		{
			__gl.enable(ext.DEBUG_OUTPUT);
			__gl.enable(ext.DEBUG_OUTPUT_SYNCHRONOUS);
		}
		#end

		#if (js && html5)
		__softwareRenderer = new CanvasRenderer(null);
		#else
		__softwareRenderer = new CairoRenderer(null);
		#end

		__type = OPENGL;

		__setBlendMode(NORMAL);
		context3D.__setGLBlend(true);

		__clipRects = new Array();
		__maskObjects = new Array();
		__numClipRects = 0;
		__projection = new Matrix4();
		__projectionFlipped = new Matrix4();
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
			__childRendererPool = new ObjectPool<Context3DRenderer>(function()
			{
				var renderer = new Context3DRenderer(context3D, null);
				renderer.__worldTransform = new Matrix();
				renderer.__worldColorTransform = new ColorTransform();
				return renderer;
			});
		}
	}

	public override function applyAlpha(alpha:Float):Void
	{
		__alphaValue[0] = alpha;

		if (__currentShaderBuffer != null)
		{
			__currentShaderBuffer.addFloatOverride("openfl_Alpha", __alphaValue);
		}
		else if (__currentShader != null)
		{
			if (__currentShader.__alpha != null) __currentShader.__alpha.value = __alphaValue;
		}
	}

	public override function applyBitmapData(bitmapData:BitmapData, smooth:Bool, repeat:Bool = false):Void
	{
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

	public override function applyColorTransform(colorTransform:ColorTransform):Void
	{
		var enabled = (colorTransform != null && !colorTransform.__isDefault(true));
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

	public override function applyHasColorTransform(enabled:Bool):Void
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

	public override function applyMatrix(matrix:Array<Float>):Void
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

	public override function getMatrix(transform:Matrix):Matrix4
	{
		if (__gl != null)
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

	public override function setShader(shader:Shader):Void
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
			context3D.setProgram(null);
			// context3D.__flushGLProgram ();
			return;
		}
		else
		{
			__currentShader = shader;
			__initShader(shader);
			context3D.setProgram(shader.program);
			context3D.__flushGLProgram();
			// context3D.__flushGLTextures ();
			__currentShader.__enable();
			context3D.__state.shader = shader;
		}
	}

	public override function setViewport():Void
	{
		__gl.viewport(__offsetX, __offsetY, __displayWidth, __displayHeight);
	}

	public override function updateShader():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__position != null) __currentShader.__position.__useArray = true;
			if (__currentShader.__textureCoord != null) __currentShader.__textureCoord.__useArray = true;
			context3D.setProgram(__currentShader.program);
			context3D.__flushGLProgram();
			context3D.__flushGLTextures();
			__currentShader.__update();
		}
	}

	public override function useAlphaArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__alpha != null) __currentShader.__alpha.__useArray = true;
		}
	}

	public override function useColorTransformArray():Void
	{
		if (__currentShader != null)
		{
			if (__currentShader.__colorMultiplier != null) __currentShader.__colorMultiplier.__useArray = true;
			if (__currentShader.__colorOffset != null) __currentShader.__colorOffset.__useArray = true;
		}
	}

	private function __cleanup():Void
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

	private override function __clear():Void
	{
		if (__stage == null || __stage.__transparent)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}
		else
		{
			context3D.clear(__stage.__colorSplit[0], __stage.__colorSplit[1], __stage.__colorSplit[2], 1, 0, 0, Context3DClearMask.COLOR);
		}

		__cleared = true;
	}

	private function __clearShader():Void
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

	private function __copyShader(other:Context3DRenderer):Void
	{
		__currentShader = other.__currentShader;
		__currentShaderBuffer = other.__currentShaderBuffer;
		__currentDisplayShader = other.__currentDisplayShader;
		__currentGraphicsShader = other.__currentGraphicsShader;

		// __gl.glProgram = other.__gl.glProgram;
	}

	private override function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void
	{
		if (clipRect != null)
		{
			__pushMaskRect(clipRect, source.__renderTransform);
		}

		var context = context3D;

		var cacheRTT = context.__state.renderToTexture;
		var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

		context.setRenderToTexture(bitmapData.getTexture(context), true);

		__render(source);

		if (cacheRTT != null)
		{
			context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			context.setRenderToBackBuffer();
		}

		if (clipRect != null)
		{
			__popMaskRect();
		}
	}

	private function __fillRect(bitmapData:BitmapData, rect:Rectangle, color:Int):Void
	{
		if (bitmapData.__texture != null)
		{
			var context = bitmapData.__texture.__context;

			var color:ARGB = (color : ARGB);
			var useScissor = !bitmapData.rect.equals(rect);

			var cacheRTT = context.__state.renderToTexture;
			var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
			var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
			var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

			context.setRenderToTexture(bitmapData.__texture);

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

	private function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	private function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__tempColorTransform.__copyFrom(__worldColorTransform);
			__tempColorTransform.__combine(value);
			return __tempColorTransform;
		}
		else
		{
			return value;
		}
	}

	private function __getDisplayTransformTempMatrix(transform:Matrix, snapToPixel:Bool):Matrix
	{
		var matrix = __getMatrixHelperMatrix;
		matrix.copyFrom(transform);
		// matrix.concat(__worldTransform);

		if (snapToPixel)
		{
			matrix.tx = Math.round(matrix.tx);
			matrix.ty = Math.round(matrix.ty);
		}

		return matrix;
	}

	private function __getMatrix(transform:Matrix, pixelSnapping:PixelSnapping):Array<Float>
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

	private function __init(context:Context3D, defaultRenderTarget:BitmapData):Void
	{
		context3D = context;
		__context = context.__context;
		__gl = context.__context.webgl;
		gl = __gl;

		// TODO: Clean on re-init instead of making a new instance?
		batcher = new BatchRenderer(this, 4096);

		__defaultRenderTarget = defaultRenderTarget;
		__flipped = (__defaultRenderTarget == null);
	}

	private function __initShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultShader;
	}

	private function __initDisplayShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultDisplayShader;
	}

	private function __initGraphicsShader(shader:Shader):Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?

			if (shader.__context == null)
			{
				shader.__context = context3D;
				shader.__init();
			}

			// currentShader = shader;
			return shader;
		}

		return __defaultGraphicsShader;
	}

	private function __initShaderBuffer(shaderBuffer:ShaderBuffer):Shader
	{
		if (shaderBuffer != null)
		{
			return __initGraphicsShader(shaderBuffer.shader);
		}

		return __defaultGraphicsShader;
	}

	private function __popMask():Void
	{
		if (__stencilReference == 0) return;

		batcher.flush();

		var mask = __maskObjects.pop();

		if (__stencilReference > 1)
		{
			context3D.setStencilActions(FRONT_AND_BACK, EQUAL, DECREMENT_SATURATE, DECREMENT_SATURATE, KEEP);
			context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
			context3D.setColorMask(false, false, false, false);

			__renderMask(mask);

			batcher.flush();

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

	private function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	private function __popMaskRect():Void
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

	private inline function __powerOfTwo(value:Int):Int
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}

	private function __pushMask(mask:DisplayObject):Void
	{
		batcher.flush();

		if (__stencilReference == 0)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
			__updatedStencil = true;
		}

		context3D.setStencilActions(FRONT_AND_BACK, EQUAL, INCREMENT_SATURATE, KEEP, KEEP);
		context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0xFF);
		context3D.setColorMask(false, false, false, false);

		__renderMask(mask);

		batcher.flush();

		__maskObjects.push(mask);
		__stencilReference++;

		context3D.setStencilActions(FRONT_AND_BACK, EQUAL, KEEP, KEEP, KEEP);
		context3D.setStencilReferenceValue(__stencilReference, 0xFF, 0);
		context3D.setColorMask(true, true, true, true);
	}

	private function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	private function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
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

	private override function __render(object:IBitmapDrawable):Void
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
			if (object != null && object.__type != null)
			{
				__renderDisplayObject(cast object);
			}

			// flush whatever is left in the batch to render
			batcher.flush();

			// TODO: Handle this in Context3D as a viewport?

			if (__offsetX > 0 || __offsetY > 0)
			{
				// context3D.__setGLScissorTest (true);

				if (__offsetX > 0)
				{
					// __gl.scissor (0, 0, __offsetX, __height);
					__scissorRectangle.setTo(0, 0, __offsetX, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (__offsetX + __displayWidth, 0, __width, __height);
					__scissorRectangle.setTo(__offsetX + __displayWidth, 0, __width, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				if (__offsetY > 0)
				{
					// __gl.scissor (0, 0, __width, __offsetY);
					__scissorRectangle.setTo(0, 0, __width, __offsetY);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (0, __offsetY + __displayHeight, __width, __height);
					__scissorRectangle.setTo(0, __offsetY + __displayHeight, __width, __height);
					context3D.setScissorRectangle(__scissorRectangle);

					context3D.__flushGL();
					__gl.clearColor(0, 0, 0, 1);
					__gl.clear(__gl.COLOR_BUFFER_BIT);
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

			var cacheMask = object.__mask;
			var cacheScrollRect = object.__scrollRect;
			object.__mask = null;
			object.__scrollRect = null;

			if (object != null)
			{
				if (object.__type != null)
				{
					__renderDisplayObject(cast object);
				}
				else
				{
					__renderBitmapData(cast object);
				}
			}

			// flush whatever is left in the batch to render
			batcher.flush();

			object.__mask = cacheMask;
			object.__scrollRect = cacheScrollRect;
		}

		context3D.present();
	}

	private function __renderBitmap(bitmap:Bitmap):Void
	{
		__updateCacheBitmap(bitmap, false);

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.image != null)
		{
			bitmap.__imageVersion = bitmap.__bitmapData.image.version;
		}

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			Context3DBitmap.render(bitmap.__cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(bitmap, this);
			Context3DBitmap.render(bitmap, this);
		}
	}

	private function __renderBitmapData(bitmapData:BitmapData):Void
	{
		__setBlendMode(NORMAL);

		var shader = __defaultDisplayShader;
		setShader(shader);
		applyBitmapData(bitmapData, __upscaled);
		applyMatrix(__getMatrix(bitmapData.__worldTransform, AUTO));
		applyAlpha(bitmapData.__worldAlpha);
		applyColorTransform(bitmapData.__worldColorTransform);
		updateShader();

		// alpha == 1, __worldColorTransform

		var vertexBuffer = bitmapData.getVertexBuffer(context3D);
		if (shader.__position != null) context3D.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context3D.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = bitmapData.getIndexBuffer(context3D);
		context3D.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		__clearShader();
	}

	private function __renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null && object.__type != null)
		{
			switch (object.__type)
			{
				case BITMAP:
					__renderBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER:
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
				default:
			}

			if (object.__customRenderEvent != null)
			{
				var event = object.__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom(object.__renderTransform);
				event.objectColorTransform.__copyFrom(object.__worldColorTransform);
				event.renderer = this;

				if (!__cleared) __clear();

				setShader(object.__worldShader);
				context3D.__flushGL();

				event.type = RenderEvent.RENDER_OPENGL;

				__setBlendMode(object.__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);

				setViewport();
			}
		}
	}

	private function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		container.__cleanupRemovedChildren();

		if (!container.__renderable || container.__worldAlpha <= 0) return;

		__updateCacheBitmap(container, false);

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender)
		{
			Context3DBitmap.render(container.__cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(container, this);
		}

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender) return;

		if (container.__children.length > 0)
		{
			__pushMaskObject(container);
			// renderer.filterManager.pushObject (this);

			if (__stage != null)
			{
				for (child in container.__children)
				{
					__renderDisplayObject(child);
					child.__renderDirty = false;
				}

				container.__renderDirty = false;
			}
			else
			{
				for (child in container.__children)
				{
					__renderDisplayObject(child);
				}
			}
		}

		if (container.__children.length > 0)
		{
			__popMaskObject(container);
		}
	}

	private function __renderFilterPass(source:BitmapData, shader:Shader, smooth:Bool, clear:Bool = true):Void
	{
		if (source == null || shader == null) return;
		if (__defaultRenderTarget == null) return;

		var cacheRTT = context3D.__state.renderToTexture;
		var cacheRTTDepthStencil = context3D.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context3D.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context3D.__state.renderToTextureSurfaceSelector;

		context3D.setRenderToTexture(__defaultRenderTarget.getTexture(context3D), false);

		if (clear)
		{
			context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}

		var shader = __initShader(shader);
		setShader(shader);
		applyAlpha(1);
		applyBitmapData(source, smooth);
		applyColorTransform(null);
		applyMatrix(__getMatrix(source.__renderTransform, AUTO));
		updateShader();

		var vertexBuffer = source.getVertexBuffer(context3D);
		if (shader.__position != null) context3D.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context3D.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
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

	private function __renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch (mask.__type)
			{
				case BITMAP:
					Context3DBitmap.renderMask(cast mask, this);

				case DISPLAY_OBJECT_CONTAINER:
					var container:DisplayObjectContainer = cast mask;
					container.__cleanupRemovedChildren();

					if (container.__graphics != null)
					{
						Context3DShape.renderMask(container, this);
					}

					for (child in container.__children)
					{
						__renderMask(child);
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					__renderMask(button.__currentState);

				case TEXTFIELD:
					Context3DTextField.renderMask(cast mask, this);
					Context3DShape.renderMask(mask, this);

				case TILEMAP:
					Context3DDisplayObject.renderMask(cast mask, this);
					Context3DTilemap.renderMask(cast mask, this);

				case VIDEO:
					Context3DVideo.renderMask(cast mask, this);

				default:
					if (mask.__graphics != null)
					{
						Context3DShape.renderMask(mask, this);
					}
			}
		}
	}

	private function __renderShape(shape:DisplayObject):Void
	{
		__updateCacheBitmap(shape, false);

		if (shape.__cacheBitmap != null && !shape.__isCacheBitmapRender)
		{
			Context3DBitmap.render(shape.__cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(shape, this);
		}
	}

	private function __renderSimpleButton(button:SimpleButton):Void
	{
		if (!button.__renderable || button.__worldAlpha <= 0 || button.__currentState == null) return;

		__pushMaskObject(button);
		__renderDisplayObject(button.__currentState);
		__popMaskObject(button);
	}

	private function __renderTextField(textField:TextField):Void
	{
		__updateCacheBitmap(textField, textField.__dirty);

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			Context3DBitmap.render(textField.__cacheBitmap, this);
		}
		else
		{
			Context3DTextField.render(textField, this);
			Context3DDisplayObject.render(textField, this);
		}
	}

	private function __renderTilemap(tilemap:Tilemap):Void
	{
		__updateCacheBitmap(tilemap, false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			Context3DBitmap.render(tilemap.__cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(tilemap, this);
			Context3DTilemap.render(tilemap, this);
		}
	}

	private function __renderVideo(video:Video):Void
	{
		Context3DVideo.render(video, this);
	}

	private override function __resize(width:Int, height:Int):Void
	{
		__width = width;
		__height = height;

		var w = (__defaultRenderTarget == null) ? __stage.stageWidth : __defaultRenderTarget.width;
		var h = (__defaultRenderTarget == null) ? __stage.stageHeight : __defaultRenderTarget.height;

		__offsetX = __defaultRenderTarget == null ? Math.round(__worldTransform.__transformX(0, 0)) : 0;
		__offsetY = __defaultRenderTarget == null ? Math.round(__worldTransform.__transformY(0, 0)) : 0;
		__displayWidth = __defaultRenderTarget == null ? Math.round(__worldTransform.__transformX(w, 0) - __offsetX) : w;
		__displayHeight = __defaultRenderTarget == null ? Math.round(__worldTransform.__transformY(0, h) - __offsetY) : h;

		__projection.createOrtho(0, __displayWidth + __offsetX * 2, 0, __displayHeight + __offsetY * 2, -1000, 1000);
		__projectionFlipped.createOrtho(0, __displayWidth + __offsetX * 2, __displayHeight + __offsetY * 2, 0, -1000, 1000);
	}

	private function __resumeClipAndMask(childRenderer:Context3DRenderer):Void
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

	private function __scissorRect(clipRect:Rectangle = null):Void
	{
		batcher.flush();

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

	private function __setBlendMode(value:BlendMode):Void
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
				context3D.__setGLBlendEquation(__gl.FUNC_REVERSE_SUBTRACT);

			#if desktop
			case DARKEN:
				context3D.setBlendFactors(ONE, ONE);
				context3D.__setGLBlendEquation(0x8007); // GL_MIN

			case LIGHTEN:
				context3D.setBlendFactors(ONE, ONE);
				context3D.__setGLBlendEquation(0x8008); // GL_MAX
			#end

			default:
				context3D.setBlendFactors(ONE, ONE_MINUS_SOURCE_ALPHA);
		}
	}

	private function __setRenderTarget(renderTarget:BitmapData):Void
	{
		__defaultRenderTarget = renderTarget;
		__flipped = (renderTarget == null);

		if (renderTarget != null)
		{
			__resize(renderTarget.width, renderTarget.height);
		}
	}

	private function __setShaderBuffer(shaderBuffer:ShaderBuffer):Void
	{
		setShader(shaderBuffer.shader);
		__currentShaderBuffer = shaderBuffer;
	}

	private function __shouldCacheHardware(object:DisplayObject, value:Null<Bool>):Null<Bool>
	{
		if (value == true) return true;

		switch (object.__type)
		{
			case DISPLAY_OBJECT_CONTAINER:
				if (object.__filters != null) return true;

				if (value == false || (object.__graphics != null && !Context3DGraphics.isCompatible(object.__graphics)))
				{
					value = false;
				}

				if (object.__children != null)
				{
					for (child in object.__children)
					{
						value = __shouldCacheHardware(child, value);
						if (value == true) return true;
					}
				}

				return value;

			case TEXTFIELD:
				return value == true ? true : false;

			case TILEMAP:
				return true;

			default:
				if (value == true || object.__filters != null) return true;

				if (value == false || (object.__graphics != null && !Context3DGraphics.isCompatible(object.__graphics)))
				{
					return false;
				}

				return null;
		}
	}

	private inline function __shouldSnapToPixel(bitmap:Bitmap):Bool
	{
		return switch bitmap.pixelSnapping
		{
			case null | NEVER: false;
			case ALWAYS: true;
			case AUTO: Math.abs(bitmap.__renderTransform.a) == 1 && Math.abs(bitmap.__renderTransform.d) == 1; // only snap when not scaled/rotated/skewed
		}
	}

	private function __suspendClipAndMask():Void
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

	private function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		if (object.__isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap)
		{
			if (object.__cacheBitmapMatrix == null)
			{
				object.__cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = #if !openfl_disable_filters object.__filters != null #else false #end;
			var bitmapMatrix = (object.__cacheAsBitmapMatrix != null ? object.__cacheAsBitmapMatrix : object.__renderTransform);

			var colorTransform = ColorTransform.__pool.get();
			colorTransform.__copyFrom(object.__worldColorTransform);
			if (__worldColorTransform != null) colorTransform.__combine(__worldColorTransform);

			var needRender = (object.__cacheBitmap == null
				|| (object.__renderDirty && (force || (object.__children != null && object.__children.length > 0)))
				|| object.opaqueBackground != object.__cacheBitmapBackground)
				|| (object.__graphics != null && object.__graphics.__hardwareDirty);

			var rect = null;

			if (!needRender
				&& (bitmapMatrix.a != object.__cacheBitmapMatrix.a
					|| bitmapMatrix.b != object.__cacheBitmapMatrix.b
					|| bitmapMatrix.c != object.__cacheBitmapMatrix.c
					|| bitmapMatrix.d != object.__cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (filter in object.__filters)
				{
					if (filter.__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !object.__cacheBitmap.__worldTransform.equals(object.__worldTransform));

			object.__cacheBitmapMatrix.copyFrom(bitmapMatrix);
			object.__cacheBitmapMatrix.tx = 0;
			object.__cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = Rectangle.__pool.get();

				object.__getFilterBounds(rect, object.__cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (object.__cacheBitmapDataTexture != null)
				{
					if (filterWidth > object.__cacheBitmapDataTexture.width || filterHeight > object.__cacheBitmapDataTexture.height)
					{
						bitmapWidth = __powerOfTwo(filterWidth);
						bitmapHeight = __powerOfTwo(filterHeight);
						needRender = true;
					}
					else
					{
						bitmapWidth = object.__cacheBitmapDataTexture.width;
						bitmapHeight = object.__cacheBitmapDataTexture.height;
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
				object.__cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;

					if (object.__cacheBitmapDataTexture == null
						|| bitmapWidth > object.__cacheBitmapDataTexture.width
						|| bitmapHeight > object.__cacheBitmapDataTexture.height)
					{
						// TODO: Use pool for HW bitmap data
						var texture = context3D.createRectangleTexture(bitmapWidth, bitmapHeight, BGRA, true);
						object.__cacheBitmapDataTexture = BitmapData.fromTexture(texture);
					}

					object.__cacheBitmapDataTexture.fillRect(rect, 0);

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						object.__cacheBitmapDataTexture.fillRect(rect, fillColor);
					}
				}
				else
				{
					ColorTransform.__pool.release(colorTransform);

					object.__cacheBitmap = null;
					object.__cacheBitmapData = null;
					object.__cacheBitmapDataTexture = null;

					return true;
				}
			}

			if (object.__cacheBitmap == null) object.__cacheBitmap = new Bitmap();
			object.__cacheBitmap.bitmapData = object.__cacheBitmapDataTexture;

			if (updateTransform)
			{
				object.__cacheBitmap.__worldTransform.copyFrom(object.__worldTransform);

				if (bitmapMatrix == object.__renderTransform)
				{
					object.__cacheBitmap.__renderTransform.identity();
					object.__cacheBitmap.__renderTransform.tx = object.__renderTransform.tx + offsetX;
					object.__cacheBitmap.__renderTransform.ty = object.__renderTransform.ty + offsetY;
				}
				else
				{
					object.__cacheBitmap.__renderTransform.copyFrom(object.__cacheBitmapMatrix);
					object.__cacheBitmap.__renderTransform.invert();
					object.__cacheBitmap.__renderTransform.concat(object.__renderTransform);
					object.__cacheBitmap.__renderTransform.tx += offsetX;
					object.__cacheBitmap.__renderTransform.ty += offsetY;
				}
			}

			object.__cacheBitmap.smoothing = __allowSmoothing;
			object.__cacheBitmap.__renderable = object.__renderable;
			object.__cacheBitmap.__worldAlpha = object.__worldAlpha;
			object.__cacheBitmap.__worldBlendMode = object.__worldBlendMode;
			object.__cacheBitmap.__worldShader = object.__worldShader;
			object.__cacheBitmap.mask = object.__mask;

			if (needRender)
			{
				var childRenderer = __childRendererPool.get();
				childRenderer.__init(context3D, object.__cacheBitmapDataTexture);

				childRenderer.__stage = object.stage;

				childRenderer.__allowSmoothing = __allowSmoothing;
				(cast childRenderer : Context3DRenderer).__setBlendMode(NORMAL);
				childRenderer.__worldAlpha = 1 / object.__worldAlpha;

				childRenderer.__worldTransform.copyFrom(object.__renderTransform);
				childRenderer.__worldTransform.invert();
				childRenderer.__worldTransform.concat(object.__cacheBitmapMatrix);
				childRenderer.__worldTransform.tx -= offsetX;
				childRenderer.__worldTransform.ty -= offsetY;

				childRenderer.__worldColorTransform.__copyFrom(colorTransform);
				childRenderer.__worldColorTransform.__invert();

				object.__isCacheBitmapRender = true;

				var cacheRTT = context3D.__state.renderToTexture;
				var cacheRTTDepthStencil = context3D.__state.renderToTextureDepthStencil;
				var cacheRTTAntiAlias = context3D.__state.renderToTextureAntiAlias;
				var cacheRTTSurfaceSelector = context3D.__state.renderToTextureSurfaceSelector;

				var cacheBlendMode = __blendMode;
				__suspendClipAndMask();
				childRenderer.__copyShader(this);

				object.__cacheBitmapDataTexture.__setUVRect(context3D, 0, 0, filterWidth, filterHeight);
				childRenderer.__setRenderTarget(object.__cacheBitmapDataTexture);
				// if (object.__cacheBitmapDataTexture.image != null) object.__cacheBitmapData.__textureVersion = object.__cacheBitmapData.image.version + 1;

				childRenderer.__drawBitmapData(object.__cacheBitmapDataTexture, object, null);

				if (hasFilters)
				{
					var needCopyOfOriginal = false;

					for (filter in object.__filters)
					{
						if (filter.__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var cacheRenderer = BitmapData.__hardwareRenderer;
					BitmapData.__hardwareRenderer = childRenderer;

					var bitmap = context3D.__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap2 = context3D.__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap3 = needCopyOfOriginal ? context3D.__bitmapDataPool.get(filterWidth, filterHeight) : null;

					bitmap.__setUVRect(context3D, 0, 0, filterWidth, filterHeight);
					bitmap2.__setUVRect(context3D, 0, 0, filterWidth, filterHeight);
					if (bitmap3 != null) bitmap3.__setUVRect(context3D, 0, 0, filterWidth, filterHeight);

					childRenderer.__setBlendMode(NORMAL);
					childRenderer.__worldAlpha = 1;
					childRenderer.__worldTransform.identity();
					childRenderer.__worldColorTransform.__identity();

					var shader, cacheBitmap, firstPass = true;

					for (filter in object.__filters)
					{
						if (filter.__preserveObject)
						{
							childRenderer.__setRenderTarget(bitmap3);
							childRenderer.__renderFilterPass(firstPass ? object.__cacheBitmapDataTexture : bitmap, childRenderer.__defaultDisplayShader,
								filter.__smooth);
						}

						for (i in 0...filter.__numShaderPasses)
						{
							shader = filter.__initShader(childRenderer, i, filter.__preserveObject ? bitmap3 : null);
							childRenderer.__setBlendMode(filter.__shaderBlendMode);
							childRenderer.__setRenderTarget(bitmap2);
							childRenderer.__renderFilterPass(firstPass ? object.__cacheBitmapDataTexture : bitmap, shader, filter.__smooth);

							firstPass = false;
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}

						filter.__renderDirty = false;
					}

					if (bitmap != null)
					{
						object.__cacheBitmapDataTexture.fillRect(object.__cacheBitmapDataTexture.rect, 0);
						childRenderer.__setRenderTarget(object.__cacheBitmapDataTexture);
						childRenderer.__renderFilterPass(bitmap, childRenderer.__defaultDisplayShader, true);
						// object.__cacheBitmap.bitmapData = object.__cacheBitmapData;
					}

					context3D.__bitmapDataPool.release(bitmap);
					context3D.__bitmapDataPool.release(bitmap2);
					if (bitmap3 != null) context3D.__bitmapDataPool.release(bitmap3);

					BitmapData.__hardwareRenderer = cacheRenderer;
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

				object.__isCacheBitmapRender = false;
				__childRendererPool.release(childRenderer);
			}

			if (updateTransform)
			{
				Rectangle.__pool.release(rect);
			}

			updated = updateTransform;

			ColorTransform.__pool.release(colorTransform);
		}
		else if (object.__cacheBitmap != null)
		{
			object.__cacheBitmap = null;
			object.__cacheBitmapDataTexture = null;

			updated = true;
		}

		return updated;
	}

	private function __updateShaderBuffer(bufferOffset:Int):Void
	{
		if (__currentShader != null && __currentShaderBuffer != null)
		{
			__currentShader.__updateFromBuffer(__currentShaderBuffer, bufferOffset);
		}
	}
}
#else
typedef Context3DRenderer = Dynamic;
#end
