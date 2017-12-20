package format.swf.tags;

import format.swf.SWFData;
import format.swf.SWFTimelineContainer;
import format.swf.tags.IDefinitionTag;
import format.swf.timeline.Frame;
import format.swf.timeline.Layer;
import format.swf.timeline.Scene;

import flash.errors.Error;

class TagDefineSprite extends SWFTimelineContainer implements IDefinitionTag
{
	public static inline var TYPE:Int = 39;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var frameCount:Int;
	
	public var characterId:Int;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineSprite";
		version = 3;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		frameCount = data.readUI16();
		/*
		if(async) {
			parseTagsAsync(data, version);
		} else {
			parseTags(data, version);
		}
		*/
		parseTags(data, version);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUI16(frameCount); // TODO: get the real number of frames from controlTags
		publishTags(body, version);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineSprite = new TagDefineSprite();
		throw(new Error("Not implemented yet."));
		return tag;
	}
	
	override public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) + 
			"ID: " + characterId + ", " +
			"FrameCount: " + frameCount +
			super.toString(indent);
	}
}