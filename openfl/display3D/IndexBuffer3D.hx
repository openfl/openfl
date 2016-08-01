package openfl.display3D;

import openfl._internal.stage3D.GLUtils;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBufferView;
import openfl.utils.ByteArray;
import openfl.utils.Int16Array;
import openfl.errors.RangeError;
import openfl.Vector;


class IndexBuffer3D {

    public var id(get, null):GLBuffer;
    public var numIndices(get, null):Int;
    public var elementType(get, null):Int;

    private var mContext:Context3D ;
    private var mNumIndices:Int ;
    private var mId:GLBuffer;
    private var mUsage:Int;
    private var mMemoryUsage:Int = 0;
    private var mElementType:Int;


    public function get_id():GLBuffer
    {
        return mId;
    }

    public function get_numIndices():Int
    {
        return mNumIndices;
    }

    public function get_elementType():Int
    {
        return mElementType;
    }

    public function new(context3D:Context3D, numIndices:Int, bufferUsage:String)
    {
        mContext = context3D;
        mNumIndices = numIndices;
        mElementType = GL.UNSIGNED_SHORT;
        mId = GL.createBuffer();
        GLUtils.CheckGLError();

        mUsage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;

        // update stats
        mContext.statsIncrement(Context3D.Stats.Count_IndexBuffer);
    }

    public function dispose():Void
    {
        GL.deleteBuffer(mId);

        // update stats
        mContext.statsDecrement(Context3D.Stats.Count_IndexBuffer);
        mContext.statsSubtract(Context3D.Stats.Mem_IndexBuffer, mMemoryUsage);
        mMemoryUsage = 0;
    }

    public function uploadFromPointer(data:ArrayBufferView, dataLength:Int, startOffset:Int, count:Int):Void
    {
        // get size of each index
        var elementSize:Int = 2; //sizeof(ushort);

        var byteCount:Int = count * elementSize;

        // bounds check
        if (byteCount > dataLength)
            throw new RangeError("data buffer is not big enough for upload");

        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, mId);
        GLUtils.CheckGLError();

        if (startOffset == 0) {
            GL.bufferData(GL.ELEMENT_ARRAY_BUFFER,
                //new IntPtr(byteCount),
            data,
            mUsage);
            GLUtils.CheckGLError();

            if (byteCount != mMemoryUsage) {
                // update stats for memory usage
                mContext.statsAdd(Context3D.Stats.Mem_IndexBuffer, byteCount - mMemoryUsage);
                mMemoryUsage = byteCount;
            }
        } else {
            // update range of index buffer
            GL.bufferSubData(GL.ELEMENT_ARRAY_BUFFER,
            startOffset * elementSize,
                //new IntPtr(byteCount),
            data);
            GLUtils.CheckGLError();
        }

    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void
    {
        // uploading from a byte array implies 16-bit indices
        mElementType = GL.UNSIGNED_SHORT;

        // pin poInter to byte array data
        //fixed (byte *ptr = data.getRawArray()) {}

        var ba:ByteArray = new ByteArrayData();
        data.readBytes(ba, byteArrayOffset);
        var sData:Int16Array = new Int16Array(ba.length, ba.toArrayBuffer());
        uploadFromPointer(sData, Std.int(data.length - byteArrayOffset), startOffset, count);

    }

    public static var sShortData:Int16Array; // was ushort[] in C#

    public function uploadFromArray(data:Vector<UInt>, startOffset:Int, count:Int):Void
    {
        // uploading from an array or vector implies 32-bit indices
        mElementType = GL.UNSIGNED_SHORT;

        var length:Int = data.length;
        if ((sShortData == null) || (sShortData.length < length)) {
            // First time, or the array is not big enough
            // Let's reallocate, this time we allocate 20% bigger size to reduce reallocation
            sShortData = new Int16Array(Std.int(data.length * 1.2));
        }

        for (i in 0...length) {
            sShortData[i] = /*(ushort)*/ data [i];
        }

        // pin pointer to array data
        //fixed (ushort *ptr = sShortData) {
        uploadFromPointer(sShortData /*ptr*/, length * 2 /*sizeof(ushort)*/, startOffset, count);
        //}
    }

    public function uploadFromVector(data:Vector<UInt>, startOffset:Int, count:Int):Void
    {
        uploadFromArray(data, startOffset, count);
    }


/* Stubs

		public IndexBuffer3D(Context3D context3D, Int numIndices, String bufferUsage)
		{
			throw new NotImplementedException();
		}
		
		public Void dispose() {
			throw new NotImplementedException();
		}
		
		public Void uploadFromByteArray(ByteArray data, Int byteArrayOffset, Int startOffset, Int count) {
			throw new NotImplementedException();
		}
		
		public Void uploadFromVector(Vector<UInt> data, Int startOffset, Int count) {
			throw new NotImplementedException();
		}

*/

}
