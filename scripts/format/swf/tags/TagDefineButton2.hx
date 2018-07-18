package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFButtonCondAction;
import format.swf.data.SWFButtonRecord;
import format.swf.utils.StringUtils;

class TagDefineButton2 implements IDefinitionTag
{
	public static inline var TYPE:Int = 34;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var trackAsMenu:Bool;
	
	public var characterId:Int;

	public var characters (default, null):Array<SWFButtonRecord>;
	public var condActions (default, null):Array<SWFButtonCondAction>;
	
	private var frames:Map<String, Array<SWFButtonRecord>>;
	
	public function new() {
		type = TYPE;
		name = "DefineButton2";
		version = 3;
		level = 2;
		characters = new Array<SWFButtonRecord>();
		condActions = new Array<SWFButtonCondAction>();
		frames = new Map<String, Array<SWFButtonRecord>>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		trackAsMenu = ((data.readUI8() & 0x01) != 0);
		var actionOffset:Int = data.readUI16();
		var record:SWFButtonRecord;
		while ((record = data.readBUTTONRECORD(2)) != null) {
			characters.push(record);
		}
		if (actionOffset != 0) {
			var condActionSize:Int;
			do {
				condActionSize = data.readUI16();
				condActions.push(data.readBUTTONCONDACTION());
			} while(condActionSize != 0);
		}
		processRecords();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var i:Int;
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUI8(trackAsMenu ? 0x01 : 0);
		var hasCondActions:Bool = (condActions.length > 0); 
		var buttonRecordsBytes:SWFData = new SWFData();
		for(i in 0...characters.length) {
			buttonRecordsBytes.writeBUTTONRECORD(characters[i], 2);
		}
		buttonRecordsBytes.writeUI8(0);
		body.writeUI16(hasCondActions ? buttonRecordsBytes.length + 2 : 0);
		body.writeBytes(buttonRecordsBytes);
		if(hasCondActions) {
			for(i in 0...condActions.length) {
				var condActionBytes:SWFData = new SWFData();
				condActionBytes.writeBUTTONCONDACTION(condActions[i]);
				body.writeUI16((i < condActions.length - 1) ? condActionBytes.length + 2 : 0);
				body.writeBytes(condActionBytes);
			}
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var i:Int;
		var tag:TagDefineButton2 = new TagDefineButton2();
		tag.characterId = characterId;
		tag.trackAsMenu = trackAsMenu;
		for(i in 0...characters.length) {
			tag.characters.push(characters[i].clone());
		}
		for(i in 0...condActions.length) {
			tag.condActions.push(condActions[i].clone());
		}
		return tag;
	}
	
	public function getRecordsByState(state:String):Array<SWFButtonRecord> {
		return frames.get (state);
	}

	private function processRecords():Void {
		var upState:Array<SWFButtonRecord> = new Array<SWFButtonRecord>();
		var overState:Array<SWFButtonRecord> = new Array<SWFButtonRecord>();
		var downState:Array<SWFButtonRecord> = new Array<SWFButtonRecord>();
		var hitState:Array<SWFButtonRecord> = new Array<SWFButtonRecord>();
		for(i in 0...characters.length) {
			var record:SWFButtonRecord = characters[i];
			if(record.stateUp) { upState.push(record); }
			if(record.stateOver) { overState.push(record); }
			if(record.stateDown) { downState.push(record); }
			if(record.stateHitTest) { hitState.push(record); }
		}
		upState.sort(sortByDepthCompareFunction);
		overState.sort(sortByDepthCompareFunction);
		downState.sort(sortByDepthCompareFunction);
		hitState.sort(sortByDepthCompareFunction);
		frames.set (TagDefineButton.STATE_UP, upState);
		frames.set (TagDefineButton.STATE_OVER, overState);
		frames.set (TagDefineButton.STATE_DOWN, downState);
		frames.set (TagDefineButton.STATE_HIT, hitState);
	}
	
	private function sortByDepthCompareFunction(a:SWFButtonRecord, b:SWFButtonRecord):Int {
		if(a.placeDepth < b.placeDepth) {
			return -1;
		} else if(a.placeDepth > b.placeDepth) {
			return 1;
		} else {
			return 0;
		}
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", TrackAsMenu: " + trackAsMenu;
		var i:Int;
		if (characters.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Characters:";
			for (i in 0...characters.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + characters[i].toString(indent + 4);
			}
		}
		if (condActions.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "CondActions:";
			for (i in 0...condActions.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + condActions[i].toString(indent + 4);
			}
		}
		return str;
	}
}