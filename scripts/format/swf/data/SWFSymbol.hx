package format.swf.data;

import format.swf.SWFData;

class SWFSymbol
{
	public var tagId:Int;
	public var name:String;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}

	public static function create(aTagID:Int, aName:String):SWFSymbol {
		var swfSymbol:SWFSymbol = new SWFSymbol();
		swfSymbol.tagId = aTagID;
		swfSymbol.name = aName;
		return swfSymbol;
	}
	
	public function parse(data:SWFData):Void {
		tagId = data.readUI16();
		name = data.readSTRING();	
	}
	
	public function publish(data:SWFData):Void {
		data.writeUI16(tagId);
		data.writeSTRING(name);
	}
	
	public function toString():String {
		return "TagID: " + tagId + ", Name: " + name;
	}
}