namespace openfl._internal.backend.lime_standalone;

#if(false && openfl_html5)
import haxe.macro.Compiler;

class AssetCache
{
	public audio: Map<string, AudioBuffer>;
	public enabled: boolean = true;
	public image: Map<string, Image>;
	public font: Map<string, Dynamic /*Font*/>;
	public version: number;

	public constructor()
	{
		audio = new Map<string, AudioBuffer>();
		font = new Map<string, Dynamic /*Font*/>();
		image = new Map<string, Image>();

		#if(macro || commonjs || lime_disable_assets_version)
		version = 0;
		#elseif lime_assets_version
		version = Std.parseInt(Compiler.getDefine("lime-assets-version"));
		#else
		version = AssetsMacro.cacheVersion();
		#end
	}

	public exists(id: string, ?type: AssetType): boolean
	{
		if (type == AssetType.IMAGE || type == null)
		{
			if (image.exists(id)) return true;
		}

		if (type == AssetType.FONT || type == null)
		{
			if (font.exists(id)) return true;
		}

		if (type == AssetType.SOUND || type == AssetType.MUSIC || type == null)
		{
			if (audio.exists(id)) return true;
		}

		return false;
	}

	public set(id: string, type: AssetType, asset: Dynamic): void
	{
		switch (type)
		{
			case FONT:
				font.set(id, asset);

			case IMAGE:
				if (!Std.is(asset, Image)) throw "Cannot cache non-Image asset: " + asset + " as Image";

				image.set(id, asset);

			case SOUND, MUSIC:
				if (!Std.is(asset, AudioBuffer)) throw "Cannot cache non-AudioBuffer asset: " + asset + " as AudioBuffer";

				audio.set(id, asset);

			default:
				throw type + " assets are not cachable";
		}
	}

	public clear(prefix: string = null): void
	{
		if (prefix == null)
		{
			audio = new Map<string, AudioBuffer>();
			font = new Map<string, Dynamic /*Font*/>();
			image = new Map<string, Image>();
		}
		else
		{
			var keys = audio.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					audio.remove(key);
				}
			}

			var keys = font.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					font.remove(key);
				}
			}

			var keys = image.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					image.remove(key);
				}
			}
		}
	}
}
#end
