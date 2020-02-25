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
	// public var alpha:Float; -- should this be attr instead?
	// public var colorTransform:ColorTransform -- should this be attr instead?
	public var attrVertexBuffer:VertexBuffer3D;
	public var attrVertexBufferPosition:Int;
	public var blendMode:BlendMode;
	public var bitmapData:BitmapData;
	public var geomVertexBuffer:VertexBuffer3D;
	public var geomVertexBufferPosition:Int;
	public var indexBuffer:IndexBuffer3D;
	public var numTriangles:Int;
	public var repeat:Bool;
	public var shader:Shader;
	public var smoothing:Bool;

	// public var vertexBufferLength:Int;
	// public var vertexBufferStart:Int;

	public function new()
	{
		reset();
	}

	public function copyFrom(other:Context3DDrawCommand):Void
	{
		if (other != null)
		{
			attrVertexBuffer = other.attrVertexBuffer;
			attrVertexBufferPosition = other.attrVertexBufferPosition;
			blendMode = other.blendMode;
			bitmapData = other.bitmapData;
			geomVertexBuffer = other.geomVertexBuffer;
			geomVertexBufferPosition = other.geomVertexBufferPosition;
			indexBuffer = other.indexBuffer;
			numTriangles = other.numTriangles;
			repeat = other.repeat;
			shader = other.shader;
			smoothing = other.smoothing;
		}
	}

	public function reset():Void
	{
		attrVertexBuffer = null;
		attrVertexBufferPosition = 0;
		blendMode = NORMAL;
		bitmapData = null;
		geomVertexBuffer = null;
		geomVertexBufferPosition = 0;
		indexBuffer = null;
		numTriangles = 0;
		repeat = false;
		shader = null;
		smoothing = false;
	}
}
