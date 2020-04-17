package openfl.display;

#if openfl_gl
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import openfl.display3D.Context3D;
import openfl.display.ShaderParameter;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D) // TODO: Remove backend references
#if (!js && !display)
@:generic
#end
@:noCompletion
class _ShaderParameter<T> /*implements Dynamic*/
{
	private var arrayLength:Int;
	private var internal:Bool;
	private var isBool:Bool;
	private var isFloat:Bool;
	private var isInt:Bool;
	private var isUniform:Bool;
	private var length:Int;
	private var parent:ShaderParameter<T>;
	private var uniformMatrix:Float32Array;
	private var useArray:Bool;

	public function new(parent:ShaderParameter<T>)
	{
		this.parent = parent;
	}

	private function disableGL(context:Context3D):Void
	{
		var gl = context._.gl;

		if (!isUniform)
		{
			for (i in 0...arrayLength)
			{
				gl.disableVertexAttribArray(parent.index + i);
			}
		}
	}

	private function updateGL(context:Context3D, overrideValue:Array<T> = null):Void
	{
		var gl = context._.gl;

		var value = overrideValue != null ? overrideValue : parent.value;

		var boolValue:Array<Bool> = isBool ? cast value : null;
		var floatValue:Array<Float> = isFloat ? cast value : null;
		var intValue:Array<Int> = isInt ? cast value : null;

		if (isUniform)
		{
			if (value != null && value.length >= this.length)
			{
				switch (parent.type)
				{
					case BOOL:
						gl.uniform1i(parent.index, boolValue[0] ? 1 : 0);
					case BOOL2:
						gl.uniform2i(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
					case BOOL3:
						gl.uniform3i(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
					case BOOL4:
						gl.uniform4i(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
					case FLOAT:
						gl.uniform1f(parent.index, floatValue[0]);
					case FLOAT2:
						gl.uniform2f(parent.index, floatValue[0], floatValue[1]);
					case FLOAT3:
						gl.uniform3f(parent.index, floatValue[0], floatValue[1], floatValue[2]);
					case FLOAT4:
						gl.uniform4f(parent.index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix2fv(parent.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix3fv(parent.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix4fv(parent.index, false, uniformMatrix);

					case INT:
						gl.uniform1i(parent.index, intValue[0]);
					case INT2:
						gl.uniform2i(parent.index, intValue[0], intValue[1]);
					case INT3:
						gl.uniform3i(parent.index, intValue[0], intValue[1], intValue[2]);
					case INT4:
						gl.uniform4i(parent.index, intValue[0], intValue[1], intValue[2], intValue[3]);

					default:
				}
			}
			else
			{
				switch (parent.type)
				{
					case BOOL, INT:
						gl.uniform1i(parent.index, 0);
					case BOOL2, INT2:
						gl.uniform2i(parent.index, 0, 0);
					case BOOL3, INT3:
						gl.uniform3i(parent.index, 0, 0, 0);
					case BOOL4, INT4:
						gl.uniform4i(parent.index, 0, 0, 0, 0);
					case FLOAT:
						gl.uniform1f(parent.index, 0);
					case FLOAT2:
						gl.uniform2f(parent.index, 0, 0);
					case FLOAT3:
						gl.uniform3f(parent.index, 0, 0, 0);
					case FLOAT4:
						gl.uniform4f(parent.index, 0, 0, 0, 0);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix2fv(parent.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix3fv(parent.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = 0;
						}
						gl.uniformMatrix4fv(parent.index, false, uniformMatrix);

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
					gl.disableVertexAttribArray(parent.index + i);
				}

				if (value != null)
				{
					switch (parent.type)
					{
						case BOOL:
							gl.vertexAttrib1f(parent.index, boolValue[0] ? 1 : 0);
						case BOOL2:
							gl.vertexAttrib2f(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
						case BOOL3:
							gl.vertexAttrib3f(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
						case BOOL4:
							gl.vertexAttrib4f(parent.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
						case FLOAT:
							gl.vertexAttrib1f(parent.index, floatValue[0]);
						case FLOAT2:
							gl.vertexAttrib2f(parent.index, floatValue[0], floatValue[1]);
						case FLOAT3:
							gl.vertexAttrib3f(parent.index, floatValue[0], floatValue[1], floatValue[2]);
						case FLOAT4:
							gl.vertexAttrib4f(parent.index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(parent.index + i, floatValue[i * 2], floatValue[i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(parent.index + i, floatValue[i * 3], floatValue[i * 3 + 1], floatValue[i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(parent.index + i, floatValue[i * 4], floatValue[i * 4 + 1], floatValue[i * 4 + 2], floatValue[i * 4 + 3]);
							}

						case INT:
							gl.vertexAttrib1f(parent.index, intValue[0]);
						case INT2:
							gl.vertexAttrib2f(parent.index, intValue[0], intValue[1]);
						case INT3:
							gl.vertexAttrib3f(parent.index, intValue[0], intValue[1], intValue[2]);
						case INT4:
							gl.vertexAttrib4f(parent.index, intValue[0], intValue[1], intValue[2], intValue[3]);
						default:
					}
				}
				else
				{
					switch (parent.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(parent.index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(parent.index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(parent.index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(parent.index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(parent.index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(parent.index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(parent.index + i, 0, 0, 0, 0);
							}

						default:
					}
				}
			}
			else
			{
				for (i in 0...arrayLength)
				{
					gl.enableVertexAttribArray(parent.index + i);
				}
			}
		}
	}

	private function updateGLFromBuffer(context:Context3D, buffer:Float32Array, position:Int, length:Int, bufferOffset:Int):Void
	{
		var gl = context._.gl;

		if (isUniform)
		{
			if (length >= this.length)
			{
				switch (parent.type)
				{
					case BOOL, INT:
						gl.uniform1i(parent.index, Std.int(buffer[position]));
					case BOOL2, INT2:
						gl.uniform2i(parent.index, Std.int(buffer[position]), Std.int(buffer[position + 1]));
					case BOOL3, INT3:
						gl.uniform3i(parent.index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]));
					case BOOL4, INT4:
						gl.uniform4i(parent.index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]),
							Std.int(buffer[position + 3]));
					case FLOAT:
						gl.uniform1f(parent.index, buffer[position]);
					case FLOAT2:
						gl.uniform2f(parent.index, buffer[position], buffer[position + 1]);
					case FLOAT3:
						gl.uniform3f(parent.index, buffer[position], buffer[position + 1], buffer[position + 2]);
					case FLOAT4:
						gl.uniform4f(parent.index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix2fv(parent.index, false, uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix3fv(parent.index, false, uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix4fv(parent.index, false, uniformMatrix);

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
					gl.disableVertexAttribArray(parent.index + i);
				}

				if (length > 0)
				{
					switch (parent.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(parent.index, buffer[position]);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(parent.index, buffer[position], buffer[position + 1]);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(parent.index, buffer[position], buffer[position + 1], buffer[position + 2]);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(parent.index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(parent.index + i, buffer[position + i * 2], buffer[position + i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(parent.index + i, buffer[position + i * 3], buffer[position + i * 3 + 1], buffer[position + i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(parent.index + i, buffer[position + i * 4], buffer[position + i * 4 + 1], buffer[position + i * 4 + 2],
									buffer[position + i * 4 + 3]);
							}

						default:
					}
				}
				else
				{
					switch (parent.type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(parent.index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(parent.index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(parent.index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(parent.index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(parent.index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(parent.index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(parent.index + i, 0, 0, 0, 0);
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
					gl.enableVertexAttribArray(parent.index + i);
				}

				if (length > 0)
				{
					for (i in 0...arrayLength)
					{
						gl.vertexAttribPointer(parent.index + i, this.length, type, false, this.length * Float32Array.BYTES_PER_ELEMENT,
							(position + (bufferOffset * this.length) + (i * arrayLength)) * Float32Array.BYTES_PER_ELEMENT);
					}
				}
			}
		}
	}

	public function setName(value:String):Void
	{
		internal = StringTools.startsWith(value, "openfl_");
	}
}
#end
