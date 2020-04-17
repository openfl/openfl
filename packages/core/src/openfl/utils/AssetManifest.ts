import AssetType from "../utils/AssetType";
import ByteArray from "../utils/ByteArray";
import Future from "../utils/Future";

export default class AssetManifest
{
	private assets: Array<Object>;

	public constructor()
	{
	}

	public addBitmapData(path: string, id: string = null): void
	{
		this.assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.IMAGE,
			preload: true
		});
	}

	public addBytes(path: string, id: string = null): void
	{
		this.assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.BINARY,
			preload: true
		});
	}

	public addFont(name: string, id: string = null): void
	{
		this.assets.push({
			path: name,
			id: (id != null ? id : name),
			type: AssetType.FONT,
			preload: true
		});
	}

	public addSound(paths: Array<String>, id: string = null): void
	{
		this.assets.push({
			pathGroup: paths,
			id: (id != null ? id : paths[0]),
			type: AssetType.SOUND,
			preload: true
		});
	}

	public addText(path: string, id: string = null): void
	{
		this.assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.TEXT,
			preload: true
		});
	}

	public static fromBytes(bytes: ByteArray, rootPath: string = null): AssetManifest
	{
		return null;
	}

	public static fromFile(path: string, rootPath: string = null): AssetManifest
	{
		return null;
	}

	public static loadFromBytes(bytes: ByteArray, rootPath: string = null): Future<AssetManifest>
	{
		return null;
	}

	public static loadFromFile(path: string, rootPath: string = null): Future<AssetManifest>
	{
		return null;
	}

	public static parse(data: string, rootPath: string = null): AssetManifest
	{
		return null;
	}
}
