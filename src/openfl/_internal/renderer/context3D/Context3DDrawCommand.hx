package openfl._internal.renderer.context3D;

import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Context3DDrawCommand
{
	public var blendMode:BlendMode;
	public var bitmapData:BitmapData;
	public var indexBuffer:IndexBuffer3D;
	public var indexBufferPosition:Int;
	public var numTriangles:Int;
	public var repeat:Bool;
	public var shader:Shader;
	public var smoothing:Bool;
	public var vertexAttributeBuffer:VertexBuffer3D;
	public var vertexAttributeBufferPosition:Int;
	public var vertexGeometryBuffer:VertexBuffer3D;
	public var vertexGeometryBufferPosition:Int;

	public function new()
	{
		reset();
	}

	public function copyFrom(other:Context3DDrawCommand):Void
	{
		if (other != null)
		{
			blendMode = other.blendMode;
			bitmapData = other.bitmapData;
			indexBuffer = other.indexBuffer;
			indexBufferPosition = other.indexBufferPosition;
			numTriangles = other.numTriangles;
			repeat = other.repeat;
			shader = other.shader;
			smoothing = other.smoothing;
			vertexAttributeBuffer = other.vertexAttributeBuffer;
			vertexAttributeBufferPosition = other.vertexAttributeBufferPosition;
			vertexGeometryBuffer = other.vertexGeometryBuffer;
			vertexGeometryBufferPosition = other.vertexGeometryBufferPosition;
		}
	}

	public function reset():Void
	{
		blendMode = NORMAL;
		bitmapData = null;
		indexBuffer = null;
		indexBufferPosition = 0;
		numTriangles = 0;
		repeat = false;
		shader = null;
		smoothing = false;
		vertexAttributeBuffer = null;
		vertexAttributeBufferPosition = 0;
		vertexGeometryBuffer = null;
		vertexGeometryBufferPosition = 0;
	}
}
