package openfl._internal.renderer.context3D;

import openfl._internal.utils.ObjectPool;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display.BitmapData)
class Context3DTexturePool
{
	// TODO: Use power of two and increase lifetime?
	private static inline var MAX_LIFETIME:Int = 2;

	private var __bitmapData:Map<Int, Map<Int, ObjectPool<BitmapData>>>;
	private var __bitmapDataAge:Map<BitmapData, Int>;
	private var __bitmapDataList:Array<BitmapData>;
	private var __context:Context3D;
	private var __textureAge:Map<TextureBase, Int>;
	private var __textureList:Array<TextureBase>;
	private var __rectangleTextures:Map<Int, Map<Int, ObjectPool<RectangleTexture>>>;

	public function new(context3D:Context3D)
	{
		__context = context3D;

		__bitmapData = new Map();
		__bitmapDataAge = new Map();
		__bitmapDataList = new Array();
		__textureAge = new Map();
		__textureList = new Array();
		__rectangleTextures = new Map();
	}

	public function enterFrame():Void
	{
		for (bitmapData in __bitmapDataList)
		{
			var age = __bitmapDataAge[bitmapData];
			if (age >= MAX_LIFETIME)
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

		for (texture in __textureList)
		{
			var age = __textureAge[texture];
			if (age >= MAX_LIFETIME)
			{
				__rectangleTextures[texture.__width][texture.__height].remove(cast texture);
				texture.dispose();
				__textureAge.remove(texture);
				__textureList.remove(texture);
			}
			else if (age > -1)
			{
				__textureAge[texture] = age + 1;
			}
		}
	}

	public function getBitmapData(width:Int, height:Int):BitmapData
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
		if (!__bitmapDataAge.exists(bitmapData))
		{
			__bitmapDataList.push(bitmapData);
		}
		__bitmapDataAge[bitmapData] = -1;

		return bitmapData;
	}

	public function getRectangleTexture(width:Int, height:Int):RectangleTexture
	{
		var heightMap = __rectangleTextures[width];
		if (heightMap == null)
		{
			heightMap = __rectangleTextures[width] = new Map();
		}

		var pool = heightMap[height];
		if (pool == null)
		{
			pool = heightMap[height] = new ObjectPool<RectangleTexture>(__context.createRectangleTexture.bind(width, height, BGRA, true));
		}

		var texture = pool.get();
		if (!__textureAge.exists(texture))
		{
			__textureList.push(texture);
		}
		__textureAge[texture] = -1;

		return texture;
	}

	public function releaseBitmapData(bitmapData:BitmapData):Void
	{
		if (__bitmapDataAge.exists(bitmapData))
		{
			__bitmapData[bitmapData.width][bitmapData.height].release(bitmapData);
			__bitmapDataAge[bitmapData] = 0;
		}
	}

	public function releaseRectangleTexture(texture:RectangleTexture):Void
	{
		if (__textureAge.exists(texture))
		{
			__rectangleTextures[texture.__width][texture.__height].release(texture);
			__textureAge[texture] = 0;
		}
	}

	private function __createBitmapData(width:Int, height:Int):BitmapData
	{
		var texture = __context.createRectangleTexture(width, height, BGRA, true);
		var bitmapData = BitmapData.fromTexture(texture);
		bitmapData.__setUVRect(__context, 0, 0, width, height);
		return bitmapData;
	}

	private function __cleanBitmapData(bitmapData:BitmapData):Void
	{
		bitmapData.fillRect(bitmapData.rect, 0);
	}
}
