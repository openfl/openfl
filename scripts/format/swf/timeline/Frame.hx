package format.swf.timeline;

import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagRemoveObject;
import format.swf.utils.StringUtils;

class Frame
{
	public var frameNumber:Int = 0;
	public var tagIndexStart:Int = 0;
	public var tagIndexEnd:Int = 0;
	public var label:String;
	
	public var objects(default, null):Map<Int, FrameObject>;
	private var _objectsSortedByDepth:Array<FrameObject>;
	public var characters(default, null):Array<Int>;
	public var tagCount (get_tagCount, null):Int;
	
	public function new(frameNumber:Int = 0, tagIndexStart:Int = 0)
	{
		this.frameNumber = frameNumber;
		this.tagIndexStart = tagIndexStart;
		objects = new Map<Int, FrameObject>();
		characters = [];
	}
	
	public function getObjectsSortedByDepth():Array<FrameObject> {
		var depths:Array<Int> = [];
		if(_objectsSortedByDepth == null) {
			for(depth in objects.keys()) {
				depths.push(depth);
			}
			depths.sort(sortNumeric);
			_objectsSortedByDepth = [];
			for(i in 0...depths.length) {
				_objectsSortedByDepth.push(objects.get (depths[i]));
			}
		}
		return _objectsSortedByDepth;
	}
	
	private function sortNumeric (a:Int, b:Int):Int {
		
		return a - b;
		
	}
	
	private function get_tagCount():Int {
		return tagIndexEnd - tagIndexStart + 1;
	}
	
	public function placeObject(tagIndex:Int, tag:TagPlaceObject):Void {
		var frameObject:FrameObject = objects.get (tag.depth);
		if(frameObject != null) {
			// A character is already available at the specified depth
			if(tag.characterId == 0 #if (neko || js) || tag.characterId == null #end) {
				// The PlaceObject tag has no character id defined:
				// This means that the previous character is reused 
				// and most likely modified by transforms
				frameObject.lastModifiedAtIndex = tagIndex;
				frameObject.isKeyframe = false;
			} else {					
				// A character id is defined:
				// This means that the previous character is replaced 
				// (possible transforms defined in previous frames are discarded)
				if(tag.hasName || tag.hasMatrix || tag.hasColorTransform || tag.hasFilterList) {
					frameObject.lastModifiedAtIndex = tagIndex;
				}
				frameObject.isKeyframe = true;
				if(tag.characterId != frameObject.characterId) {
					// The character id does not match the previous character:
					// An entirely new character is placed at this depth.
					frameObject.lastModifiedAtIndex = 0;
					frameObject.placedAtIndex = tagIndex;
					frameObject.characterId = tag.characterId;
				}
			}
		} else {
			// No character defined at specified depth. Create one.
			objects.set (tag.depth, new FrameObject(tag.depth, tag.clipDepth, tag.characterId, tag.className, tagIndex, 0, true));
		}
		_objectsSortedByDepth = null;
	}
	
	public function removeObject(tag:TagRemoveObject):Void {
		objects.remove (tag.depth);
		_objectsSortedByDepth = null;
	}
	
	public function clone():Frame {
		var frame:Frame = new Frame();
		for(depth in objects.keys()) {
			frame.objects.set (depth, objects.get (depth).clone());
		}
		return frame;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = StringUtils.repeat(indent) + "[" + frameNumber + "] " +
			"Start: " + tagIndexStart + ", " +
			"Length: " + tagCount;
		if(label != null && label != "") { str += ", Label: " + label; }
		if(characters.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Defined CharacterIDs: " + characters.join(", ");
		}
		for(depth in objects.keys()) {
			//str += objects.get (depth).toString(indent);
			str += objects.get (depth).toString();
		}
		return str;
	}
}
