package openfl.utils;

import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;
import openfl.geom.Rectangle;
import openfl.utils.UnshrinkableArray;

class DisplayObjectUtils {

    public static function applyToAllChildren (displayObject:DisplayObject, f:DisplayObject -> Void) {

        var toProcessTable = new UnshrinkableArray<DisplayObject> ();
        toProcessTable.push (displayObject);

        while (toProcessTable.length > 0) {
            var current = toProcessTable.pop ();

            f (current);

            if(@:privateAccess current.__children != null)
            {
                toProcessTable.concat (@:privateAccess current.__children);
            }
        }

    }

    public static function takeScreenshot(displayObject:DisplayObject, renderSession:RenderSession):Bitmap {
        var bitmapData = @:privateAccess BitmapData.__asRenderTexture ();
        var renderBounds = Rectangle.pool.get ();
        displayObject.__cacheBitmapFn (bitmapData, renderBounds, renderSession);
        Rectangle.pool.put (renderBounds);

        var screenshotBitmap:Bitmap = new Bitmap(bitmapData);
        screenshotBitmap.smoothing = true;
        screenshotBitmap.pixelSnapping = PixelSnapping.NEVER;
        @:privateAccess screenshotBitmap.__transform.copyFrom (displayObject.__transform);

        return screenshotBitmap;
    }
}