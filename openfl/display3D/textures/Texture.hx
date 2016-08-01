package openfl.display3D.textures;

import openfl._internal.stage3D.GLUtils;
import openfl.utils.ByteArray;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.utils.Timer;
import openfl.utils.ArrayBufferView;
import openfl.gl.GL;


@:enum
private abstract AtfType(Int)
{
    var NORMAL = 0;
    var CUBE_MAP = 1;
}

@:enum
private abstract AtfFormat(Int)
{
    var RGB888 = 0;
    var RGBA8888 = 1;
    var Compressed = 2;
    var Block = 5;
}

class Texture extends TextureBase {

    // sets the low memory mode for textures
    // (they are half-res'd before uploading to GPU)
    public static var LowMemoryMode:Bool = false;

    //
    // Methods
    //

    public var width(get, null):Int;
    public var height(get, null):Int;


    private var mWidth(default, null):Int;
    private var mHeight(default, null):Int;
// the fields below are assigned but never used
    private var mFormat(default, null):String;
    private var mOptimizeForRenderToTexture(default, null):Bool;
    private var mStreamingLevels(default, null):Int;


    public function get_width():Int
    {
        return mWidth;
    }

    public function get_height():Int
    {
        return mHeight;
    }

    public function new(context:Context3D, width:Int, height:Int, format:String,
                        optimizeForRenderToTexture:Bool, streamingLevels:Int)
    {
        super(context, GL.TEXTURE_2D);
        mWidth = width;
        mHeight = height;
        mFormat = format;
        mOptimizeForRenderToTexture = optimizeForRenderToTexture;
        mStreamingLevels = streamingLevels;
    }


    private static function readUInt24(data:ByteArray):UInt
    {
        var value:UInt ;
        value = (data.readUnsignedByte() << 16);
        value |= (data.readUnsignedByte() << 8);
        value |= data.readUnsignedByte();
        return value;
    }

    /* Rumble begin */

    private static function readUInt32(data:ByteArray):UInt
    {
        var value:UInt ;
        value = (data.readUnsignedByte() << 24);
        value |= (data.readUnsignedByte() << 16);
        value |= (data.readUnsignedByte() << 8);
        value |= data.readUnsignedByte();
        return value;
    }

    private static function getATFVersion(data:ByteArray):UInt
    {
        // read atf signature
        var signature:String = data.readUTFBytes(3);
        if (signature != "ATF") {
            throw new IllegalOperationError("ATF signature not found");
        }

        var position = data.position;

        var version:UInt = 0;
        if (data.bytesAvailable >= 5) {
            var sig:UInt = readUInt32(data);
            if (sig == 0xff) {
                version = data.readUnsignedByte();
            } else {
                data.position = position;
            }
        }
        return version;
    }
    /* Rumble end */

    private function uploadATFTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
    {
        data.position = byteArrayOffset;

        /* Rumble begin */
        var version:UInt = getATFVersion(data);

        // read atf length
        var length:UInt = (version == 0) ? readUInt24(data) : readUInt32(data);
        /* Rumble end */
        if (cast((byteArrayOffset + length), Int) > data.length) {
            throw new IllegalOperationError("ATF length exceeds byte array length");
        }

        // get format
        var tdata:UInt = data.readUnsignedByte();
        var type:AtfType = cast (tdata >> 7);
        if (type != AtfType.NORMAL) {
            throw new IllegalOperationError("ATF Cube maps are not supported");
        }

//			Removing ATF format limitation to allow for multiple format support.
//			AtfFormat format = (AtfFormat)(tdata & 0x7f);	
//			if (format != AtfFormat.Block) {
//				throw new NotImplementedException("Only ATF block compressed textures are supported");
//			}

        // get dimensions
        var width:Int = (1 << cast /*(Int)*/data.readUnsignedByte());
        var height:Int = (1 << cast /*(Int)*/data.readUnsignedByte());

        if (width != mWidth || height != mHeight) {
            throw new IllegalOperationError("ATF Width and height dont match");
        }

        // get mipmap count
        var mipCount:Int = cast /*(Int)*/data.readUnsignedByte();

        // read all mipmap levels
        for (level in 0...mipCount) {
            // read all gpu formats
            for (gpuFormat in 0...3) {
                // read block length
                /* Rumble begin */
                var blockLength:UInt = (version == 0) ? readUInt24(data) : readUInt32(data);
                /* Rumble end */
                /*
                    //TODO: Figure out exceptions
					if ((data.position + blockLength) > data.length) {
						throw new System.IO.InvalidDataException("Block length exceeds ATF file length");
					}*/

                if (blockLength > 0) {
                    // handle PVRTC on iOS
                    if (gpuFormat == 1) {
                        //TODO: Removed Monoplatform code
                    }
                    else if (gpuFormat == 2) {
                        //TODO: Removed Monoplatform code
                    }

                    // TODO handle other formats/platforms
                }

                // next block data
                data.position += blockLength;
            }
        }
    }

    public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void
    {
        // see if this is an ATF container
        data.position = byteArrayOffset;
        var signature:String = data.readUTFBytes(3);
        data.position = byteArrayOffset;
        if (signature == "ATF") {
            // Bind the texture
            GL.bindTexture(textureTarget, textureId);
            GLUtils.CheckGLError();

            uploadATFTextureFromByteArray(data, byteArrayOffset);

            GL.bindTexture(textureTarget, null);
            GLUtils.CheckGLError();

        }
        else {


            // trackCompressedMemoryUsage(dataLength); // TODO: Figure out where dataLength comes from

            // unbind texture and pixel buffer
            GL.bindTexture(textureTarget, null);
            GLUtils.CheckGLError();

        }

        if (async) {
            // load with a delay
            var timer = new Timer(1, 1);
            //timer.addEventListener(TimerEvent.TIMER, (System.Action<Event>)this.OnTextureReady );
            timer.addEventListener(TimerEvent.TIMER, function(e:Event)
            { this.OnTextureReady(e); });
            timer.start();
        }
    }

    private function OnTextureReady(e:Event):Void
    {
        this.dispatchEvent(new Event("textureReady" /*Event.TEXTURE_READY*/ ));
    }

    public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void
    {
        var width:Int = mWidth;
        var height:Int = mHeight;

        /* TODO
			if (LowMemoryMode) {
				// shrink bitmap data
				source = source.shrinkToHalfResolution();
				// shrink our dimensions for upload
				width = source.width;
				height = source.height;
			}
            */

        // Bind the texture
        GL.bindTexture(textureTarget, textureId);
        GLUtils.CheckGLError();

        #if ((js && html5) || neko || cpp)

        #if lime
        var pixels = source.image.data;
        #else
        var pixels = new UInt8Array (source.getPixels(source.rect));
        #end

        GL.texImage2D(textureTarget, miplevel, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
        GLUtils.CheckGLError();

        mAllocated = true;

        #else

        throw new IllegalOperationError("Texture upload not implemented");

        #end


        // unbind texture and pixel buffer
        GL.bindTexture(textureTarget, null);
        GLUtils.CheckGLError();

        // store memory usaged by texture
        var memUsage:Int = (width * height) * 4;
        trackMemoryUsage(memUsage);
    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void
    {
        if (cast(byteArrayOffset, Int) >= data.length)
            throw new RangeError();

        /*
               TODO: figure out fixed
			fixed (byte *bytePtr = data.getRawArray()) {
				IntPtr ptr = (IntPtr)bytePtr;
				ptr += (Int)byteArrayOffset;
				uploadFromPointer (ptr, miplevel);
			}
            */
    }

    public function uploadFromPointer(dataPointer:ArrayBufferView, miplevel:UInt = 0, generateMipmap:Bool = false):Void
    {
        // Bind the texture
        GL.bindTexture(textureTarget, textureId);
        GLUtils.CheckGLError();

        // TODO: handle mipmap generation? Maybe unnecessary, monoTouch, monoDroid don't bother.
        GL.texImage2D(textureTarget, miplevel, GL.RGBA, mWidth, mHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, dataPointer);


        mAllocated = true;
        GLUtils.CheckGLError();

        // unbind texture and pixel buffer
        GL.bindTexture(textureTarget, null);
        GLUtils.CheckGLError();

        // store memory usaged by texture
        var memUsage:Int = (mWidth * mHeight) * 4;
        trackMemoryUsage(memUsage);
    }

/* Stubs
    public Texture(Context3D context, Int width, Int height, String format,
		               Bool optimizeForRenderToTexture, Int streamingLevels)
		{
			throw new NotImplementedException();
		}

		public Void uploadCompressedTextureFromByteArray(ByteArray data, UInt byteArrayOffset, Bool async = false) {
			throw new NotImplementedException();
		}

		public Void uploadFromBitmapData (BitmapData source, UInt miplevel = 0)
		{
			throw new NotImplementedException();
		}

		public Void uploadFromByteArray(ByteArray data, UInt byteArrayOffset, UInt miplevel = 0) {
			throw new NotImplementedException();
		}
 */

}