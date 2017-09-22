package format.swf.lite;

import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.Assets;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.SimpleSpriteSymbol;
import openfl.utils.UnshrinkableArray;

class SimpleSprite extends flash.display.MovieClip
{
    public function new(swf:SWFLite, symbol:SimpleSpriteSymbol)
    {
        super();

        var bitmap = new Bitmap(Assets.getBitmapData(cast(swf.symbols.get(symbol.bitmapID),format.swf.lite.symbols.BitmapSymbol).path));
        addChild(bitmap);
        bitmap.smoothing = symbol.smooth;
        bitmap.pixelSnapping = NEVER;
        bitmap.__transform.copyFrom(symbol.matrix);
    }

    private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
        if ( !parent.mouseEnabled && interactiveOnly ) {
            return false;
        }
        return super.__hitTest(x,y,shapeFlag,stack,interactiveOnly,hitObject);
    }
}
