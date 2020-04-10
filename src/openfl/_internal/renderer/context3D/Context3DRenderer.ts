import BatchRenderer from "../../../_internal/renderer/context3D/batcher/BatchRenderer";
import DisplayObjectRendererType from "../../../_internal/renderer/DisplayObjectRendererType";
import DisplayObjectType from "../../../_internal/renderer/DisplayObjectType";
import ShaderBuffer from "../../../_internal/renderer/ShaderBuffer";
import * as internal from "../../../_internal/utils/InternalAccess";
import ObjectPool from "../../../_internal/utils/ObjectPool";
import Bitmap from "../../../display/Bitmap";
import BitmapData from "../../../display/BitmapData";
import BlendMode from "../../../display/BlendMode";
import DisplayObject from "../../../display/DisplayObject";
import DisplayObjectContainer from "../../../display/DisplayObjectContainer";
import DisplayObjectRenderer from "../../../display/DisplayObjectRenderer";
import DisplayObjectShader from "../../../display/DisplayObjectShader";
import Graphics from "../../../display/Graphics";
import GraphicsShader from "../../../display/GraphicsShader";
import IBitmapDrawable from "../../../display/IBitmapDrawable";
import Context3DRendererAPI from "../../../display/OpenGLRenderer";
import PixelSnapping from "../../../display/PixelSnapping";
import Shader from "../../../display/Shader";
import Shape from "../../../display/Shape";
import SimpleButton from "../../../display/SimpleButton";
import Tilemap from "../../../display/Tilemap";
import Context3D from "../../../display3D/Context3D";
import Context3DBlendFactor from "../../../display3D/Context3DBlendFactor";
import Context3DClearMask from "../../../display3D/Context3DClearMask";
import Context3DCompareMode from "../../../display3D/Context3DCompareMode";
import Context3DMipFilter from "../../../display3D/Context3DMipFilter";
import Context3DStencilAction from "../../../display3D/Context3DStencilAction";
import Context3DTextureFilter from "../../../display3D/Context3DTextureFilter";
import Context3DTextureFormat from "../../../display3D/Context3DTextureFormat";
import Context3DTriangleFace from "../../../display3D/Context3DTriangleFace";
import Context3DVertexBufferFormat from "../../../display3D/Context3DVertexBufferFormat";
import Context3DWrapMode from "../../../display3D/Context3DWrapMode";
import RenderEvent from "../../../events/RenderEvent";
import ColorTransform from "../../../geom/ColorTransform";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
import Video from "../../../media/Video";
import TextField from "../../../text/TextField";
// import openfl._internal.backend.lime_standalone.ARGB;
import Matrix3D from "../../../geom/Matrix3D";
import CanvasRenderer from "../../../_internal/renderer/canvas/CanvasRenderer";
import ARGB from "../../graphics/ARGB";
import Context3DAlphaMaskShader from "./Context3DAlphaMaskShader";
import Context3DBitmap from "./Context3DBitmap";
import Context3DBitmapData from "./Context3DBitmapData";
import Context3DDisplayObject from "./Context3DDisplayObject";
import Context3DGraphics from "./Context3DGraphics";
import Context3DMaskShader from "./Context3DMaskShader";
import Context3DShape from "./Context3DShape";
import Context3DTextField from "./Context3DTextField";
import Context3DTilemap from "./Context3DTilemap";
import Context3DVideo from "./Context3DVideo";

// #if gl_stats
// import openfl._internal.renderer.context3D.stats.Context3DStats;
// import openfl._internal.renderer.context3D.stats.DrawCallContext;
// #end

export default class Context3DRenderer extends Context3DRendererAPI
{
	public static __alphaValue: Array<number> = [1];
	public static __childRendererPool: ObjectPool<Context3DRenderer>;
	public static __colorMultipliersValue: Array<number> = [0, 0, 0, 0];
	public static __colorOffsetsValue: Array<number> = [0, 0, 0, 0];
	public static __defaultColorMultipliersValue: Array<number> = [1, 1, 1, 1];
	public static __emptyColorValue: Array<number> = [0, 0, 0, 0];
	public static __emptyAlphaValue: Array<number> = [1];
	public static __hasColorTransformValue: Array<boolean> = [false];
	public static __scissorRectangle: Rectangle = new Rectangle();
	public static __textureSizeValue: Array<number> = [0, 0];

	public batcher: BatchRenderer = null;
	public context3D: Context3D;

	public __alphaMaskShader: Context3DAlphaMaskShader;
	public __clipRects: Array<Rectangle>;
	public __currentDisplayShader: Shader;
	public __currentGraphicsShader: Shader;
	public __currentRenderTarget: BitmapData;
	public __currentShader: Shader;
	public __currentShaderBuffer: ShaderBuffer;
	public __defaultDisplayShader: DisplayObjectShader;
	public __defaultGraphicsShader: GraphicsShader;
	public __defaultRenderTarget: BitmapData;
	public __defaultShader: Shader;
	public __displayHeight: number;
	public __displayWidth: number;
	public __flipped: boolean;
	public __getMatrixHelperMatrix: Matrix = new Matrix();
	public __gl: WebGLRenderingContext;
	public __height: number;
	public __maskShader: Context3DMaskShader;
	public __matrix: Matrix3D;
	public __maskObjects: Array<DisplayObject>;
	public __numClipRects: number;
	public __offsetX: number;
	public __offsetY: number;
	public __projection: Matrix3D;
	public __projectionFlipped: Matrix3D;
	public __scrollRectMasks: ObjectPool<Shape>;
	public __softwareRenderer: DisplayObjectRenderer;
	public __stencilReference: number;
	public __tempColorTransform: ColorTransform;
	public __tempRect: Rectangle;
	public __updatedStencil: boolean;
	public __upscaled: boolean;
	public __values: Array<number>;
	public __width: number;

	public constructor(context: Context3D, defaultRenderTarget: BitmapData = null)
	{
		super(context);

		this.__init(context, defaultRenderTarget);

		if ((<internal.Graphics><any>Graphics).maxTextureWidth == null)
		{
			(<internal.Graphics><any>Graphics).maxTextureWidth = (<internal.Graphics><any>Graphics).maxTextureHeight = this.__gl.getParameter(this.__gl.MAX_TEXTURE_SIZE);
		}

		this.__matrix = new Matrix3D();

		this.__values = new Array();

		// 	#if gl_debug
		// var ext: KHR_debug = __gl.getExtension("KHR_debug");
		// if (ext != null)
		// {
		// 	__gl.enable(ext.DEBUG_OUTPUT);
		// 	__gl.enable(ext.DEBUG_OUTPUT_SYNCHRONOUS);
		// }
		// 	#end

		this.__softwareRenderer = new CanvasRenderer(null);

		this.__type = DisplayObjectRendererType.CONTEXT3D;

		this.__setBlendMode(BlendMode.NORMAL);
		(<internal.Context3D><any>this.context3D).__setGLBlend(true);

		this.__clipRects = new Array();
		this.__maskObjects = new Array();
		this.__numClipRects = 0;
		this.__projection = new Matrix3D();
		this.__projectionFlipped = new Matrix3D();
		this.__stencilReference = 0;
		this.__tempRect = new Rectangle();

		this.__defaultDisplayShader = new DisplayObjectShader();
		this.__defaultGraphicsShader = new GraphicsShader();
		this.__defaultShader = this.__defaultDisplayShader;

		this.__initShader(this.__defaultShader);

		this.__scrollRectMasks = new ObjectPool<Shape>(() => new Shape());
		this.__alphaMaskShader = new Context3DAlphaMaskShader();
		this.__maskShader = new Context3DMaskShader();

		if (Context3DRenderer.__childRendererPool == null)
		{
			Context3DRenderer.__childRendererPool = new ObjectPool<Context3DRenderer>(function ()
			{
				var renderer = new Context3DRenderer(this.context3D, null);
				renderer.__worldTransform = new Matrix();
				renderer.__worldColorTransform = new ColorTransform();
				return renderer;
			});
		}
	}

	public applyAlpha(alpha: number): void
	{
		Context3DRenderer.__alphaValue[0] = alpha;

		if (this.__currentShaderBuffer != null)
		{
			this.__currentShaderBuffer.addFloatOverride("openfl_Alpha", Context3DRenderer.__alphaValue);
		}
		else if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__alpha != null) (<internal.Shader><any>this.__currentShader).__alpha.value = Context3DRenderer.__alphaValue;
		}
	}

	publicapplyBitmapData(bitmapData: BitmapData, smooth: boolean, repeat: boolean = false): void
	{
		if (this.__currentShaderBuffer != null)
		{
			if (bitmapData != null)
			{
				Context3DRenderer.__textureSizeValue[0] = (<internal.BitmapData><any>bitmapData).__renderData.textureWidth;
				Context3DRenderer.__textureSizeValue[1] = (<internal.BitmapData><any>bitmapData).__renderData.textureHeight;

				this.__currentShaderBuffer.addFloatOverride("openfl_TextureSize", Context3DRenderer.__textureSizeValue);
			}
		}
		else if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__bitmap != null)
			{
				(<internal.Shader><any>this.__currentShader).__bitmap.input = bitmapData;
				(<internal.Shader><any>this.__currentShader).__bitmap.filter = (smooth && this.__allowSmoothing) ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST;
				(<internal.Shader><any>this.__currentShader).__bitmap.mipFilter = Context3DMipFilter.MIPNONE;
				(<internal.Shader><any>this.__currentShader).__bitmap.wrap = repeat ? Context3DWrapMode.REPEAT : Context3DWrapMode.CLAMP;
			}

			if ((<internal.Shader><any>this.__currentShader).__texture != null)
			{
				(<internal.Shader><any>this.__currentShader).__texture.input = bitmapData;
				(<internal.Shader><any>this.__currentShader).__texture.filter = (smooth && this.__allowSmoothing) ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST;
				(<internal.Shader><any>this.__currentShader).__texture.mipFilter = Context3DMipFilter.MIPNONE;
				(<internal.Shader><any>this.__currentShader).__texture.wrap = repeat ? Context3DWrapMode.REPEAT : Context3DWrapMode.CLAMP;
			}

			if ((<internal.Shader><any>this.__currentShader).__textureSize != null)
			{
				if (bitmapData != null)
				{
					Context3DRenderer.__textureSizeValue[0] = (<internal.BitmapData><any>bitmapData).__renderData.textureWidth;
					Context3DRenderer.__textureSizeValue[1] = (<internal.BitmapData><any>bitmapData).__renderData.textureHeight;

					(<internal.Shader><any>this.__currentShader).__textureSize.value = Context3DRenderer.__textureSizeValue;
				}
				else
				{
					(<internal.Shader><any>this.__currentShader).__textureSize.value = null;
				}
			}
		}
	}

	public applyColorTransform(colorTransform: ColorTransform): void
	{
		var enabled = (colorTransform != null && !(<internal.ColorTransform><any>colorTransform).__isDefault(true));
		this.applyHasColorTransform(enabled);

		if (enabled)
		{
			(<internal.ColorTransform><any>colorTransform).__setArrays(Context3DRenderer.__colorMultipliersValue, Context3DRenderer.__colorOffsetsValue);

			if (this.__currentShaderBuffer != null)
			{
				this.__currentShaderBuffer.addFloatOverride("openfl_ColorMultiplier", Context3DRenderer.__colorMultipliersValue);
				this.__currentShaderBuffer.addFloatOverride("openfl_ColorOffset", Context3DRenderer.__colorOffsetsValue);
			}
			else if (this.__currentShader != null)
			{
				if ((<internal.Shader><any>this.__currentShader).__colorMultiplier != null) (<internal.Shader><any>this.__currentShader).__colorMultiplier.value = Context3DRenderer.__colorMultipliersValue;
				if ((<internal.Shader><any>this.__currentShader).__colorOffset != null) (<internal.Shader><any>this.__currentShader).__colorOffset.value = Context3DRenderer.__colorOffsetsValue;
			}
		}
		else
		{
			if (this.__currentShaderBuffer != null)
			{
				this.__currentShaderBuffer.addFloatOverride("openfl_ColorMultiplier", Context3DRenderer.__emptyColorValue);
				this.__currentShaderBuffer.addFloatOverride("openfl_ColorOffset", Context3DRenderer.__emptyColorValue);
			}
			else if (this.__currentShader != null)
			{
				if ((<internal.Shader><any>this.__currentShader).__colorMultiplier != null) (<internal.Shader><any>this.__currentShader).__colorMultiplier.value = Context3DRenderer.__emptyColorValue;
				if ((<internal.Shader><any>this.__currentShader).__colorOffset != null) (<internal.Shader><any>this.__currentShader).__colorOffset.value = Context3DRenderer.__emptyColorValue;
			}
		}
	}

	public applyHasColorTransform(enabled: boolean): void
	{
		Context3DRenderer.__hasColorTransformValue[0] = enabled;

		if (this.__currentShaderBuffer != null)
		{
			this.__currentShaderBuffer.addBoolOverride("openfl_HasColorTransform", Context3DRenderer.__hasColorTransformValue);
		}
		else if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__hasColorTransform != null) (<internal.Shader><any>this.__currentShader).__hasColorTransform.value = Context3DRenderer.__hasColorTransformValue;
		}
	}

	public applyMatrix(matrix: Array<number>): void
	{
		if (this.__currentShaderBuffer != null)
		{
			this.__currentShaderBuffer.addFloatOverride("openfl_Matrix", matrix);
		}
		else if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__matrix != null) (<internal.Shader><any>this.__currentShader).__matrix.value = matrix;
		}
	}

	public getMatrix(transform: Matrix): Matrix3D
	{
		if (this.__gl != null)
		{
			var values = this.__getMatrix(transform, PixelSnapping.AUTO);

			for (let i = 0; i < 16; i++)
			{
				this.__matrix.rawData[i] = values[i];
			}

			return this.__matrix;
		}
		else
		{
			this.__matrix.identity();
			this.__matrix.rawData[0] = transform.a;
			this.__matrix.rawData[1] = transform.b;
			this.__matrix.rawData[4] = transform.c;
			this.__matrix.rawData[5] = transform.d;
			this.__matrix.rawData[12] = transform.tx;
			this.__matrix.rawData[13] = transform.ty;
			return this.__matrix;
		}
	}

	public setShader(shader: Shader): void
	{
		this.__currentShaderBuffer = null;

		if (this.__currentShader == shader) return;

		if (this.__currentShader != null)
		{
			// TODO : numberegrate cleanup with Context3D
			// __currentShader.__disable ();
		}

		if (shader == null)
		{
			this.__currentShader = null;
			this.context3D.setProgram(null);
			// context3D.__flushGLProgram ();
			return;
		}
		else
		{
			this.__currentShader = shader;
			this.__initShader(shader);
			this.context3D.setProgram(shader.program);
			(<internal.Context3D><any>this.context3D).__flushGLProgram();
			// context3D.__flushGLTextures ();
			(<internal.Shader><any>this.__currentShader).__enable();
			(<internal.Context3D><any>this.context3D).__state.shader = shader;
		}
	}

	public setViewport(): void
	{
		this.__gl.viewport(this.__offsetX, this.__offsetY, this.__displayWidth, this.__displayHeight);
	}

	public updateShader(): void
	{
		if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__position != null) (<internal.Shader><any>this.__currentShader).__position.__useArray = true;
			if ((<internal.Shader><any>this.__currentShader).__textureCoord != null) (<internal.Shader><any>this.__currentShader).__textureCoord.__useArray = true;
			this.context3D.setProgram(this.__currentShader.program);
			(<internal.Context3D><any>this.context3D).__flushGLProgram();
			(<internal.Context3D><any>this.context3D).__flushGLTextures();
			(<internal.Shader><any>this.__currentShader).__update();
		}
	}

	public useAlphaArray(): void
	{
		if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__alpha != null) (<internal.Shader><any>this.__currentShader).__alpha.__useArray = true;
		}
	}

	public useColorTransformArray(): void
	{
		if (this.__currentShader != null)
		{
			if ((<internal.Shader><any>this.__currentShader).__colorMultiplier != null) (<internal.Shader><any>this.__currentShader).__colorMultiplier.__useArray = true;
			if ((<internal.Shader><any>this.__currentShader).__colorOffset != null) (<internal.Shader><any>this.__currentShader).__colorOffset.__useArray = true;
		}
	}

	public __cleanup(): void
	{
		if (this.__stencilReference > 0)
		{
			this.__stencilReference = 0;
			this.context3D.setStencilActions();
			this.context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (this.__numClipRects > 0)
		{
			this.__numClipRects = 0;
			this.__scissorRect();
		}
	}

	private__clear(): void
	{
		if (this.__stage == null || (<internal.Stage><any>this.__stage).__transparent)
		{
			this.context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}
		else
		{
			this.context3D.clear((<internal.Stage><any>this.__stage).__colorSplit[0], (<internal.Stage><any>this.__stage).__colorSplit[1], (<internal.Stage><any>this.__stage).__colorSplit[2], 1, 0, 0, Context3DClearMask.COLOR);
		}

		this.__cleared = true;
	}

	public __clearShader(): void
	{
		if (this.__currentShader != null)
		{
			if (this.__currentShaderBuffer == null)
			{
				if ((<internal.Shader><any>this.__currentShader).__bitmap != null) (<internal.Shader><any>this.__currentShader).__bitmap.input = null;
			}
			else
			{
				this.__currentShaderBuffer.clearOverride();
			}

			if ((<internal.Shader><any>this.__currentShader).__texture != null) (<internal.Shader><any>this.__currentShader).__texture.input = null;
			if ((<internal.Shader><any>this.__currentShader).__textureSize != null) (<internal.Shader><any>this.__currentShader).__textureSize.value = null;
			if ((<internal.Shader><any>this.__currentShader).__hasColorTransform != null) (<internal.Shader><any>this.__currentShader).__hasColorTransform.value = null;
			if ((<internal.Shader><any>this.__currentShader).__position != null) (<internal.Shader><any>this.__currentShader).__position.value = null;
			if ((<internal.Shader><any>this.__currentShader).__matrix != null) (<internal.Shader><any>this.__currentShader).__matrix.value = null;
			(<internal.Shader><any>this.__currentShader).__clearUseArray();
		}
	}

	public __copyShader(other: Context3DRenderer): void
	{
		this.__currentShader = other.__currentShader;
		this.__currentShaderBuffer = other.__currentShaderBuffer;
		this.__currentDisplayShader = other.__currentDisplayShader;
		this.__currentGraphicsShader = other.__currentGraphicsShader;

		// __gl.glProgram = other.__gl.glProgram;
	}

	private__drawBitmapData(bitmapData: BitmapData, source: IBitmapDrawable, clipRect: Rectangle): void
	{
		var clipMatrix = null;

		if (clipRect != null)
		{
			clipMatrix = (<internal.Matrix><any>Matrix).__pool.get();
			clipMatrix.copyFrom(this.__worldTransform);
			clipMatrix.invert();
			this.__pushMaskRect(clipRect, clipMatrix);
		}

		var context = this.context3D;

		var cacheRTT = (<internal.Context3D><any>context).__state.renderToTexture;
		var cacheRTTDepthStencil = (<internal.Context3D><any>context).__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = (<internal.Context3D><any>context).__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = (<internal.Context3D><any>context).__state.renderToTextureSurfaceSelector;

		var prevRenderTarget = this.__defaultRenderTarget;
		context.setRenderToTexture(bitmapData.getTexture(context), true);
		this.__setRenderTarget(bitmapData);

		this.__render(source);

		if (cacheRTT != null)
		{
			context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			context.setRenderToBackBuffer();
		}

		this.__setRenderTarget(prevRenderTarget);

		if (clipRect != null)
		{
			this.__popMaskRect();
			(<internal.Matrix><any>Matrix).__pool.release(clipMatrix);
		}
	}

	public __fillRect(bitmapData: BitmapData, rect: Rectangle, color: number): void
	{
		if ((<internal.BitmapData><any>bitmapData).__renderData.texture != null)
		{
			var context = (<internal.TextureBase><any>(<internal.BitmapData><any>bitmapData).__renderData.texture).__context;

			var color = new ARGB(color);
			var useScissor = !bitmapData.rect.equals(rect);

			var cacheRTT = (<internal.Context3D><any>context).__state.renderToTexture;
			var cacheRTTDepthStencil = (<internal.Context3D><any>context).__state.renderToTextureDepthStencil;
			var cacheRTTAntiAlias = (<internal.Context3D><any>context).__state.renderToTextureAntiAlias;
			var cacheRTTSurfaceSelector = (<internal.Context3D><any>context).__state.renderToTextureSurfaceSelector;

			context.setRenderToTexture((<internal.BitmapData><any>bitmapData).__renderData.texture);

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

	public __getAlpha(value: number): number
	{
		return value * this.__worldAlpha;
	}

	public __getColorTransform(value: ColorTransform): ColorTransform
	{
		if (this.__worldColorTransform != null)
		{
			(<internal.ColorTransform><any>this.__tempColorTransform).__copyFrom(this.__worldColorTransform);
			(<internal.ColorTransform><any>this.__tempColorTransform).__combine(value);
			return this.__tempColorTransform;
		}
		else
		{
			return value;
		}
	}

	public __getDisplayTransformTempMatrix(transform: Matrix, pixelSnapping: PixelSnapping): Matrix
	{
		var matrix = this.__getMatrixHelperMatrix;
		matrix.copyFrom(transform);
		// matrix.concat(__worldTransform);

		if (pixelSnapping == PixelSnapping.ALWAYS
			|| (pixelSnapping == PixelSnapping.AUTO
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

	public __getMatrix(transform: Matrix, pixelSnapping: PixelSnapping): Array<number>
	{
		var _matrix = (<internal.Matrix><any>Matrix).__pool.get();
		_matrix.copyFrom(transform);
		_matrix.concat(this.__worldTransform);

		if (pixelSnapping == PixelSnapping.ALWAYS
			|| (pixelSnapping == PixelSnapping.AUTO
				&& _matrix.b == 0
				&& _matrix.c == 0
				&& (_matrix.a < 1.001 && _matrix.a > 0.999)
				&& (_matrix.d < 1.001 && _matrix.d > 0.999)))
		{
			_matrix.tx = Math.round(_matrix.tx);
			_matrix.ty = Math.round(_matrix.ty);
		}

		this.__matrix.identity();
		this.__matrix.rawData[0] = _matrix.a;
		this.__matrix.rawData[1] = _matrix.b;
		this.__matrix.rawData[4] = _matrix.c;
		this.__matrix.rawData[5] = _matrix.d;
		this.__matrix.rawData[12] = _matrix.tx;
		this.__matrix.rawData[13] = _matrix.ty;
		this.__matrix.append(this.__flipped ? this.__projectionFlipped : this.__projection);

		for (let i = 0; i < 16; i++)
		{
			this.__values[i] = this.__matrix.rawData[i];
		}

		(<internal.Matrix><any>Matrix).__pool.release(_matrix);

		return this.__values;
	}

	public __init(context: Context3D, defaultRenderTarget: BitmapData): void
	{
		this.context3D = context;
		this.__gl = (<internal.Context3D><any>context).__gl;
		this.gl = this.__gl;

		// #if!disable_batcher
		if (this.batcher == null)
		{
			this.batcher = new BatchRenderer(this, 4096);
		}
		else
		{
			this.batcher.flush();
		}
		// #end

		this.__defaultRenderTarget = defaultRenderTarget;
		this.__flipped = (this.__defaultRenderTarget == null);
	}

	public __initShader(shader: Shader): Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if ((<internal.Shader><any>shader).__context == null)
			{
				(<internal.Shader><any>shader).__init(this.context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return this.__defaultShader;
	}

	public __initDisplayShader(shader: Shader): Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if ((<internal.Shader><any>shader).__context == null)
			{
				(<internal.Shader><any>shader).__init(this.context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return this.__defaultDisplayShader;
	}

	public __initGraphicsShader(shader: Shader): Shader
	{
		if (shader != null)
		{
			// TODO: Change of GL context?
			if ((<internal.Shader><any>shader).__context == null)
			{
				(<internal.Shader><any>shader).__init(this.context3D);
			}

			// currentShader = shader;
			return shader;
		}

		return this.__defaultGraphicsShader;
	}

	public __initShaderBuffer(shaderBuffer: ShaderBuffer): Shader
	{
		if (shaderBuffer != null)
		{
			return this.__initGraphicsShader(shaderBuffer.shader);
		}

		return this.__defaultGraphicsShader;
	}

	public __popMask(): void
	{
		if (this.__stencilReference == 0) return;

		// #if!disable_batcher
		this.batcher.flush();
		// #end

		var mask = this.__maskObjects.pop();

		if (this.__stencilReference > 1)
		{
			this.context3D.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.DECREMENT_SATURATE, Context3DStencilAction.DECREMENT_SATURATE, Context3DStencilAction.KEEP);
			this.context3D.setStencilReferenceValue(this.__stencilReference, 0xFF, 0xFF);
			this.context3D.setColorMask(false, false, false, false);

			this.__renderMask(mask);

			// #if!disable_batcher
			this.batcher.flush();
			// #end

			this.__stencilReference--;

			this.context3D.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP);
			this.context3D.setStencilReferenceValue(this.__stencilReference, 0xFF, 0);
			this.context3D.setColorMask(true, true, true, true);
		}
		else
		{
			this.__stencilReference = 0;
			this.context3D.setStencilActions();
			this.context3D.setStencilReferenceValue(0, 0, 0);
		}
	}

	public __popMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if ((<internal.DisplayObject><any>object).__mask != null)
		{
			this.__popMask();
		}

		if (handleScrollRect && (<internal.DisplayObject><any>object).__scrollRect != null)
		{
			if ((<internal.DisplayObject><any>object).__renderTransform.b != 0 || (<internal.DisplayObject><any>object).__renderTransform.c != 0)
			{
				this.__scrollRectMasks.release(this.__maskObjects[this.__maskObjects.length - 1] as Shape);
				this.__popMask();
			}
			else
			{
				this.__popMaskRect();
			}
		}
	}

	public __popMaskRect(): void
	{
		if (this.__numClipRects > 0)
		{
			this.__numClipRects--;
			if (this.__numClipRects > 0)
			{
				this.__scissorRect(this.__clipRects[this.__numClipRects - 1]);
			}
			else
			{
				this.__scissorRect();
			}
		}
	}

	public __powerOfTwo(value: number): number
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}

	public __pushMask(mask: DisplayObject): void
	{
		// #if!disable_batcher
		this.batcher.flush();
		// #end

		if (this.__stencilReference == 0)
		{
			this.context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
			this.__updatedStencil = true;
		}

		this.context3D.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP);
		this.context3D.setStencilReferenceValue(this.__stencilReference, 0xFF, 0xFF);
		this.context3D.setColorMask(false, false, false, false);

		this.__renderMask(mask);

		// #if!disable_batcher
		this.batcher.flush();
		// #end

		this.__maskObjects.push(mask);
		this.__stencilReference++;

		this.context3D.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP);
		this.context3D.setStencilReferenceValue(this.__stencilReference, 0xFF, 0);
		this.context3D.setColorMask(true, true, true, true);
	}

	public __pushMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if (handleScrollRect && (<internal.DisplayObject><any>object).__scrollRect != null)
		{
			if ((<internal.DisplayObject><any>object).__renderTransform.b != 0 || (<internal.DisplayObject><any>object).__renderTransform.c != 0)
			{
				var shape = this.__scrollRectMasks.get();
				shape.graphics.clear();
				shape.graphics.beginFill(0x00FF00);
				shape.graphics.drawRect((<internal.DisplayObject><any>object).__scrollRect.x, (<internal.DisplayObject><any>object).__scrollRect.y, (<internal.DisplayObject><any>object).__scrollRect.width, (<internal.DisplayObject><any>object).__scrollRect.height);
				(<internal.DisplayObject><any>shape).__renderTransform.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				this.__pushMask(shape);
			}
			else
			{
				this.__pushMaskRect((<internal.DisplayObject><any>object).__scrollRect, (<internal.DisplayObject><any>object).__renderTransform);
			}
		}

		if ((<internal.DisplayObject><any>object).__mask != null)
		{
			this.__pushMask((<internal.DisplayObject><any>object).__mask);
		}
	}

	public __pushMaskRect(rect: Rectangle, transform: Matrix): void
	{
		// TODO: Handle rotation?

		if (this.__numClipRects == this.__clipRects.length)
		{
			this.__clipRects[this.__numClipRects] = new Rectangle();
		}

		var _matrix = (<internal.Matrix><any>Matrix).__pool.get();
		_matrix.copyFrom(transform);
		_matrix.concat(this.__worldTransform);

		var clipRect = this.__clipRects[this.__numClipRects];
		(<internal.Rectangle><any>rect).__transform(clipRect, _matrix);

		if (this.__numClipRects > 0)
		{
			var parentClipRect = this.__clipRects[this.__numClipRects - 1];
			(<internal.Rectangle><any>clipRect).__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
		}

		if (clipRect.height < 0)
		{
			clipRect.height = 0;
		}

		if (clipRect.width < 0)
		{
			clipRect.width = 0;
		}

		(<internal.Matrix><any>Matrix).__pool.release(_matrix);

		this.__scissorRect(clipRect);
		this.__numClipRects++;
	}

	private__render(object: IBitmapDrawable): void
	{
		this.context3D.setColorMask(true, true, true, true);
		this.context3D.setCulling(Context3DTriangleFace.NONE);
		this.context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		this.context3D.setStencilActions();
		this.context3D.setStencilReferenceValue(0, 0, 0);
		this.context3D.setScissorRectangle(null);

		this.__blendMode = null;
		this.__setBlendMode(BlendMode.NORMAL);

		if (this.__defaultRenderTarget == null)
		{
			Context3DRenderer.__scissorRectangle.setTo(this.__offsetX, this.__offsetY, this.__displayWidth, this.__displayHeight);
			this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);

			this.__upscaled = (this.__worldTransform.a != 1 || this.__worldTransform.d != 1);

			// TODO: BitmapData render
			if (object != null && (<internal.DisplayObject><any>object).__type != null)
			{
				this.__renderDisplayObject(object as DisplayObject);
			}

			// #if!disable_batcher
			// flush whatever is left in the batch to render
			this.batcher.flush();
			// #end

			// TODO: Handle this in Context3D as a viewport?

			if (this.__offsetX > 0 || this.__offsetY > 0)
			{
				// context3D.__setGLScissorTest (true);

				if (this.__offsetX > 0)
				{
					// __gl.scissor (0, 0, __offsetX, __height);
					Context3DRenderer.__scissorRectangle.setTo(0, 0, this.__offsetX, this.__height);
					this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);

					(<internal.Context3D><any>this.context3D).__flushGL();
					this.__gl.clearColor(0, 0, 0, 1);
					this.__gl.clear(this.__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (__offsetX + __displayWidth, 0, __width, __height);
					Context3DRenderer.__scissorRectangle.setTo(this.__offsetX + this.__displayWidth, 0, this.__width, this.__height);
					this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);

					(<internal.Context3D><any>this.context3D).__flushGL();
					this.__gl.clearColor(0, 0, 0, 1);
					this.__gl.clear(this.__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				if (this.__offsetY > 0)
				{
					// __gl.scissor (0, 0, __width, __offsetY);
					Context3DRenderer.__scissorRectangle.setTo(0, 0, this.__width, this.__offsetY);
					this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);

					(<internal.Context3D><any>this.context3D).__flushGL();
					this.__gl.clearColor(0, 0, 0, 1);
					this.__gl.clear(this.__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);

					// __gl.scissor (0, __offsetY + __displayHeight, __width, __height);
					Context3DRenderer.__scissorRectangle.setTo(0, this.__offsetY + this.__displayHeight, this.__width, this.__height);
					this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);

					(<internal.Context3D><any>this.context3D).__flushGL();
					this.__gl.clearColor(0, 0, 0, 1);
					this.__gl.clear(this.__gl.COLOR_BUFFER_BIT);
					// context3D.clear (0, 0, 0, 1, 0, 0, Context3DClearMask.COLOR);
				}

				this.context3D.setScissorRectangle(null);
			}
		}
		else
		{
			Context3DRenderer.__scissorRectangle.setTo(this.__offsetX, this.__offsetY, this.__displayWidth, this.__displayHeight);
			this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);
			// __gl.viewport (__offsetX, __offsetY, __displayWidth, __displayHeight);

			// __upscaled = (__worldTransform.a != 1 || __worldTransform.d != 1);

			// TODO: Cleaner approach?

			var cacheMask = (<internal.DisplayObject><any>object).__mask;
			var cacheScrollRect = (<internal.DisplayObject><any>object).__scrollRect;
			(<internal.DisplayObject><any>object).__mask = null;
			(<internal.DisplayObject><any>object).__scrollRect = null;

			if (object != null)
			{
				if ((<internal.DisplayObject><any>object).__type != null)
				{
					this.__renderDisplayObject(object as DisplayObject);
				}
				else
				{
					this.__renderBitmapData(object as BitmapData);
				}
			}

			// #if!disable_batcher
			// flush whatever is left in the batch to render
			this.batcher.flush();
			// #end

			(<internal.DisplayObject><any>object).__mask = cacheMask;
			(<internal.DisplayObject><any>object).__scrollRect = cacheScrollRect;

			this.context3D.setScissorRectangle(null);
		}

		this.context3D.present();
	}

	public __renderBitmap(bitmap: Bitmap): void
	{
		this.__updateCacheBitmap(bitmap, false);

		if ((<internal.Bitmap><any>bitmap).__bitmapData != null && (<internal.Bitmap><any>bitmap).__bitmapData.readable)
		{
			(<internal.Bitmap><any>bitmap).__imageVersion = (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getVersion();
		}

		if ((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>bitmap).__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(bitmap, this);
			Context3DBitmap.render(bitmap, this);
		}
	}

	public __renderBitmapData(bitmapData: BitmapData): void
	{
		this.__setBlendMode(BlendMode.NORMAL);

		var shader = this.__defaultDisplayShader;
		this.setShader(shader);
		this.applyBitmapData(bitmapData, this.__upscaled);
		this.applyMatrix(this.__getMatrix((<internal.IBitmapDrawable><any>bitmapData).__worldTransform, PixelSnapping.AUTO));
		this.applyAlpha(this.__getAlpha((<internal.IBitmapDrawable><any>bitmapData).__worldAlpha));
		this.applyColorTransform((<internal.IBitmapDrawable><any>bitmapData).__worldColorTransform);
		this.updateShader();

		// alpha == 1, __worldColorTransform

		var vertexBuffer = bitmapData.getVertexBuffer(this.context3D);
		if ((<internal.Shader><any>shader).__position != null) this.context3D.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		if ((<internal.Shader><any>shader).__textureCoord != null) this.context3D.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		var indexBuffer = bitmapData.getIndexBuffer(this.context3D);
		this.context3D.drawTriangles(indexBuffer);

		// #if gl_stats
		// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		// #end

		this.__clearShader();
	}

	public __renderDisplayObject(object: DisplayObject): void
	{
		if (object != null && (<internal.DisplayObject><any>object).__type != null)
		{
			switch ((<internal.DisplayObject><any>object).__type)
			{
				case DisplayObjectType.BITMAP:
					this.__renderBitmap(object as Bitmap);
					break;
				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					this.__renderDisplayObjectContainer(object as DisplayObjectContainer);
					break;
				case DisplayObjectType.DISPLAY_OBJECT:
				case DisplayObjectType.SHAPE:
					this.__renderShape(object);
					break;
				case DisplayObjectType.SIMPLE_BUTTON:
					this.__renderSimpleButton(object as SimpleButton);
					break;
				case DisplayObjectType.TEXTFIELD:
					this.__renderTextField(object as TextField);
					break;
				case DisplayObjectType.TILEMAP:
					this.__renderTilemap(object as Tilemap);
					break;
				case DisplayObjectType.VIDEO:
					this.__renderVideo(object as Video);
					break;
				// #if draft
				// case GL_GRAPHICS:
				// 	openfl.display.HWGraphics.render(cast object, this);
				// case GEOMETRY:
				// 	openfl._internal.renderer.context3D.Context3DGeometry.render(cast object, this);
				// #end
				default:
			}

			if ((<internal.DisplayObject><any>object).__customRenderEvent != null)
			{
				var event = (<internal.DisplayObject><any>object).__customRenderEvent;
				event.allowSmoothing = this.__allowSmoothing;
				event.objectMatrix.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				(<internal.ColorTransform><any>event.objectColorTransform).__copyFrom((<internal.DisplayObject><any>object).__worldColorTransform);
				(<internal.RenderEvent><any>event).__renderer = this;

				if (!this.__cleared) this.__clear();

				this.setShader((<internal.DisplayObject><any>object).__worldShader);
				(<internal.Context3D><any>this.context3D).__flushGL();

				(<internal.Event><any>event).__type = RenderEvent.RENDER_OPENGL;

				this.__setBlendMode((<internal.DisplayObject><any>object).__worldBlendMode);
				this.__pushMaskObject(object);

				object.dispatchEvent(event);

				this.__popMaskObject(object);

				this.setViewport();
			}
		}
	}

	public __renderDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		(<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

		if (!(<internal.DisplayObject><any>container).__renderable || (<internal.DisplayObject><any>container).__worldAlpha <= 0) return;

		this.__updateCacheBitmap(container, false);

		if ((<internal.DisplayObject><any>container).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>container).__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2((<internal.DisplayObject><any>container).__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(container, this);
		}

		if ((<internal.DisplayObject><any>container).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>container).__renderData.isCacheBitmapRender) return;

		if (container.numChildren > 0)
		{
			this.__pushMaskObject(container);
			// renderer.filterManager.pushObject (this);

			var child = (<internal.DisplayObject><any>container).__firstChild;
			if (this.__stage != null)
			{
				while (child != null)
				{
					this.__renderDisplayObject(child);
					(<internal.DisplayObject><any>child).__renderDirty = false;
					child = (<internal.DisplayObject><any>child).__nextSibling;
				}

				(<internal.DisplayObject><any>container).__renderDirty = false;
			}
			else
			{
				while (child != null)
				{
					this.__renderDisplayObject(child);
					child = (<internal.DisplayObject><any>child).__nextSibling;
				}
			}
		}

		if (container.numChildren > 0)
		{
			this.__popMaskObject(container);
		}
	}

	public __renderFilterPass(source: BitmapData, shader: Shader, smooth: boolean, clear: boolean = true): void
	{
		if (source == null || shader == null) return;
		if (this.__defaultRenderTarget == null) return;

		var cacheRTT = (<internal.Context3D><any>this.context3D).__state.renderToTexture;
		var cacheRTTDepthStencil = (<internal.Context3D><any>this.context3D).__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = (<internal.Context3D><any>this.context3D).__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = (<internal.Context3D><any>this.context3D).__state.renderToTextureSurfaceSelector;

		this.context3D.setRenderToTexture(this.__defaultRenderTarget.getTexture(this.context3D), false);

		if (clear)
		{
			this.context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.COLOR);
		}

		var shader = this.__initShader(shader);
		this.setShader(shader);
		this.applyAlpha(this.__getAlpha(1));
		this.applyBitmapData(source, smooth);
		this.applyColorTransform(null);
		this.applyMatrix(this.__getMatrix((<internal.DisplayObject><any>source).__renderTransform, PixelSnapping.AUTO));
		this.updateShader();

		var vertexBuffer = source.getVertexBuffer(this.context3D);
		if ((<internal.Shader><any>shader).__position != null) this.context3D.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		if ((<internal.Shader><any>shader).__textureCoord != null) this.context3D.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		var indexBuffer = source.getIndexBuffer(this.context3D);
		this.context3D.drawTriangles(indexBuffer);

		// #if gl_stats
		// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		// #end

		if (cacheRTT != null)
		{
			this.context3D.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			this.context3D.setRenderToBackBuffer();
		}

		this.__clearShader();
	}

	public __renderMask(mask: DisplayObject): void
	{
		if (mask != null)
		{
			switch ((<internal.DisplayObject><any>mask).__type)
			{
				case DisplayObjectType.BITMAP:
					Context3DBitmap.renderMask(mask as Bitmap, this);
					break;

				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					var container: DisplayObjectContainer = mask as DisplayObjectContainer;
					(<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

					if ((<internal.DisplayObject><any>container).__graphics != null)
					{
						Context3DShape.renderMask(container, this);
					}

					var child = (<internal.DisplayObject><any>container).__firstChild;
					while (child != null)
					{
						this.__renderMask(child);
						child = (<internal.DisplayObject><any>child).__nextSibling;
					}
					break;

				case DisplayObjectType.DOM_ELEMENT:
					break;

				case DisplayObjectType.SIMPLE_BUTTON:
					var button: SimpleButton = mask as SimpleButton;
					this.__renderMask((<internal.SimpleButton><any>button).__currentState);
					break;

				case DisplayObjectType.TEXTFIELD:
					Context3DTextField.renderMask(mask as TextField, this);
					Context3DShape.renderMask(mask, this);
					break;

				case DisplayObjectType.TILEMAP:
					Context3DDisplayObject.renderMask(mask as Tilemap, this);
					Context3DTilemap.renderMask(mask as Tilemap, this);
					break;

				case DisplayObjectType.VIDEO:
					Context3DVideo.renderMask(mask as Video, this);
					break;

				default:
					if ((<internal.DisplayObject><any>mask).__graphics != null)
					{
						Context3DShape.renderMask(mask, this);
					}
			}
		}
	}

	public __renderShape(shape: DisplayObject): void
	{
		this.__updateCacheBitmap(shape, false);

		if ((<internal.DisplayObject><any>shape).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>shape).__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2((<internal.DisplayObject><any>shape).__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(shape, this);
		}
	}

	public __renderSimpleButton(button: SimpleButton): void
	{
		if (!(<internal.DisplayObject><any>button).__renderable || (<internal.DisplayObject><any>button).__worldAlpha <= 0 || (<internal.SimpleButton><any>button).__currentState == null) return;

		this.__pushMaskObject(button);
		this.__renderDisplayObject((<internal.SimpleButton><any>button).__currentState);
		this.__popMaskObject(button);
	}

	public __renderTextField(textField: TextField): void
	{
		this.__updateCacheBitmap(textField, (<internal.TextField><any>textField).__dirty);

		if ((<internal.DisplayObject><any>textField).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>textField).__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2((<internal.DisplayObject><any>textField).__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DTextField.render(textField, this);
			Context3DDisplayObject.render(textField, this);
		}
	}

	public __renderTilemap(tilemap: Tilemap): void
	{
		this.__updateCacheBitmap(tilemap, false);

		if ((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>tilemap).__renderData.isCacheBitmapRender)
		{
			Context3DBitmap.render2((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap, this);
		}
		else
		{
			Context3DDisplayObject.render(tilemap, this);
			Context3DTilemap.render(tilemap, this);
		}
	}

	public __renderVideo(video: Video): void
	{
		Context3DVideo.render(video, this);
	}

	private__resize(width: number, height: number): void
	{
		this.__width = width;
		this.__height = height;

		var w = (this.__defaultRenderTarget == null) ? this.__stage.stageWidth : (<internal.BitmapData><any>this.__defaultRenderTarget).__renderData.textureWidth;
		var h = (this.__defaultRenderTarget == null) ? this.__stage.stageHeight : (<internal.BitmapData><any>this.__defaultRenderTarget).__renderData.textureHeight;

		this.__offsetX = this.__defaultRenderTarget == null ? Math.round((<internal.Matrix><any>this.__worldTransform).__transformX(0, 0)) : 0;
		this.__offsetY = this.__defaultRenderTarget == null ? Math.round((<internal.Matrix><any>this.__worldTransform).__transformY(0, 0)) : 0;
		this.__displayWidth = this.__defaultRenderTarget == null ? Math.round((<internal.Matrix><any>this.__worldTransform).__transformX(w, 0) - this.__offsetX) : w;
		this.__displayHeight = this.__defaultRenderTarget == null ? Math.round((<internal.Matrix><any>this.__worldTransform).__transformY(0, h) - this.__offsetY) : h;

		this.__projection = Matrix3D.createOrtho(0, this.__displayWidth + this.__offsetX * 2, 0, this.__displayHeight + this.__offsetY * 2, -1000, 1000);
		this.__projectionFlipped = Matrix3D.createOrtho(0, this.__displayWidth + this.__offsetX * 2, this.__displayHeight + this.__offsetY * 2, 0, -1000, 1000);
	}

	public __resumeClipAndMask(childRenderer: Context3DRenderer): void
	{
		if (this.__stencilReference > 0)
		{
			this.context3D.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP);
			this.context3D.setStencilReferenceValue(this.__stencilReference, 0xFF, 0);
		}
		else
		{
			this.context3D.setStencilActions();
			this.context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (this.__numClipRects > 0)
		{
			this.__scissorRect(this.__clipRects[this.__numClipRects - 1]);
		}
		else
		{
			this.__scissorRect();
		}
	}

	public __scissorRect(clipRect: Rectangle = null): void
	{
		// #if!disable_batcher
		this.batcher.flush();
		// #end

		if (clipRect != null)
		{
			var x = Math.floor(clipRect.x);
			var y = Math.floor(clipRect.y);
			var width = (clipRect.width > 0 ? Math.ceil(clipRect.right) - x : 0);
			var height = (clipRect.height > 0 ? Math.ceil(clipRect.bottom) - y : 0);

			if (width < 0) width = 0;
			if (height < 0) height = 0;

			// __scissorRectangle.setTo (x, __flipped ? __height - y - height : y, width, height);
			Context3DRenderer.__scissorRectangle.setTo(x, y, width, height);
			this.context3D.setScissorRectangle(Context3DRenderer.__scissorRectangle);
		}
		else
		{
			this.context3D.setScissorRectangle(null);
		}
	}

	public __setBlendMode(value: BlendMode): void
	{
		if (this.__overrideBlendMode != null) value = this.__overrideBlendMode;
		if (this.__blendMode == value) return;

		this.__blendMode = value;

		switch (value)
		{
			case BlendMode.ADD:
				this.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				break;

			case BlendMode.MULTIPLY:
				this.context3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				break;

			case BlendMode.SCREEN:
				this.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
				break;

			case BlendMode.SUBTRACT:
				this.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				(<internal.Context3D><any>this.context3D).__setGLBlendEquation(this.__gl.FUNC_REVERSE_SUBTRACT);
				break;

			// #if desktop
			// case DARKEN:
			// 	context3D.setBlendFactors(ONE, ONE);
			// 	context3D.__backend.setGLBlendEquation(0x8007); // GL_MIN

			// case LIGHTEN:
			// 	context3D.setBlendFactors(ONE, ONE);
			// 	context3D.__backend.setGLBlendEquation(0x8008); // GL_MAX
			// #end

			default:
				this.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				break;
		}
	}

	public __setRenderTarget(renderTarget: BitmapData): void
	{
		this.__defaultRenderTarget = renderTarget;
		this.__flipped = (renderTarget == null);

		if (renderTarget != null)
		{
			this.__resize(renderTarget.width, renderTarget.height);
		}
	}

	public __setShaderBuffer(shaderBuffer: ShaderBuffer): void
	{
		this.setShader(shaderBuffer.shader);
		this.__currentShaderBuffer = shaderBuffer;
	}

	public __shouldCacheHardware(object: DisplayObject, value: null | boolean): null | boolean
	{
		if (value === true) return true;

		switch ((<internal.DisplayObject><any>object).__type)
		{
			case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
			case DisplayObjectType.MOVIE_CLIP:
				if ((<internal.DisplayObject><any>object).__filters != null) return true;

				if (value === false || ((<internal.DisplayObject><any>object).__graphics != null && !Context3DGraphics.isCompatible((<internal.DisplayObject><any>object).__graphics)))
				{
					value = false;
				}

				var child = (<internal.DisplayObject><any>object).__firstChild;
				while (child != null)
				{
					value = this.__shouldCacheHardware(child, value);
					if (value === true) return true;
					child = (<internal.DisplayObject><any>child).__nextSibling;
				}

				return value;

			case DisplayObjectType.TEXTFIELD:
				return value === true ? true : false;

			case DisplayObjectType.TILEMAP:
				return true;

			default:
				if (value === true || (<internal.DisplayObject><any>object).__filters != null) return true;

				if (value === false || ((<internal.DisplayObject><any>object).__graphics != null && !Context3DGraphics.isCompatible((<internal.DisplayObject><any>object).__graphics)))
				{
					return false;
				}

				return null;
		}
	}

	public __shouldSnapToPixel(bitmap: Bitmap): boolean
	{
		switch (bitmap.pixelSnapping)
		{
			case null:
			case PixelSnapping.NEVER:
				return false;
			case PixelSnapping.ALWAYS:
				return true;
			case PixelSnapping.AUTO:
				return Math.abs((<internal.DisplayObject><any>bitmap).__renderTransform.a) == 1 && Math.abs((<internal.DisplayObject><any>bitmap).__renderTransform.d) == 1; // only snap when not scaled/rotated/skewed
		}
	}

	public __suspendClipAndMask(): void
	{
		if (this.__stencilReference > 0)
		{
			this.context3D.setStencilActions();
			this.context3D.setStencilReferenceValue(0, 0, 0);
		}

		if (this.__numClipRects > 0)
		{
			this.__scissorRect();
		}
	}

	public __updateCacheBitmap(object: DisplayObject, force: boolean): boolean
	{
		// #if openfl_disable_cacheasbitmap
		// return false;
		// #end

		if ((<internal.DisplayObject><any>object).__renderData.isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap)
		{
			if ((<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix == null)
			{
				(<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = (<internal.DisplayObject><any>object).__filters != null;
			var bitmapMatrix = ((<internal.DisplayObject><any>object).__cacheAsBitmapMatrix != null ? (<internal.DisplayObject><any>object).__cacheAsBitmapMatrix : (<internal.DisplayObject><any>object).__renderTransform);

			var colorTransform = (<internal.ColorTransform><any>ColorTransform).__pool.get();
			(<internal.ColorTransform><any>colorTransform).__copyFrom((<internal.DisplayObject><any>object).__worldColorTransform);
			if (this.__worldColorTransform != null) (<internal.ColorTransform><any>colorTransform).__combine(this.__worldColorTransform);

			var needRender = ((<internal.DisplayObject><any>object).__renderData.cacheBitmap == null
				|| ((<internal.DisplayObject><any>object).__renderDirty && (force || (<internal.DisplayObject><any>object).__firstChild != null))
				|| object.opaqueBackground != (<internal.DisplayObject><any>object).__renderData.cacheBitmapBackground)
				|| ((<internal.DisplayObject><any>object).__graphics != null && (<internal.Graphics><any>(<internal.DisplayObject><any>object).__graphics).__hardwareDirty);

			var rect = null;

			if (!needRender
				&& (bitmapMatrix.a != (<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.a
					|| bitmapMatrix.b != (<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.b
					|| bitmapMatrix.c != (<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.c
					|| bitmapMatrix.d != (<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (let filter of (<internal.DisplayObject><any>object).__filters)
				{
					if ((<internal.BitmapFilter><any>filter).__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__worldTransform.equals((<internal.DisplayObject><any>object).__worldTransform));

			(<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.copyFrom(bitmapMatrix);
			(<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.tx = 0;
			(<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = (<internal.Rectangle><any>Rectangle).__pool.get();

				(<internal.DisplayObject><any>object).__getFilterBounds(rect, (<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if ((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture != null)
				{
					if (filterWidth > (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.width
						|| filterHeight > (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.height)
					{
						bitmapWidth = this.__powerOfTwo(filterWidth);
						bitmapHeight = this.__powerOfTwo(filterHeight);
						needRender = true;
					}
					else
					{
						bitmapWidth = (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.width;
						bitmapHeight = (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.height;
					}
				}
				else
				{
					bitmapWidth = this.__powerOfTwo(filterWidth);
					bitmapHeight = this.__powerOfTwo(filterHeight);
				}
			}

			if (needRender)
			{
				updateTransform = true;
				(<internal.DisplayObject><any>object).__renderData.cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;

					if ((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture == null
						|| bitmapWidth > (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.width
						|| bitmapHeight > (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.height)
					{
						// TODO: Use pool for HW bitmap data
						var texture = this.context3D.createRectangleTexture(bitmapWidth, bitmapHeight, Context3DTextureFormat.BGRA, true);
						(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture = BitmapData.fromTexture(texture);
					}

					(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.fillRect(rect, 0);

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.fillRect(rect, fillColor);
					}
				}
				else
				{
					(<internal.ColorTransform><any>ColorTransform).__pool.release(colorTransform);

					(<internal.DisplayObject><any>object).__renderData.cacheBitmap = null;
					(<internal.DisplayObject><any>object).__renderData.cacheBitmapData = null;
					(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture = null;

					return true;
				}
			}

			if ((<internal.DisplayObject><any>object).__renderData.cacheBitmap == null) (<internal.DisplayObject><any>object).__renderData.cacheBitmap = new Bitmap();
			(<internal.DisplayObject><any>object).__renderData.cacheBitmap.bitmapData = (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture;

			if (updateTransform)
			{
				(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__worldTransform.copyFrom((<internal.DisplayObject><any>object).__worldTransform);

				if (bitmapMatrix == (<internal.DisplayObject><any>object).__renderTransform)
				{
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.identity();
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.tx = (<internal.DisplayObject><any>object).__renderTransform.tx + offsetX;
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.ty = (<internal.DisplayObject><any>object).__renderTransform.ty + offsetY;
				}
				else
				{
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.copyFrom((<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix);
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.invert();
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.concat((<internal.DisplayObject><any>object).__renderTransform);
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.tx += offsetX;
					(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderTransform.ty += offsetY;
				}
			}

			(<internal.DisplayObject><any>object).__renderData.cacheBitmap.smoothing = this.__allowSmoothing;
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__renderable = (<internal.DisplayObject><any>object).__renderable;
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__worldAlpha = (<internal.DisplayObject><any>object).__worldAlpha;
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__worldBlendMode = (<internal.DisplayObject><any>object).__worldBlendMode;
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>object).__renderData.cacheBitmap).__worldShader = (<internal.DisplayObject><any>object).__worldShader;
			(<internal.DisplayObject><any>object).__renderData.cacheBitmap.mask = (<internal.DisplayObject><any>object).__mask;

			if (needRender)
			{
				var childRenderer = Context3DRenderer.__childRendererPool.get();
				childRenderer.__init(this.context3D, (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture);

				childRenderer.__stage = object.stage;

				childRenderer.__allowSmoothing = this.__allowSmoothing;
				(childRenderer as Context3DRenderer).__setBlendMode(BlendMode.NORMAL);
				childRenderer.__worldAlpha = 1 / (<internal.DisplayObject><any>object).__worldAlpha;

				childRenderer.__worldTransform.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				childRenderer.__worldTransform.invert();
				childRenderer.__worldTransform.concat((<internal.DisplayObject><any>object).__renderData.cacheBitmapMatrix);
				childRenderer.__worldTransform.tx -= offsetX;
				childRenderer.__worldTransform.ty -= offsetY;

				(<internal.ColorTransform><any>childRenderer.__worldColorTransform).__copyFrom(colorTransform);
				(<internal.ColorTransform><any>childRenderer.__worldColorTransform).__invert();

				(<internal.DisplayObject><any>object).__renderData.isCacheBitmapRender = true;

				var cacheRTT = (<internal.Context3D><any>this.context3D).__state.renderToTexture;
				var cacheRTTDepthStencil = (<internal.Context3D><any>this.context3D).__state.renderToTextureDepthStencil;
				var cacheRTTAntiAlias = (<internal.Context3D><any>this.context3D).__state.renderToTextureAntiAlias;
				var cacheRTTSurfaceSelector = (<internal.Context3D><any>this.context3D).__state.renderToTextureSurfaceSelector;

				var cacheBlendMode = this.__blendMode;
				this.__suspendClipAndMask();
				childRenderer.__copyShader(this);

				Context3DBitmapData.setUVRect((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture, this.context3D, 0, 0, filterWidth, filterHeight);
				childRenderer.__setRenderTarget((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture);
				// if ((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.image != null) (<internal.DisplayObject><any>object).__renderData.cacheBitmapData.__renderData.textureVersion = (<internal.DisplayObject><any>object).__renderData.cacheBitmapData.__getVersion() + 1;

				childRenderer.__drawBitmapData((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture, object, null);

				if (hasFilters)
				{
					var needCopyOfOriginal = false;

					for (let filter of (<internal.DisplayObject><any>object).__filters)
					{
						if ((<internal.BitmapFilter><any>filter).__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var cacheRenderer = (<internal.BitmapData><any>BitmapData).__hardwareRenderer;
					(<internal.BitmapData><any>BitmapData).__hardwareRenderer = childRenderer;

					var bitmap = (<internal.Context3D><any>this.context3D).__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap2 = (<internal.Context3D><any>this.context3D).__bitmapDataPool.get(filterWidth, filterHeight);
					var bitmap3 = needCopyOfOriginal ? (<internal.Context3D><any>this.context3D).__bitmapDataPool.get(filterWidth, filterHeight) : null;

					Context3DBitmapData.setUVRect(bitmap, this.context3D, 0, 0, filterWidth, filterHeight);
					Context3DBitmapData.setUVRect(bitmap2, this.context3D, 0, 0, filterWidth, filterHeight);
					if (bitmap3 != null) Context3DBitmapData.setUVRect(bitmap3, this.context3D, 0, 0, filterWidth, filterHeight);

					childRenderer.__setBlendMode(BlendMode.NORMAL);
					childRenderer.__worldAlpha = 1;
					childRenderer.__worldTransform.identity();
					(<internal.ColorTransform><any>childRenderer.__worldColorTransform).__identity();

					var shader, cacheBitmap, firstPass = true;

					for (let filter of (<internal.DisplayObject><any>object).__filters)
					{
						if ((<internal.BitmapFilter><any>filter).__preserveObject)
						{
							childRenderer.__setRenderTarget(bitmap3);
							childRenderer.__renderFilterPass(firstPass ? (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture : bitmap,
								childRenderer.__defaultDisplayShader, (<internal.BitmapFilter><any>filter).__smooth);
						}

						for (let i = 0; i < (<internal.BitmapFilter><any>filter).__numShaderPasses; i++)
						{
							shader = (<internal.BitmapFilter><any>filter).__initShader(childRenderer, i, (<internal.BitmapFilter><any>filter).__preserveObject ? bitmap3 : null);
							childRenderer.__setBlendMode((<internal.BitmapFilter><any>filter).__shaderBlendMode);
							childRenderer.__setRenderTarget(bitmap2);
							childRenderer.__renderFilterPass(firstPass ? (<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture : bitmap, shader, (<internal.BitmapFilter><any>filter).__smooth);

							firstPass = false;
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}

						(<internal.BitmapFilter><any>filter).__renderDirty = false;
					}

					if (bitmap != null)
					{
						(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.fillRect((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture.rect, 0);
						childRenderer.__setRenderTarget((<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture);
						childRenderer.__renderFilterPass(bitmap, childRenderer.__defaultDisplayShader, true);
						// (<internal.DisplayObject><any>object).__renderData.cacheBitmap.bitmapData = (<internal.DisplayObject><any>object).__renderData.cacheBitmapData;
					}

					(<internal.Context3D><any>this.context3D).__bitmapDataPool.release(bitmap);
					(<internal.Context3D><any>this.context3D).__bitmapDataPool.release(bitmap2);
					if (bitmap3 != null) (<internal.Context3D><any>this.context3D).__bitmapDataPool.release(bitmap3);

					(<internal.BitmapData><any>BitmapData).__hardwareRenderer = cacheRenderer;
				}

				this.__blendMode = BlendMode.NORMAL;
				this.__setBlendMode(cacheBlendMode);
				this.__copyShader(childRenderer);

				if (cacheRTT != null)
				{
					this.context3D.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
				}
				else
				{
					this.context3D.setRenderToBackBuffer();
				}

				this.__resumeClipAndMask(childRenderer);
				this.setViewport();

				(<internal.DisplayObject><any>object).__renderData.isCacheBitmapRender = false;
				Context3DRenderer.__childRendererPool.release(childRenderer);
			}

			if (updateTransform)
			{
				(<internal.Rectangle><any>Rectangle).__pool.release(rect);
			}

			updated = updateTransform;

			(<internal.ColorTransform><any>ColorTransform).__pool.release(colorTransform);
		}
		else if ((<internal.DisplayObject><any>object).__renderData.cacheBitmap != null)
		{
			(<internal.DisplayObject><any>object).__renderData.cacheBitmap = null;
			(<internal.DisplayObject><any>object).__renderData.cacheBitmapDataTexture = null;

			updated = true;
		}

		return updated;
	}

	public __updateShaderBuffer(bufferOffset: number): void
	{
		if (this.__currentShader != null && this.__currentShaderBuffer != null)
		{
			this.__currentShader.__updateFromBuffer(this.__currentShaderBuffer, bufferOffset);
		}
	}
}
