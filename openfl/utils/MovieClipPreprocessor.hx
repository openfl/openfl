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

    static public function process(movieclip : MovieClip, cachePrecision:Int = 100, timeSliceMillisecondCount:Null<Int> = null) {
        jobTable.push (new JobContext (movieclip, timeSliceMillisecondCount != null, timeSliceMillisecondCount, cachePrecision) );

        processNextJob ();
    }

    static private function processNextJob() {
        if (currentJob == null || currentJob.done) {
            if (jobTable.length > 0) {
                currentJob = jobTable.splice (0, 1)[0];
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

    public var done(default, null):Bool = false;

    public function new (movieclip:MovieClip, useDelay:Bool, timeSliceMillisecondCount:Int, cachePrecision:Int) {
        this.movieclip = movieclip;
        this.useDelay = useDelay;
        this.timeSliceMillisecondCount = timeSliceMillisecondCount;
        this.cachePrecision = cachePrecision;

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
        var startTime = haxe.Timer.stamp () * 1000;

        while (shapeToProcessIndex < shapeToProcessTable.length && (!useDelay || (haxe.Timer.stamp () * 1000 - startTime) < timeSliceMillisecondCount)) {
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
        var previousRenderTransformMap = new Map<Int,Matrix> ();
        var renderTransform:Matrix = Matrix.pool.get ();

        for (frame in symbol.frames) {
            for (frameObject in frame.objects) {
                if (frameObject.type == FrameObjectType.CREATE || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
                    var symbol = swflite.symbols.get(frameObject.symbol);

                    if (frameObject.matrix != null) {
                        renderTransform.copyFrom (frameObject.matrix);
                        renderTransform.concat (transform);
                    } else {
                        var cached = previousRenderTransformMap[frameObject.depth];
                        renderTransform.copyFrom (cached != null ? cached : transform);
                    }

                    previousRenderTransformMap[frameObject.depth] = renderTransform;

                    if (Std.is (symbol, SpriteSymbol)) {
                        findDependentSymbols (shapeTable, cast symbol, swflite, renderTransform);
                    } else if (Std.is(symbol, ShapeSymbol)) {
                        shapeTable.push ({ symbol: cast symbol, transform: renderTransform.clone () });
                    }
                }
            }
        }

        Matrix.pool.put (renderTransform);
    }
}
