package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl.display3D.Context3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class Shader
{
	private static var UID:Int = 0;

	public var context3D:Context3D;

	public var vertexSrc:Array<String>;
	public var fragmentSrc:Array<String>;
	public var attributes:Map<String, Int> = new Map();
	public var uniforms:Map<String, GLUniformLocation> = new Map();

	public var ID(default, null):Int;

	public var program:GLProgram;

	public function new(context3D:Context3D)
	{
		ID = UID++;
		this.context3D = context3D;

		program = null;
	}

	private function init():Void
	{
		var gl = @:privateAccess context3D.__backend.gl;
		program = Shader.compileProgram(context3D, vertexSrc, fragmentSrc);
		gl.useProgram(program);
	}

	public function destroy():Void
	{
		var gl = @:privateAccess context3D.__backend.gl;

		if (program != null)
		{
			gl.deleteProgram(program);
		}

		attributes = null;
	}

	public function getAttribLocation(attribute:String):Int
	{
		var gl = @:privateAccess context3D.__backend.gl;

		if (program == null)
		{
			throw "Shader isn't initialized";
		}
		if (attributes.exists(attribute))
		{
			return attributes.get(attribute);
		}
		else
		{
			var location = gl.getAttribLocation(program, attribute);
			attributes.set(attribute, location);
			return location;
		}
	}

	public function getUniformLocation(uniform:String):GLUniformLocation
	{
		var gl = @:privateAccess context3D.__backend.gl;

		if (program == null)
		{
			throw "Shader isn't initialized";
		}
		if (uniforms.exists(uniform))
		{
			return uniforms.get(uniform);
		}
		else
		{
			var location = gl.getUniformLocation(program, uniform);
			uniforms.set(uniform, location);
			return location;
		}
	}

	public function enableVertexAttribute(attribute:VertexAttribute, stride:Int, offset:Int):Void
	{
		var gl = @:privateAccess context3D.__backend.gl;

		// trace("Enable vertex attribute " + attribute.name);
		var location = getAttribLocation(attribute.name);
		gl.enableVertexAttribArray(location);
		gl.vertexAttribPointer(location, attribute.components, attribute.type, attribute.normalized, stride, offset * 4);
	}

	public function disableVertexAttribute(attribute:VertexAttribute, setDefault:Bool = true):Void
	{
		var gl = @:privateAccess context3D.__backend.gl;

		var location = getAttribLocation(attribute.name);
		gl.disableVertexAttribArray(location);
		if (setDefault)
		{
			switch (attribute.components)
			{
				case 1:
					gl.vertexAttrib1fv(location, attribute.defaultValue.subarray(0, 1));
				case 2:
					gl.vertexAttrib2fv(location, attribute.defaultValue.subarray(0, 2));
				case 3:
					gl.vertexAttrib3fv(location, attribute.defaultValue.subarray(0, 3));
				case _:
					gl.vertexAttrib4fv(location, attribute.defaultValue.subarray(0, 4));
			}
		}
	}

	public function bindVertexArray(va:VertexArray):Void
	{
		var offset = 0;
		var stride = va.stride;

		for (attribute in va.attributes)
		{
			if (attribute.enabled)
			{
				enableVertexAttribute(attribute, stride, offset);
				offset += attribute.elements;
			}
			else
			{
				disableVertexAttribute(attribute, true);
			}
		}
	}

	public function unbindVertexArray(va:VertexArray):Void
	{
		for (attribute in va.attributes)
		{
			disableVertexAttribute(attribute, false);
		}
	}

	public static function compileProgram(context3D:Context3D, vertexSrc:Array<String>, fragmentSrc:Array<String>):GLProgram
	{
		var gl = @:privateAccess context3D.__backend.gl;

		var vertexShader = Shader.compileShader(context3D, vertexSrc, gl.VERTEX_SHADER);
		var fragmentShader = Shader.compileShader(context3D, fragmentSrc, gl.FRAGMENT_SHADER);
		var program = gl.createProgram();

		if (vertexShader != null && fragmentShader != null)
		{
			gl.attachShader(program, vertexShader);
			gl.attachShader(program, fragmentShader);
			gl.linkProgram(program);

			if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0)
			{
				trace("Could not initialize shaders");
			}
		}

		return program;
	}

	private static function compileShader(context3D:Context3D, shaderSrc:Array<String>, type:Int):GLShader
	{
		var gl = @:privateAccess context3D.__backend.gl;

		var src = shaderSrc.join("\n");
		var shader = gl.createShader(type);
		gl.shaderSource(shader, src);
		gl.compileShader(shader);

		if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0)
		{
			trace(gl.getShaderInfoLog(shader));
			return null;
		}

		return shader;
	}
}
