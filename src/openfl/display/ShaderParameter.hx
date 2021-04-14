package openfl.display;

#if !flash
import openfl.utils._internal.Float32Array;
import openfl.display3D.Context3D;

/**
	TODO: Document GLSL Shaders

	A ShaderParameter instance represents a single input parameter of a shader
	kernel. A kernel can be defined to accept zero, one, or more parameters
	that are used in the kernel execution. A ShaderParameter provides
	information about the parameter, such as the type of data it expects. It
	also provides a mechanism for setting the parameter value that is used
	when the shader executes. To specify a value or values for the shader
	parameter, create an Array containing the value or values and assign it to
	the `value` property.

	A ShaderParameter instance representing a parameter for a Shader instance
	is accessed as a property of the Shader instance's `data` property. The
	ShaderParameter property has the same name as the parameter's name in the
	shader code. For example, if a shader defines a parameter named `radius`,
	the ShaderParameter instance representing the `radius` parameter is
	available as the `radius` property, as shown here:

	```haxe
	var radiusParam:ShaderParameter = myShader.data.radius;
	```

	In addition to the defined properties of the ShaderParameter class, each
	ShaderParameter instance has additional properties corresponding to any
	metadata defined for the parameter. These properties are added to the
	ShaderParameter object when it is created. The properties' names match the
	metadata names specified in the shader's source code. The data type of
	each property varies according to the data type of the corresponding
	metadata. A text metadata value such as "description" is a String
	instance. A metadata property with a non-string value (such as `minValue`
	or `defaultValue`) is represented as an Array instance. The number of
	elements and element data types correspond to the metadata values.

	For example, suppose a shader includes the following two parameter
	declarations:

	```as3
	parameter float2 size
	<
		description: "The size of the image to which the kernel is applied";
		minValue: float2(0.0, 0.0);
		maxValue: float2(100.0, 100.0);
		defaultValue: float2(50.0, 50.0);
	>;

	parameter float radius
	<
		description: "The radius of the effect";
		minValue: 0.0;
		maxValue: 50.0;
		defaultValue: 25.0;
	>;
	```

	The ShaderParameter instance corresponding to the `size` parameter has the
	following metadata properties in addition to its built-in properties:

	| Property name | Data type | Value |
	| --- | --- | --- |
	| `name` | String | `"size"` |
	| `description` | String | `"The size of the image to which the kernel is applied"` |
	| `minValue` | Array | `[0, 0]` |
	| `maxValue` | Array | `[100, 100]` |
	| `defaultValue` | Array | `[50, 50]` |

	The ShaderParameter corresponding to the `radius` parameter has the
	following additional properties:

	| Property name | Data type | Value |
	| --- | --- | --- |
	| `name` | String | `"radius"` |
	| `description` | String | `"The radius of the effect"` |
	| `minValue` | Array | `[0]` |
	| `maxValue` | Array | `[50]` |
	| `defaultValue` | Array | `[25]` |

	Generally, developer code does not create a ShaderParameter instance
	directly. A ShaderParameter instance is created for each of a shader's
	parameters when the Shader instance is created.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
#if (!js && !display)
@:generic
#end
@:final class ShaderParameter<T> /*implements Dynamic*/
{
	/**
		The zero-based index of the parameter.
	**/
	@SuppressWarnings("checkstyle:Dynamic") public var index(default, null):Dynamic;

	@:noCompletion @:dox(hide) @SuppressWarnings("checkstyle:FieldDocComment") public var name(default, set):String;

	/**
		The data type of the parameter as defined in the shader. The set of
		possible values for the `type` property is defined by the constants in
		the ShaderParameterType class.
	**/
	public var type(default, null):ShaderParameterType;

	/**
		The value or values that are passed in as the parameter value to the
		shader. The `value` property is an indexed Array. The number and type
		of the elements of the Array correspond to the data type of the
		parameter, which can be determined using the `type` property.
		The following table indicates the parameter type and corresponding
		number and data type of the `value` Array's elements:

		| Parameter type | # Elements | Element data type |
		| --- | --- | --- |
		| float (`ShaderParameterType.FLOAT`) | 1 | Number |
		| float2 (`ShaderParameterType.FLOAT2`) | 2 | Number |
		| float3 (`ShaderParameterType.FLOAT3`) | 3 | Number |
		| float4 (`ShaderParameterType.FLOAT4`) | 4 | Number |
		| int (`ShaderParameterType.INT`) | 1 | int or uint |
		| int2 (`ShaderParameterType.INT2`) | 2 | int or uint |
		| int3 (`ShaderParameterType.INT3`) | 3 | int or uint |
		| int4 (`ShaderParameterType.INT4`) | 4 | int or uint |
		| bool (`ShaderParameterType.BOOL`) | 1 | Boolean |
		| bool2	(`ShaderParameterType.BOOL2`) | 2 | Boolean |
		| bool3 (`ShaderParameterType.BOOL3`) | 3 | Boolean |
		| bool4 (`ShaderParameterType.BOOL4`) | 4 | Boolean |
		| float2x2 (`ShaderParameterType.MATRIX2X2`) | 4 | Number |
		| float3x3 (`ShaderParameterType.MATRIX3X3`) | 9 | Number |
		| float4x4 (`ShaderParameterType.MATRIX4X4`) | 16 | Number |

		For the matrix parameter types, the array elements fill the rows of
		the matrix, then the columns. For example, suppose the following line
		of ActionScript is used to fill a `float2x2` parameter named
		`myMatrix`:

		```haxe
		myShader.data.myMatrix.value = [.1, .2, .3, .4];
		```

		Within the shader, the matrix elements have the following values:

		* `myMatrix[0][0]`: .1
		* `myMatrix[0][1]`: .2
		* `myMatrix[1][0]`: .3
		* `myMatrix[1][1]`: .4
	**/
	public var value:Array<T>;

	@:noCompletion private var __arrayLength:Int;
	@:noCompletion private var __internal:Bool;
	@:noCompletion private var __isBool:Bool;
	@:noCompletion private var __isFloat:Bool;
	@:noCompletion private var __isInt:Bool;
	@:noCompletion private var __isUniform:Bool;
	@:noCompletion private var __length:Int;
	@:noCompletion private var __uniformMatrix:Float32Array;
	@:noCompletion private var __useArray:Bool;

	public function new()
	{
		index = 0;
	}

	@:noCompletion private function __disableGL(context:Context3D):Void
	{
		var gl = context.gl;

		if (!__isUniform)
		{
			for (i in 0...__arrayLength)
			{
				gl.disableVertexAttribArray(index + i);
			}
		}
	}

	@:noCompletion private function __updateGL(context:Context3D, overrideValue:Array<T> = null):Void
	{
		#if lime
		var gl = context.gl;

		var value = overrideValue != null ? overrideValue : this.value;

		var boolValue:Array<Bool> = __isBool ? cast value : null;
		var floatValue:Array<Float> = __isFloat ? cast value : null;
		var intValue:Array<Int> = __isInt ? cast value : null;

		if (__isUniform)
		{
			if (value != null && value.length >= __length)
			{
				switch (type)
				{
					case BOOL:
						gl.uniform1i(index, boolValue[0] ? 1 : 0);
					case BOOL2:
						gl.uniform2i(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
					case BOOL3:
						gl.uniform3i(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
					case BOOL4:
						gl.uniform4i(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
					case FLOAT:
						gl.uniform1f(index, floatValue[0]);
					case FLOAT2:
						gl.uniform2f(index, floatValue[0], floatValue[1]);
					case FLOAT3:
						gl.uniform3f(index, floatValue[0], floatValue[1], floatValue[2]);
					case FLOAT4:
						gl.uniform4f(index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix2fv(index, false, __uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix3fv(index, false, __uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix4fv(index, false, __uniformMatrix);

					case INT:
						gl.uniform1i(index, intValue[0]);
					case INT2:
						gl.uniform2i(index, intValue[0], intValue[1]);
					case INT3:
						gl.uniform3i(index, intValue[0], intValue[1], intValue[2]);
					case INT4:
						gl.uniform4i(index, intValue[0], intValue[1], intValue[2], intValue[3]);

					default:
				}
			}
			else
			{
				switch (type)
				{
					case BOOL, INT:
						gl.uniform1i(index, 0);
					case BOOL2, INT2:
						gl.uniform2i(index, 0, 0);
					case BOOL3, INT3:
						gl.uniform3i(index, 0, 0, 0);
					case BOOL4, INT4:
						gl.uniform4i(index, 0, 0, 0, 0);
					case FLOAT:
						gl.uniform1f(index, 0);
					case FLOAT2:
						gl.uniform2f(index, 0, 0);
					case FLOAT3:
						gl.uniform3f(index, 0, 0, 0);
					case FLOAT4:
						gl.uniform4f(index, 0, 0, 0, 0);

					case MATRIX2X2:
						for (i in 0...4)
						{
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix2fv(index, false, __uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix3fv(index, false, __uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix4fv(index, false, __uniformMatrix);

					default:
				}
			}
		}
		else
		{
			if (!__useArray && (value == null || value.length == __length))
			{
				for (i in 0...__arrayLength)
				{
					gl.disableVertexAttribArray(index + i);
				}

				if (value != null)
				{
					switch (type)
					{
						case BOOL:
							gl.vertexAttrib1f(index, boolValue[0] ? 1 : 0);
						case BOOL2:
							gl.vertexAttrib2f(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
						case BOOL3:
							gl.vertexAttrib3f(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
						case BOOL4:
							gl.vertexAttrib4f(index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
						case FLOAT:
							gl.vertexAttrib1f(index, floatValue[0]);
						case FLOAT2:
							gl.vertexAttrib2f(index, floatValue[0], floatValue[1]);
						case FLOAT3:
							gl.vertexAttrib3f(index, floatValue[0], floatValue[1], floatValue[2]);
						case FLOAT4:
							gl.vertexAttrib4f(index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(index + i, floatValue[i * 2], floatValue[i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(index + i, floatValue[i * 3], floatValue[i * 3 + 1], floatValue[i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(index + i, floatValue[i * 4], floatValue[i * 4 + 1], floatValue[i * 4 + 2], floatValue[i * 4 + 3]);
							}

						case INT:
							gl.vertexAttrib1f(index, intValue[0]);
						case INT2:
							gl.vertexAttrib2f(index, intValue[0], intValue[1]);
						case INT3:
							gl.vertexAttrib3f(index, intValue[0], intValue[1], intValue[2]);
						case INT4:
							gl.vertexAttrib4f(index, intValue[0], intValue[1], intValue[2], intValue[3]);
						default:
					}
				}
				else
				{
					switch (type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(index + i, 0, 0, 0, 0);
							}

						default:
					}
				}
			}
			else
			{
				for (i in 0...__arrayLength)
				{
					gl.enableVertexAttribArray(index + i);
				}
			}
		}
		#end
	}

	@:noCompletion private function __updateGLFromBuffer(context:Context3D, buffer:Float32Array, position:Int, length:Int, bufferOffset:Int):Void
	{
		#if lime
		var gl = context.gl;

		if (__isUniform)
		{
			if (length >= __length)
			{
				switch (type)
				{
					case BOOL, INT:
						gl.uniform1i(index, Std.int(buffer[position]));
					case BOOL2, INT2:
						gl.uniform2i(index, Std.int(buffer[position]), Std.int(buffer[position + 1]));
					case BOOL3, INT3:
						gl.uniform3i(index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]));
					case BOOL4, INT4:
						gl.uniform4i(index, Std.int(buffer[position]), Std.int(buffer[position + 1]), Std.int(buffer[position + 2]),
							Std.int(buffer[position + 3]));
					case FLOAT:
						gl.uniform1f(index, buffer[position]);
					case FLOAT2:
						gl.uniform2f(index, buffer[position], buffer[position + 1]);
					case FLOAT3:
						gl.uniform3f(index, buffer[position], buffer[position + 1], buffer[position + 2]);
					case FLOAT4:
						gl.uniform4f(index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

					case MATRIX2X2:
						for (i in 0...4)
						{
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix2fv(index, false, __uniformMatrix);

					// case MATRIX2X3:
					// case MATRIX2X4:
					// case MATRIX3X2:

					case MATRIX3X3:
						for (i in 0...9)
						{
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix3fv(index, false, __uniformMatrix);

					// case MATRIX3X4:
					// case MATRIX4X2:
					// case MATRIX4X3:

					case MATRIX4X4:
						for (i in 0...16)
						{
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix4fv(index, false, __uniformMatrix);

					default:
				}
			}
		}
		else
		{
			if (!__internal && (length == 0 || length == __length))
			{
				for (i in 0...__arrayLength)
				{
					gl.disableVertexAttribArray(index + i);
				}

				if (length > 0)
				{
					switch (type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(index, buffer[position]);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(index, buffer[position], buffer[position + 1]);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(index, buffer[position], buffer[position + 1], buffer[position + 2]);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(index + i, buffer[position + i * 2], buffer[position + i * 2 + 1]);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(index + i, buffer[position + i * 3], buffer[position + i * 3 + 1], buffer[position + i * 3 + 2]);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(index + i, buffer[position + i * 4], buffer[position + i * 4 + 1], buffer[position + i * 4 + 2],
									buffer[position + i * 4 + 3]);
							}

						default:
					}
				}
				else
				{
					switch (type)
					{
						case BOOL, FLOAT, INT:
							gl.vertexAttrib1f(index, 0);
						case BOOL2, FLOAT2, INT2:
							gl.vertexAttrib2f(index, 0, 0);
						case BOOL3, FLOAT3, INT3:
							gl.vertexAttrib3f(index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4:
							gl.vertexAttrib4f(index, 0, 0, 0, 0);

						case MATRIX2X2:
							for (i in 0...2)
							{
								gl.vertexAttrib2f(index + i, 0, 0);
							}

						case MATRIX3X3:
							for (i in 0...3)
							{
								gl.vertexAttrib3f(index + i, 0, 0, 0);
							}

						case MATRIX4X4:
							for (i in 0...4)
							{
								gl.vertexAttrib4f(index + i, 0, 0, 0, 0);
							}

						default:
					}
				}
			}
			else
			{
				var type = gl.FLOAT;
				if (__isBool) type = gl.INT; // gl.BOOL;
				else if (__isInt) type = gl.INT;

				for (i in 0...__arrayLength)
				{
					gl.enableVertexAttribArray(index + i);
				}

				if (length > 0)
				{
					for (i in 0...__arrayLength)
					{
						gl.vertexAttribPointer(index + i, __length, type, false, __length * Float32Array.BYTES_PER_ELEMENT,
							(position + (bufferOffset * __length) + (i * __arrayLength)) * Float32Array.BYTES_PER_ELEMENT);
					}
				}
			}
		}
		#end
	}

	// Get & Set Methods
	@:noCompletion private function set_name(value:String):String
	{
		__internal = StringTools.startsWith(value, "openfl_");
		return this.name = value;
	}
}
#else
typedef ShaderParameter<T> = flash.display.ShaderParameter<T>;
#end
