package openfl.display3D._internal.assembler;

import haxe.ds.StringMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SamplerMap
{
	public static var map(get, never):StringMap<Sampler>;
	private static var _map:StringMap<Sampler>;

	private static function get_map():StringMap<Sampler>
	{
		if (SamplerMap._map == null)
		{
			SamplerMap._map = new StringMap<Sampler>();
			SamplerMap._map.set("rgba", new Sampler(8, 0xf, 0));
			SamplerMap._map.set("rg", new Sampler(8, 0xf, 5));
			SamplerMap._map.set("r", new Sampler(8, 0xf, 4));
			SamplerMap._map.set("compressed", new Sampler(8, 0xf, 1));
			SamplerMap._map.set("compressed_alpha", new Sampler(8, 0xf, 2));
			SamplerMap._map.set("dxt1", new Sampler(8, 0xf, 1));
			SamplerMap._map.set("dxt5", new Sampler(8, 0xf, 2));
			// dimension
			SamplerMap._map.set("2d", new Sampler(12, 0xf, 0));
			SamplerMap._map.set("cube", new Sampler(12, 0xf, 1));
			SamplerMap._map.set("3d", new Sampler(12, 0xf, 2));
			// special
			SamplerMap._map.set("centroid", new Sampler(16, 1, 1));
			SamplerMap._map.set("ignoresampler", new Sampler(16, 4, 4));
			// repeat
			SamplerMap._map.set("clamp", new Sampler(20, 0xf, 0));
			SamplerMap._map.set("repeat", new Sampler(20, 0xf, 1));
			SamplerMap._map.set("wrap", new Sampler(20, 0xf, 1));
			// mip
			SamplerMap._map.set("nomip", new Sampler(24, 0xf, 0));
			SamplerMap._map.set("mipnone", new Sampler(24, 0xf, 0));
			SamplerMap._map.set("mipnearest", new Sampler(24, 0xf, 1));
			SamplerMap._map.set("miplinear", new Sampler(24, 0xf, 2));
			// filter
			SamplerMap._map.set("nearest", new Sampler(28, 0xf, 0));
			SamplerMap._map.set("linear", new Sampler(28, 0xf, 1));
		}

		return SamplerMap._map;
	}
}
