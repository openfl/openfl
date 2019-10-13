package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBuffer;
import lime.utils.ArrayBufferView;
import openfl.display3D.Context3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class VertexArray
{
	public var context3D:Context3D;
	public var glBuffer:GLBuffer;
	public var attributes:Array<VertexAttribute> = [];
	public var buffer:ArrayBuffer;
	public var size:Int = 0;
	public var stride(get, never):Int;

	public var isStatic:Bool = false;

	public function new(attributes:Array<VertexAttribute>, ?size:Int = 0, isStatic:Bool = false)
	{
		this.size = size;
		this.attributes = attributes;

		if (size > 0)
		{
			buffer = new ArrayBuffer(size);
		}

		this.isStatic = isStatic;
	}

	public inline function bind():Void
	{
		var gl = @:privateAccess context3D.gl;

		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
	}

	public inline function unbind():Void
	{
		var gl = @:privateAccess context3D.gl;

		gl.bindBuffer(gl.ARRAY_BUFFER, null);
	}

	public function upload(view:ArrayBufferView):Void
	{
		var gl = @:privateAccess context3D.gl;

		gl.bufferSubData(gl.ARRAY_BUFFER, 0, view);
	}

	public function destroy():Void
	{
		var gl = @:privateAccess context3D.gl;

		gl.deleteBuffer(glBuffer);
		buffer = null;
	}

	public function setContext(context3D:Context3D, view:ArrayBufferView):Void
	{
		var gl = @:privateAccess context3D.gl;

		this.context3D = context3D;

		glBuffer = gl.createBuffer();

		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
		// TODO fix this, it should accept an ArrayBuffer
		gl.bufferData(gl.ARRAY_BUFFER, view, isStatic ? gl.STATIC_DRAW : gl.DYNAMIC_DRAW);
	}

	private function get_stride():Int
	{
		var s = 0;
		for (a in attributes)
		{
			if (a.enabled) s += a.elements * 4;
		}
		return s;
	}
}
