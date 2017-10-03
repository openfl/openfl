package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import format.swf.data.SWFShape;
import format.swf.data.SWFShapeRecord;
import format.swf.data.SWFShapeRecordStraightEdge;
import format.swf.data.SWFShapeRecordCurvedEdge;
import format.swf.data.SWFShapeRecordStyleChange;
import format.swf.data.SWFMorphFillStyle;
import format.swf.data.SWFMorphLineStyle;
import format.swf.exporters.core.IShapeExporter;
import format.swf.exporters.ShapeCommandExporter;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import haxe.io.Int32Array;
import openfl.geom.Rectangle;

class MorphShapeSymbol extends SWFSymbol {

    @:s public var startEdges : SWFShape;
    @:s public var endEdges : SWFShape;
    @:s public var morphFillStyles :Array<SWFMorphFillStyle>;
    @:s public var morphLineStyles :Array<SWFMorphLineStyle>;

    public var cachedHandlers: Map<Int,ShapeCommandExporter>;

    public var useBitmapCache(default, set):Bool = false;
    private var cachedTable:Array<CacheEntry>;
    public var cachePrecision:Int = 100;

    public function new () {

        super ();

    }

    public function getShape(ratio:Float):SWFShape {
        var j:Int = 0;
        var exportShape:SWFShape = new SWFShape();
        var lastStartStyleChange:SWFShapeRecordStyleChange = null;
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

            if (endRecord.type == SWFShapeRecord.TYPE_STYLECHANGE
                && startRecord.type != SWFShapeRecord.TYPE_STYLECHANGE) {

                var startStyleChange:SWFShapeRecordStyleChange = cast lastStartStyleChange.clone();
                var endStyleChange:SWFShapeRecordStyleChange = cast endRecord;

                startStyleChange.stateMoveTo = true;
                startStyleChange.moveDeltaX += (endStyleChange.moveDeltaX - startStyleChange.moveDeltaX) * ratio;
                startStyleChange.moveDeltaY += (endStyleChange.moveDeltaY - startStyleChange.moveDeltaY) * ratio;
                ++j;

                exportShape.records.push(startStyleChange);
                continue;
            }

            switch(startRecord.type) {
                case SWFShapeRecord.TYPE_STYLECHANGE:
                    lastStartStyleChange = cast startRecord;
                    var startStyleChange:SWFShapeRecordStyleChange = cast startRecord.clone();
                    startStyleChange.stateMoveTo = true;
                    if (endRecord.type == SWFShapeRecord.TYPE_STYLECHANGE) {
                        var endStyleChange:SWFShapeRecordStyleChange = cast endRecord;
                        startStyleChange.moveDeltaX += (endStyleChange.moveDeltaX - startStyleChange.moveDeltaX) * ratio;
                        startStyleChange.moveDeltaY += (endStyleChange.moveDeltaY - startStyleChange.moveDeltaY) * ratio;
                    } else {
                        startStyleChange.moveDeltaX += (-startStyleChange.moveDeltaX) * ratio;
                        startStyleChange.moveDeltaY += ( -startStyleChange.moveDeltaY) * ratio;
                        j--;
                    }
                    exportRecord = startStyleChange;
                case SWFShapeRecord.TYPE_STRAIGHTEDGE:
                    var startStraightEdge:SWFShapeRecordStraightEdge = cast startRecord.clone();
                    var endStraightEdge:SWFShapeRecordStraightEdge = cast endRecord;

                    startStraightEdge.deltaX += (endStraightEdge.deltaX - startStraightEdge.deltaX) * ratio;
                    startStraightEdge.deltaY += (endStraightEdge.deltaY - startStraightEdge.deltaY) * ratio;

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
                    startCurvedEdge.controlDeltaX += (endCurvedEdge.controlDeltaX - startCurvedEdge.controlDeltaX) * ratio;
                    startCurvedEdge.controlDeltaY += (endCurvedEdge.controlDeltaY - startCurvedEdge.controlDeltaY) * ratio;
                    startCurvedEdge.anchorDeltaX += (endCurvedEdge.anchorDeltaX - startCurvedEdge.anchorDeltaX) * ratio;
                    startCurvedEdge.anchorDeltaY += (endCurvedEdge.anchorDeltaY - startCurvedEdge.anchorDeltaY) * ratio;
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

        return exportShape;
    }

    private function convertToCurvedEdge(straightEdge:SWFShapeRecordStraightEdge):SWFShapeRecordCurvedEdge {
        var curvedEdge:SWFShapeRecordCurvedEdge = new SWFShapeRecordCurvedEdge();
        curvedEdge.controlDeltaX = straightEdge.deltaX / 2;
        curvedEdge.controlDeltaY = straightEdge.deltaY / 2;
        //curvedEdge.anchorDeltaX = straightEdge.deltaX;
        //curvedEdge.anchorDeltaY = straightEdge.deltaY;
        curvedEdge.anchorDeltaX = straightEdge.deltaX / 2;
        curvedEdge.anchorDeltaY = straightEdge.deltaY / 2;
        return curvedEdge;
    }

    public function set_useBitmapCache (useBitmapCache:Bool):Bool {

        if (useBitmapCache && cachedTable == null) {
            cachedTable = new Array<CacheEntry> ();
        }

        return this.useBitmapCache = useBitmapCache;
    }

    public function getCacheEntry(renderTransform:Matrix, ratio:Float):CacheEntry {

        if (useBitmapCache) {

            var hash = CacheEntry.getHash(renderTransform, ratio, cachePrecision);

            for (entry in cachedTable) {

                if (entry.hash == hash) {

                    return entry;

                }

            }

        }

        return null;

    }


    public function addCacheEntry(bitmapData:BitmapData, bounds:Rectangle, renderTransform:Matrix, ratio:Float) {

        if (!useBitmapCache) {

            return ;

        }

        var hash = CacheEntry.getHash(renderTransform, ratio, cachePrecision);
        cachedTable.push (new CacheEntry (bitmapData, bounds, hash));

    }
}

class CacheEntry {

    public var bitmapData:BitmapData;
    public var bounds:Rectangle;
    public var hash:Int;

    public function new (bitmapData:BitmapData, bounds:Rectangle, hash:Int) {
        this.bitmapData = bitmapData;
        this.bounds = bounds.clone();
        this.hash = hash;
    }

    static private var __buffer = new Int32Array(5);

    static public function getHash(matrix:Matrix, ratio:Float, cachePrecision:Int):Int {
        var buffer = __buffer;

        buffer[0] = Std.int(matrix.a * cachePrecision);
        buffer[1] = Std.int(matrix.b * cachePrecision);
        buffer[2] = Std.int(matrix.c * cachePrecision);
        buffer[3] = Std.int(matrix.d * cachePrecision);
        buffer[4] = Std.int(ratio * 100);

        return haxe.crypto.Crc32.make(buffer.view.buffer);
    }
}
