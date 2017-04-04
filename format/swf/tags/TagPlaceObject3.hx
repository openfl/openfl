package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BlendMode;
import format.swf.utils.ColorUtils;
import format.swf.utils.StringUtils;

class TagPlaceObject3 extends TagPlaceObject2 implements IDisplayListTag
{
	public static inline var TYPE:Int = 70;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "PlaceObject3";
		version = 8;
		level = 3;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var flags1:Int = data.readUI8();
		hasClipActions = (flags1 & 0x80) != 0;
		hasClipDepth = (flags1 & 0x40) != 0;
		hasName = (flags1 & 0x20) != 0;
		hasRatio = (flags1 & 0x10) != 0;
		hasColorTransform = (flags1 & 0x08) != 0;
		hasMatrix = (flags1 & 0x04) != 0;
		hasCharacter = (flags1 & 0x02) != 0;
		hasMove = (flags1 & 0x01) != 0;
		var flags2:Int = data.readUI8();
		hasOpaqueBackground = (flags2 & 0x40) != 0;
		hasVisible = (flags2 & 0x20) != 0;
		hasImage = (flags2 & 0x10) != 0;
		hasClassName = (flags2 & 0x08) != 0;
		hasCacheAsBitmap = (flags2 & 0x04) != 0;
		hasBlendMode = (flags2 & 0x02) != 0;
		hasFilterList = (flags2 & 0x01) != 0;
		depth = data.readUI16();
		if (hasClassName) {
			className = data.readSTRING();
		}
		if (hasCharacter) {
			characterId = data.readUI16();
		}
		if (hasMatrix) {
			matrix = data.readMATRIX();
		}
		if (hasColorTransform) {
			colorTransform = data.readCXFORMWITHALPHA();
		}
		if (hasRatio) {
			ratio = data.readUI16();
		}
		if (hasName) {
			instanceName = data.readSTRING();
		}
		if (hasClipDepth) {
			clipDepth = data.readUI16();
		}
		if (hasFilterList) {
			var numberOfFilters:Int = data.readUI8();
			for (i in 0...numberOfFilters) {
				surfaceFilterList.push(data.readFILTER());
			}
		}
		if (hasBlendMode) {
			blendMode = data.readUI8();
		}
		if (hasCacheAsBitmap) {
			bitmapCache = data.readUI8();
		}
		if (hasVisible) {
			visible = data.readUI8();
 		}
 		if (hasOpaqueBackground) {
			bitmapBackgroundColor = data.readRGBA();
 		}
		if (hasClipActions) {
			clipActions = data.readCLIPACTIONS(version);
		}
	}
	
	private function prepareBody():SWFData {
		var body:SWFData = new SWFData();
		var flags1:Int = 0;
		if (hasClipActions) { flags1 |= 0x80; }
		if (hasClipDepth) { flags1 |= 0x40; }
		if (hasName) { flags1 |= 0x20; }
		if (hasRatio) { flags1 |= 0x10; }
		if (hasColorTransform) { flags1 |= 0x08; }
		if (hasMatrix) { flags1 |= 0x04; }
		if (hasCharacter) { flags1 |= 0x02; }
		if (hasMove) { flags1 |= 0x01; }
		body.writeUI8(flags1);
		var flags2:Int = 0;
		if (hasOpaqueBackground) { flags2 |= 0x40; }
		if (hasVisible) { flags2 |= 0x20; }
		if (hasImage) { flags2 |= 0x10; }
		if (hasClassName) { flags2 |= 0x08; }
		if (hasCacheAsBitmap) { flags2 |= 0x04; }
		if (hasBlendMode) { flags2 |= 0x02; }
		if (hasFilterList) { flags2 |= 0x01; }
		body.writeUI8(flags2);
		body.writeUI16(depth);
		if (hasClassName) {
			body.writeSTRING(className);
		}
		if (hasCharacter) {
			body.writeUI16(characterId);
		}
		if (hasMatrix) {
			body.writeMATRIX(matrix);
		}
		if (hasColorTransform) {
			body.writeCXFORM(colorTransform);
		}
		if (hasRatio) {
			body.writeUI16(ratio);
		}
		if (hasName) {
			body.writeSTRING(instanceName);
		}
		if (hasClipDepth) {
			body.writeUI16(clipDepth);
		}
		if (hasFilterList) {
			var numberOfFilters:Int = surfaceFilterList.length;
			body.writeUI8(numberOfFilters);
			for (i in 0...numberOfFilters) {
				body.writeFILTER(surfaceFilterList[i]);
			}
		}
		if (hasBlendMode) {
			body.writeUI8(blendMode);
		}
		if (hasCacheAsBitmap) {
			body.writeUI8(bitmapCache);
		}
		if (hasVisible) {
			body.writeUI8(visible);
 		}
 		if (hasOpaqueBackground) {
			body.writeRGBA(bitmapBackgroundColor);
 		}
		if (hasClipActions) {
			body.writeCLIPACTIONS(clipActions, version);
		}
		
		
		return body;
	}
	
	
	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = prepareBody();
		
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"Depth: " + depth;
		if (hasClassName /*|| (hasImage && hasCharacter)*/) { str += ", ClassName: " + className; }
		if (hasCharacter) { str += ", CharacterID: " + characterId; }
		if (hasMatrix) { str += ", Matrix: " + matrix.toString(); }
		if (hasColorTransform) { str += ", ColorTransform: " + colorTransform; }
		if (hasRatio) { str += ", Ratio: " + ratio; }
		if (hasName) { str += ", Name: " + instanceName; }
		if (hasClipDepth) { str += ", ClipDepth: " + clipDepth; }
		if (hasBlendMode) { str += ", BlendMode: " + BlendMode.toString(blendMode); }
		if (hasCacheAsBitmap) { str += ", CacheAsBitmap: " + bitmapCache; }
		if (hasVisible) { str += ", Visible: " + visible; }
		if (hasOpaqueBackground) { str += ", BackgroundColor: " + ColorUtils.rgbaToString(bitmapBackgroundColor); }
		if (hasFilterList) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Filters:";
			for(i in 0...surfaceFilterList.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + surfaceFilterList[i].toString(indent + 4);
			}
		}
		if (hasClipActions) {
			str += "\n" + StringUtils.repeat(indent + 2) + clipActions.toString(indent + 2);
		}
		return str;
	}
}