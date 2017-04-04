package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFButtonRecord;
import format.swf.data.actions.IAction;
import format.swf.utils.StringUtils;

class TagDefineButton implements IDefinitionTag
{
	public static inline var TYPE:Int = 7;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public static inline var STATE_UP:String = "up"; 
	public static inline var STATE_OVER:String = "over"; 
	public static inline var STATE_DOWN:String = "down"; 
	public static inline var STATE_HIT:String = "hit"; 
	
	public var characterId:Int;
	
	public var characters (default, null):Array<SWFButtonRecord>;
	public var actions (default, null):Array<IAction>;
	
	private var frames:Map<String, Array<SWFButtonRecord>>;
	
	public function new() {
		type = TYPE;
		name = "DefineButton";
		version = 1;
		level = 1;
		characters = new Array<SWFButtonRecord>();
		actions = new Array<IAction>();
		frames = new Map<String, Array<SWFButtonRecord>>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		var record:SWFButtonRecord;
		while ((record = data.readBUTTONRECORD()) != null) {
			characters.push(record);
		}
		var action:IAction;
		while ((action = data.readACTIONRECORD()) != null) {
			actions.push(action);
		}
		processRecords();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var i:Int;
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		for(i in 0...characters.length) {
			data.writeBUTTONRECORD(characters[i]);
		}
		data.writeUI8(0);
		for(i in 0...actions.length) {
			data.writeACTIONRECORD(actions[i]);
		}
		data.writeUI8(0);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var i:Int;
		var tag:TagDefineButton = new TagDefineButton();
		tag.characterId = characterId;
		for(i in 0...characters.length) {
			tag.characters.push(characters[i].clone());
		}
		for(i in 0...actions.length) {
			tag.actions.push(actions[i].clone());
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
		frames.set (STATE_UP, upState);
		frames.set (STATE_OVER, overState);
		frames.set (STATE_DOWN, downState);
		frames.set (STATE_HIT, hitState);
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
			"ID: " + characterId;
		var i:Int;
		if (characters.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Characters:";
			for (i in 0...characters.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + characters[i].toString(indent + 4);
			}
		}
		if (actions.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Actions:";
			for (i in 0...actions.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + actions[i].toString(indent + 4);
			}
		}
		return str;
	}
}