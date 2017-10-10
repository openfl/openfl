package openfl.utils;

import format.swf.exporters.ShapeCommandExporter;
import openfl.display.Graphics;
import format.swf.lite.MorphShape;
import format.swf.lite.timeline.FrameObjectType;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.MorphShapeSymbol;
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

    static public function process(movieclip : MovieClip, cachePrecision:Int = 100, translationCachePrecision:Int = 100, timeSliceMillisecondCount:Null<Int> = null, priority:Int = 0) {
        var symbol = movieclip.getSymbol ();

        if (symbol != null) {
            var swf = cast (Reflect.field (movieclip, "__swf"), SWFLite);
            @:privateAccess movieclip.__getWorldTransform ();
            jobTable.push (new JobContext (cast (symbol, SpriteSymbol), swf, movieclip.__renderTransform, timeSliceMillisecondCount != null, timeSliceMillisecondCount, cachePrecision, translationCachePrecision, priority) );
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
                #if dev
                    trace("No more job.");
                #end
            }
        }
    }

    static public function renderCompleteFromSymbol(spriteSymbol:SpriteSymbol, swflite:SWFLite, cachePrecision:Int = 100, translationCachePrecision:Int = 100, ?parent:DisplayObjectContainer, timeSliceMillisecondCount = null)
    {
        var tempClip = new format.swf.lite.MovieClip (swflite, spriteSymbol);

        if(parent == null) {
            parent = Lib.current.stage;
        }

        parent.addChild(tempClip);

        process(tempClip, cachePrecision, translationCachePrecision, timeSliceMillisecondCount);

        parent.removeChild(tempClip);
    }

    static public function renderCompleteInstant(clipId:String, cachePrecision:Int = 100, translationCachePrecision:Int = 100, ?parent:DisplayObjectContainer = null)
    {
        var tempClip = Assets.getMovieClip(clipId);

        if(parent == null) {
            parent = Lib.current.stage;
        }

        parent.addChild(tempClip);

        process(tempClip, cachePrecision, translationCachePrecision);

        parent.removeChild(tempClip);
    }

    static public function renderComplete(clipId:String, cachePrecision:Int = 100, translationCachePrecision:Int = 100, ?parent:DisplayObjectContainer = null, timeSliceMillisecondCount = null)
    {
        if ( timeSliceMillisecondCount == null ) {
            timeSliceMillisecondCount = globalTimeSliceMillisecondCount;
        }

        var tempClip = Assets.getMovieClip(clipId);

        if(parent == null) {
            parent = Lib.current.stage;
        }

        parent.addChild(tempClip);

        process(tempClip, cachePrecision, translationCachePrecision, timeSliceMillisecondCount);

        parent.removeChild(tempClip);
    }
}

typedef ShapeCacheInfo = {
    symbol: ShapeSymbol,
    transform: Matrix
};

typedef MorphShapeCacheInfo = {
    symbol: MorphShapeSymbol,
    transform: Matrix,
    ratio: Float
};

private class Sprite {
    private var idTransformMap = new Map<Int,Matrix> ();
    private var idRenderTransformMap = new Map<Int,Matrix> ();
    private var idRatiosMap = new Map<Int,Array<Float>> ();
    private var idSymbolMap = new Map<Int,Int> ();
    private var idSpriteMap = new Map<Int, Sprite>();
    private var children = new Array<Sprite>();
    private var symbol:SpriteSymbol;

    public var frameIndex:Int = 0;
    public var renderTransform:Matrix;

    public function new(symbol:SpriteSymbol) {
        this.symbol = symbol;
        renderTransform = Matrix.pool.get();
    }

    public function update(shapeTable:Array<ShapeCacheInfo>, simpleSpritesToProcessTable:Array<SimpleSpriteSymbol>, morphShapeToProcessTable:Array<MorphShapeCacheInfo>, swflite:SWFLite):Void {
        if(frameIndex >= symbol.frames.length) {
            frameIndex = 0;
        }
        var frame =  symbol.frames[frameIndex];
        var childRenderTransform:Matrix = Matrix.pool.get ();
        var localTransform:Matrix = Matrix.pool.get ();

        for (frameObject in frame.objects) {
            var symbol = swflite.symbols.get(frameObject.symbol);
            var isSprite = Std.is(symbol, SpriteSymbol);

            if (frameObject.type != FrameObjectType.DESTROY) {

                if (frameObject.matrix != null) {
                    localTransform.copyFrom(frameObject.matrix);

                } else {

                    var cached = idTransformMap[frameObject.id];

                    if(cached != null) {
                        localTransform.copyFrom (cached);
                    }
                    else {
                        localTransform.identity();
                    }
                }

                childRenderTransform.copyFrom(localTransform);
                childRenderTransform.concat (renderTransform);

                if (isSprite) {
                    var sprite = idSpriteMap.get(frameObject.id);
                    if(sprite == null || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
                        sprite = new Sprite(cast symbol);
                        idSpriteMap.set(frameObject.id, sprite);
                        children.push(sprite);
                    }
                    sprite.renderTransform.copyFrom(childRenderTransform);
            } else if (Std.is(symbol, MorphShapeSymbol)) {
                if ( !idRatiosMap.exists(frameObject.id) ) {
                    idRatiosMap.set(frameObject.id, []);
                }
                var patchedRatio = frameObject.ratio == null ? 0 : frameObject.ratio;
                    var morphShapeSymbol = cast(symbol, MorphShapeSymbol);
                    if ( morphShapeSymbol.cachedHandlers == null ) {
                        morphShapeSymbol.cachedHandlers = new Map<Int, ShapeCommandExporter>();
                    }
                    morphShapeToProcessTable.push ({ symbol: morphShapeSymbol, transform: childRenderTransform.clone (), ratio: patchedRatio });

                } else if (Std.is(symbol, SimpleSpriteSymbol)) {
                    if (frameObject.symbol != idSymbolMap[frameObject.id]) {
                        simpleSpritesToProcessTable.push(cast symbol);
                    }
                } else if (Std.is(symbol, ShapeSymbol)) {
                    if (frameObject.symbol != idSymbolMap[frameObject.id] || !childRenderTransform.equals (idRenderTransformMap[frameObject.id])) {
                        shapeTable.push ({ symbol: cast symbol, transform: childRenderTransform.clone () });
                    }
                }

                if(!idTransformMap.exists(frameObject.id)) {
                    idTransformMap[frameObject.id] = Matrix.pool.get();
                }

                if(!idRenderTransformMap.exists(frameObject.id)) {
                    idRenderTransformMap[frameObject.id] = Matrix.pool.get();
                }

                idTransformMap[frameObject.id].copyFrom(localTransform.clone ());
                idRenderTransformMap[frameObject.id].copyFrom(childRenderTransform.clone ());
                idSymbolMap[frameObject.id] = frameObject.symbol;
            } else {
                if(isSprite) {
                    var sprite = idSpriteMap.get(frameObject.id);
                    sprite.dispose();
                    idSpriteMap.remove(frameObject.id);
                    children.remove(sprite);
                }

                idSymbolMap.remove(frameObject.id);
            }

        }

        for(sprite in children) {
            sprite.update(shapeTable, simpleSpritesToProcessTable, morphShapeToProcessTable, swflite);
        }

        ++frameIndex;
        Matrix.pool.put(childRenderTransform);
        Matrix.pool.put(localTransform);
    }

    public function dispose() {
        Matrix.pool.put(renderTransform);
        for(t in idTransformMap) {
            Matrix.pool.put(t);
        }
        for(t in idRenderTransformMap) {
            Matrix.pool.put(t);
        }
    }
}

class JobContext {
    private var shapeToProcessTable = new Array<ShapeCacheInfo> ();
    private var morphShapeToProcessTable = new Array<MorphShapeCacheInfo>();
    private var simpleSpritesToProcessTable = new Array<SimpleSpriteSymbol> ();
    private var shapeToProcessIndex: Int = 0;
    private var simpleSpriteToProcessIndex: Int = 0;
    private var morphShapeToProcessIndex: Int = 0;
    private var symbol: SpriteSymbol;
    private var timeSliceMillisecondCount:Int;
    private var useDelay:Bool;
    private var cachePrecision:Int;
    private var translationCachePrecision:Int;
    private var priority:Int;
    private var swf:SWFLite;
    private var startTime:Int;
    private var mainSprite:Sprite;

    public var done(default, null):Bool = false;

    public function new (symbol:SpriteSymbol, swf:SWFLite, baseTransform:Matrix, useDelay:Bool, timeSliceMillisecondCount:Int, cachePrecision:Int, translationCachePrecision:Int, priority:Int) {
        this.symbol= symbol;
        this.swf= swf;
        this.useDelay = useDelay;
        this.timeSliceMillisecondCount = timeSliceMillisecondCount;
        this.cachePrecision = cachePrecision;
        this.translationCachePrecision = translationCachePrecision;
        this.priority = priority;
        mainSprite = new Sprite(symbol);
        mainSprite.dispose();
        mainSprite.renderTransform = baseTransform.clone();
    }

    private inline function timedOut ():Bool {
        return useDelay && (openfl.Lib.getTimer () - startTime) >= timeSliceMillisecondCount;
    }

    public function process () {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;

        startTime = openfl.Lib.getTimer ();

        if (mainSprite.frameIndex < symbol.frames.length) {
            updateMainSprite(shapeToProcessTable, simpleSpritesToProcessTable, morphShapeToProcessTable, swf);
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

        while (morphShapeToProcessIndex < morphShapeToProcessTable.length && !timedOut()) {
            var entry = morphShapeToProcessTable[morphShapeToProcessIndex];
            var graphics = @:privateAccess new Graphics();
            graphics.keepBitmapData = true;
            if ( @:privateAccess MorphShape.__updateMorphShape(entry.symbol, entry.ratio, entry.transform, graphics) ) {
                openfl._internal.renderer.canvas.CanvasGraphics.render (graphics, renderSession, entry.transform, false);
                if ( @:privateAccess graphics.__bitmap != null ) {
                    #if(js && profile)
                        untyped $global.Profile.BitmapDataUpload.currentProfileId = symbol.id + " (preprocessed)";
                    #end
                    @:privateAccess graphics.__bitmap.getTexture (gl);
                    #if(js && profile)
                        untyped $global.Profile.BitmapDataUpload.currentProfileId = null;
                    #end

                    entry.symbol.addCacheEntry(@:privateAccess graphics.__bitmap, @:privateAccess graphics.__bounds, entry.transform, entry.ratio);
                }
            }
            ++morphShapeToProcessIndex;
        }

        if (mainSprite.frameIndex == symbol.frames.length && shapeToProcessIndex == shapeToProcessTable.length && simpleSpriteToProcessIndex == simpleSpritesToProcessTable.length && morphShapeToProcessIndex == morphShapeToProcessTable.length) {
            done = true;
            @:privateAccess MovieClipPreprocessor.processNextJob ();
        } else {
            if(useDelay) {
                haxe.Timer.delay (process, 16);
            }
        }
    }

    private function updateMainSprite(shapeTable:Array<ShapeCacheInfo>, simpleSpritesToProcessTable:Array<SimpleSpriteSymbol>, morphShapeToProcessTable:Array<MorphShapeCacheInfo>, swflite:SWFLite):Void {
        while (mainSprite.frameIndex < symbol.frames.length && !timedOut ()) {
            mainSprite.update(shapeTable, simpleSpritesToProcessTable, morphShapeToProcessTable, swflite);
        }

        if (mainSprite.frameIndex == symbol.frames.length && symbol == this.symbol) {
            #if dev
                trace("Preprocessing MovieClip " + symbol.id + ":");
                trace("    Shapes x" + shapeTable.length);
                trace("    SimpleSprites x" + simpleSpritesToProcessTable.length);
                trace("    MorphShapes x" + morphShapeToProcessTable.length);
            #end
            for (entry in shapeTable) {
                var shapeSymbol = entry.symbol;
                shapeSymbol.cachePrecision = cachePrecision;
                shapeSymbol.translationCachePrecision = translationCachePrecision;
                shapeSymbol.useBitmapCache = true;
            }
            for (entry in morphShapeToProcessTable) {
                var symbol = entry.symbol;
                symbol.cachePrecision = cachePrecision;
                symbol.useBitmapCache = true;
            }
        }
    }
}
