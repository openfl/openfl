package openfl._internal.renderer;

import openfl._internal.utils.ObjectPool;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
class BitmapDataPool
{
	private var __bitmapData:Map<Int, Map<Int, ObjectPool<BitmapData>>>;
	private var __bitmapDataAge:Map<BitmapData, Int>;
	private var __bitmapDataList:Array<BitmapData>;
	private var __context:Context3D;
	private var __lifetime:Int;

	public function new(lifetime:Int = 2, context3D:Context3D = null)
	{
		__lifetime = lifetime;
		__context = context3D;

		__bitmapData = new Map();
		__bitmapDataAge = new Map();
		__bitmapDataList = new Array();
	}

	public function cleanup():Void
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

	public function get(width:Int, height:Int):BitmapData
	{
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

	public function release(bitmapData:BitmapData):Void
	{
		if (__bitmapDataAge.exists(bitmapData))
		{
			__bitmapData[bitmapData.width][bitmapData.height].release(bitmapData);
			__bitmapDataAge[bitmapData] = 0;
		}
	}

	private function __cleanBitmapData(bitmapData:BitmapData):Void
	{
		bitmapData.fillRect(bitmapData.rect, 0);
	}

	private function __createBitmapData(width:Int, height:Int):BitmapData
	{
		if (__context != null)
		{
			var texture = __context.createRectangleTexture(width, height, BGRA, true);
			var bitmapData = BitmapData.fromTexture(texture);
			// bitmapData.__setUVRect(__context, 0, 0, width, height);
			return bitmapData;
		}
		else
		{
			return new BitmapData(width, height, true, 0);
		}
	}
}
