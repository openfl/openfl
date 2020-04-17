import * as internal from "../../_internal/utils/InternalAccess";
import Context3DMipFilter from "../../display3D/Context3DMipFilter";
import Context3DTextureFilter from "../../display3D/Context3DTextureFilter";
import Context3DWrapMode from "../../display3D/Context3DWrapMode";
import BitmapData from "../../display/BitmapData";
import GraphicsShader from "../../display/GraphicsShader";
import ShaderInput from "../../display/ShaderInput";
import ShaderParameter from "../../display/ShaderParameter";

export default class ShaderBuffer
{
	public inputCount: number;
	public inputRefs: Array<ShaderInput<BitmapData>>;
	public inputFilter: Array<Context3DTextureFilter>;
	public inputMipFilter: Array<Context3DMipFilter>;
	public inputs: Array<BitmapData>;
	public inputWrap: Array<Context3DWrapMode>;
	public overrideBoolCount: number;
	public overrideBoolNames: Array<string>;
	public overrideBoolValues: Array<Array<boolean>>;
	// public overrideCount:Int;
	public overrideFloatCount: number;
	public overrideFloatNames: Array<string>;
	public overrideFloatValues: Array<Array<number>>;
	public overrideIntCount: number;
	public overrideIntNames: Array<string>;
	public overrideIntValues: Array<Array<number>>;
	// public overrideNames:Array<string>;
	// public overrideValues:Array<Array<Dynamic>>;
	public paramBoolCount: number;
	public paramCount: number;
	public paramData: Float32Array;
	public paramDataBuffer: WebGLBuffer;
	public paramDataLength: number;
	public paramFloatCount: number;
	public paramIntCount: number;
	public paramLengths: Array<number>;
	public paramPositions: Array<number>;
	public paramRefs_Bool: Array<ShaderParameter<boolean>>;
	public paramRefs_Float: Array<ShaderParameter<number>>;
	public paramRefs_Int: Array<ShaderParameter<number>>;
	public paramTypes: Array<number>;
	public shader: GraphicsShader;

	public constructor()
	{
		this.inputRefs = [];
		this.inputFilter = [];
		this.inputMipFilter = [];
		this.inputs = [];
		this.inputWrap = [];
		// overrideNames = [];
		// overrideValues = [];
		this.overrideIntNames = [];
		this.overrideIntValues = [];
		this.overrideFloatNames = [];
		this.overrideFloatValues = [];
		this.overrideBoolNames = [];
		this.overrideBoolValues = [];
		this.paramLengths = [];
		this.paramPositions = [];
		this.paramRefs_Bool = [];
		this.paramRefs_Float = [];
		this.paramRefs_Int = [];
		this.paramTypes = [];
	}

	public addBoolOverride(name: string, values: Array<boolean>): void
	{
		this.overrideBoolNames[this.overrideBoolCount] = name;
		this.overrideBoolValues[this.overrideBoolCount] = values;
		this.overrideBoolCount++;
	}

	public addFloatOverride(name: string, values: Array<number>): void
	{
		this.overrideFloatNames[this.overrideFloatCount] = name;
		this.overrideFloatValues[this.overrideFloatCount] = values;
		this.overrideFloatCount++;
	}

	public addIntOverride(name: string, values: Array<number>): void
	{
		this.overrideIntNames[this.overrideIntCount] = name;
		this.overrideIntValues[this.overrideIntCount] = values;
		this.overrideIntCount++;
	}

	public clearOverride(): void
	{
		// overrideCount = 0;
		this.overrideIntCount = 0;
		this.overrideFloatCount = 0;
		this.overrideBoolCount = 0;
	}

	public update(shader: GraphicsShader): void
	{
		this.inputCount = 0;
		// overrideCount = 0;
		this.overrideIntCount = 0;
		this.overrideFloatCount = 0;
		this.overrideBoolCount = 0;
		this.paramBoolCount = 0;
		this.paramCount = 0;
		this.paramDataLength = 0;
		this.paramFloatCount = 0;
		this.paramIntCount = 0;
		this.shader = null;

		if (shader == null) return;

		(<internal.Shader><any>shader).__init();

		this.inputCount = (<internal.Shader><any>shader).__inputBitmapData.length;
		var input;

		for (let i = 0; i < this.inputCount; i++)
		{
			input = (<internal.Shader><any>shader).__inputBitmapData[i];
			this.inputs[i] = input.input;
			this.inputFilter[i] = input.filter;
			this.inputMipFilter[i] = input.mipFilter;
			this.inputRefs[i] = input;
			this.inputWrap[i] = input.wrap;
		}

		var boolCount = (<internal.Shader><any>shader).__paramBool.length;
		var floatCount = (<internal.Shader><any>shader).__paramFloat.length;
		var intCount = (<internal.Shader><any>shader).__paramInt.length;
		this.paramCount = boolCount + floatCount + intCount;
		this.paramBoolCount = boolCount;
		this.paramFloatCount = floatCount;
		this.paramIntCount = intCount;

		var length: number = 0, p = 0;
		var param;

		for (let i = 0; i < boolCount; i++)
		{
			param = (<internal.Shader><any>shader).__paramBool[i];

			this.paramPositions[p] = this.paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			this.paramLengths[p] = length;
			this.paramDataLength += length;
			this.paramTypes[p] = 0;

			this.paramRefs_Bool[i] = param;
			p++;
		}

		var param;

		for (let i = 0; i < floatCount; i++)
		{
			param = (<internal.Shader><any>shader).__paramFloat[i];

			this.paramPositions[p] = this.paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			this.paramLengths[p] = length;
			this.paramDataLength += length;
			this.paramTypes[p] = 1;

			this.paramRefs_Float[i] = param;
			p++;
		}

		var param;

		for (let i = 0; i < intCount; i++)
		{
			param = (<internal.Shader><any>shader).__paramInt[i];

			this.paramPositions[p] = this.paramDataLength;
			length = (param.value != null ? param.value.length : 0);
			this.paramLengths[p] = length;
			this.paramDataLength += length;
			this.paramTypes[p] = 2;

			this.paramRefs_Int[i] = param;
			p++;
		}

		if (this.paramDataLength > 0)
		{
			if (this.paramData == null)
			{
				this.paramData = new Float32Array(this.paramDataLength);
			}
			else if (this.paramDataLength > this.paramData.length)
			{
				var data = new Float32Array(this.paramDataLength);
				data.set(this.paramData);
				this.paramData = data;
			}
		}

		var boolIndex = 0;
		var floatIndex = 0;
		var intIndex = 0;

		var paramPosition: number = 0;
		var boolParam, floatParam, intParam;

		for (let i = 0; i < this.paramCount; i++)
		{
			length = this.paramLengths[i];

			if (i < boolCount)
			{
				boolParam = this.paramRefs_Bool[boolIndex];
				boolIndex++;

				for (let j = 0; j < length; j++)
				{
					this.paramData[paramPosition] = boolParam.value[j] ? 1 : 0;
					paramPosition++;
				}
			}
			else if (i < boolCount + floatCount)
			{
				floatParam = this.paramRefs_Float[floatIndex];
				floatIndex++;

				for (let j = 0; j < length; j++)
				{
					this.paramData[paramPosition] = floatParam.value[j];
					paramPosition++;
				}
			}
			else
			{
				intParam = this.paramRefs_Int[intIndex];
				intIndex++;

				for (let j = 0; j < length; j++)
				{
					this.paramData[paramPosition] = intParam.value[j];
					paramPosition++;
				}
			}
		}

		this.shader = shader;
	}
}
