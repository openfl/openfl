package openfl._internal.renderer;

import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl.display._internal.Context3DBuffer;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if openfl_cairo
import lime.graphics.cairo.CairoSurface;
import lime.graphics.cairo.Cairo;
#end
#if openfl_gl
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
#end
#if openfl_html5
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Bitmap)
class DisplayObjectRenderData
{
	// TODO: Trim down number of variables?
	public var buffer:GLBuffer;
	public var bufferAlpha:Float;
	public var bufferColorTransform:ColorTransform;
	public var bufferContext:Context3D;
	public var bufferData:Float32Array;
	public var cacheBitmap:Bitmap;
	public var cacheBitmapBackground:Null<Int>;
	public var cacheBitmapColorTransform:ColorTransform;
	public var cacheBitmapData:BitmapData;
	public var cacheBitmapData2:BitmapData;
	public var cacheBitmapData3:BitmapData;
	public var cacheBitmapDataTexture:BitmapData;
	public var cacheBitmapMatrix:Matrix;
	public var cacheBitmapRendererHW:DisplayObjectRenderer;
	public var cacheBitmapRendererSW:DisplayObjectRenderer;
	#if openfl_cairo
	public var cairo:Cairo;
	#end
	#if openfl_html5
	public var canvas:CanvasElement;
	public var context:CanvasRenderingContext2D;
	#end
	#if openfl_gl
	public var framebuffer:GLFramebuffer;
	public var framebufferContext:Context3D;
	#end
	public var indexBuffer:IndexBuffer3D;
	public var indexBufferContext:Context3D;
	public var indexBufferData:UInt16Array;
	public var indexBufferGrid:Rectangle;
	public var isCacheBitmapRender:Bool;
	#if openfl_gl
	public var quadBuffer:Context3DBuffer;
	#end
	#if openfl_gl
	public var stencilBuffer:GLRenderbuffer;
	#end
	#if openfl_html5
	public var style:CSSStyleDeclaration;
	#end
	#if openfl_cairo
	public var surface:CairoSurface;
	#end
	public var texture:TextureBase;
	public var textureContext:Context3D;
	public var textureHeight:Int;
	public var textureTime:Float;
	public var textureVersion:Int;
	public var textureWidth:Int;
	public var triangleIndexBuffer:IndexBuffer3D;
	public var triangleIndexBufferCount:Int;
	public var triangleIndexBufferData:UInt16Array;
	public var uvRect:Rectangle;
	public var vertexBuffer:VertexBuffer3D;
	public var vertexBufferContext:Context3D;
	public var vertexBufferCount:Int;
	public var vertexBufferCountUVT:Int;
	public var vertexBufferData:Float32Array;
	public var vertexBufferDataUVT:Float32Array;
	public var vertexBufferUVT:VertexBuffer3D;
	public var vertexBufferGrid:Rectangle;
	public var vertexBufferHeight:Float;
	public var vertexBufferScaleX:Float;
	public var vertexBufferScaleY:Float;
	public var vertexBufferWidth:Float;

	public function new() {}

	public function dispose():Void
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
