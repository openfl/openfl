package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BitmapType;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.utils.ByteArray;

class TagDefineBits implements IDefinitionTag
{
	public static inline var TYPE:Int = 6;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var bitmapType:Int = BitmapType.JPEG;
	
	public var characterId:Int;

	public var bitmapData (default, null):ByteArray;
	public var instance:BitmapData;
	
	public function new() {
		type = TYPE;
		name = "DefineBits";
		version = 1;
		level = 1;
		bitmapData = new ByteArray();
		bitmapData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		if (length > 2) {
			data.readBytes(bitmapData, 0, length - 2);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, bitmapData.length + 2, true);
		data.writeUI16(characterId);
		if (bitmapData.length > 0) {
			data.writeBytes(bitmapData);
		}
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineBits = new TagDefineBits();
		tag.characterId = characterId;
		tag.bitmapType = bitmapType;
		if (bitmapData.length > 0) {
			tag.bitmapData.writeBytes(bitmapData);
		}
		return tag;
	}
	
	private var loader:Loader;
	private var onCompleteCallback:Dynamic;
	
	public function exportBitmapData(onComplete:Dynamic):Void {
		onCompleteCallback = onComplete;
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, exportCompleteHandler);
		loader.loadBytes(bitmapData);
	}
	
	private function exportCompleteHandler(event:Event):Void {
		var loader:Loader = (cast event.target).loader;
		var bitmapData:BitmapData = new BitmapData(Math.ceil (loader.content.width), Math.ceil (loader.content.height));
		bitmapData.draw(loader);
		instance = bitmapData;
		onCompleteCallback(bitmapData);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"BitmapLength: " + bitmapData.length;
	}
}