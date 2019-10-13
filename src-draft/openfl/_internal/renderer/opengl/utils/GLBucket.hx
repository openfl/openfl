package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.utils.Int16Array;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;

@SuppressWarnings("checkstyle:FieldDocComment")
class GLBucket
{
	public var context3D:Context3D;
	public var color:Array<Float>;
	public var alpha:Float;
	public var dirty:Bool;
	public var graphicType:GraphicType;

	public var lastIndex:Int;

	public var fillIndex:Int = -1;

	public var mode:BucketMode;

	public var fills:Array<GLBucketData> = [];
	public var lines:Array<GLBucketData> = [];

	public var bitmap:BitmapData;
	public var texture:GLTexture;
	public var textureMatrix:Matrix;
	public var textureRepeat:Bool = false;
	public var textureSmooth:Bool = true;
	public var textureTL:Point;
	public var textureBR:Point;

	public var overrideMatrix:Matrix;

	public var tileBuffer:GLBuffer;
	public var glTile:Int16Array;
	public var tile:Array<Int>;

	public var uploadTileBuffer = true;

	public function new(context3D:Context3D)
	{
		this.context3D = context3D;

		color = [0, 0, 0];
		lastIndex = 0;
		alpha = 1;
		dirty = true;

		mode = Fill;

		textureMatrix = new Matrix();
		textureTL = new Point();
		textureBR = new Point(1, 1);
	}

	public function getData(type:BucketDataType):GLBucketData
	{
		var data:Array<GLBucketData>;
		switch (type)
		{
			case Fill:
				data = fills;
			case _:
				data = lines;
		}
		var result:GLBucketData = null;
		var remove = false;
		for (d in data)
		{
			if (d.available)
			{
				result = d;
				remove = true;
				break;
			}
		}

		if (result == null)
		{
			result = new GLBucketData(context3D);
		}

		result.available = false;
		result.parent = this;
		result.type = type;

		if (remove) data.remove(result);
		data.push(result);

		switch (type)
		{
			case Fill:
				switch (mode)
				{
					case Fill, PatternFill:
						result.vertexArray.attributes = GraphicsRenderer.fillVertexAttributes;
					case DrawTriangles:
						// we are using static values and we don't want the color attribute to be shared.
						result.vertexArray.attributes = GraphicsRenderer.drawTrianglesVertexAttributes.copy();
						result.vertexArray.attributes[2] = result.vertexArray.attributes[2].copy();
					case _:
				}
			case Line:
				result.vertexArray.attributes = GraphicsRenderer.primitiveVertexAttributes;
		}

		return result;
	}

	public function optimize():Void
	{
		inline function opt(data:Array<GLBucketData>, type:BucketDataType)
		{
			if (data.length > 1)
			{
				var result:Array<GLBucketData> = [];
				var tmp:GLBucketData = null;
				var last:GLBucketData = null;
				var idx:Int = 0;
				var vi:Int = 0;
				var ii:Int = 0;
				var before = data.length;
				for (d in data)
				{
					if (d.available || d.rawVerts || d.rawIndices)
					{
						if (tmp != null)
						{
							result.push(tmp);
							tmp = null;
						}
						result.push(d);
						last = d;
						// trace("destroyed or raw data");
						continue;
					}
					// trace("last null? "+(last == null)+" or same drawmode? "+ (last != null && last.drawMode == d.drawMode) + " " + d.drawMode);
					if (last == null || (last.drawMode == d.drawMode))
					{
						if (tmp == null)
						{
							tmp = d;
						}
						else
						{
							vi = tmp.verts.length;
							ii = tmp.indices.length;
							for (j in 0...d.verts.length)
							{
								tmp.verts[j + vi] = d.verts[j];
							}
							for (j in 0...d.indices.length)
							{
								tmp.indices[j + ii] = d.indices[j] + idx;
							}
						}
						idx = tmp.indices[tmp.indices.length - 1] + 1;
						last = d;
					}
					else
					{
						if (tmp != null)
						{
							result.push(tmp);
							tmp = null;
						}
						result.push(d);
						last = d;
						continue;
					}
				}

				if (result.length == 0 && tmp != null)
				{
					result.push(tmp);
				}

				if (result.length > 0)
				{
					switch (type)
					{
						case Fill:
							this.fills = result;
						case _:
							this.lines = result;
					}
					// data = result;
				}

				// trace("Optimized from: " + before + " to: " + result.length);
			}
		}

		// opt(fills, Fill);
		opt(lines, Line);
	}

	public function reset():Void
	{
		for (fill in fills)
		{
			fill.reset();
		}

		for (line in lines)
		{
			line.reset();
		}

		fillIndex = -1;
		uploadTileBuffer = true;
		graphicType = GraphicType.Polygon;
	}

	public function uploadTile(x:Int, y:Int, w:Int, h:Int):Void
	{
		var gl = @:privateAccess context3D.gl;

		if (tileBuffer == null)
		{
			tileBuffer = gl.createBuffer();
		}

		tile = [
			x, y, 0, 0,
			w, y, 1, 0,
			x, h, 0, 1,
			w, h, 1, 1
		];

		glTile = new Int16Array(tile);

		gl.bindBuffer(gl.ARRAY_BUFFER, tileBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, glTile, gl.STATIC_DRAW);
	}

	public function upload():Void
	{
		if (this.mode != Line)
		{
			for (fill in fills)
			{
				if (!fill.available)
				{
					fill.upload();
				}
			}
		}

		for (line in lines)
		{
			if (!line.available)
			{
				line.upload();
			}
		}

		dirty = false;
	}
}
