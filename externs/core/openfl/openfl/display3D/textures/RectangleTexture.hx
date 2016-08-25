package openfl.display3D.textures;
#if (display || !flash)


import openfl.display.BitmapData;
import openfl.utils.ByteArray;


@:final extern class RectangleTexture extends TextureBase {

    public var width(get, never):Int;
    public var height(get, never):Int;
    private var mWidth(default, null):Int;
    private var mHeight(default, null):Int;
    private var mFormat(default, null):String;
    private var mOptimizeForRenderToTexture(default, null):Bool;

    public function new ():Void;
    public function uploadFromBitmapData (source:BitmapData):Void;
    public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void;

    public function get_width():Int
    {
        return mWidth;
    }

    public function get_height():Int
    {
        return mHeight;
    }

}


#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end