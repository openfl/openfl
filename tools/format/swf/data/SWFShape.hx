package format.swf.data;

import format.swf.SWFData;
import format.swf.data.consts.GradientInterpolationMode;
import format.swf.data.consts.GradientSpreadMode;
import format.swf.data.consts.LineCapsStyle;
import format.swf.data.consts.LineJointStyle;
import format.swf.data.etc.CurvedEdge;
import format.swf.data.etc.IEdge;
import format.swf.data.etc.StraightEdge;
import format.swf.exporters.core.DefaultShapeExporter;
import format.swf.exporters.core.IShapeExporter;
import format.swf.utils.ColorUtils;
import format.swf.utils.NumberUtils;
import format.swf.utils.StringUtils;

import flash.display.GradientType;
import flash.display.LineScaleMode;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.errors.Error;

class SWFShape
{
	public var records(default, null):Array<SWFShapeRecord>;

	public var fillStyles(default, null):Array<SWFFillStyle>;
	public var lineStyles(default, null):Array<SWFLineStyle>;
	public var referencePoint(default, null):Point;
	
	private var fillEdgeMaps:Array<Map<Int, Array<IEdge>>>;
	private var lineEdgeMaps:Array<Map<Int, Array<IEdge>>>;
	private var currentFillEdgeMap:Map<Int, Array<IEdge>>;
	private var currentLineEdgeMap:Map<Int, Array<IEdge>>;
	private var numGroups:Int;
	private var coordMap:Map<String, Array<IEdge>>;
	
	private var unitDivisor:Float;
	
	private var edgeMapsCreated:Bool = false;
	
	public function new(data:SWFData = null, level:Int = 1, unitDivisor:Float = 20) {
		records = new Array<SWFShapeRecord>();
		fillStyles = new Array<SWFFillStyle>();
		lineStyles = new Array<SWFLineStyle>();
		referencePoint = new Point(0, 0);
		this.unitDivisor = unitDivisor;
		if (data != null) {
			parse(data, level);
		}
	}

	public function getMaxFillStyleIndex():Int {
		var ret:Int = 0;
		for(i in 0...records.length) {
			var shapeRecord:SWFShapeRecord = records[i];
			if(shapeRecord.type == SWFShapeRecord.TYPE_STYLECHANGE) {
				var shapeRecordStyleChange:SWFShapeRecordStyleChange = cast (shapeRecord, SWFShapeRecordStyleChange);
				if(shapeRecordStyleChange.fillStyle0 > ret) {
					ret = shapeRecordStyleChange.fillStyle0;
				}
				if(shapeRecordStyleChange.fillStyle1 > ret) {
					ret = shapeRecordStyleChange.fillStyle1;
				}
				if(shapeRecordStyleChange.stateNewStyles) {
					break;
				}
			} 
		}
		return ret;
	}
	
	public function getMaxLineStyleIndex():Int {
		var ret:Int = 0;
		for(i in 0...records.length) {
			var shapeRecord:SWFShapeRecord = records[i];
			if(shapeRecord.type == SWFShapeRecord.TYPE_STYLECHANGE) {
				var shapeRecordStyleChange:SWFShapeRecordStyleChange = cast (shapeRecord, SWFShapeRecordStyleChange);
				if(shapeRecordStyleChange.lineStyle > ret) {
					ret = shapeRecordStyleChange.lineStyle;
				}
				if(shapeRecordStyleChange.stateNewStyles) {
					break;
				}
			} 
		}
		return ret;
	}
	
	public function parse(data:SWFData, level:Int = 1):Void {
		data.resetBitsPending();
		var numFillBits:Int = data.readUB(4);
		var numLineBits:Int = data.readUB(4);
		readShapeRecords(data, numFillBits, numLineBits, level);
		determineReferencePoint();
	}
	
	public function publish(data:SWFData, level:Int = 1):Void {
		var numFillBits:Int = data.calculateMaxBits(false, [getMaxFillStyleIndex()]);
		var numLineBits:Int = data.calculateMaxBits(false, [getMaxLineStyleIndex()]);
		data.resetBitsPending();
		data.writeUB(4, numFillBits);
		data.writeUB(4, numLineBits);
		writeShapeRecords(data, numFillBits, numLineBits, level);
	}
	
	private function readShapeRecords(data:SWFData, fillBits:Int, lineBits:Int, level:Int = 1):Void {
		var shapeRecord:SWFShapeRecord = null;
		while (!Std.is (shapeRecord, SWFShapeRecordEnd)) {
			// The SWF10 spec says that shape records are byte aligned.
			// In reality they seem not to be?
			// bitsPending = 0;
			var edgeRecord:Bool = (data.readUB(1) == 1);
			if (edgeRecord) {
				var straightFlag:Bool = (data.readUB(1) == 1);
				var numBits:Int = data.readUB(4) + 2;
				if (straightFlag) {
					shapeRecord = data.readSTRAIGHTEDGERECORD(numBits);
				} else {
					shapeRecord = data.readCURVEDEDGERECORD(numBits);
				}
			} else {
				var states:Int = data.readUB(5);
				if (states == 0) {
					shapeRecord = new SWFShapeRecordEnd();
				} else {
					var styleChangeRecord:SWFShapeRecordStyleChange = data.readSTYLECHANGERECORD(states, fillBits, lineBits, level);
					if (styleChangeRecord.stateNewStyles) {
						fillBits = styleChangeRecord.numFillBits;
						lineBits = styleChangeRecord.numLineBits;
					}
					shapeRecord = styleChangeRecord;
				}
			}
			records.push(shapeRecord);
		}
	}

	private function writeShapeRecords(data:SWFData, fillBits:Int, lineBits:Int, level:Int = 1):Void {
		if(records.length == 0 || !Std.is (records[records.length - 1], SWFShapeRecordEnd)) {
			records.push(new SWFShapeRecordEnd());
		}
		for(i in 0...records.length) {
			var shapeRecord:SWFShapeRecord = records[i];
			if(shapeRecord.isEdgeRecord) {
				// EdgeRecordFlag (set)
				data.writeUB(1, 1);
				if(shapeRecord.type == SWFShapeRecord.TYPE_STRAIGHTEDGE) {
					// StraightFlag (set)
					data.writeUB(1, 1);
					data.writeSTRAIGHTEDGERECORD(cast (shapeRecord, SWFShapeRecordStraightEdge));
				} else {
					// StraightFlag (not set)
					data.writeUB(1, 0);
					data.writeCURVEDEDGERECORD(cast (shapeRecord, SWFShapeRecordCurvedEdge));
				}
			} else {
				// EdgeRecordFlag (not set)
				data.writeUB(1, 0);
				if(shapeRecord.type == SWFShapeRecord.TYPE_END) {
					data.writeUB(5, 0);
				} else {
					var states:Int = 0;
					var styleChangeRecord:SWFShapeRecordStyleChange = cast (shapeRecord, SWFShapeRecordStyleChange);
					if(styleChangeRecord.stateNewStyles) { states |= 0x10; }
					if(styleChangeRecord.stateLineStyle) { states |= 0x08; }
					if(styleChangeRecord.stateFillStyle1) { states |= 0x04; }
					if(styleChangeRecord.stateFillStyle0) { states |= 0x02; }
					if(styleChangeRecord.stateMoveTo) { states |= 0x01; }
					data.writeUB(5, states);
					data.writeSTYLECHANGERECORD(styleChangeRecord, fillBits, lineBits, level);
					if (styleChangeRecord.stateNewStyles) {
						fillBits = styleChangeRecord.numFillBits;
						lineBits = styleChangeRecord.numLineBits;
					}
				}
			}
		}
	}
	
	private function determineReferencePoint():Void {
		if (Std.is (records[0], SWFShapeRecordStyleChange)) {
			var styleChangeRecord:SWFShapeRecordStyleChange = cast records[0];
			if(styleChangeRecord != null && styleChangeRecord.stateMoveTo) {
				referencePoint.x = NumberUtils.roundPixels400(styleChangeRecord.moveDeltaX / unitDivisor);
				referencePoint.y = NumberUtils.roundPixels400(styleChangeRecord.moveDeltaY / unitDivisor);
			}
		}
	}
	
	public function export(handler:IShapeExporter = null):Void {
		// Reset the flag so that shapes can be exported multiple times
		// TODO: This is a temporary bug fix. edgeMaps shouldn't need to be recreated for subsequent exports
		edgeMapsCreated = false;
		// Create edge maps
		createEdgeMaps();
		// If no handler is passed, default to DefaultShapeExporter (does nothing)
		if (handler == null) { handler = new DefaultShapeExporter(null); }
		// Let the doc handler know that a shape export starts
		handler.beginShape();
		// Export fills and strokes for each group separately
		for (i in 0...numGroups) {
			// Export fills first
			exportFillPath(handler, i);
			// Export strokes last
			exportLinePath(handler, i);
		}
		// Let the doc handler know that we're done exporting a shape
		handler.endShape();
	}
	
	private function createEdgeMaps():Void {
		if(!edgeMapsCreated) {
			var xPos:Float = 0;
			var yPos:Float = 0;
			var from:Point;
			var to:Point;
			var control:Point;
			var fillStyleIdxOffset:Int = 0;
			var lineStyleIdxOffset:Int = 0;
			var currentFillStyleIdx0:Int = 0;
			var currentFillStyleIdx1:Int = 0;
			var currentLineStyleIdx:Int = 0;
			var subPath:Array<IEdge> = new Array<IEdge>();
			numGroups = 0;
			fillEdgeMaps = new Array<Map<Int, Array<IEdge>>>();
			lineEdgeMaps = new Array<Map<Int, Array<IEdge>>>();
			currentFillEdgeMap = new Map<Int, Array<IEdge>>();
			currentLineEdgeMap = new Map<Int, Array<IEdge>>();
			for (i in 0...records.length) {
				var shapeRecord:SWFShapeRecord = records[i];
				switch(shapeRecord.type) {
					case SWFShapeRecord.TYPE_STYLECHANGE:
						var styleChangeRecord:SWFShapeRecordStyleChange = cast (shapeRecord, SWFShapeRecordStyleChange);
						if (styleChangeRecord.stateLineStyle || styleChangeRecord.stateFillStyle0 || styleChangeRecord.stateFillStyle1) {
							processSubPath(subPath, currentLineStyleIdx, currentFillStyleIdx0, currentFillStyleIdx1);
							subPath = new Array<IEdge>();
						}
						if (styleChangeRecord.stateNewStyles) {
							fillStyleIdxOffset = fillStyles.length;
							lineStyleIdxOffset = lineStyles.length;
							appendFillStyles(fillStyles, styleChangeRecord.fillStyles);
							appendLineStyles(lineStyles, styleChangeRecord.lineStyles);
						}
						// Check if all styles are reset to 0.
						// This (probably) means that a new group starts with the next record
						if (styleChangeRecord.stateLineStyle && styleChangeRecord.lineStyle == 0 &&
							styleChangeRecord.stateFillStyle0 && styleChangeRecord.fillStyle0 == 0 &&
							styleChangeRecord.stateFillStyle1 && styleChangeRecord.fillStyle1 == 0) {
								cleanEdgeMap(currentFillEdgeMap);
								cleanEdgeMap(currentLineEdgeMap);
								fillEdgeMaps.push(currentFillEdgeMap);
								lineEdgeMaps.push(currentLineEdgeMap);
								currentFillEdgeMap = new Map<Int, Array<IEdge>>();
								currentLineEdgeMap = new Map<Int, Array<IEdge>>();
								currentLineStyleIdx = 0;
								currentFillStyleIdx0 = 0;
								currentFillStyleIdx1 = 0;
								numGroups++;
						} else {
							if (styleChangeRecord.stateLineStyle) {
								currentLineStyleIdx = styleChangeRecord.lineStyle;
								if (currentLineStyleIdx > 0) {
									currentLineStyleIdx += lineStyleIdxOffset;
								}
							}
							if (styleChangeRecord.stateFillStyle0) {
								currentFillStyleIdx0 = styleChangeRecord.fillStyle0;
								if (currentFillStyleIdx0 > 0) {
									currentFillStyleIdx0 += fillStyleIdxOffset;
								}
							}
							if (styleChangeRecord.stateFillStyle1) {
								currentFillStyleIdx1 = styleChangeRecord.fillStyle1;
								if (currentFillStyleIdx1 > 0) {
									currentFillStyleIdx1 += fillStyleIdxOffset;
								}
							}
						}
						if (styleChangeRecord.stateMoveTo) {
							xPos = styleChangeRecord.moveDeltaX / unitDivisor;
							yPos = styleChangeRecord.moveDeltaY / unitDivisor;
						}
					case SWFShapeRecord.TYPE_STRAIGHTEDGE:
						var straightEdgeRecord:SWFShapeRecordStraightEdge = cast (shapeRecord, SWFShapeRecordStraightEdge);
						from = new Point(NumberUtils.roundPixels400(xPos), NumberUtils.roundPixels400(yPos));
						if (straightEdgeRecord.generalLineFlag) {
							xPos += straightEdgeRecord.deltaX / unitDivisor;
							yPos += straightEdgeRecord.deltaY / unitDivisor;
						} else {
							if (straightEdgeRecord.vertLineFlag) {
								yPos += straightEdgeRecord.deltaY / unitDivisor;
							} else {
								xPos += straightEdgeRecord.deltaX / unitDivisor;
							}
						}
						to = new Point(NumberUtils.roundPixels400(xPos), NumberUtils.roundPixels400(yPos));
						subPath.push(new StraightEdge(from, to, currentLineStyleIdx, currentFillStyleIdx1));
					case SWFShapeRecord.TYPE_CURVEDEDGE:
						var curvedEdgeRecord:SWFShapeRecordCurvedEdge = cast (shapeRecord, SWFShapeRecordCurvedEdge);
						from = new Point(NumberUtils.roundPixels400(xPos), NumberUtils.roundPixels400(yPos));
						var xPosControl:Float = xPos + curvedEdgeRecord.controlDeltaX / unitDivisor;
						var yPosControl:Float = yPos + curvedEdgeRecord.controlDeltaY / unitDivisor;
						xPos = xPosControl + curvedEdgeRecord.anchorDeltaX / unitDivisor;
						yPos = yPosControl + curvedEdgeRecord.anchorDeltaY / unitDivisor;
						control = new Point(xPosControl, yPosControl);
						to = new Point(NumberUtils.roundPixels400(xPos), NumberUtils.roundPixels400(yPos));
						subPath.push(new CurvedEdge(from, control, to, currentLineStyleIdx, currentFillStyleIdx1));
					case SWFShapeRecord.TYPE_END:
						// We're done. Process the last subpath, if any
						processSubPath(subPath, currentLineStyleIdx, currentFillStyleIdx0, currentFillStyleIdx1);
						cleanEdgeMap(currentFillEdgeMap);
						cleanEdgeMap(currentLineEdgeMap);
						fillEdgeMaps.push(currentFillEdgeMap);
						lineEdgeMaps.push(currentLineEdgeMap);
						numGroups++;
				}
			}
			edgeMapsCreated = true;
		}
	}
	
	private function processSubPath(subPath:Array<IEdge>, lineStyleIdx:Int, fillStyleIdx0:Int, fillStyleIdx1:Int):Void {
		var path:Array<IEdge>;
		if (fillStyleIdx0 != 0) {
			path = currentFillEdgeMap.get (fillStyleIdx0);
			if (path == null) { 
				currentFillEdgeMap.set (fillStyleIdx0, new Array<IEdge>());
				path = currentFillEdgeMap.get (fillStyleIdx0);
			}
			var j = subPath.length - 1;
			while (j >= 0) {
				path.push(subPath[j].reverseWithNewFillStyle(fillStyleIdx0));
				j--;
			}
		}
		if (fillStyleIdx1 != 0) {
			path = currentFillEdgeMap.get (fillStyleIdx1);
			if (path == null) {
				currentFillEdgeMap.set (fillStyleIdx1, new Array<IEdge>());
				path = currentFillEdgeMap.get (fillStyleIdx1);
			}
			appendEdges(path, subPath);
		}
		if (lineStyleIdx != 0) {
			path = currentLineEdgeMap.get (lineStyleIdx);
			if (path == null) {
				currentLineEdgeMap.set (lineStyleIdx, new Array<IEdge>());
				path = currentLineEdgeMap.get (lineStyleIdx);
			}
			appendEdges(path, subPath);
		}
	}
	
	private function exportFillPath(handler:IShapeExporter, groupIndex:Int):Void {
		var path:Array<IEdge> = createPathFromEdgeMap(fillEdgeMaps[groupIndex]);
		var pos:Point = new Point(SWFData.MAX_FLOAT_VALUE, SWFData.MAX_FLOAT_VALUE);
		//var fillStyleIdx:Int = uint.MAX_VALUE;
		var fillStyleIdx:Int = Std.int (SWFData.MAX_FLOAT_VALUE);
		if(path.length > 0) {
			handler.beginFills();
			for (i in 0...path.length) {
				var e:IEdge = path[i];
				if (fillStyleIdx != e.fillStyleIdx) {
					//if(fillStyleIdx != uint.MAX_VALUE) {
					if(fillStyleIdx != SWFData.MAX_FLOAT_VALUE) {
						handler.endFill();
					}
					fillStyleIdx = e.fillStyleIdx;
					pos = new Point(SWFData.MAX_FLOAT_VALUE, SWFData.MAX_FLOAT_VALUE);
					try {
						var matrix:Matrix;
						var fillStyle:SWFFillStyle = fillStyles[fillStyleIdx - 1];
						if (fillStyle != null) {
							switch(fillStyle.type) {
								case 0x00:
									// Solid fill
									handler.beginFill(ColorUtils.rgb(fillStyle.rgb), ColorUtils.alpha(fillStyle.rgb));
								case 0x10, 0x12, 0x13:
									// Gradient fill
									var colors:Array<UInt> = [];
									var alphas:Array<Float> = [];
									var ratios:Array<Int> = [];
									var gradientRecord:SWFGradientRecord;
									matrix = fillStyle.gradientMatrix.matrix.clone();
									matrix.tx /= 20;
									matrix.ty /= 20;
									for (gri in 0...fillStyle.gradient.records.length) {
										gradientRecord = fillStyle.gradient.records[gri];
										colors.push(ColorUtils.rgb(gradientRecord.color));
										alphas.push(ColorUtils.alpha(gradientRecord.color));
										ratios.push(gradientRecord.ratio);
									}
									handler.beginGradientFill(
										(fillStyle.type == 0x10) ? GradientType.LINEAR : GradientType.RADIAL,
										colors, alphas, ratios, matrix,
										GradientSpreadMode.toEnum(fillStyle.gradient.spreadMode),
										GradientInterpolationMode.toEnum(fillStyle.gradient.interpolationMode),
										fillStyle.gradient.focalPoint
									);
								case 0x40, 0x41, 0x42, 0x43:
									// Bitmap fill
									var m:SWFMatrix = fillStyle.bitmapMatrix;
									matrix = new Matrix(m.scaleX / 20, m.rotateSkew0 / 20, m.rotateSkew1 / 20, m.scaleY / 20, m.translateX / 20, m.translateY / 20 );
									handler.beginBitmapFill(
										fillStyle.bitmapId,
										matrix,
										(fillStyle.type == 0x40 || fillStyle.type == 0x42),
										(fillStyle.type == 0x40 || fillStyle.type == 0x41)
									);
							}
						} else {
							// TODO: Static SWF text is falling through to here :(
							handler.beginFill (0xFFFFFF);
						}
					} catch (e:Error) {
						// Font shapes define no fillstyles per se, but do reference fillstyle index 1,
						// which represents the font color. We just report solid black in this case.
						handler.beginFill(0);
					}
				}
				if (!pos.equals(e.from)) {
					handler.moveTo(e.from.x, e.from.y);
				}
				if (Std.is (e, CurvedEdge)) {
					var c:CurvedEdge = cast e;
					handler.curveTo(c.control.x, c.control.y, c.to.x, c.to.y);
				} else {
					handler.lineTo(e.to.x, e.to.y);
				}
				pos = e.to;
			}
			//if(fillStyleIdx != uint.MAX_VALUE) {
			if(fillStyleIdx != SWFData.MAX_FLOAT_VALUE) {
				handler.endFill();
			}
			handler.endFills();
		}
	}
	
	private function exportLinePath(handler:IShapeExporter, groupIndex:Int):Void {
		var path:Array<IEdge> = createPathFromEdgeMap(lineEdgeMaps[groupIndex]);
		var pos:Point = new Point(SWFData.MAX_FLOAT_VALUE, SWFData.MAX_FLOAT_VALUE);
		//var lineStyleIdx:Int = uint.MAX_VALUE;
		var lineStyleIdx:Int = Std.int (SWFData.MAX_FLOAT_VALUE);
		var lineStyle:SWFLineStyle;
		if(path.length > 0) {
			handler.beginLines();
			for (i in 0...path.length) {
				var e:IEdge = path[i];
				if (lineStyleIdx != e.lineStyleIdx) {
					lineStyleIdx = e.lineStyleIdx;
					pos = new Point(SWFData.MAX_FLOAT_VALUE, SWFData.MAX_FLOAT_VALUE);
					try {
						lineStyle = lineStyles[lineStyleIdx - 1];
					} catch (e:Error) {
						lineStyle = null;
					}
					if (lineStyle != null) {
						var scaleMode:LineScaleMode = LineScaleMode.NORMAL;
						if (lineStyle.noHScaleFlag && lineStyle.noVScaleFlag) {
							scaleMode = LineScaleMode.NONE;
						} else if (lineStyle.noHScaleFlag) {
							scaleMode = LineScaleMode.HORIZONTAL;
						} else if (lineStyle.noVScaleFlag) {
							scaleMode = LineScaleMode.VERTICAL;
						}
						handler.lineStyle(
							lineStyle.width / 20, 
							ColorUtils.rgb(lineStyle.color), 
							ColorUtils.alpha(lineStyle.color), 
							lineStyle.pixelHintingFlag,
							scaleMode,
							LineCapsStyle.toEnum(lineStyle.startCapsStyle),
							LineCapsStyle.toEnum(lineStyle.endCapsStyle),
							LineJointStyle.toEnum(lineStyle.jointStyle),
							lineStyle.miterLimitFactor);
						
						if(lineStyle.hasFillFlag) {
							var fillStyle:SWFFillStyle = lineStyle.fillType;
							switch(fillStyle.type) {
								case 0x10, 0x12, 0x13:
									// Gradient fill
									var colors:Array<Int> = [];
									var alphas:Array<Float> = [];
									var ratios:Array<Int> = [];
									var gradientRecord:SWFGradientRecord;
									var matrix:Matrix = fillStyle.gradientMatrix.matrix.clone();
									matrix.tx /= 20;
									matrix.ty /= 20;
									for (gri in 0...fillStyle.gradient.records.length) {
										gradientRecord = fillStyle.gradient.records[gri];
										colors.push(ColorUtils.rgb(gradientRecord.color));
										alphas.push(ColorUtils.alpha(gradientRecord.color));
										ratios.push(gradientRecord.ratio);
									}
									handler.lineGradientStyle(
										(fillStyle.type == 0x10) ? GradientType.LINEAR : GradientType.RADIAL,
										colors, alphas, ratios, matrix,
										GradientSpreadMode.toEnum(fillStyle.gradient.spreadMode),
										GradientInterpolationMode.toEnum(fillStyle.gradient.interpolationMode),
										fillStyle.gradient.focalPoint
									);
							}
						}
					} else {
						// We should never get here
						handler.lineStyle(0);
					}
				}
				if (!e.from.equals(pos)) {
					handler.moveTo(e.from.x, e.from.y);
				}
				if (Std.is (e, CurvedEdge)) {
					var c:CurvedEdge = cast e;
					handler.curveTo(c.control.x, c.control.y, c.to.x, c.to.y);
				} else {
					handler.lineTo(e.to.x, e.to.y);
				}
				pos = e.to;
			}
			handler.endLines();
		}
	}
	
	private function createPathFromEdgeMap(edgeMap:Map<Int, Array<IEdge>>):Array<IEdge> {
		var newPath:Array<IEdge> = new Array<IEdge>();
		var styleIdxArray = [];
		for(styleIdx in edgeMap.keys()) {
			styleIdxArray.push(Std.int(styleIdx));
		}
		styleIdxArray.sort(function (a, b) { return a - b; } );
		for(i in 0...styleIdxArray.length) {
			appendEdges(newPath, edgeMap.get (styleIdxArray[i]));
		}
		return newPath;
	}
	
	private function cleanEdgeMap(edgeMap:Map<Int, Array<IEdge>>):Void {
		for(styleIdx in edgeMap.keys()) {
			var subPath:Array<IEdge> = edgeMap.get (styleIdx);
			if(subPath != null && subPath.length > 0) {
				var idx:Int;
				var prevEdge:IEdge = null;
				var tmpPath:Array<IEdge> = new Array<IEdge>();
				createCoordMap(subPath);
				while(subPath.length > 0) {
					idx = 0;
					while(idx < subPath.length) {
						if(prevEdge == null || prevEdge.to.equals(subPath[idx].from)) {
							var edge:IEdge = subPath.splice(idx, 1)[0];
							tmpPath.push(edge);
							removeEdgeFromCoordMap(edge);
							prevEdge = edge;
						} else {
							var edge = findNextEdgeInCoordMap(prevEdge);
							if (edge != null) {
								for (i in 0...subPath.length) {
									if (subPath[i] == edge) idx = i;
								}
							} else {
								idx = 0;
								prevEdge = null;
							}
						}
					}
				}
				edgeMap.set (styleIdx, tmpPath);
			}
		}
	}
	
	private function createCoordMap(path:Array<IEdge>):Void {
		coordMap = new Map<String, Array<IEdge>>();
		for(i in 0...path.length) {
			var from:Point = path[i].from;
			var key:String = from.x + "_" + from.y;
			var coordMapArray = coordMap.get (key);
			if(coordMapArray == null) {
				coordMap.set (key, [ path[i] ]);
			} else {
				coordMapArray.push(path[i]);
			}
		}
	}
	
	private function removeEdgeFromCoordMap(edge:IEdge):Void {
		var key:String = edge.from.x + "_" + edge.from.y;
		var coordMapArray = coordMap.get (key);
		if (coordMapArray != null) {
			coordMap.remove (key);
		}
	}
	
	private function findNextEdgeInCoordMap(edge:IEdge):IEdge {
		var key:String = edge.to.x + "_" + edge.to.y;
		var coordMapArray:Array<IEdge> = coordMap.get (key);
		if(coordMapArray != null && coordMapArray.length > 0) {
			return cast coordMapArray[0];
		}
		return null;
	}
	
	private function appendFillStyles(v1:Array<SWFFillStyle>, v2:Array<SWFFillStyle>):Void {
		for (i in 0...v2.length) {
			v1.push(v2[i]);
		}
	}
	
	private function appendLineStyles(v1:Array<SWFLineStyle>, v2:Array<SWFLineStyle>):Void {
		for (i in 0...v2.length) {
			v1.push(v2[i]);
		}
	}

	private function appendEdges(v1:Array<IEdge>, v2:Array<IEdge>):Void {
		for (i in 0...v2.length) {
			v1.push(v2[i]);
		}
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = "\n" + StringUtils.repeat(indent) + "ShapeRecords:";
		for (i in 0...records.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + records[i].toString(indent + 2);
		}
		return str;
	}
}