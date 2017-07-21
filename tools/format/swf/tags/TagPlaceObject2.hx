package format.swf.tags;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

class TagPlaceObject2 extends TagPlaceObject implements IDisplayListTag
{
	public static inline var TYPE:Int = 26;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "PlaceObject2";
		version = 3;
		level = 2;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var flags:Int = data.readUI8();
		hasClipActions = (flags & 0x80) != 0;
		hasClipDepth = (flags & 0x40) != 0;
		hasName = (flags & 0x20) != 0;
		hasRatio = (flags & 0x10) != 0;
		hasColorTransform = (flags & 0x08) != 0;
		hasMatrix = (flags & 0x04) != 0;
		hasCharacter = (flags & 0x02) != 0;
		hasMove = (flags & 0x01) != 0;
		depth = data.readUI16();
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
		if (hasClipActions) {
			clipActions = data.readCLIPACTIONS(version);
		}
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		var flags:Int = 0;
		var body:SWFData = new SWFData();
		if (hasMove) { flags |= 0x01; }
		if (hasCharacter) { flags |= 0x02; }
		if (hasMatrix) { flags |= 0x04; }
		if (hasColorTransform) { flags |= 0x08; }
		if (hasRatio) { flags |= 0x10; }
		if (hasName) { flags |= 0x20; }
		if (hasClipDepth) { flags |= 0x40; }
		if (hasClipActions) { flags |= 0x80; }
		body.writeUI8(flags);
		body.writeUI16(depth);
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
		if (hasClipActions) {
			body.writeCLIPACTIONS(clipActions, version);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"Depth: " + depth;
		if (hasCharacter) { str += ", CharacterID: " + characterId; }
		if (hasMatrix) { str += ", Matrix: " + matrix.toString(); }
		if (hasColorTransform) { str += ", ColorTransform: " + colorTransform; }
		if (hasRatio) { str += ", Ratio: " + ratio; }
		if (hasName) { str += ", Name: " + instanceName; }
		if (hasClipDepth) { str += ", ClipDepth: " + clipDepth; }
		if (hasClipActions && clipActions != null) {
			str += "\n" + StringUtils.repeat(indent + 2) + clipActions.toString(indent + 2);
		}
		return str;
	}
}