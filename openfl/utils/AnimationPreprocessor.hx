package openfl.utils;

import format.swf.lite.symbols.ShapeSymbol;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class AnimationPreprocessor {

    // :NOTE: This implementation is not perfect! we might not account for movieclips in movieclips!?
    static public function renderCompleteAnimation(movieclip : MovieClip) {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;
        // :NOTE: update all parent transforms
        @:privateAccess movieclip.__getWorldTransform();

        var containerToProcessTable = new UnshrinkableArray<DisplayObjectContainer>();
        var graphicsToProcessTable = new Array<CacheInfo>();

        var cachedVisible = movieclip.visible;
        movieclip.visible = true;

        for(currentFrame in 0...movieclip.totalFrames) {
            movieclip.gotoAndStop(currentFrame);
            movieclip.__update(true, true);

            containerToProcessTable.clear ();
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
            var symbol = @:privateAccess cast(entry.graphics.__symbol, ShapeSymbol);
            symbol.useBitmapCache = true;
            entry.graphics.dirty = true;
            openfl._internal.renderer.canvas.CanvasGraphics.render(entry.graphics, renderSession, entry.transform, false);
            @:privateAccess entry.graphics.__bitmap.getTexture(gl);
        }

    }
}


typedef CacheInfo = {
    graphics: Graphics,
    transform: Matrix
};