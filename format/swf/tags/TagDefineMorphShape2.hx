package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFMorphLineStyle2;
import format.swf.data.SWFRectangle;
import format.swf.utils.StringUtils;

class TagDefineMorphShape2 extends TagDefineMorphShape implements ITag
{
	public static inline var TYPE:Int = 84;
	
	public var startEdgeBounds:SWFRectangle;
	public var endEdgeBounds:SWFRectangle;
	public var usesNonScalingStrokes:Bool;
	public var usesScalingStrokes:Bool;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineMorphShape2";
		version = 8;
		level = 2;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		startBounds = data.readRECT();
		endBounds = data.readRECT();
		startEdgeBounds = data.readRECT();
		endEdgeBounds = data.readRECT();
		var flags:Int = data.readUI8();
		usesNonScalingStrokes = ((flags & 0x02) != 0);
		usesScalingStrokes = ((flags & 0x01) != 0);
		var offset:Int = data.readUI32();
		var i:Int;
		// MorphFillStyleArray
		var fillStyleCount:Int = data.readUI8();
		if (fillStyleCount == 0xff) {
			fillStyleCount = data.readUI16();
		}
		for (i in 0...fillStyleCount) {
			morphFillStyles.push(data.readMORPHFILLSTYLE());
		}
		// MorphLineStyleArray
		var lineStyleCount:Int = data.readUI8();
		if (lineStyleCount == 0xff) {
			lineStyleCount = data.readUI16();
		}
		for (i in 0...lineStyleCount) {
			morphLineStyles.push(data.readMORPHLINESTYLE2());
		}
		startEdges = data.readSHAPE();
		endEdges = data.readSHAPE();
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeRECT(startBounds);
		body.writeRECT(endBounds);
		body.writeRECT(startEdgeBounds);
		body.writeRECT(endEdgeBounds);
		var flags:Int = 0;
		if(usesNonScalingStrokes) { flags |= 0x02; }
		if(usesScalingStrokes) { flags |= 0x01; }
		body.writeUI8(flags);
		var startBytes:SWFData = new SWFData();
		var i:Int;
		// MorphFillStyleArray
		var fillStyleCount:Int = morphFillStyles.length;
		if (fillStyleCount > 0xfe) {
			startBytes.writeUI8(0xff);
			startBytes.writeUI16(fillStyleCount);
		} else {
			startBytes.writeUI8(fillStyleCount);
		}
		for (i in 0...fillStyleCount) {
			startBytes.writeMORPHFILLSTYLE(morphFillStyles[i]);
		}
		// MorphLineStyleArray
		var lineStyleCount:Int = morphLineStyles.length;
		if (lineStyleCount > 0xfe) {
			startBytes.writeUI8(0xff);
			startBytes.writeUI16(lineStyleCount);
		} else {
			startBytes.writeUI8(lineStyleCount);
		}
		for (i in 0...lineStyleCount) {
			startBytes.writeMORPHLINESTYLE2(cast(morphLineStyles[i], SWFMorphLineStyle2));
		}
		startBytes.writeSHAPE(startEdges);
		body.writeUI32(startBytes.length);
		body.writeBytes(startBytes);
		body.writeSHAPE(endEdges);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	override public function toString(indent:Int = 0):String {
		var i:Int;
		var indent2:String = StringUtils.repeat(indent + 2);
		var indent4:String = StringUtils.repeat(indent + 4);
		var str:String = Tag.toStringCommon(type, name, indent) + "ID: " + characterId;
		str += "\n" + indent2 + "Bounds:";
		str += "\n" + indent4 + "StartBounds: " + startBounds.toString();
		str += "\n" + indent4 + "EndBounds: " + endBounds.toString();
		str += "\n" + indent4 + "StartEdgeBounds: " + startEdgeBounds.toString();
		str += "\n" + indent4 + "EndEdgeBounds: " + endEdgeBounds.toString();
		if(morphFillStyles.length > 0) {
			str += "\n" + indent2 + "FillStyles:";
			for(i in 0...morphFillStyles.length) {
				str += "\n" + indent4 + "[" + (i + 1) + "] " + morphFillStyles[i].toString();
			}
		}
		if(morphLineStyles.length > 0) {
			str += "\n" + indent2 + "LineStyles:";
			for(i in 0...morphLineStyles.length) {
				str += "\n" + indent4 + "[" + (i + 1) + "] " + morphLineStyles[i].toString();
			}
		}
		str += startEdges.toString(indent + 2);
		str += endEdges.toString(indent + 2);
		return str;
	}
}