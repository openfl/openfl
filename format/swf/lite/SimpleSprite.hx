package format.swf.lite;

import openfl.display.Bitmap;
import openfl.Assets;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.SimpleSpriteSymbol;

class SimpleSprite extends flash.display.MovieClip
{
    public function new(swf:SWFLite, symbol:SimpleSpriteSymbol)
    {
        super();

        var bitmap = new Bitmap(Assets.getBitmapData(cast(swf.symbols.get(symbol.bitmapID),format.swf.lite.symbols.BitmapSymbol).path));
        addChild(bitmap);
        bitmap.smoothing = true;
        bitmap.__transform.copyFrom(symbol.matrix);
    }
}
