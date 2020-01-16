package openfl.display;

import openfl.display3D.VertexBuffer3D;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class Geometry extends DisplayObject
{
	public static inline var FLOATS_PER_VERTEX = 2 + 4;
	private static var __geomShader:GeomShader = new GeomShader();

	private var __numVertices:Int = 0;
	private var __vertices:Array<Float> = [];
	private var __vertexBuffer:VertexBuffer3D = null;

	private var __bounds:Rectangle = new Rectangle(0, 0, 0, 0);

	public function new()
	{
		super();
		__type = GEOMETRY;
		__blendMode = NORMAL;
	}

	public function clear():Void
	{
		__vertices = [];
		__numVertices = 0;
		__bounds.width = 0;
		__bounds.height = 0;
		__bounds.x = 0;
		__bounds.y = 0;

		if (__vertexBuffer != null)
		{
			__vertexBuffer.dispose();
			__vertexBuffer = null;
		}
	}

	public function pushVertex(x:Float, y:Float, color:Int, alpha:Float = 1.0)
	{
		__vertices.push(x);
		__vertices.push(y);
		__vertices.push(((color >> 16) & 0xFF) / 255);
		__vertices.push(((color >> 8) & 0xFF) / 255);
		__vertices.push((color & 0xFF) / 255);
		__vertices.push(alpha);

		__addPointToBounds(x, y);

		++__numVertices;
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = Rectangle.__pool.get();
		__bounds.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}

	private function __addPointToBounds(x:Float, y:Float):Void
	{
		if (x < __bounds.x)
		{
			__bounds.width += __bounds.x - x;
			__bounds.x = x;
		}

		if (y < __bounds.y)
		{
			__bounds.height += __bounds.y - y;
			__bounds.y = y;
		}

		if (x > __bounds.x + __bounds.width)
		{
			__bounds.width = x - __bounds.x;
		}

		if (y > __bounds.y + __bounds.height)
		{
			__bounds.height = y - __bounds.y;
		}
	}
}

private class GeomShader extends Shader
{
	@:glVertexSource("
		attribute vec2 openfl_Position;
		attribute vec4 aColor;

		uniform mat4 openfl_Matrix;
		varying vec4 vColor;

		void main(void) {
			gl_Position = openfl_Matrix * vec4(openfl_Position, 0, 1);
			vColor = aColor;
		}
	")
	@:glFragmentSource("
		uniform vec4 uColorMultiplier;
		uniform vec4 uColorOffset;
		varying vec4 vColor;

		void main(void) {
			vec4 color = clamp(vColor * uColorMultiplier + uColorOffset, 0.0, 1.0);
			gl_FragColor = vec4(color.rgb * color.a, color.a);
		}
	")
	public function new()
	{
		super();
		#if !macro
		data.uColorMultiplier.value = [1, 1, 1, 1];
		data.uColorOffset.value = [1, 1, 1, 1];
		#end
	}
}
