package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFClipActions;
import format.swf.data.SWFColorTransform;
import format.swf.data.SWFMatrix;
import format.swf.data.filters.IFilter;

class TagPlaceObject implements IDisplayListTag
{
	public static inline var TYPE:Int = 4;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var hasClipActions:Bool;
	public var hasClipDepth:Bool;
	public var hasName:Bool;
	public var hasRatio:Bool;
	public var hasColorTransform:Bool;
	public var hasMatrix:Bool;
	public var hasCharacter:Bool;
	public var hasMove:Bool;
	public var hasOpaqueBackground:Bool;
	public var hasVisible:Bool;
	public var hasImage:Bool;
	public var hasClassName:Bool;
	public var hasCacheAsBitmap:Bool;
	public var hasBlendMode:Bool;
	public var hasFilterList:Bool;
	
	public var characterId:Int;
	public var depth:Int;
	public var matrix:SWFMatrix;
	public var colorTransform:SWFColorTransform;
	
	// Forward declarations for TagPlaceObject2
	public var ratio:Int;
	public var instanceName:String;
	public var clipDepth:Int;
	public var clipActions:SWFClipActions;

	// Forward declarations for TagPlaceObject3
	public var className:String;
	public var blendMode:Int;
	public var bitmapCache:Int;
	public var bitmapBackgroundColor:Int;
	public var visible:Int;
	
	// Forward declarations for TagPlaceObject4
	public var metaData:Dynamic;
	
	public var surfaceFilterList(default, null):Array<IFilter>;
	
	public function new() {
		type = TYPE;
		name = "PlaceObject";
		version = 1;
		level = 1;
		surfaceFilterList = new Array<IFilter>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var pos:Int = data.position;
		characterId = data.readUI16();
		depth = data.readUI16();
		matrix = data.readMATRIX();
		hasCharacter = true;
		hasMatrix = true;
		if (Std.int (data.position) - pos < length) {
			colorTransform = data.readCXFORM();
			hasColorTransform = true;
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUI16(depth);
		body.writeMATRIX(matrix);
		if (hasColorTransform) {
			body.writeCXFORM(colorTransform);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"Depth: " + depth;
		if (hasCharacter) { str += ", CharacterID: " + characterId; }
		if (hasMatrix) { str += ", Matrix: " + matrix; }
		if (hasColorTransform) { str += ", ColorTransform: " + colorTransform; }
		return str;
	}
}