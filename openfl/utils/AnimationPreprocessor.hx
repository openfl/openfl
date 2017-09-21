package openfl.utils;

import format.swf.lite.symbols.ShapeSymbol;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

class AnimationPreprocessor {

    // :NOTE: This implementation is not perfect! we might not account for movieclips in movieclips!?
    static public function renderCompleteAnimation(movieclip : MovieClip) {
        var renderSession = @:privateAccess Lib.current.stage.__renderer.renderSession;
        var gl:lime.graphics.GLRenderContext = renderSession.gl;
        // :NOTE: update all parent transforms
        var cachedVisible = movieclip.visible;
        movieclip.visible = true;
        @:privateAccess movieclip.__getWorldTransform();

        for(currentFrame in 0...movieclip.totalFrames) {
            movieclip.gotoAndStop(currentFrame);
            movieclip.__update(true, true);

            var allObjects = new Array<CacheInfo>();
            getAllObjectsWithGraphics(movieclip, allObjects);

            for (entry in allObjects) {
                var symbol = @:privateAccess cast(entry.graphics.__symbol, ShapeSymbol);
                symbol.useBitmapCache = true;
                openfl._internal.renderer.canvas.CanvasGraphics.render(entry.graphics, renderSession, entry.transform, false);
                @:privateAccess entry.graphics.__bitmap.getTexture(gl);
            }
        }

        for( child in @:privateAccess movieclip.__children ) {
            if ( Std.is(child, MovieClip) ) {
                renderCompleteAnimation(cast child);
            }
        }

        movieclip.visible = cachedVisible;

    }

    static private function getAllObjectsWithGraphics(displayObject: DisplayObject, container: Array<CacheInfo>) {
        var children = @:privateAccess displayObject.__children;
        if ( children != null ) {
            for( child in children ) {
                getAllObjectsWithGraphics(child, container);
            }
        }

        var graphics = @:privateAccess  displayObject.__graphics;
        if ( graphics != null ) {
            container.push({ graphics: graphics, transform: displayObject.__renderTransform.clone() });
        }
    }


}

typedef CacheInfo = {
    graphics: Graphics,
    transform: Matrix
};