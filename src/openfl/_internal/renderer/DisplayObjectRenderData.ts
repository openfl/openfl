import Context3DBuffer from "../../_internal/renderer/context3D/Context3DBuffer";
import * as internal from "../../_internal/utils/InternalAccess";
import TextureBase from "../../display3D/textures/TextureBase";
import Context3D from "../../display3D/Context3D";
import IndexBuffer3D from "../../display3D/IndexBuffer3D";
import VertexBuffer3D from "../../display3D/VertexBuffer3D";
import Bitmap from "../../display/Bitmap";
import BitmapData from "../../display/BitmapData";
import DisplayObjectRenderer from "../../display/DisplayObjectRenderer";
import ColorTransform from "../../geom/ColorTransform";
import Matrix from "../../geom/Matrix";
import Rectangle from "../../geom/Rectangle";

export default class DisplayObjectRenderData
{
	// TODO: Trim down number of variables?
	public buffer: WebGLBuffer;
	public bufferAlpha: number;
	public bufferColorTransform: ColorTransform;
	public bufferContext: Context3D;
	public bufferData: Float32Array;
	public cacheBitmap: Bitmap;
	public cacheBitmapBackground: null | number;
	public cacheBitmapColorTransform: ColorTransform;
	public cacheBitmapData: BitmapData;
	public cacheBitmapData2: BitmapData;
	public cacheBitmapData3: BitmapData;
	public cacheBitmapDataTexture: BitmapData;
	public cacheBitmapMatrix: Matrix;
	public cacheBitmapRendererHW: DisplayObjectRenderer;
	public cacheBitmapRendererSW: DisplayObjectRenderer;
	public canvas: HTMLCanvasElement;
	public context: CanvasRenderingContext2D;
	public framebuffer: WebGLFramebuffer;
	public framebufferContext: Context3D;
	public indexBuffer: IndexBuffer3D;
	public indexBufferContext: Context3D;
	public indexBufferData: Uint16Array;
	public indexBufferGrid: Rectangle;
	public isCacheBitmapRender: boolean;
	public quadBuffer: Context3DBuffer;
	public stencilBuffer: WebGLRenderbuffer;
	public style: CSSStyleDeclaration;
	public texture: TextureBase;
	public textureContext: Context3D;
	public textureHeight: number;
	public textureTime: number;
	public textureVersion: number;
	public textureWidth: number;
	public triangleIndexBuffer: IndexBuffer3D;
	public triangleIndexBufferCount: number;
	public triangleIndexBufferData: Int16Array;
	public uvRect: Rectangle;
	public vertexBuffer: VertexBuffer3D;
	public vertexBufferContext: Context3D;
	public vertexBufferCount: number;
	public vertexBufferCountUVT: number;
	public vertexBufferData: Float32Array;
	public vertexBufferDataUVT: Float32Array;
	public vertexBufferUVT: VertexBuffer3D;
	public vertexBufferGrid: Rectangle;
	public vertexBufferHeight: number;
	public vertexBufferScaleX: number;
	public vertexBufferScaleY: number;
	public vertexBufferWidth: number;

	public constructor() { }

	public dispose(): void
	{
		if (this.cacheBitmap != null)
		{
			(<internal.DisplayObject><any>this.cacheBitmap).__cleanup();
			this.cacheBitmap = null;
		}

		if (this.cacheBitmapDataTexture != null)
		{
			this.cacheBitmapDataTexture.dispose();
			this.cacheBitmapDataTexture = null;
		}

		if (this.cacheBitmapData != null)
		{
			this.cacheBitmapData.dispose();
			this.cacheBitmapData = null;
		}

		if (this.cacheBitmapData2 != null)
		{
			this.cacheBitmapData2.dispose();
			this.cacheBitmapData2 = null;
		}

		if (this.cacheBitmapData3 != null)
		{
			this.cacheBitmapData3.dispose();
			this.cacheBitmapData3 = null;
		}

		this.vertexBuffer = null;
		this.framebuffer = null;
		this.framebufferContext = null;
		this.texture = null;
		this.textureContext = null;

		this.canvas = null;
		this.context = null;
		this.style = null;
	}
}
