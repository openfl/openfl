namespace openfl._internal.renderer;

import openfl._internal.bindings.cairo.CairoSurface;
import openfl._internal.bindings.cairo.Cairo;
import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GLFramebuffer;
import openfl._internal.bindings.gl.GLRenderbuffer;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl._internal.bindings.typedarray.UInt16Array;
import openfl._internal.renderer.context3D.Context3DBuffer;
import openfl.display3D.textures.TextureBase;
import Context3D from "openfl/display3D/Context3D";
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import ColorTransfrom from "openfl/geom/ColorTransform";
import Matrix from "openfl/geom/Matrix";
import Rectangle from "openfl/geom/Rectangle";
#if openfl_html5
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
#end

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl.display.Bitmap)
class DisplayObjectRenderData
{
	// TODO: Trim down number of variables?
	public buffer: GLBuffer;
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
	#if openfl_cairo
	public cairo: Cairo;
	#end
	#if openfl_html5
	public canvas: CanvasElement;
	public context: CanvasRenderingContext2D;
	#end
	#if openfl_gl
	public framebuffer: GLFramebuffer;
	public framebufferContext: Context3D;
	#end
	public indexBuffer: IndexBuffer3D;
	public indexBufferContext: Context3D;
	public indexBufferData: number16Array;
	public indexBufferGrid: Rectangle;
	public isCacheBitmapRender: boolean;
	#if openfl_gl
	public quadBuffer: Context3DBuffer;
	#end
	#if openfl_gl
	public stencilBuffer: GLRenderbuffer;
	#end
	#if openfl_html5
	public style: CSSStyleDeclaration;
	#end
	#if openfl_cairo
	public surface: CairoSurface;
	#end
	public texture: TextureBase;
	public textureContext: Context3D;
	public textureHeight: number;
	public textureTime: number;
	public textureVersion: number;
	public textureWidth: number;
	public triangleIndexBuffer: IndexBuffer3D;
	public triangleIndexBufferCount: number;
	public triangleIndexBufferData: number16Array;
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

	public new() { }

	public dispose(): void
	{
		if (cacheBitmap != null)
		{
			cacheBitmap.__cleanup();
			cacheBitmap = null;
		}

		if (cacheBitmapDataTexture != null)
		{
			cacheBitmapDataTexture.dispose();
			cacheBitmapDataTexture = null;
		}

		if (cacheBitmapData != null)
		{
			cacheBitmapData.dispose();
			cacheBitmapData = null;
		}

		if (cacheBitmapData2 != null)
		{
			cacheBitmapData2.dispose();
			cacheBitmapData2 = null;
		}

		if (cacheBitmapData3 != null)
		{
			cacheBitmapData3.dispose();
			cacheBitmapData3 = null;
		}

		#if openfl_cairo
		cairo = null;
		surface = null;
		#end

		#if openfl_gl
		vertexBuffer = null;
		framebuffer = null;
		framebufferContext = null;
		texture = null;
		textureContext = null;
		#end

		#if openfl_html5
		canvas = null;
		context = null;
		style = null;
		#end
	}
}
