package xfl;

import openfl.Assets;
import openfl._internal.formats.xfl.dom.DOMBitmapItem;
import openfl._internal.formats.xfl.dom.DOMDocument;
import openfl._internal.formats.xfl.dom.DOMSoundItem;
import openfl._internal.formats.xfl.dom.DOMSymbolItem;
import openfl._internal.formats.xfl.dom.DOMTimeline;
import openfl.display.BitmapData;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl.media.Sound;

class XFL
{
	public static var BITMAPDATA_DISPOSEIMAGE:Bool = true;
	public static var BITMAPDATA_USECACHE:Bool = false;
	public static var SOUND_USECACHE:Bool = false;
	public static var ASSETS_CLEARCACHE:Bool = true;

	public var paths:Array<String>;
	public var documents:Array<DOMDocument>;
	public var customSymbolLoader:XFLCustomSymbolLoader;

	public function new(paths:Array<String>, customSymbolLoader:XFLCustomSymbolLoader = null)
	{
		this.documents = [];
		this.paths = paths;
		this.customSymbolLoader = customSymbolLoader;
		for (path in this.paths)
		{
			documents.push(DOMDocument.load(path, "DOMDocument.xml"));
		}
	}

	public static function getXMLData(name:String)
	{
		var textAsset:String = openfl.Assets.getText(name);
		if (textAsset != null)
		{
			if (ASSETS_CLEARCACHE == true)
			{
				Assets.cache.clear();
			}
			return new haxe.xml.Fast(Xml.parse(textAsset).firstElement());
		}
		trace("getXMLData(): xml data not found: " + name);
		return null;
	}

	public function getBitmapData(name:String):BitmapData
	{
		var bitmapData:BitmapData = null;
		for (document in documents)
		{
			for (medium in document.media)
			{
				if (medium.linkageClassName == name)
				{
					var bitmapItem:DOMBitmapItem = medium.item;
					var assetUrl:String = document.path + "/LIBRARY/" + bitmapItem.href;
					if (Assets.exists(assetUrl) == true) bitmapData = Assets.getBitmapData(assetUrl, BITMAPDATA_USECACHE);
					if (bitmapData != null)
					{
						if (BITMAPDATA_DISPOSEIMAGE == true) bitmapData.disposeImage();
						if (ASSETS_CLEARCACHE == true)
						{
							Assets.cache.clear();
						}
						return bitmapData;
					}
				}
			}
		}
		trace("getBitmapData(): bitmap data not found: " + name);
		return null;
	}

	public function getBitmapDataByPath(path:String):BitmapData
	{
		var bitmapData:BitmapData = null;
		for (document in documents)
		{
			for (medium in document.media)
			{
				if (medium.name == path)
				{
					var bitmapItem:DOMBitmapItem = medium.item;
					var assetUrl:String = document.path + "/LIBRARY/" + bitmapItem.href;
					if (Assets.exists(assetUrl) == true) bitmapData = Assets.getBitmapData(assetUrl, BITMAPDATA_USECACHE);
					if (bitmapData != null)
					{
						if (BITMAPDATA_DISPOSEIMAGE == true) bitmapData.disposeImage();
						if (ASSETS_CLEARCACHE == true)
						{
							Assets.cache.clear();
						}
						return bitmapData;
					}
				}
			}
		}
		trace("getBitmapDataByPath(): bitmap data not found by path: " + path);
		return null;
	}

	public function getSound(name:String):Sound
	{
		var sound:Sound = null;
		for (document in documents)
		{
			for (medium in document.media)
			{
				if (medium.linkageClassName == name)
				{
					var soundItem:DOMSoundItem = medium.item;
					var assetUrl:String = document.path + "/LIBRARY/" + soundItem.href;
					if (Assets.exists(assetUrl) == true) sound = Assets.getSound(assetUrl, SOUND_USECACHE);
					if (sound != null)
					{
						if (ASSETS_CLEARCACHE == true)
						{
							Assets.cache.clear();
						}
						return sound;
					}
				}
			}
		}
		trace("getSound(): sound not found: " + name);
		return sound;
	}

	private function getSymbolItem(name:String):DOMSymbolItem
	{
		for (document in documents)
		{
			for (symbol in document.symbols)
			{
				if (symbol.linkageClassName == name)
				{
					var domSymbolItem:DOMSymbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", symbol.fileName);
					if (domSymbolItem != null)
					{
						if (ASSETS_CLEARCACHE == true)
						{
							Assets.cache.clear();
						}
					}
					return domSymbolItem;
				}
			}
		}
		trace("getSymbolItem(): symbol not found: " + name);
		return null;
	}

	public function createSymbolArguments(name:String):XFLSymbolArguments
	{
		var symbolItem:DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null)
		{
			return new XFLSymbolArguments(this, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked);
		}
		trace("createSymbolArguments(): symbol not found: " + name);
		return null;
	}

	public function createMovieClip(name:String):XFLMovieClip
	{
		var symbolItem:DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null)
		{
			if (customSymbolLoader != null)
			{
				var movieClip:XFLMovieClip = customSymbolLoader.createMovieClip(this, symbolItem);
				if (movieClip != null)
				{
					customSymbolLoader.onMovieClipLoaded(this, symbolItem, movieClip);
					return movieClip;
				}
			}
			return new XFLMovieClip(new XFLSymbolArguments(this, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked));
		}
		trace("createMovieClip(): movie clip not found: " + name);
		return null;
	}

	public function createSprite(name:String):XFLSprite
	{
		var symbolItem:DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null)
		{
			if (customSymbolLoader != null)
			{
				var sprite:XFLSprite = customSymbolLoader.createSprite(this, symbolItem);
				if (sprite != null)
				{
					customSymbolLoader.onSpriteLoaded(this, symbolItem, sprite);
					return sprite;
				}
			}
			return new XFLSprite(new XFLSymbolArguments(this, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked));
		}
		trace("createSprite(): sprite not found: " + name);
		return null;
	}
}
