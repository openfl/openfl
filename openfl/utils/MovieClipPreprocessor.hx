package openfl.utils;

import format.swf.lite.timeline.FrameObjectType;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.ShapeSymbol;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class MovieClipPreprocessor {

    static var jobTable = new Array<JobContext> ();
    static var currentJob:JobContext = null;
    public static var globalTimeSliceMillisecondCount = 10;

    static public function process(movieclip : MovieClip, cachePrecision:Int = 100, timeSliceMillisecondCount:Null<Int> = null, priority:Int = 0) {
        jobTable.push (new JobContext (movieclip, timeSliceMillisecondCount != null, timeSliceMillisecondCount, cachePrecision, priority) );
        jobTable.sort (function (first:JobContext, second:JobContext) { return @:privateAccess second.priority - @:privateAccess first.priority; });

        processNextJob ();
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

typedef CacheInfo = {
    symbol: ShapeSymbol,
    transform: Matrix
};

class JobContext {
    private var shapeToProcessTable = new Array<CacheInfo> ();
    private var shapeToProcessIndex: Int = 0;
    private var movieclip: MovieClip;
    private var timeSliceMillisecondCount:Int;
    private var useDelay:Bool;
    private var cachePrecision:Int;
    private var priority:Int;

    public var done(default, null):Bool = false;

    public function new (movieclip:MovieClip, useDelay:Bool, timeSliceMillisecondCount:Int, cachePrecision:Int, priority:Int) {
        this.movieclip = movieclip;
        this.useDelay = useDelay;
        this.timeSliceMillisecondCount = timeSliceMillisecondCount;
        this.cachePrecision = cachePrecision;
        this.priority = priority;

        init ();
    }

    private function init () {
        var symbol = movieclip.getSymbol ();

        // :NOTE: update hierarchy transforms
        @:privateAccess movieclip.__getWorldTransform ();

        if (symbol != null) {
            var swf = cast (Reflect.field (movieclip, "__swf"), SWFLite);
            findDependentSymbols (shapeToProcessTable, cast (symbol, SpriteSymbol), swf, movieclip.__renderTransform);

            for (entry in shapeToProcessTable) {
                var shapeSymbol = entry.symbol;
                shapeSymbol.cachePrecision = cachePrecision;
                shapeSymbol.useBitmapCache = true;
            }
        }
    }

    public function process () {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;
        var startTime = openfl.Lib.getTimer ();

        while (shapeToProcessIndex < shapeToProcessTable.length && (!useDelay || (openfl.Lib.getTimer () - startTime) < timeSliceMillisecondCount)) {
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

            ++shapeToProcessIndex;
        }

        if (shapeToProcessIndex == shapeToProcessTable.length) {
            done = true;
            @:privateAccess MovieClipPreprocessor.processNextJob ();
        } else {
            if(useDelay) {
                haxe.Timer.delay (process, 16);
            }
        }
    }

    static private function findDependentSymbols(shapeTable:Array<CacheInfo>, symbol:SpriteSymbol, swflite:SWFLite, transform:Matrix):Void {
        var depthRenderTransformMap = new Map<Int,Matrix> ();
        var depthSymbolMap = new Map<Int,Int> ();
        var renderTransform:Matrix = Matrix.pool.get ();

        for (frame in symbol.frames) {
            for (frameObject in frame.objects) {
                if (frameObject.type != FrameObjectType.DESTROY) {
                    var symbol = swflite.symbols.get(frameObject.symbol);

                    if (frameObject.matrix != null) {
                        renderTransform.copyFrom (frameObject.matrix);
                        renderTransform.concat (transform);
                    } else {
                        var cached = depthRenderTransformMap[frameObject.depth];
                        renderTransform.copyFrom (cached != null ? cached : transform);
                    }


                    if (Std.is (symbol, SpriteSymbol)) {
                        findDependentSymbols (shapeTable, cast symbol, swflite, renderTransform);
                    } else if (Std.is(symbol, ShapeSymbol)) {
                        if (frameObject.symbol != depthSymbolMap[frameObject.depth] || !renderTransform.equals (depthRenderTransformMap[frameObject.depth])) {
                            shapeTable.push ({ symbol: cast symbol, transform: renderTransform.clone () });
                        }
                    }

                    depthRenderTransformMap[frameObject.depth] = renderTransform.clone ();
                    depthSymbolMap[frameObject.depth] = frameObject.symbol;
                }
            }
        }

        Matrix.pool.put (renderTransform);
    }
}
