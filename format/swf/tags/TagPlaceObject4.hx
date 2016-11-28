package format.swf.tags;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

/**
 * PlaceObject4 is essentially identical to PlaceObject3 except it has a different
 * swf tag value of course (94 instead of 70) and at the end of the tag, if there are
 * additional bytes, those bytes will be interpreted as AMF binary data that will be
 * used as the metadata attached to the instance.
 * 
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#metaData
 */
class TagPlaceObject4 extends TagPlaceObject3 implements IDisplayListTag
{
	public static inline var TYPE:Int = 94;
	
	public function new() {
		super();
		type = TYPE;
		name = "PlaceObject4";
		version = 19;
		level = 4;
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		super.parse(data, length, version, async);
		if (data.bytesAvailable > 0) {
			// TODO
			//metaData = data.readObject();
		}
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = prepareBody();
		
		if (metaData != null) {
			// TODO
			//body.writeObject(metaData);
		}
		
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = super.toString(indent);
		if (metaData != null) {
			str += "\n" + StringUtils.repeat(indent + 2) + "MetaData: yes";
		}
		return str;
	}
}