package openfl.display3D.textures;

import openfl._internal.stage3D.GLUtils;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.errors.RangeError;
import openfl.errors.IllegalOperationError;
import openfl.utils.ArrayBufferView;
import openfl.gl.GL;


class RectangleTexture extends TextureBase {

    public var width(get, null):Int;
    public var height(get, null):Int;

    // the fields below are assigned but never used
    private var mWidth(default, null):Int;
    private var mHeight(default, null):Int;
    private var mFormat(default, null):String;
    private var mOptimizeForRenderToTexture(default, null):Bool;

    public function get_width():Int
    {
        return mWidth;
    }

    public function get_height():Int
    {
        return mHeight;
    }


    //
    // Methods
    //

    public function new(context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool)
    {
        super(context, GL.TEXTURE_2D);
        mWidth = width;
        mHeight = height;
        mFormat = format;
        mOptimizeForRenderToTexture = optimizeForRenderToTexture;
    }

    public function uploadFromBitmapData(source:BitmapData):Void
    {
        /* TODO: figure out fixed.
               fixed (UInt *ptr = source.getRawData()) {
				uploadFromPointer((IntPtr)ptr);
			}*/
    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
    {
        if (cast(byteArrayOffset, Int) >= data.length)
            throw new RangeError();

        /*
               TODO: Figure out fixed.
			fixed (byte *bytePtr = data.getRawArray()) {
				IntPtr ptr = (IntPtr)bytePtr;
				ptr += (Int)byteArrayOffset;
				uploadFromPointer (ptr);
			}
            */
    }

    public function uploadFromPointer(dataPointer:ArrayBufferView):Void
    {

        // check texture format
        if (mFormat != Context3DTextureFormat.BGRA) {
            throw new IllegalOperationError();
        }

        // Bind the texture
        GL.bindTexture(textureTarget, textureId);
        GLUtils.CheckGLError();

        mAllocated = true;
        GLUtils.CheckGLError();

        // unbind texture
        GL.bindTexture(textureTarget, null);
        GLUtils.CheckGLError();

        // store memory usaged by texture
        var memUsage:Int = (mWidth * mHeight) * 4;
        trackMemoryUsage(memUsage);
    }


/* Stubs

    public Void uploadFromBitmapData(BitmapData source) {
        throw new System.NotImplementedException();
    }

    public Void uploadFromByteArray(ByteArray data, UInt byteArrayOffset) {
        throw new System.NotImplementedException();
    }

*/


}
