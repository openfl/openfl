package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFFillStyle;
import format.swf.data.SWFLineStyle;
import format.swf.data.SWFMorphFillStyle;
import format.swf.data.SWFMorphLineStyle;
import format.swf.data.SWFRectangle;
import format.swf.data.SWFShape;
import format.swf.data.SWFShapeRecord;
import format.swf.data.SWFShapeRecordCurvedEdge;
import format.swf.data.SWFShapeRecordStraightEdge;
import format.swf.data.SWFShapeRecordStyleChange;
import format.swf.exporters.core.IShapeExporter;
import format.swf.utils.StringUtils;
import flash.errors.Error;

class TagDefineMorphShape implements IDefinitionTag
{
	public static inline var TYPE:Int = 46;
	
	public var startBounds:SWFRectangle;
	public var endBounds:SWFRectangle;
	public var startEdges:SWFShape;
	public var endEdges:SWFShape;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var characterId:Int;
	
	public var morphFillStyles (default, null):Array<SWFMorphFillStyle>;
	public var morphLineStyles (default, null):Array<SWFMorphLineStyle>;
	
	public var exportHandler:IShapeExporter;
	
	private var exportShape:SWFShape;
	
	public function new() {
		
		type = TYPE;
		name = "DefineMorphShape";
		version = 3;
		level = 1;
		
		morphFillStyles = new Array<SWFMorphFillStyle>();
		morphLineStyles = new Array<SWFMorphLineStyle>();
		
		exportShape = new SWFShape();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		startBounds = data.readRECT();
		endBounds = data.readRECT();
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
			morphLineStyles.push(data.readMORPHLINESTYLE());
		}
		startEdges = data.readSHAPE();
		endEdges = data.readSHAPE();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeRECT(startBounds);
		body.writeRECT(endBounds);
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
			startBytes.writeMORPHLINESTYLE(morphLineStyles[i]);
		}
		startBytes.writeSHAPE(startEdges);
		body.writeUI32(startBytes.length);
		body.writeBytes(startBytes);
		body.writeSHAPE(endEdges);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineMorphShape = new TagDefineMorphShape();
		throw(new Error("Not implemented yet."));
		return tag;
	}
	
	public function export(ratio:Float = 0):Void {
		var i:Int;
		var j:Int = 0;
		//var exportShape:SWFShape = new SWFShape();
		
		exportShape.records.splice(0, exportShape.records.length);
		exportShape.fillStyles.splice(0, exportShape.fillStyles.length);
		exportShape.lineStyles.splice(0, exportShape.lineStyles.length);
		
		var numEdges:Int = startEdges.records.length;
		for(i in 0...numEdges) {
			var startRecord:SWFShapeRecord = startEdges.records[i];
			// Ignore start records that are style change records and don't have moveTo
			// The end record index is not incremented, because end records do not have
			// style change records without moveTo's.
			//if(startRecord.type == SWFShapeRecord.TYPE_STYLECHANGE && !cast(startRecord,SWFShapeRecordStyleChange).stateMoveTo) {
				//exportShape.records.push(startRecord.clone());
				/* //Also increment the endEdges (Prevent errors)
				j++;*/
				//continue;
			//}
			
			var endRecord:SWFShapeRecord = endEdges.records[j++];
			
			var exportRecord:SWFShapeRecord = null;
			// It is possible for an edge to change type over the course of a morph sequence. 
			// A straight edge can become a curved edge and vice versa
			// Convert straight edge to curved edge, if needed:
			if(startRecord.type == SWFShapeRecord.TYPE_CURVEDEDGE && endRecord.type == SWFShapeRecord.TYPE_STRAIGHTEDGE) {
				endRecord = convertToCurvedEdge(cast (endRecord, SWFShapeRecordStraightEdge));
			} else if(startRecord.type == SWFShapeRecord.TYPE_STRAIGHTEDGE && endRecord.type == SWFShapeRecord.TYPE_CURVEDEDGE) {
				startRecord = convertToCurvedEdge(cast (startRecord, SWFShapeRecordStraightEdge));
			}
			
			switch(startRecord.type) {
				case SWFShapeRecord.TYPE_STYLECHANGE:
					var startStyleChange:SWFShapeRecordStyleChange = cast startRecord.clone();
					startStyleChange.stateMoveTo = true;
					if (endRecord.type == SWFShapeRecord.TYPE_STYLECHANGE) {
						var endStyleChange:SWFShapeRecordStyleChange = cast endRecord;
						startStyleChange.moveDeltaX += Std.int ((endStyleChange.moveDeltaX - startStyleChange.moveDeltaX) * ratio);
						startStyleChange.moveDeltaY += Std.int ((endStyleChange.moveDeltaY - startStyleChange.moveDeltaY) * ratio);
					} else {
						startStyleChange.moveDeltaX += Std.int ((-startStyleChange.moveDeltaX) * ratio);
						startStyleChange.moveDeltaY += Std.int (( -startStyleChange.moveDeltaY) * ratio);
						j--;
					}
					exportRecord = startStyleChange;
				case SWFShapeRecord.TYPE_STRAIGHTEDGE:
					var startStraightEdge:SWFShapeRecordStraightEdge = cast startRecord.clone();
					var endStraightEdge:SWFShapeRecordStraightEdge = cast endRecord;
					
					startStraightEdge.deltaX += Std.int ((endStraightEdge.deltaX - startStraightEdge.deltaX) * ratio);
					startStraightEdge.deltaY += Std.int ((endStraightEdge.deltaY - startStraightEdge.deltaY) * ratio);
					
					if(startStraightEdge.deltaX != 0 && startStraightEdge.deltaY != 0) {
						startStraightEdge.generalLineFlag = true;
						startStraightEdge.vertLineFlag = false;
					} else {
						startStraightEdge.generalLineFlag = false;
						startStraightEdge.vertLineFlag = (startStraightEdge.deltaX == 0);
					}
					
					exportRecord = startStraightEdge;
				case SWFShapeRecord.TYPE_CURVEDEDGE:
					var startCurvedEdge:SWFShapeRecordCurvedEdge = cast startRecord.clone();
					var endCurvedEdge:SWFShapeRecordCurvedEdge = cast endRecord;
					startCurvedEdge.controlDeltaX += Std.int ((endCurvedEdge.controlDeltaX - startCurvedEdge.controlDeltaX) * ratio);
					startCurvedEdge.controlDeltaY += Std.int ((endCurvedEdge.controlDeltaY - startCurvedEdge.controlDeltaY) * ratio);
					startCurvedEdge.anchorDeltaX += Std.int ((endCurvedEdge.anchorDeltaX - startCurvedEdge.anchorDeltaX) * ratio);
					startCurvedEdge.anchorDeltaY += Std.int ((endCurvedEdge.anchorDeltaY - startCurvedEdge.anchorDeltaY) * ratio);
					exportRecord = startCurvedEdge;
				case SWFShapeRecord.TYPE_END:
					exportRecord = startRecord.clone();
			}
			exportShape.records.push(exportRecord);
		}
		for(i in 0...morphFillStyles.length) {
			exportShape.fillStyles.push(morphFillStyles[i].getMorphedFillStyle(ratio));
		}
		for(i in 0...morphLineStyles.length) {
			exportShape.lineStyles.push(morphLineStyles[i].getMorphedLineStyle(ratio));
		}
		exportShape.export(exportHandler);
	}
	
	private function convertToCurvedEdge(straightEdge:SWFShapeRecordStraightEdge):SWFShapeRecordCurvedEdge {
		var curvedEdge:SWFShapeRecordCurvedEdge = new SWFShapeRecordCurvedEdge();
		curvedEdge.controlDeltaX = Std.int (straightEdge.deltaX / 2);
		curvedEdge.controlDeltaY = Std.int (straightEdge.deltaY / 2);
		//curvedEdge.anchorDeltaX = straightEdge.deltaX;
		//curvedEdge.anchorDeltaY = straightEdge.deltaY;
		curvedEdge.anchorDeltaX = Std.int (straightEdge.deltaX / 2);
		curvedEdge.anchorDeltaY = Std.int (straightEdge.deltaY / 2);
		return curvedEdge;
	}
	
	public function toString(indent:Int = 0):String {
		var i:Int;
		var indent2:String = StringUtils.repeat(indent + 2);
		var indent4:String = StringUtils.repeat(indent + 4);
		var str:String = Tag.toStringCommon(type, name, indent) + "ID: " + characterId;
		str += "\n" + indent2 + "Bounds:";
		str += "\n" + indent4 + "StartBounds: " + startBounds.toString();
		str += "\n" + indent4 + "EndBounds: " + endBounds.toString();
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