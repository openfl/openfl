package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFRectangle;
import format.swf.utils.StringUtils;

class TagDefineShape4 extends TagDefineShape3 implements IDefinitionTag
{
	public static inline var TYPE:Int = 83;
	
	public var edgeBounds:SWFRectangle;
	public var usesFillWindingRule:Bool;
	public var usesNonScalingStrokes:Bool;
	public var usesScalingStrokes:Bool;

	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineShape4";
		version = 8;
		level = 4;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		shapeBounds = data.readRECT();
		edgeBounds = data.readRECT();
		var flags:Int = data.readUI8();
		usesFillWindingRule = ((flags & 0x04) != 0);
		usesNonScalingStrokes = ((flags & 0x02) != 0);
		usesScalingStrokes = ((flags & 0x01) != 0);
		shapes = data.readSHAPEWITHSTYLE(level);
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeRECT(shapeBounds);
		body.writeRECT(edgeBounds);
		var flags:Int = 0;
		if(usesFillWindingRule) { flags |= 0x04; }
		if(usesNonScalingStrokes) { flags |= 0x02; }
		if(usesScalingStrokes) { flags |= 0x01; }
		body.writeUI8(flags);
		body.writeSHAPEWITHSTYLE(shapes, level);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) + "ID: " + characterId + ", ";
		if(usesFillWindingRule) { str += "UsesFillWindingRule, "; }
		if(usesNonScalingStrokes) { str += "UsesNonScalingStrokes, "; }
		if(usesScalingStrokes) { str += "UsesScalingStrokes, "; }
		str += "ShapeBounds: " + shapeBounds + ", EdgeBounds: " + edgeBounds;
		str += shapes.toString(indent + 2);
		return str;
	}
}