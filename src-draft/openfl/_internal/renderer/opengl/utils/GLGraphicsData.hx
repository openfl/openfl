package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl.display3D.Context3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class GLGraphicsData
{
	public var context3D:Context3D;

	public var tint:Array<Float> = [1.0, 1.0, 1.0];
	public var alpha:Float = 1.0;
	public var dirty:Bool = true;
	public var mode:RenderMode = RenderMode.DEFAULT;
	public var lastIndex:Int = 0;

	public var data:Array<Float> = [];
	public var glData:Float32Array;
	public var dataBuffer:GLBuffer;

	public var indices:Array<Int> = [];
	public var glIndices:UInt16Array;
	public var indexBuffer:GLBuffer;

	public function new(context3D:Context3D)
	{
		this.context3D = context3D;

		var gl = @:privateAccess context3D.__backend.gl;

		dataBuffer = gl.createBuffer();
		indexBuffer = gl.createBuffer();
	}

	public function reset():Void
	{
		data = [];
		indices = [];
		lastIndex = 0;
	}

	public function upload():Void
	{
		var gl = @:privateAccess context3D.__backend.gl;

		glData = new Float32Array(cast data);
		gl.bindBuffer(gl.ARRAY_BUFFER, dataBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, glData, gl.STATIC_DRAW);

		glIndices = new UInt16Array(cast indices);
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, glIndices, gl.STATIC_DRAW);

		dirty = false;
	}
}
