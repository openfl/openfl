namespace openfl._internal.renderer;

import ObjectPool from "../_internal/utils/ObjectPool";
import Context3D from "../display3D/Context3D";
import BitmapData from "../display/BitmapData";

#if!openfl_debug
@: fileXml(' tags="haxe,release" ')
@: noDebug
#end
class BitmapDataPool
{
	private __bitmapData: Map<Int, Map<Int, ObjectPool<BitmapData>>>;
	private __bitmapDataAge: Map<BitmapData, Int>;
	private __bitmapDataList: Array<BitmapData>;
	private __context: Context3D;
	private __lifetime: number;

	public constructor(lifetime: number = 2, context3D: Context3D = null)
	{
		__lifetime = lifetime;
		__context = context3D;

		__bitmapData = new Map();
		__bitmapDataAge = new Map();
		__bitmapDataList = new Array();
	}

	public cleanup(): void
	{
		for (bitmapData in __bitmapDataList)
		{
			var age = __bitmapDataAge[bitmapData];
			if (age >= __lifetime)
			{
				__bitmapData[bitmapData.width][bitmapData.height].remove(bitmapData);
				bitmapData.dispose();
				__bitmapDataAge.remove(bitmapData);
				__bitmapDataList.remove(bitmapData);
			}
			else if (age > -1)
			{
				__bitmapDataAge[bitmapData] = age + 1;
			}
		}
	}

	public get(width: number, height: number): BitmapData
	{
		#if openfl_power_of_two
		width = __powerOfTwo(width);
		height = __powerOfTwo(height);
		#end

		var heightMap = __bitmapData[width];
		if (heightMap == null)
		{
			heightMap = __bitmapData[width] = new Map();
		}

		var pool = heightMap[height];
		if (pool == null)
		{
			pool = heightMap[height] = new ObjectPool<BitmapData>(__createBitmapData.bind(width, height), __cleanBitmapData);
		}

		var bitmapData = pool.get();

		if (bitmapData == null) return null;

		if (!__bitmapDataAge.exists(bitmapData))
		{
			__bitmapDataList.push(bitmapData);
		}
		__bitmapDataAge[bitmapData] = -1;

		return bitmapData;
	}

	public release(bitmapData: BitmapData): void
	{
		if (__bitmapDataAge.exists(bitmapData))
		{
			__bitmapData[bitmapData.width][bitmapData.height].release(bitmapData);
			__bitmapDataAge[bitmapData] = 0;
		}
	}

	private __cleanBitmapData(bitmapData: BitmapData): void
	{
		bitmapData.fillRect(bitmapData.rect, 0);
	}

	private __createBitmapData(width: number, height: number): BitmapData
	{
		if (__context != null)
		{
			var texture = __context.createRectangleTexture(width, height, BGRA, true);
			var bitmapData = BitmapData.fromTexture(texture);
			// bitmapData.setUVRect(__context, 0, 0, width, height);
			return bitmapData;
		}
		else
		{
			return new BitmapData(width, height, true, 0);
		}
	}

	private inline __powerOfTwo(value: number): number
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}
}
