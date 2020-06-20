package xfl;

import openfl._internal.formats.xfl.XFL;
import openfl.display.BitmapData;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl.media.Sound;

/**
 * XFL assets class
 */
class XFLAssets
{
	private static var instance:XFLAssets = null;

	private var xfl:XFL;

	public static function getInstance():XFLAssets
	{
		if (instance == null)
		{
			instance = new XFLAssets();
		}
		return instance;
	}

	public function setup(paths:Array<String>, customSymbolLoader:XFLCustomSymbolLoader = null)
	{
		xfl = new XFL(paths, customSymbolLoader);
	}

	/**
	 * Private constructor
	 */
	private function new()
	{
		this.xfl = null;
	}

	/**
	 *  Get XML asset
	 *  @param asset name
	 *  @return haxe.xml.Fast
	 */
	public function getXFLXMLAsset(assetName:String):haxe.xml.Fast
	{
		return openfl._internal.formats.xfl.getXMLData(assetName);
	}

	/**
	 *  Get XFL symbol arguments
	 *  @param asset name
	 *  @return XFLSymbolArguments
	 */
	public function createXFLSymbolArguments(assetName:String):XFLSymbolArguments
	{
		return openfl._internal.formats.xfl.createSymbolArguments(assetName);
	}

	/**
	 *  Get XFL movie clip asset
	 *  @param asset name
	 *  @return XFLMovieClip
	 */
	public function getXFLMovieClipAsset(assetName:String):XFLMovieClip
	{
		return openfl._internal.formats.xfl.createMovieClip(assetName);
	}

	/**
	 *  Get XFL sprite asset
	 *  @param asset name
	 *  @return XFLSprite
	 */
	public function getXFLSpriteAsset(assetName:String):XFLSprite
	{
		return openfl._internal.formats.xfl.createSprite(assetName);
	}

	/**
	 *  Get XFL bitmap asset
	 *  @param asset name
	 *  @return BitmapData
	 */
	public function getXFLBitmapDataAsset(assetName:String):BitmapData
	{
		return openfl._internal.formats.xfl.getBitmapData(assetName);
	}

	/**
	 *  Get XFL bitmap asset by path
	 *  @param asset path
	 *  @return BitmapData
	 */
	public function getXFLBitmapDataAssetByPath(assetPath:String):BitmapData
	{
		return openfl._internal.formats.xfl.getBitmapDataByPath(assetPath);
	}

	/**
	 *  Get XFL sound asset
	 *  @param asset name
	 *  @return Sound
	 */
	public function getXFLSoundAsset(assetName:String):Sound
	{
		return openfl._internal.formats.xfl.getSound(assetName);
	}
}
