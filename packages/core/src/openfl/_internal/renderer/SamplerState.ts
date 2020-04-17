import Context3DMipFilter from "../../display3D/Context3DMipFilter";
import Context3DTextureFilter from "../../display3D/Context3DTextureFilter";
import Context3DWrapMode from "../../display3D/Context3DWrapMode";

export default class SamplerState
{
	public centroid: boolean;
	public filter: Context3DTextureFilter;
	public ignoreSampler: boolean;
	public lodBias: number;
	public mipfilter: Context3DMipFilter;
	public mipmapGenerated: boolean;
	public textureAlpha: boolean;
	public wrap: Context3DWrapMode;

	public constructor(wrap: Context3DWrapMode = Context3DWrapMode.CLAMP, filter: Context3DTextureFilter = Context3DTextureFilter.NEAREST, mipfilter: Context3DMipFilter = Context3DMipFilter.MIPNONE, lodBias: number = 0.0,
		ignoreSampler: boolean = false, centroid: boolean = false, textureAlpha: boolean = false)
	{
		this.wrap = wrap;
		this.filter = filter;
		this.mipfilter = mipfilter;
		this.lodBias = lodBias;
		this.ignoreSampler = ignoreSampler;
		this.centroid = centroid;
		this.textureAlpha = textureAlpha;
	}

	public clone(): SamplerState
	{
		var copy = new SamplerState(this.wrap, this.filter, this.mipfilter, this.lodBias, this.ignoreSampler, this.centroid, this.textureAlpha);
		copy.mipmapGenerated = this.mipmapGenerated;
		return copy;
	}

	public copyFrom(other: SamplerState): void
	{
		if (other == null || other.ignoreSampler) return;

		this.wrap = other.wrap;
		this.filter = other.filter;
		this.mipfilter = other.mipfilter;
		this.lodBias = other.lodBias;
		this.centroid = other.centroid;
		this.textureAlpha = other.textureAlpha;
	}

	public equals(other: SamplerState): boolean
	{
		if (other == null)
		{
			return false;
		}

		return (this.wrap == other.wrap && this.filter == other.filter && this.mipfilter == other.mipfilter && this.lodBias == other.lodBias && this.textureAlpha == other.textureAlpha);
	}
}
