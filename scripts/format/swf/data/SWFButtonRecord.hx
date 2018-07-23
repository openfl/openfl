package format.swf.data;

import format.swf.SWFData;
import format.swf.data.consts.BlendMode;
import format.swf.data.filters.IFilter;
import format.swf.utils.StringUtils;

class SWFButtonRecord
{
	public var hasBlendMode:Bool;
	public var hasFilterList:Bool;
	public var stateHitTest:Bool;
	public var stateDown:Bool;
	public var stateOver:Bool;
	public var stateUp:Bool;
	
	public var characterId:Int;
	public var placeDepth:Int;
	public var placeMatrix:SWFMatrix;
	public var colorTransform:SWFColorTransformWithAlpha;
	public var blendMode:Int;

	public var filterList (default, null):Array <IFilter>;
	
	public function new(data:SWFData = null, level:Int = 1) {
		filterList = new Array<IFilter>();
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int = 1):Void {
		var flags:Int = data.readUI8();
		stateHitTest = ((flags & 0x08) != 0);
		stateDown = ((flags & 0x04) != 0);
		stateOver = ((flags & 0x02) != 0);
		stateUp = ((flags & 0x01) != 0);
		characterId = data.readUI16();
		placeDepth = data.readUI16();
		placeMatrix = data.readMATRIX();
		if (level >= 2) {
			colorTransform = data.readCXFORMWITHALPHA();
			hasFilterList = ((flags & 0x10) != 0);
			if (hasFilterList) {
				var numberOfFilters:Int = data.readUI8();
				for (i in 0...numberOfFilters) {
					filterList.push(data.readFILTER());
				}
			}
			hasBlendMode = ((flags & 0x20) != 0);
			if (hasBlendMode) {
				blendMode = data.readUI8();
			}
		}
	}
	
	public function publish(data:SWFData, level:Int = 1):Void {
		var flags:Int = 0;
		if(level >= 2 && hasBlendMode) { flags |= 0x20; }
		if(level >= 2 && hasFilterList) { flags |= 0x10; }
		if(stateHitTest) { flags |= 0x08; }
		if(stateDown) { flags |= 0x04; }
		if(stateOver) { flags |= 0x02; }
		if(stateUp) { flags |= 0x01; }
		data.writeUI8(flags);
		data.writeUI16(characterId);
		data.writeUI16(placeDepth);
		data.writeMATRIX(placeMatrix);
		if (level >= 2) {
			data.writeCXFORMWITHALPHA(colorTransform);
			if (hasFilterList) {
				var numberOfFilters:Int = filterList.length;
				data.writeUI8(numberOfFilters);
				for (i in 0...numberOfFilters) {
					data.writeFILTER(filterList[i]);
				}
			}
			if (hasBlendMode) {
				data.writeUI8(blendMode);
			}
		}
	}
	
	public function clone():SWFButtonRecord {
		var data:SWFButtonRecord = new SWFButtonRecord();
		data.hasBlendMode = hasBlendMode;
		data.hasFilterList = hasFilterList;
		data.stateHitTest = stateHitTest;
		data.stateDown = stateDown;
		data.stateOver = stateOver;
		data.stateUp = stateUp;
		data.characterId = characterId;
		data.placeDepth = placeDepth;
		data.placeMatrix = placeMatrix.clone();
		if(colorTransform != null) {
			data.colorTransform = cast (colorTransform.clone(), SWFColorTransformWithAlpha);
		}
		for(i in 0...filterList.length) {
			data.filterList.push(filterList[i].clone());
		}
		data.blendMode = blendMode;
		return data;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = "Depth: " + placeDepth + ", CharacterID: " + characterId + ", States: ";
		var states:Array<String> = [];
		if (stateUp) { states.push("up"); }
		if (stateOver) { states.push("over"); }
		if (stateDown) { states.push("down"); }
		if (stateHitTest) { states.push("hit"); }
		str += states.join(",");
		if (hasBlendMode) { str += ", BlendMode: " + BlendMode.toString(blendMode); }
		if (placeMatrix != null && !placeMatrix.isIdentity()) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Matrix: " + placeMatrix;
		}
		if (colorTransform != null && !colorTransform.isIdentity()) {
			str += "\n" + StringUtils.repeat(indent + 2) + "ColorTransform: " + colorTransform;
		}
		if (hasFilterList) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Filters:";
			for(i in 0...filterList.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + filterList[i].toString(indent + 4);
			}
		}
		return str;
	}
}