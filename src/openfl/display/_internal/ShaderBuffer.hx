package openfl.display._internal;

import openfl.display3D._internal.GLBuffer;
import openfl.utils._internal.Float32Array;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display.BitmapData;
import openfl.display.GraphicsShader;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Shader)
@SuppressWarnings("checkstyle:FieldDocComment")
class ShaderBuffer
{
	public var inputCount:Int;
	public var inputRefs:Array<ShaderInput<BitmapData>>;
	public var inputFilter:Array<Context3DTextureFilter>;
	public var inputMipFilter:Array<Context3DMipFilter>;
	public var inputs:Array<BitmapData>;
	public var inputWrap:Array<Context3DWrapMode>;
	public var overrideBoolCount:Int;
	public var overrideBoolNames:Array<String>;
	public var overrideBoolValues:Array<Array<Bool>>;
	// public var overrideCount:Int;
	public var overrideFloatCount:Int;
	public var overrideFloatNames:Array<String>;
	public var overrideFloatValues:Array<Array<Float>>;
	public var overrideIntCount:Int;
	public var overrideIntNames:Array<String>;
	@SuppressWarnings("checkstyle:Dynamic") public var overrideIntValues:Array<Array<Dynamic>>;
	// public var overrideNames:Array<String>;
	// public var overrideValues:Array<Array<Dynamic>>;
	public var paramBoolCount:Int;
	public var paramCount:Int;
	public var paramData:Float32Array;
	public var paramDataBuffer:GLBuffer;
	public var paramDataLength:Int;
	public var paramFloatCount:Int;
	public var paramIntCount:Int;
	public var paramLengths:Array<Int>;
	public var paramPositions:Array<Int>;
	public var paramRefs_Bool:Array<ShaderParameter<Bool>>;
	public var paramRefs_Float:Array<ShaderParameter<Float>>;
	public var paramRefs_Int:Array<ShaderParameter<Int>>;
	public var paramTypes:Array<Int>;
	public var shader:GraphicsShader;

	public function new()
	{
		inputRefs = [];
		inputFilter = [];
		inputMipFilter = [];
		inputs = [];
		inputWrap = [];
		// overrideNames = [];
		// overrideValues = [];
		overrideIntNames = [];
		overrideIntValues = [];
		overrideFloatNames = [];
		overrideFloatValues = [];
		overrideBoolNames = [];
		overrideBoolValues = [];
		paramLengths = [];
		paramPositions = [];
		paramRefs_Bool = [];
		paramRefs_Float = [];
		paramRefs_Int = [];
		paramTypes = [];
	}

	public function addBoolOverride(name:String, values:Array<Bool>):Void
	{
		overrideBoolNames[overrideBoolCount] = name;
		overrideBoolValues[overrideBoolCount] = values;
		overrideBoolCount++;
	}

	public function addFloatOverride(name:String, values:Array<Float>):Void
	{
		overrideFloatNames[overrideFloatCount] = name;
		overrideFloatValues[overrideFloatCount] = values;
		overrideFloatCount++;
	}

	public function addIntOverride(name:String, values:Array<Int>):Void
	{
		overrideIntNames[overrideIntCount] = name;
		overrideIntValues[overrideIntCount] = values;
		overrideIntCount++;
	}

	public function clearOverride():Void
	{
		// overrideCount = 0;
		overrideIntCount = 0;
		overrideFloatCount = 0;
		overrideBoolCount = 0;
	}

	public function update(shader:GraphicsShader):Void
	{
		#if lime
		inputCount = 0;
		// overrideCount = 0;
		overrideIntCount = 0;
		overrideFloatCount = 0;
		overrideBoolCount = 0;
		paramBoolCount = 0;
		paramCount = 0;
		paramDataLength = 0;
		paramFloatCount = 0;
		paramIntCount = 0;
		this.shader = null;

		if (shader == null) return;

		shader.__init();

		inputCount = shader.__inputBitmapData.length;
		var input;

		for (i in 0...inputCount)
		{
			input = shader.__inputBitmapData[i];
			inputs[i] = input.input;
			inputFilter[i] = input.filter;
			inputMipFilter[i] = input.mipFilter;
			inputRefs[i] = input;
			inputWrap[i] = input.wrap;
		}

		var boolCount = shader.__paramBool.length;
		var floatCount = shader.__paramFloat.length;
		var intCount = shader.__paramInt.length;
		paramCount = boolCount + floatCount + intCount;
		paramBoolCount = boolCount;
		paramFloatCount = floatCount;
		paramIntCount = intCount;

		var length = 0, p = 0;
		var param;

		for (i in 0...boolCount)
		{
			param = shader.__paramBool[i];

			paramPositions[p] = paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			paramLengths[p] = length;
			paramDataLength += length;
			paramTypes[p] = 0;

			paramRefs_Bool[i] = param;
			p++;
		}

		var param;

		for (i in 0...floatCount)
		{
			param = shader.__paramFloat[i];

			paramPositions[p] = paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			paramLengths[p] = length;
			paramDataLength += length;
			paramTypes[p] = 1;

			paramRefs_Float[i] = param;
			p++;
		}

		var param;

		for (i in 0...intCount)
		{
			param = shader.__paramInt[i];

			paramPositions[p] = paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			paramLengths[p] = length;
			paramDataLength += length;
			paramTypes[p] = 2;

			paramRefs_Int[i] = param;
			p++;
		}

		if (paramDataLength > 0)
		{
			if (paramData == null)
			{
				paramData = new Float32Array(paramDataLength);
			}
			else if (paramDataLength > paramData.length)
			{
				var data = new Float32Array(paramDataLength);
				data.set(paramData);
				paramData = data;
			}
		}

		var boolIndex = 0;
		var floatIndex = 0;
		var intIndex = 0;

		var paramPosition:Int = 0;
		var boolParam, floatParam, intParam, length;

		for (i in 0...paramCount)
		{
			length = paramLengths[i];

			if (i < boolCount)
			{
				boolParam = paramRefs_Bool[boolIndex];
				boolIndex++;

				for (j in 0...length)
				{
					paramData[paramPosition] = boolParam.value[j] ? 1 : 0;
					paramPosition++;
				}
			}
			else if (i < boolCount + floatCount)
			{
				floatParam = paramRefs_Float[floatIndex];
				floatIndex++;

				for (j in 0...length)
				{
					paramData[paramPosition] = floatParam.value[j];
					paramPosition++;
				}
			}
			else
			{
				intParam = paramRefs_Int[intIndex];
				intIndex++;

				for (j in 0...length)
				{
					paramData[paramPosition] = intParam.value[j];
					paramPosition++;
				}
			}
		}

		this.shader = shader;
		#end
	}
}
