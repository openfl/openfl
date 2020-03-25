namespace openfl._internal.renderer;

import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class SamplerState
{
	public centroid: boolean;
	public filter: Context3DTextureFilter;
	public ignoreSampler: boolean;
	public lodBias: number;
	public mipfilter: Context3DMipFilter;
	public mipmapGenerated: boolean;
	public textureAlpha: boolean;
	public wrap: Context3DWrapMode;

	public new(wrap: Context3DWrapMode = CLAMP, filter: Context3DTextureFilter = NEAREST, mipfilter: Context3DMipFilter = MIPNONE, lodBias: number = 0.0,
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
		var copy = new SamplerState(wrap, filter, mipfilter, lodBias, ignoreSampler, centroid, textureAlpha);
		copy.mipmapGenerated = mipmapGenerated;
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

		return (wrap == other.wrap && filter == other.filter && mipfilter == other.mipfilter && lodBias == other.lodBias && textureAlpha == other.textureAlpha);
	}
}
