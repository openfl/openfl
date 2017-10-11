package openfl.utils;

import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
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

    public static function replaceWithScreenshot(displayObject:DisplayObject):Void {

        var screenshot = takeScreenshot (displayObject);

        var visibilityTable = new Array<Bool> ();

        for (child in @:privateAccess displayObject.__children) {
            visibilityTable.push (child.visible);
            child.visible = false;
        }

        if (Std.is (displayObject, DisplayObjectContainer)) {
            // :TRICKY: add to display object and not on parent so that code that updates its position is still valid
            (cast displayObject).addChildAt (screenshot, 0);
        } else {
            throw ":TODO: add screenshot to parent instead";
        }

        Reflect.setField (displayObject, "visibilityTable", visibilityTable);
        Reflect.setField (displayObject, "screenshot", screenshot);

    }

    public static function undoReplaceWithScreenshot(displayObject:DisplayObject):Void {

        var screenshot = cast (Reflect.field (displayObject, "screenshot"), Bitmap);
        Reflect.deleteField (displayObject, "screenshot");
        screenshot.parent.removeChild (screenshot);

        var visibilityTable = cast (Reflect.field (displayObject, "visibilityTable"), Array<Dynamic>);
        Reflect.deleteField (displayObject, "visibilityTable");

        var children = @:privateAccess displayObject.__children;

        #if dev
            if (children.length != visibilityTable.length) {
                throw "visibility cache doesn't match children count";
            }
        #end

        for (i in 0...visibilityTable.length) {
            children[i].visible = visibilityTable[i];

        }
    }

    public static function takeScreenshot(displayObject:DisplayObject):Bitmap {
        var renderSession:RenderSession = @:privateAccess openfl.Lib.current.stage.__renderer.renderSession;
        var bitmapData = @:privateAccess BitmapData.__asRenderTexture ();
        var renderBounds = Rectangle.pool.get ();
        displayObject.__update(false, true);
        displayObject.__cacheBitmapFn (bitmapData, renderBounds, renderSession);
        Rectangle.pool.put (renderBounds);

        var screenshotBitmap:Bitmap = new Bitmap(bitmapData);
        screenshotBitmap.smoothing = true;
        screenshotBitmap.pixelSnapping = PixelSnapping.NEVER;

        return screenshotBitmap;
    }
}