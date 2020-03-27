namespace openfl._internal.renderer;

import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display.BitmapData;
import openfl.display.GraphicsShader;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;


#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl._internal.backend.opengl) // TODO: Remove backend references
@: access(openfl.display.Shader)
@SuppressWarnings("checkstyle:FieldDocComment")
class ShaderBuffer
{
	public inputCount: number;
	public inputRefs: Array<ShaderInput<BitmapData>>;
	public inputFilter: Array<Context3DTextureFilter>;
	public inputMipFilter: Array<Context3DMipFilter>;
	public inputs: Array<BitmapData>;
	public inputWrap: Array<Context3DWrapMode>;
	public overrideBoolCount: number;
	public overrideBoolNames: Array<string>;
	public overrideBoolValues: Array<Array<Bool>>;
	// public overrideCount:Int;
	public overrideFloatCount: number;
	public overrideFloatNames: Array<string>;
	public overrideFloatValues: Array<Array<Float>>;
	public overrideIntCount: number;
	public overrideIntNames: Array<string>;
	@SuppressWarnings("checkstyle:Dynamic") public overrideIntValues: Array<Array<Dynamic>>;
	// public overrideNames:Array<string>;
	// public overrideValues:Array<Array<Dynamic>>;
	public paramBoolCount: number;
	public paramCount: number;
	public paramData: Float32Array;
	public paramDataBuffer: GLBuffer;
	public paramDataLength: number;
	public paramFloatCount: number;
	public paramIntCount: number;
	public paramLengths: Array<Int>;
	public paramPositions: Array<Int>;
	public paramRefs_Bool: Array<ShaderParameter<Bool>>;
	public paramRefs_Float: Array<ShaderParameter<Float>>;
	public paramRefs_Int: Array<ShaderParameter<Int>>;
	public paramTypes: Array<Int>;
	public shader: GraphicsShader;

	public constructor()
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

	public addBoolOverride(name: string, values: Array<Bool>): void
	{
		overrideBoolNames[overrideBoolCount] = name;
		overrideBoolValues[overrideBoolCount] = values;
		overrideBoolCount++;
	}

	public addFloatOverride(name: string, values: Array<Float>): void
	{
		overrideFloatNames[overrideFloatCount] = name;
		overrideFloatValues[overrideFloatCount] = values;
		overrideFloatCount++;
	}

	public addIntOverride(name: string, values: Array<Int>): void
	{
		overrideIntNames[overrideIntCount] = name;
		overrideIntValues[overrideIntCount] = values;
		overrideIntCount++;
	}

	public clearOverride(): void
	{
		// overrideCount = 0;
		overrideIntCount = 0;
		overrideFloatCount = 0;
		overrideBoolCount = 0;
	}

	public update(shader: GraphicsShader): void
	{
		#if(lime || openfl_html5)
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

		inputCount = shader.__backend.inputBitmapData.length;
		var input;

		for (i in 0...inputCount)
		{
			input = shader.__backend.inputBitmapData[i];
			inputs[i] = input.input;
			inputFilter[i] = input.filter;
			inputMipFilter[i] = input.mipFilter;
			inputRefs[i] = input;
			inputWrap[i] = input.wrap;
		}

		var boolCount = shader.__backend.paramBool.length;
		var floatCount = shader.__backend.paramFloat.length;
		var intCount = shader.__backend.paramInt.length;
		paramCount = boolCount + floatCount + intCount;
		paramBoolCount = boolCount;
		paramFloatCount = floatCount;
		paramIntCount = intCount;

		var length = 0, p = 0;
		var param;

		for (i in 0...boolCount)
		{
			param = shader.__backend.paramBool[i];

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
			param = shader.__backend.paramFloat[i];

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
			param = shader.__backend.paramInt[i];

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

		var paramPosition: number = 0;
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
