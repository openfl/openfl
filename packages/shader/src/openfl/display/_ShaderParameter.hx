package openfl.display;

import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import openfl.display3D.Context3D;
import openfl.display3D._Context3D;
import openfl.display.ShaderParameter;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ShaderParameter<T> /*implements Dynamic*/
{
	public var index:Dynamic;
	public var name(default, set):String;
	public var type:ShaderParameterType;
	public var value:Array<T>;

	public var arrayLength:Int;
	public var internal:Bool;
	public var isBool:Bool;
	public var isFloat:Bool;
	public var isInt:Bool;
	public var isUniform:Bool;
	public var length:Int;
	public var uniformMatrix:Float32Array;
	public var useArray:Bool;

	private var shaderParameter:ShaderParameter<T>;

	public function new(shaderParameter:ShaderParameter<T>)
	{
		this.shaderParameter = shaderParameter;
		index = 0;
	}

	public function disableGL(context:Context3D):Void
	{
		var gl = (context._ : _Context3D).gl;

		if (!isUniform)
		{
			for (i in 0...arrayLength)
			{
				gl.disableVertexAttribArray(shaderParameter.index + i);
			}
		}
	}

	public function updateGL(context:Context3D, overrideValue:Array<T> = null):Void
	{
		var gl = (context._ : _Context3D).gl;

		var value = overrideValue != null ? overrideValue : shaderParameter.value;

		var boolValue:Array<Bool> = isBool ? cast value : null;
		var floatValue:Array<Float> = isFloat ? cast value : null;
		var intValue:Array<Int> = isInt ? cast value : null;

		if (isUniform)
		{
			if (value != null && value.length >= this.length)
			{
				switch (shaderParameter.type)
				{
					case BOOL:
						gl.uniform1i(shaderParameter.index, boolValue[0] ? 1 : 0);
					case BOOL2:
						gl.uniform2i(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
					case BOOL3:
						gl.uniform3i(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
					case BOOL4:
						gl.uniform4i(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
					case FLOAT:
						gl.uniform1f(shaderParameter.index, floatValue[0]);
					case FLOAT2:
						gl.uniform2f(shaderParameter.index, floatValue[0], floatValue[1]);
					case FLOAT3:
						gl.uniform3f(shaderParameter.index, floatValue[0], floatValue[1], floatValue[2]);
					case FLOAT4:
						gl.uniform4f(shaderParameter.index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix2fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix3fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix4fv(shaderParameter.index, false, uniformMatrix);

					case INT:
						gl.uniform1i(shaderParameter.index, intValue[0]);
					case INT2:
						gl.uniform2i(shaderParameter.index, intValue[0], intValue[1]);
					case INT3:
						gl.uniform3i(shaderParameter.index, intValue[0], intValue[1], intValue[2]);
					case INT4:
						gl.uniform4i(shaderParameter.index, intValue[0], intValue[1], intValue[2], intValue[3]);

					default:
				}
			}
			else
			{
				switch (shaderParameter.type)
				{
					case BOOL, INT:
						gl.uniform1i(shaderParameter.index, 0);
					case BOOL2, INT2:
						gl.uniform2i(shaderParameter.index, 0, 0);
					case BOOL3, INT3:
						gl.uniform3i(shaderParameter.index, 0, 0, 0);
					case BOOL4, INT4:
						gl.uniform4i(shaderParameter.index, 0, 0, 0, 0);
					case FLOAT:
						gl.uniform1f(shaderParameter.index, 0);
					case FLOAT2:
						gl.uniform2f(shaderParameter.index, 0, 0);
					case FLOAT3:
						gl.uniform3f(shaderParameter.index, 0, 0, 0);
					case FLOAT4:
						gl.uniform4f(shaderParameter.index, 0, 0, 0, 0);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix2fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix3fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix4fv(shaderParameter.index, false, uniformMatrix);

					default:
				}
			}
		}
		else
		{
			if (!useArray && (value == null || value.length == this.length))
			{
				for (i in 0...arrayLength)
				{
					gl.disableVertexAttribArray(shaderParameter.index + i);
				}

				if (value != null)
				{
					switch (shaderParameter.type)
					{
						case BOOL:
							gl.vertexAttrib1f(shaderParameter.index, boolValue[0] ? 1 : 0);
						case BOOL2:
							gl.vertexAttrib2f(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
						case BOOL3:
							gl.vertexAttrib3f(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
						case BOOL4:
							gl.vertexAttrib4f(shaderParameter.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
						case FLOAT:
							gl.vertexAttrib1f(shaderParameter.index, floatValue[0]);
						case FLOAT2:
							gl.vertexAttrib2f(shaderParameter.index, floatValue[0], floatValue[1]);
						case FLOAT3:
							gl.vertexAttrib3f(shaderParameter.index, floatValue[0], floatValue[1], floatValue[2]);
						case FLOAT4:
							gl.vertexAttrib4f(shaderParameter.index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(shaderParameter.index + i, floatValue[i * 2], floatValue[i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(shaderParameter.index + i, floatValue[i * 3], floatValue[i * 3 + 1], floatValue[i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(shaderParameter.index + i, floatValue[i * 4], floatValue[i * 4 + 1], floatValue[i * 4 + 2],
									floatValue[i * 4 + 3]);
							}

						case INT:
							gl.vertexAttrib1f(shaderParameter.index, intValue[0]);
						case INT2:
							gl.vertexAttrib2f(shaderParameter.index, intValue[0], intValue[1]);
						case INT3:
							gl.vertexAttrib3f(shaderParameter.index, intValue[0], intValue[1], intValue[2]);
						case INT4:
							gl.vertexAttrib4f(shaderParameter.index, intValue[0], intValue[1], intValue[2], intValue[3]);
						default:
					}
				}
				else
				{
					switch (shaderParameter.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(shaderParameter.index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(shaderParameter.index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(shaderParameter.index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(shaderParameter.index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(shaderParameter.index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(shaderParameter.index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(shaderParameter.index + i, 0, 0, 0, 0);
							}

						default:
					}
				}
			}
			else
			{
				for (i in 0...arrayLength)
				{
					gl.enableVertexAttribArray(shaderParameter.index + i);
				}
			}
		}
	}

	public function updateGLFromBuffer(context:Context3D, buffer:Float32Array, position:Int, length:Int, bufferOffset:Int):Void
	{
		var gl = (context._ : _Context3D).gl;

		if (isUniform)
		{
			if (length >= this.length)
			{
				switch (shaderParameter.type)
				{
					case BOOL, INT:
						gl.uniform1i(shaderParameter.index, Std.int(buffer[position]));
					case BOOL2, INT2:
						gl.uniform2i(shaderParameter.index, Std.int(buffer[position]), Std.int(buffer[position + 1]));
					case BOOL3, INT3:
						gl.uniform3i(shaderParameter.index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]));
					case BOOL4, INT4:
						gl.uniform4i(shaderParameter.index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]),
							Std.int(buffer[position + 3]));
					case FLOAT:
						gl.uniform1f(shaderParameter.index, buffer[position]);
					case FLOAT2:
						gl.uniform2f(shaderParameter.index, buffer[position], buffer[position + 1]);
					case FLOAT3:
						gl.uniform3f(shaderParameter.index, buffer[position], buffer[position + 1], buffer[position + 2]);
					case FLOAT4:
						gl.uniform4f(shaderParameter.index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix2fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix3fv(shaderParameter.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix4fv(shaderParameter.index, false, uniformMatrix);

					default:
				}
			}
		}
		else
		{
			if (!internal && (length == 0 || length == this.length))
			{
				for (i in 0...arrayLength)
				{
					gl.disableVertexAttribArray(shaderParameter.index + i);
				}

				if (length > 0)
				{
					switch (shaderParameter.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(shaderParameter.index, buffer[position]);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(shaderParameter.index, buffer[position], buffer[position + 1]);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(shaderParameter.index, buffer[position], buffer[position + 1], buffer[position + 2]);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(shaderParameter.index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(shaderParameter.index + i, buffer[position + i * 2], buffer[position + i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(shaderParameter.index + i, buffer[position + i * 3], buffer[position + i * 3 + 1],
									buffer[position + i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(shaderParameter.index + i, buffer[position + i * 4], buffer[position + i * 4 + 1],
									buffer[position + i * 4 + 2], buffer[position + i * 4 + 3]);
							}

						default:
					}
				}
				else
				{
					switch (shaderParameter.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(shaderParameter.index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(shaderParameter.index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(shaderParameter.index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(shaderParameter.index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(shaderParameter.index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(shaderParameter.index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(shaderParameter.index + i, 0, 0, 0, 0);
							}

						default:
					}
				}
			}
			else
			{
				var type = GL.FLOAT;
				if (isBool) type = GL.INT; // gl.BOOL;
				else if (isInt) type = GL.INT;

				for (i in 0...arrayLength)
				{
					gl.enableVertexAttribArray(shaderParameter.index + i);
				}

				if (length > 0)
				{
					for (i in 0...arrayLength)
					{
						gl.vertexAttribPointer(shaderParameter.index + i, this.length, type, false, this.length * Float32Array.BYTES_PER_ELEMENT,
							(position + (bufferOffset * this.length) + (i * arrayLength)) * Float32Array.BYTES_PER_ELEMENT);
					}
				}
			}
		}
	}

	// Get & Set Methods

	private function set_name(value:String):String
	{
		internal = StringTools.startsWith(value, "openfl_");
		return this.name = value;
	}
}
