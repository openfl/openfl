package openfl.utils;

import format.swf.lite.timeline.FrameObjectType;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.ShapeSymbol;
import format.swf.lite.symbols.SimpleSpriteSymbol;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class MovieClipPreprocessor {

    static var jobTable = new Array<JobContext> ();
    static var currentJob:JobContext = null;
    public static var globalTimeSliceMillisecondCount = 10;

    static public function process(movieclip : MovieClip, cachePrecision:Int = 100, timeSliceMillisecondCount:Null<Int> = null, priority:Int = 0) {
        var symbol = movieclip.getSymbol ();

        if (symbol != null) {
            var swf = cast (Reflect.field (movieclip, "__swf"), SWFLite);
            @:privateAccess movieclip.__getWorldTransform ();
            jobTable.push (new JobContext (cast (symbol, SpriteSymbol), swf, movieclip.__renderTransform, timeSliceMillisecondCount != null, timeSliceMillisecondCount, cachePrecision, priority) );
            jobTable.sort (function (first:JobContext, second:JobContext) { return @:privateAccess second.priority - @:privateAccess first.priority; });

            processNextJob ();
        }
    }

    static private function processNextJob() {
        if (currentJob == null || currentJob.done) {
            if (jobTable.length > 0) {
                currentJob = jobTable.shift();
                currentJob.process ();
            } else {
                currentJob = null;
            }
        }
    }

    static public function renderCompleteInstant(clipId:String, cachePrecision:Int = 100, ?parent:DisplayObjectContainer = null)
    {
        var tempClip = Assets.getMovieClip(clipId);

        if(parent == null) {
            parent = Lib.current.stage;
        }

        parent.addChild(tempClip);

        process(tempClip, cachePrecision);

        parent.removeChild(tempClip);
        // :TODO: reset parent if there was one
    }

    static public function renderComplete(clipId:String, cachePrecision:Int = 100, ?parent:DisplayObjectContainer = null, timeSliceMillisecondCount = null)
    {
        if ( timeSliceMillisecondCount == null ) {
            timeSliceMillisecondCount = globalTimeSliceMillisecondCount;
        }

        var tempClip = Assets.getMovieClip(clipId);

        if(parent == null) {
            parent = Lib.current.stage;
        }

        parent.addChild(tempClip);

        process(tempClip, cachePrecision, timeSliceMillisecondCount);

        parent.removeChild(tempClip);
        // :TODO: reset parent if there was one
    }
}

typedef ShapeCacheInfo = {
    symbol: ShapeSymbol,
    transform: Matrix
};

private class Sprite {
    private var idRenderTransformMap = new Map<Int,Matrix> ();
    private var idSymbolMap = new Map<Int,Int> ();
    private var idSpriteMap = new Map<Int, Sprite>();
    private var symbol:SpriteSymbol;

    public var frameIndex:Int = 0;

    public function new(symbol:SpriteSymbol) {
        this.symbol = symbol;
    }

    public function update(shapeTable:Array<ShapeCacheInfo>, simpleSpritesToProcessTable:Array<SimpleSpriteSymbol>, swflite:SWFLite, transform:Matrix):Void {
        if(frameIndex >= symbol.frames.length) {
            frameIndex = 0;
        }
        var frame =  symbol.frames[frameIndex];
        var renderTransform:Matrix = Matrix.pool.get ();

        for (frameObject in frame.objects) {
            var symbol = swflite.symbols.get(frameObject.symbol);
            var isSprite = Std.is(symbol, SpriteSymbol);

            if (frameObject.type != FrameObjectType.DESTROY) {

                if (frameObject.matrix != null) {
                    renderTransform.copyFrom (frameObject.matrix);
                    renderTransform.concat (transform);
                } else {
                    var cached = idRenderTransformMap[frameObject.id];
                    renderTransform.copyFrom (cached != null ? cached : transform);
                }

                if (isSprite) {
                    var sprite = idSpriteMap.get(frameObject.id);
                    if(sprite == null || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
                        sprite = new Sprite(cast symbol);
                        idSpriteMap.set(frameObject.id, sprite);
                    }
                    sprite.update(shapeTable, simpleSpritesToProcessTable, swflite, renderTransform);
                } else if (Std.is(symbol, ShapeSymbol)) {
                    if (frameObject.symbol != idSymbolMap[frameObject.id] || !renderTransform.equals (idRenderTransformMap[frameObject.id])) {
                        shapeTable.push ({ symbol: cast symbol, transform: renderTransform.clone () });
                    }
                } else if (Std.is(symbol, SimpleSpriteSymbol)) {
                    if (frameObject.symbol != idSymbolMap[frameObject.id]) {
                        simpleSpritesToProcessTable.push(cast symbol);
                    }
                }

                idRenderTransformMap[frameObject.id] = renderTransform.clone ();
                idSymbolMap[frameObject.id] = frameObject.symbol;
            } else {
                if(isSprite) {
                    idSpriteMap.remove(frameObject.id);
                }

                idSymbolMap.remove(frameObject.id);
            }
        }

        ++frameIndex;
        Matrix.pool.put(renderTransform);
    }
}

class JobContext {
    private var shapeToProcessTable = new Array<ShapeCacheInfo> ();
    private var simpleSpritesToProcessTable = new Array<SimpleSpriteSymbol> ();
    private var shapeToProcessIndex: Int = 0;
    private var simpleSpriteToProcessIndex: Int = 0;
    private var frameToProcessIndex: Int = 0;
    private var symbol: SpriteSymbol;
    private var timeSliceMillisecondCount:Int;
    private var useDelay:Bool;
    private var cachePrecision:Int;
    private var priority:Int;
    private var swf:SWFLite;
    private var startTime:Int;
    private var baseTransform:Matrix;

    public var done(default, null):Bool = false;

    public function new (symbol:SpriteSymbol, swf:SWFLite, baseTransform:Matrix, useDelay:Bool, timeSliceMillisecondCount:Int, cachePrecision:Int, priority:Int) {
        this.symbol= symbol;
        this.swf= swf;
        this.baseTransform = baseTransform.clone ();
        this.useDelay = useDelay;
        this.timeSliceMillisecondCount = timeSliceMillisecondCount;
        this.cachePrecision = cachePrecision;
        this.priority = priority;
    }

    private inline function timedOut ():Bool {
        return useDelay && (openfl.Lib.getTimer () - startTime) >= timeSliceMillisecondCount;
    }

    public function process () {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;

        startTime = openfl.Lib.getTimer ();

        if (frameToProcessIndex < symbol.frames.length) {
            frameToProcessIndex = findDependentSymbols (shapeToProcessTable, simpleSpritesToProcessTable, symbol, swf, baseTransform, frameToProcessIndex);
        }

        while (shapeToProcessIndex < shapeToProcessTable.length && !timedOut ()) {
            var entry = shapeToProcessTable [shapeToProcessIndex];
            var graphics = entry.symbol.graphics;
            graphics.dirty = true;
            openfl._internal.renderer.canvas.CanvasGraphics.render (graphics, renderSession, entry.transform, false);

            if(@:privateAccess graphics.__bitmap != null) {
                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = entry.symbol.id + " (preprocessed)";
                #end

                @:privateAccess graphics.__bitmap.getTexture (gl);

                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = null;
                #end
            }

            graphics.dirty = true;
            ++shapeToProcessIndex;
        }

        while (simpleSpriteToProcessIndex < simpleSpritesToProcessTable.length && !timedOut ()) {
            var symbol = simpleSpritesToProcessTable[simpleSpriteToProcessIndex];
            var bitmapData = Assets.getBitmapData(cast(swf.symbols.get(symbol.bitmapID),format.swf.lite.symbols.BitmapSymbol).path);

            if(bitmapData != null) {
                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = symbol.id + " (preprocessed)";
                #end

                @:privateAccess bitmapData.getTexture (gl);

                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = null;
                #end
            }

            ++simpleSpriteToProcessIndex;
        }

        if (frameToProcessIndex == symbol.frames.length && shapeToProcessIndex == shapeToProcessTable.length && simpleSpriteToProcessIndex == simpleSpritesToProcessTable.length) {
            done = true;
            @:privateAccess MovieClipPreprocessor.processNextJob ();
        } else {
            if(useDelay) {
                haxe.Timer.delay (process, 16);
            }
        }
    }

    private function findDependentSymbols(shapeTable:Array<ShapeCacheInfo>, simpleSpritesToProcessTable:Array<SimpleSpriteSymbol>, symbol:SpriteSymbol, swflite:SWFLite, transform:Matrix, frameIndex:Int):Int {
        var mainSprite = new Sprite(symbol);

        while (frameIndex < symbol.frames.length && !timedOut ()) {
            mainSprite.update(shapeTable, simpleSpritesToProcessTable, swflite, transform);

            ++frameIndex;
        }

        if (frameIndex == symbol.frames.length && symbol == this.symbol) {
            for (entry in shapeTable) {
                var shapeSymbol = entry.symbol;
                shapeSymbol.cachePrecision = cachePrecision;
                shapeSymbol.useBitmapCache = true;
            }
        }

        return frameIndex;
    }
}
