namespace openfl._internal.backend.lime_standalone;

#if(false && openfl_html5)
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.zip.Reader;
import openfl.utils.Future;

class AssetBundle
{
	public data: Map<string, Bytes>;
	public paths: Array<string>;

	public new()
	{
		// compressed = new Map();
		data = new Map();
		paths = new Array();
	}

	public static fromBytes(bytes: Bytes): AssetBundle
	{
		var input = new BytesInput(bytes);
		return __extractBundle(input);
	}

	public static fromFile(path: string): AssetBundle
	{
		return null;
	}

	public static loadFromBytes(bytes: Bytes): Future<AssetBundle>
	{
		return Future.withValue(fromBytes(bytes));
	}

	public static loadFromFile(path: string): Future<AssetBundle>
	{
		return LimeBytes.loadFromFile(path).then(loadFromBytes);
	}

	protected static __extractBundle(input: Input): AssetBundle
	{
		var entries = Reader.readZip(input);

		var bundle = new AssetBundle();

		for (entry in entries)
		{
			if (entry.compressed)
			{
				var bytes: LimeBytes = entry.data;
				bundle.data.set(entry.fileName, bytes.decompress(DEFLATE));
			}
			else
			{
				bundle.data.set(entry.fileName, entry.data);
			}
			bundle.paths.push(entry.fileName);
		}

		return bundle;
	}
}
#end
