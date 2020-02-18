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
	public var blendMode:BlendMode;
	public var bitmapData:BitmapData;
	public var indexBuffer:IndexBuffer3D;
	public var numTriangles:Int;
	public var shader:Shader;
	public var smoothing:Bool;
	public var vertexBuffer:VertexBuffer3D;
	public var vertexBufferPosition:Int;

	// public var vertexBufferLength:Int;
	// public var vertexBufferStart:Int;

	public function new() {}

	public function copyFrom(other:Context3DDrawCommand):Void
	{
		blendMode = other.blendMode;
		bitmapData = other.bitmapData;
		indexBuffer = other.indexBuffer;
		numTriangles = other.numTriangles;
		shader = other.shader;
		smoothing = other.smoothing;
		vertexBuffer = other.vertexBuffer;
		vertexBufferPosition = other.vertexBufferPosition;
	}
}
