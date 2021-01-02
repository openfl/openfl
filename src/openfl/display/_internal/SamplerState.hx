package openfl.display._internal;

import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class SamplerState
{
	public var centroid:Bool;
	public var filter:Context3DTextureFilter;
	public var ignoreSampler:Bool;
	public var lodBias:Float;
	public var mipfilter:Context3DMipFilter;
	public var mipmapGenerated:Bool;
	public var textureAlpha:Bool;
	public var wrap:Context3DWrapMode;

	public function new(wrap:Context3DWrapMode = CLAMP, filter:Context3DTextureFilter = NEAREST, mipfilter:Context3DMipFilter = MIPNONE, lodBias:Float = 0.0,
			ignoreSampler:Bool = false, centroid:Bool = false, textureAlpha:Bool = false)
	{
		this.wrap = wrap;
		this.filter = filter;
		this.mipfilter = mipfilter;
		this.lodBias = lodBias;
		this.ignoreSampler = ignoreSampler;
		this.centroid = centroid;
		this.textureAlpha = textureAlpha;
	}

	public function clone():SamplerState
	{
		var copy = new SamplerState(wrap, filter, mipfilter, lodBias, ignoreSampler, centroid, textureAlpha);
		copy.mipmapGenerated = mipmapGenerated;
		return copy;
	}

	public function copyFrom(other:SamplerState):Void
	{
		if (other == null || other.ignoreSampler) return;

		this.wrap = other.wrap;
		this.filter = other.filter;
		this.mipfilter = other.mipfilter;
		this.lodBias = other.lodBias;
		this.centroid = other.centroid;
		this.textureAlpha = other.textureAlpha;
	}

	public function equals(other:SamplerState):Bool
	{
		if (other == null)
		{
			return false;
		}

		return (wrap == other.wrap && filter == other.filter && mipfilter == other.mipfilter && lodBias == other.lodBias && textureAlpha == other.textureAlpha);
	}
}
