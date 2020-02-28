package openfl._internal.renderer.context3D;

import openfl.geom.ColorTransform;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl.display3D.VertexBuffer3D;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Matrix)
class Context3DVertexBufferData
{
	public inline static var MAX_LENGTH:Int = 64000;

	public var length:Int;
	public var data:Float32Array;
	public var position:Int;

	public function new()
	{
		length = 0;
		data = new Float32Array(MAX_LENGTH);
		position = 0;
	}

	public function reset():Void
	{
		length = 0;
		position = 0;
	}

	public function upload(vertexBuffer:VertexBuffer3D):Void
	{
		vertexBuffer.uploadFromTypedArray(data, length * 4);
		reset();
	}

	public function writeColorTransform(colorTransform:ColorTransform):Bool
	{
		if (position + 8 > MAX_LENGTH)
		{
			return false;
		}

		data[position] = colorTransform.redMultiplier;
		data[position + 1] = colorTransform.greenMultiplier;
		data[position + 2] = colorTransform.blueMultiplier;
		data[position + 3] = colorTransform.alphaMultiplier;
		data[position + 4] = colorTransform.redOffset;
		data[position + 5] = colorTransform.greenOffset;
		data[position + 6] = colorTransform.blueOffset;
		data[position + 7] = colorTransform.alphaOffset;

		position += 8;
		length += 8;

		return true;
	}

	public function writeFloat(value:Float):Bool
	{
		if (position + 1 > MAX_LENGTH)
		{
			return false;
		}

		data[position] = value;

		position += 1;
		length += 1;

		return true;
	}

	public function writeQuad(rect:Rectangle, uvRect:Rectangle = null, transform:Matrix = null):Bool
	{
		var VERTEX_BUFFER_STRIDE = 4;

		if (position + (VERTEX_BUFFER_STRIDE * 4) > MAX_LENGTH)
		{
			return false;
		}

		var uvX, uvY, uvWidth, uvHeight;

		if (uvRect != null)
		{
			uvX = uvRect.x;
			uvY = uvRect.y;
			uvWidth = uvRect.width;
			uvHeight = uvRect.height;
		}
		else
		{
			uvX = 0;
			uvY = 0;
			uvWidth = 1;
			uvHeight = 1;
		}

		var x, y, x2, y2, x3, y3, x4, y4;

		if (transform == null)
		{
			x = rect.x;
			y = rect.y;
			x2 = rect.right;
			y2 = y;
			x3 = x;
			y3 = rect.bottom;
			x4 = rect.right;
			y4 = rect.bottom;
		}
		else
		{
			x = transform.__transformX(rect.x, rect.y);
			y = transform.__transformY(rect.x, rect.y);
			x2 = transform.__transformX(rect.right, rect.y);
			y2 = transform.__transformY(rect.right, rect.y);
			x3 = transform.__transformX(rect.x, rect.bottom);
			y3 = transform.__transformY(rect.x, rect.bottom);
			x4 = transform.__transformX(rect.right, rect.bottom);
			y4 = transform.__transformY(rect.right, rect.bottom);
		}

		data[position + 0] = x;
		data[position + 1] = y;
		data[position + 2] = uvX;
		data[position + 3] = uvY;

		data[position + VERTEX_BUFFER_STRIDE] = x2;
		data[position + VERTEX_BUFFER_STRIDE + 1] = y2;
		data[position + VERTEX_BUFFER_STRIDE + 2] = uvWidth;
		data[position + VERTEX_BUFFER_STRIDE + 3] = uvY;

		data[position + VERTEX_BUFFER_STRIDE * 2] = x3;
		data[position + VERTEX_BUFFER_STRIDE * 2 + 1] = y3;
		data[position + VERTEX_BUFFER_STRIDE * 2 + 2] = uvX;
		data[position + VERTEX_BUFFER_STRIDE * 2 + 3] = uvHeight;

		data[position + VERTEX_BUFFER_STRIDE * 3] = x4;
		data[position + VERTEX_BUFFER_STRIDE * 3 + 1] = y4;
		data[position + VERTEX_BUFFER_STRIDE * 3 + 2] = uvWidth;
		data[position + VERTEX_BUFFER_STRIDE * 3 + 3] = uvHeight;

		position += VERTEX_BUFFER_STRIDE * 4;
		length += VERTEX_BUFFER_STRIDE * 4;

		return true;
	}
}
