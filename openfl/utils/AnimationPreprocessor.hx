package openfl.utils;

import format.swf.lite.symbols.ShapeSymbol;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class AnimationPreprocessor {

    static var graphicsToProcessTable:Array<CacheInfo> = null;
    static var graphicsToProcessIndex:Int = 0;

    static public function renderCompleteAnimation(movieclip : MovieClip, useDelay:Bool) {
        // :NOTE: update hierarchy transforms
        @:privateAccess movieclip.__getWorldTransform();

        if (graphicsToProcessTable == null) {
            graphicsToProcessTable = new Array<CacheInfo>();
        }

        var containerToProcessTable = new UnshrinkableArray<DisplayObjectContainer>();

        var cachedVisible = movieclip.visible;
        movieclip.visible = true;

        for(currentFrame in 0...movieclip.totalFrames) {
            movieclip.gotoAndStop(currentFrame);
            movieclip.__update(true, true);

            containerToProcessTable.push (movieclip);

            while (containerToProcessTable.length > 0) {
                var container = containerToProcessTable.pop ();

                for( child in @:privateAccess container.__children ) {
                    var graphics = @:privateAccess child.__graphics;
                    if ( graphics != null ) {
                        // :TODO: get transform from pool (or store coefficients manually)
                        graphicsToProcessTable.push({ graphics: graphics, transform: child.__renderTransform.clone() });
                    }

                    if ( Std.is(child, DisplayObjectContainer) ) {
                        containerToProcessTable.push (cast child);
                    }
                }
            }
        }

        movieclip.visible = cachedVisible;

        for (entry in graphicsToProcessTable) {
            if(Std.is(@:privateAccess entry.graphics.__symbol, ShapeSymbol)) {
                var symbol = @:privateAccess cast(entry.graphics.__symbol, ShapeSymbol);
                symbol.useBitmapCache = true;
            }
        }

        if(useDelay) {
            haxe.Timer.delay (function() { cacheGraphics(); }, 16);
        } else {
            cacheGraphics(false);
        }
    }

    static public function cacheGraphics(useDelay:Bool = true) {
        if (graphicsToProcessTable == null) {
            return;
        }

        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;
        var count = Std.int (Math.min (graphicsToProcessTable.length - graphicsToProcessIndex, 20));

        for (index in graphicsToProcessIndex...graphicsToProcessIndex + count) {
            var entry = graphicsToProcessTable [index];
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
        }

        graphicsToProcessIndex += count;

        if (graphicsToProcessIndex == graphicsToProcessTable.length) {
            graphicsToProcessTable = null;
            graphicsToProcessIndex = 0;
        } else {
            if(useDelay) {
                haxe.Timer.delay (function() { cacheGraphics(); }, 16);
            } else {
                cacheGraphics(false);
            }
        }
    }
    static public function renderCompleteInstant(clipId:String)
    {
        var tempClip = Assets.getMovieClip(clipId);

        Lib.current.stage.addChild(tempClip);

        renderCompleteAnimation(tempClip, false);

        Lib.current.stage.removeChild(tempClip);
    }
}


typedef CacheInfo = {
    graphics: Graphics,
    transform: Matrix
};
