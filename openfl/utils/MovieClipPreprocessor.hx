package openfl.utils;

import format.swf.lite.symbols.ShapeSymbol;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class MovieClipPreprocessor {

    static var jobTable = new Array<JobContext> ();
    static var currentJob:JobContext = null;

    static public function process(movieclip : MovieClip, cachePrecision:Int = 100, timeSliceMillisecondCount:Null<Int> = null) {
        // :NOTE: update hierarchy transforms
        var worldTransform = @:privateAccess movieclip.__getWorldTransform();

        jobTable.push (new JobContext (movieclip, worldTransform, timeSliceMillisecondCount != null, timeSliceMillisecondCount, cachePrecision) );

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

    static public function renderCompleteInstant(clipId:String, cachePrecision:Int = 100)
    {
        var tempClip = Assets.getMovieClip(clipId);

        Lib.current.stage.addChild(tempClip);

        process(tempClip, cachePrecision);

        Lib.current.stage.removeChild(tempClip);
    }
}


typedef CacheInfo = {
    graphics: Graphics,
    transform: Matrix
};

class JobContext {
    private var containerToProcessTable = new UnshrinkableArray<DisplayObjectContainer> ();
    private var frameIndex: Int = 0;
    private var graphicsToProcessTable = new Array<CacheInfo> ();
    private var graphicsToProcessIndex: Int = 0;
    private var initialWorldTransform: Matrix;
    private var movieclip: MovieClip;
    private var timeSliceMillisecondCount:Int;
    private var useDelay:Bool;
    private var cachePrecision:Int;

    public var done(default, null):Bool = false;

    public function new (movieclip:MovieClip, worldTransform:Matrix, useDelay:Bool, timeSliceMillisecondCount:Int, cachePrecision:Int) {
        initialWorldTransform = worldTransform.clone ();
        this.movieclip = movieclip;
        this.useDelay = useDelay;
        this.timeSliceMillisecondCount = timeSliceMillisecondCount;
        this.cachePrecision = cachePrecision;
    }

    private inline function validate () {
        #if dev
            if (!movieclip.__worldTransform.equals (initialWorldTransform)) {
                throw "movie clip preprocessing should be finished before updating clip transform";
            }
        #end
    }

    public function process () {
        validate ();

        var startTime = haxe.Timer.stamp () * 1000;

        var cachedFrameIndex = movieclip.currentFrame;
        var cachedVisible = movieclip.visible;
        movieclip.visible = true;

        while (frameIndex < movieclip.totalFrames && (!useDelay || (haxe.Timer.stamp () * 1000 - startTime) < timeSliceMillisecondCount)) {
            movieclip.gotoAndStop (frameIndex);
            movieclip.__update (true, true);

            containerToProcessTable.push (movieclip);

            while (containerToProcessTable.length > 0) {
                var container = containerToProcessTable.pop ();

                for( child in @:privateAccess container.__children ) {
                    var graphics = @:privateAccess child.__graphics;
                    if ( graphics != null ) {
                        if(Std.is(@:privateAccess graphics.__symbol, ShapeSymbol)) {
                            var symbol = @:privateAccess cast(graphics.__symbol, ShapeSymbol);
                            symbol.cachePrecision = cachePrecision;
                            symbol.useBitmapCache = true;
                        }

                        // :TODO: get transform from pool (or store coefficients manually)
                        graphicsToProcessTable.push ({ graphics: graphics, transform: child.__renderTransform.clone() });
                    }

                    if ( Std.is(child, DisplayObjectContainer) ) {
                        containerToProcessTable.push (cast child);
                    }
                }
            }

            ++frameIndex;
        }

        movieclip.gotoAndStop (cachedFrameIndex);
        movieclip.visible = cachedVisible;

        if(useDelay) {
            var callback = (frameIndex == movieclip.totalFrames) ? cacheGraphics : process;
            haxe.Timer.delay (callback, 16);
        } else {
            cacheGraphics();
        }
    }

    private function cacheGraphics () {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;
        var startTime = haxe.Timer.stamp () * 1000;

        while (graphicsToProcessIndex < graphicsToProcessTable.length && (!useDelay || (haxe.Timer.stamp () * 1000 - startTime) < timeSliceMillisecondCount)) {
            var entry = graphicsToProcessTable [graphicsToProcessIndex];
            entry.graphics.dirty = true;
            openfl._internal.renderer.canvas.CanvasGraphics.render(entry.graphics, renderSession, entry.transform, false);
            if(@:privateAccess entry.graphics.__bitmap != null) {
                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = @:privateAccess entry.graphics.__symbol.id + " (preprocessed)";
                #end

                @:privateAccess entry.graphics.__bitmap.getTexture(gl);

                #if(js && profile)
                    untyped $global.Profile.BitmapDataUpload.currentProfileId = null;
                #end
            }

            ++graphicsToProcessIndex;
        }

        if (graphicsToProcessIndex == graphicsToProcessTable.length) {
            done = true;
            @:privateAccess MovieClipPreprocessor.processNextJob ();
        } else {
            if(useDelay) {
                haxe.Timer.delay (cacheGraphics, 16);
            }
        }
    }
}
