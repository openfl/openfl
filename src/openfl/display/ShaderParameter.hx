package openfl.display; #if !flash


import openfl.display3D.Context3D;

#if lime
import lime.utils.Float32Array;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)

#if (!js && !display) @:generic #end


@:final class ShaderParameter<T> /*implements Dynamic*/ {
	
	
	public var index (default, null):Dynamic;
	@:noCompletion public var name (default, set):String;
	public var type (default, null):ShaderParameterType;
	public var value:Array<T>;
	
	@:noCompletion private var __arrayLength:Int;
	@:noCompletion private var __internal:Bool;
	@:noCompletion private var __isBool:Bool;
	@:noCompletion private var __isFloat:Bool;
	@:noCompletion private var __isInt:Bool;
	@:noCompletion private var __isUniform:Bool;
	@:noCompletion private var __length:Int;
	@:noCompletion private var __uniformMatrix:#if lime Float32Array #else Dynamic #end;
	@:noCompletion private var __useArray:Bool;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
	@:noCompletion private function __disableGL (context:Context3D):Void {
		
		var gl = context.gl;
		
		if (!__isUniform) {
			
			for (i in 0...__arrayLength) {
				
				gl.disableVertexAttribArray (index + i);
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __updateGL (context:Context3D, overrideValue:Array<T> = null):Void {
		
		#if lime
		var gl = context.gl;
		
		var value = overrideValue != null ? overrideValue : this.value;
		
		var boolValue:Array<Bool> = __isBool ? cast value : null;
		var floatValue:Array<Float> = __isFloat ? cast value : null;
		var intValue:Array<Int> = __isInt ? cast value : null;
		
		if (__isUniform) {
			
			if (value != null && value.length >= __length) {
				
				switch (type) {
					
					case BOOL: gl.uniform1i (index, boolValue[0] ? 1 : 0);
					case BOOL2: gl.uniform2i (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
					case BOOL3: gl.uniform3i (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
					case BOOL4: gl.uniform4i (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
					case FLOAT: gl.uniform1f (index, floatValue[0]);
					case FLOAT2: gl.uniform2f (index, floatValue[0], floatValue[1]);
					case FLOAT3: gl.uniform3f (index, floatValue[0], floatValue[1], floatValue[2]);
					case FLOAT4: gl.uniform4f (index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);
					
					case MATRIX2X2:
						for (i in 0...4) {
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix2fv (index, false, __uniformMatrix);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						for (i in 0...9) {
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix3fv (index, false, __uniformMatrix);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						for (i in 0...16) {
							__uniformMatrix[i] = floatValue[i];
						}
						gl.uniformMatrix4fv (index, false, __uniformMatrix);
					
					case INT: gl.uniform1i (index, intValue[0]);
					case INT2: gl.uniform2i (index, intValue[0], intValue[1]);
					case INT3: gl.uniform3i (index, intValue[0], intValue[1], intValue[2]);
					case INT4: gl.uniform4i (index, intValue[0], intValue[1], intValue[2], intValue[3]);
					
					default:
					
				}
				
			} else {
				
				switch (type) {
					
					case BOOL, INT: gl.uniform1i (index, 0);
					case BOOL2, INT2: gl.uniform2i (index, 0, 0);
					case BOOL3, INT3: gl.uniform3i (index, 0, 0, 0);
					case BOOL4, INT4: gl.uniform4i (index, 0, 0, 0, 0);
					case FLOAT: gl.uniform1f (index, 0);
					case FLOAT2: gl.uniform2f (index, 0, 0);
					case FLOAT3: gl.uniform3f (index, 0, 0, 0);
					case FLOAT4: gl.uniform4f (index, 0, 0, 0, 0);
					
					case MATRIX2X2:
						for (i in 0...4) {
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix2fv (index, false, __uniformMatrix);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						for (i in 0...9) {
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix3fv (index, false, __uniformMatrix);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						for (i in 0...16) {
							__uniformMatrix[i] = 0;
						}
						gl.uniformMatrix4fv (index, false, __uniformMatrix);
					
					default:
					
				}
				
			}
			
		} else {
			
			if (!__useArray && (value == null || value.length == __length)) {
				
				for (i in 0...__arrayLength) {
					
					gl.disableVertexAttribArray (index + i);
					
				}
				
				if (value != null) {
					
					switch (type) {
						
						case BOOL: gl.vertexAttrib1f (index, boolValue[0] ? 1 : 0);
						case BOOL2: gl.vertexAttrib2f (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
						case BOOL3: gl.vertexAttrib3f (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
						case BOOL4: gl.vertexAttrib4f (index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
						case FLOAT: gl.vertexAttrib1f (index, floatValue[0]);
						case FLOAT2: gl.vertexAttrib2f (index, floatValue[0], floatValue[1]);
						case FLOAT3: gl.vertexAttrib3f (index, floatValue[0], floatValue[1], floatValue[2]);
						case FLOAT4: gl.vertexAttrib4f (index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);
						
						case MATRIX2X2:
							for (i in 0...2) {
								gl.vertexAttrib2f (index + i, floatValue[i * 2], floatValue[i * 2 + 1]);
							}
						
						case MATRIX3X3:
							for (i in 0...3) {
								gl.vertexAttrib3f (index + i, floatValue[i * 3], floatValue[i * 3 + 1], floatValue[i * 3 + 2]);
							}
						
						case MATRIX4X4:
							for (i in 0...4) {
								gl.vertexAttrib4f (index + i, floatValue[i * 4], floatValue[i * 4 + 1], floatValue[i * 4 + 2], floatValue[i * 4 + 3]);
							}
						
						case INT: gl.vertexAttrib1f (index, intValue[0]);
						case INT2: gl.vertexAttrib2f (index, intValue[0], intValue[1]);
						case INT3: gl.vertexAttrib3f (index, intValue[0], intValue[1], intValue[2]);
						case INT4: gl.vertexAttrib4f (index, intValue[0], intValue[1], intValue[2], intValue[3]);
						default:
						
					}
					
				} else {
					
					switch (type) {
						
						case BOOL, FLOAT, INT: gl.vertexAttrib1f (index, 0);
						case BOOL2, FLOAT2, INT2: gl.vertexAttrib2f (index, 0, 0);
						case BOOL3, FLOAT3, INT3: gl.vertexAttrib3f (index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4: gl.vertexAttrib4f (index, 0, 0, 0, 0);
						
						case MATRIX2X2:
							for (i in 0...2) {
								gl.vertexAttrib2f (index + i, 0, 0);
							}
						
						case MATRIX3X3:
							for (i in 0...3) {
								gl.vertexAttrib3f (index + i, 0, 0, 0);
							}
						
						case MATRIX4X4:
							for (i in 0...4) {
								gl.vertexAttrib4f (index + i, 0, 0, 0, 0);
							}
						
						default:
						
					}
					
				}
			
			} else {
				
				for (i in 0...__arrayLength) {
					gl.enableVertexAttribArray (index + i);
				}
				
			}
			
		}
		#end
		
	}
	
	
	@:noCompletion private function __updateGLFromBuffer (context:Context3D, buffer:#if lime Float32Array #else Dynamic #end, position:Int, length:Int, bufferOffset:Int):Void {
		
		#if lime
		var gl = context.gl;
		
		if (__isUniform) {
			
			if (length >= __length) {
				
				switch (type) {
					
					case BOOL, INT: gl.uniform1i (index, Std.int (buffer[position]));
					case BOOL2, INT2: gl.uniform2i (index, Std.int (buffer[position]), Std.int (buffer[position + 1]));
					case BOOL3, INT3: gl.uniform3i (index, Std.int (buffer[position]), Std.int (buffer[position + 1]), Std.int (buffer[position + 2]));
					case BOOL4, INT4: gl.uniform4i (index, Std.int (buffer[position]), Std.int (buffer[position + 1]), Std.int (buffer[position + 2]), Std.int (buffer[position + 3]));
					case FLOAT: gl.uniform1f (index, buffer[position]);
					case FLOAT2: gl.uniform2f (index, buffer[position], buffer[position + 1]);
					case FLOAT3: gl.uniform3f (index, buffer[position], buffer[position + 1], buffer[position + 2]);
					case FLOAT4: gl.uniform4f (index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);
					
					case MATRIX2X2:
						for (i in 0...4) {
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix2fv (index, false, __uniformMatrix);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						for (i in 0...9) {
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix3fv (index, false, __uniformMatrix);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						for (i in 0...16) {
							__uniformMatrix[i] = buffer[position + i];
						}
						gl.uniformMatrix4fv (index, false, __uniformMatrix);
					
					default:
					
				}
				
			}
			
		} else {
			
			if (!__internal && (length == 0 || length == __length)) {
				
				for (i in 0...__arrayLength) {
					
					gl.disableVertexAttribArray (index + i);
					
				}
				
				if (length > 0) {
					
					switch (type) {
						
						case BOOL, FLOAT, INT: gl.vertexAttrib1f (index, buffer[position]);
						case BOOL2, FLOAT2, INT2: gl.vertexAttrib2f (index, buffer[position], buffer[position + 1]);
						case BOOL3, FLOAT3, INT3: gl.vertexAttrib3f (index, buffer[position], buffer[position + 1], buffer[position + 2]);
						case BOOL4, FLOAT4, INT4: gl.vertexAttrib4f (index, buffer[position], buffer[position + 1], buffer[position + 2], buffer[position + 3]);
						
						case MATRIX2X2:
							for (i in 0...2) {
								gl.vertexAttrib2f (index + i, buffer[position + i * 2], buffer[position + i * 2 + 1]);
							}
						
						case MATRIX3X3:
							for (i in 0...3) {
								gl.vertexAttrib3f (index + i, buffer[position + i * 3], buffer[position + i * 3 + 1], buffer[position + i * 3 + 2]);
							}
						
						case MATRIX4X4:
							for (i in 0...4) {
								gl.vertexAttrib4f (index + i, buffer[position + i * 4], buffer[position + i * 4 + 1], buffer[position + i * 4 + 2], buffer[position + i * 4 + 3]);
							}
						
						default:
						
					}
					
				} else {
					
					switch (type) {
						
						case BOOL, FLOAT, INT: gl.vertexAttrib1f (index, 0);
						case BOOL2, FLOAT2, INT2: gl.vertexAttrib2f (index, 0, 0);
						case BOOL3, FLOAT3, INT3: gl.vertexAttrib3f (index, 0, 0, 0);
						case BOOL4, FLOAT4, INT4: gl.vertexAttrib4f (index, 0, 0, 0, 0);
						
						case MATRIX2X2:
							for (i in 0...2) {
								gl.vertexAttrib2f (index + i, 0, 0);
							}
						
						case MATRIX3X3:
							for (i in 0...3) {
								gl.vertexAttrib3f (index + i, 0, 0, 0);
							}
						
						case MATRIX4X4:
							for (i in 0...4) {
								gl.vertexAttrib4f (index + i, 0, 0, 0, 0);
							}
						
						default:
						
					}
					
				}
			
			} else {
				
				var type = gl.FLOAT;
				if (__isBool) type = gl.INT; //gl.BOOL;
				else if (__isInt) type = gl.INT;
				
				for (i in 0...__arrayLength) {
					
					gl.enableVertexAttribArray (index + i);
					
				}
				
				if (length > 0) {
					
					for (i in 0...__arrayLength) {
						
						gl.vertexAttribPointer (index + i, __length, type, false, __length * Float32Array.BYTES_PER_ELEMENT, (position + (bufferOffset * __length) + (i * __arrayLength)) * Float32Array.BYTES_PER_ELEMENT);
						
					}
					
				}
				
			}
			
		}
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function set_name (value:String):String {
		
		__internal = StringTools.startsWith (value, "openfl_");
		return this.name = value;
		
	}
	
	
}


#else
typedef ShaderParameter<T> = flash.display.ShaderParameter<T>;
#end