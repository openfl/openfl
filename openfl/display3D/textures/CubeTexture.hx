package openfl.display3D.textures;

import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.gl.GL;


class CubeTexture extends TextureBase {


    public function new(context:Context3D, size:Int, format:String,
                        optimizeForRenderToTexture:Bool, streamingLevels:Int)
    {
        super(context, GL.TEXTURE_CUBE_MAP);
        mSize = size;
        mFormat = format;
        mOptimizeForRenderToTexture = optimizeForRenderToTexture;
        mStreamingLevels = streamingLevels;
    }

    public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void
    {
        throw new IllegalOperationError();
    }

    public function uploadFromBitmapData(source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void
    {
        // bind the texture
        GL.bindTexture(textureTarget, textureId);

        // determine which side of the cubmap to upload
        var target:Int = 0;
        switch (side)
        {
            case 0: target = GL.TEXTURE_CUBE_MAP_POSITIVE_X;
            case 1: target = GL.TEXTURE_CUBE_MAP_NEGATIVE_X;
            case 2: target = GL.TEXTURE_CUBE_MAP_POSITIVE_Y;
            case 3: target = GL.TEXTURE_CUBE_MAP_NEGATIVE_Y;
            case 4: target = GL.TEXTURE_CUBE_MAP_POSITIVE_Z;
            case 5: target = GL.TEXTURE_CUBE_MAP_NEGATIVE_Z;
        }

        mUploadedSides |= 1 << side;


        trackMemoryUsage(width * height * 4);

        // unbind texture and pixel buffer
        GL.bindTexture(textureTarget, null);
    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void
    {
        throw new IllegalOperationError();
    }

    public var size(get, null):Int;
    public var width(get, null):Int;
    public var height(get, null):Int;


    public function get_size():Int
    {
        return mSize;
    }

    public function get_width():Int
    {
        return mSize;
    }

    public function get_height():Int
    {
        return mSize;
    }

    private var mSize:Int;

    // the fields below are assigned but never used
    private var mFormat:String;
    private var mOptimizeForRenderToTexture:Bool;
    private var mStreamingLevels:Int ;

    private var mUploadedSides:Int = 0;

}


/* Stubs
        public Void uploadCompressedTextureFromByteArray(ByteArray data, UInt byteArrayOffset, Bool async = false) {
			throw new System.NotImplementedException();
		}

		public Void uploadFromBitmapData(BitmapData source, UInt side, UInt miplevel = 0) {
			throw new System.NotImplementedException();
		}

		public Void uploadFromByteArray(ByteArray data, UInt byteArrayOffset, UInt side, UInt miplevel = 0) {
			throw new System.NotImplementedException();
		}
 */