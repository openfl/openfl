import ObjectPool from "../../_internal/utils/ObjectPool";
import BitmapData from "../../display/BitmapData";
import Context3D from "../../display3D/Context3D";
import Context3DTextureFormat from "../../display3D/Context3DTextureFormat";

export default class BitmapDataPool
{
	private __bitmapData: Map<number, Map<number, ObjectPool<BitmapData>>>;
	private __bitmapDataAge: Map<BitmapData, number>;
	private __bitmapDataList: Array<BitmapData>;
	private __context: Context3D;
	private __lifetime: number;

	public constructor(lifetime: number = 2, context3D: Context3D = null)
	{
		this.__lifetime = lifetime;
		this.__context = context3D;

		this.__bitmapData = new Map();
		this.__bitmapDataAge = new Map();
		this.__bitmapDataList = new Array();
	}

	public cleanup(): void
	{
		for (let bitmapData of this.__bitmapDataList)
		{
			var age = this.__bitmapDataAge.get(bitmapData);
			if (age >= this.__lifetime)
			{
				this.__bitmapData[bitmapData.width][bitmapData.height].remove(bitmapData);
				bitmapData.dispose();
				this.__bitmapDataAge.delete(bitmapData);
				var index = this.__bitmapDataList.indexOf(bitmapData);
				if (index > -1) this.__bitmapDataList.splice(index, 1);
			}
			else if (age > -1)
			{
				this.__bitmapDataAge.set(bitmapData, age + 1);
			}
		}
	}

	public get(width: number, height: number): BitmapData
	{
		// #if openfl_power_of_two
		// width = __powerOfTwo(width);
		// height = __powerOfTwo(height);
		// #end

		var heightMap = this.__bitmapData[width];
		if (heightMap == null)
		{
			heightMap = this.__bitmapData[width] = new Map();
		}

		var pool = heightMap[height];
		if (pool == null)
		{
			pool = heightMap[height] = new ObjectPool<BitmapData>(() => this.__createBitmapData(width, height), this.__cleanBitmapData);
		}

		var bitmapData = pool.get();

		if (bitmapData == null) return null;

		if (!this.__bitmapDataAge.has(bitmapData))
		{
			this.__bitmapDataList.push(bitmapData);
		}
		this.__bitmapDataAge[bitmapData] = -1;

		return bitmapData;
	}

	public release(bitmapData: BitmapData): void
	{
		if (this.__bitmapDataAge.has(bitmapData))
		{
			this.__bitmapData[bitmapData.width][bitmapData.height].release(bitmapData);
			this.__bitmapDataAge.set(bitmapData, 0);
		}
	}

	private __cleanBitmapData(bitmapData: BitmapData): void
	{
		bitmapData.fillRect(bitmapData.rect, 0);
	}

	private __createBitmapData(width: number, height: number): BitmapData
	{
		if (this.__context != null)
		{
			var texture = this.__context.createRectangleTexture(width, height, Context3DTextureFormat.BGRA, true);
			var bitmapData = BitmapData.fromTexture(texture);
			// bitmapData.setUVRect(__context, 0, 0, width, height);
			return bitmapData;
		}
		else
		{
			return new BitmapData(width, height, true, 0);
		}
	}

	// private __powerOfTwo(value: number): number
	// {
	// 	var newValue = 1;
	// 	while (newValue < value)
	// 	{
	// 		newValue <<= 1;
	// 	}
	// 	return newValue;
	// }
}
