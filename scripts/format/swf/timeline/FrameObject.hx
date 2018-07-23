package format.swf.timeline;

import flash.geom.Matrix;
import format.swf.utils.StringUtils;

class FrameObject
{
	// The clipping depth of this display object
	public var clipDepth:Int;
	// The depth of this display object
	public var depth:Int;
	// The character id of this display object
	public var characterId:Int;
	// The class name of this display object
	public var className:String;
	// The tag index of the PlaceObject tag that placed this object on the display list
	public var placedAtIndex:Int;
	// The tag index of the PlaceObject tag that modified this object (optional)
	public var lastModifiedAtIndex:Int;
	
	// Whether this is a keyframe or not
	public var isKeyframe:Bool;
	
	// The index of the layer this object resides on 
	public var layer:Int = -1;
	
	public function new(depth:Int, clipDepth:Int, characterId:Int, className:String, placedAtIndex:Int, lastModifiedAtIndex:Int = 0, isKeyframe:Bool = false)
	{
		this.depth = depth;
		this.clipDepth = clipDepth;
		this.characterId = characterId;
		this.className = className;
		this.placedAtIndex = placedAtIndex;
		this.lastModifiedAtIndex = lastModifiedAtIndex;
		this.isKeyframe = isKeyframe;
		this.layer = -1;
	}
	
	public function clone():FrameObject {
		return new FrameObject(depth, clipDepth, characterId, className, placedAtIndex, lastModifiedAtIndex, false);
	}
	
	public function toString(/*indent:Int = 0*/):String {
		var indent = 0;
		var str:String = StringUtils.repeat(indent + 2) +
			"Depth: " + depth + (layer > -1 ? " (Layer " + layer + ")" : "") + ", " +
			"CharacterId: " + characterId + ", ";
		if(className != null) {
			str += "ClassName: " + className + ", ";
		}
		str += "PlacedAt: "  + placedAtIndex;
		if(lastModifiedAtIndex > 0) {
			str += ", LastModifiedAt: " + lastModifiedAtIndex;
		}
		if(isKeyframe) {
			str += ", IsKeyframe";
		}
		return str;
	}
}
