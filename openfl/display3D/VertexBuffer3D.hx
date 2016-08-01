package openfl.display3D;

import openfl.Vector;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBufferView;
import haxe.io.Bytes;
import openfl.utils.Float32Array;


class VertexBuffer3D {
	public var stride(get, null):Int;

	public var id(get, null):GLBuffer;
	private var mContext(default, null):Context3D;
	private var mNumVertices(default, null):Int;
	private var mVertexSize(default, null):Int; // size in Floats
	private var mData:Vector<Float>;
	private var mId:GLBuffer;
	private var mUsage:Int = 0;
	private var mMemoryUsage:Int = 0;

	//
	// Methods
	//


	public function get_stride():Int
	{
		return mVertexSize * 4; //sizeof(Float);
	}

	public function get_id():GLBuffer
	{
		return mId;
	}
	/*Internal*/

	public function new(context3D:Context3D, numVertices:Int, dataPerVertex:Int, bufferUsage:String)
	{
		mContext = context3D;
		mNumVertices = numVertices;
		mVertexSize = dataPerVertex;
		mId = GL.createBuffer();

		mUsage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;

		// update stats
		mContext.statsIncrement(Context3D.Stats.Count_VertexBuffer);
	}

	public function dispose():Void
	{
		GL.deleteBuffer(mId);

		// update stats
		mContext.statsDecrement(Context3D.Stats.Count_VertexBuffer);
		mContext.statsSubtract(Context3D.Stats.Mem_VertexBuffer, mMemoryUsage);
		mMemoryUsage = 0;
	}


	// TODO: Must be a better way to handle buffer uploading. Copying and
	// transcoding data back and forth. Not good.

	public function uploadFromPointer(data:Bytes, dataLength:Int, startVertex:Int, numVertices:Int):Void
	{
		GL.bindBuffer(GL.ARRAY_BUFFER, mId);

		// get poInter to byte array data
		var byteStart:Int = startVertex * mVertexSize * 4; //sizeof(Float);
		var byteCount:Int = numVertices * mVertexSize * 4; //sizeof(Float);

		var dataView:Float32Array = Float32Array.fromBytes(data, 0, Std.int(byteCount / 4));

		// bounds check
		if (byteCount > dataLength)
			throw new RangeError("data buffer is not big enough for upload");

		if (byteStart == 0) {
			// upload whole array
			GL.bufferData(GL.ARRAY_BUFFER,
				//new IntPtr(byteCount),
			dataView,
			mUsage);

			if (byteCount != mMemoryUsage) {
				// update stats for memory usage
				mContext.statsAdd(Context3D.Stats.Mem_VertexBuffer, byteCount - mMemoryUsage);
				mMemoryUsage = byteCount;
			}
		} else {
			// upload whole array
			GL.bufferSubData(GL.ARRAY_BUFFER,
			byteStart,
				//new IntPtr(byteCount),
			dataView);
		}
	}

	public /*unsafe*/ function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void
	{
		// Ugh. On Haxe, we need to copy the bytes one by one from
		// ByteArray to Bytes in order to be able to upload to GPU.
		data.position = 0;
		var ptr:Bytes = Bytes.alloc(data.length - byteArrayOffset);

		data.position = byteArrayOffset;
		var i = 0;
		while (data.bytesAvailable > 0) {
			ptr.set(i++, data.readByte());
		}

		uploadFromPointer(ptr, (data.length - byteArrayOffset), startVertex, numVertices);
	}

	public /*unsafe*/ function uploadFromArray(data:Array<Float>, startVertex:Int, numVertices:Int):Void
	{
		var bytes:Bytes = Bytes.alloc(data.length * 4);
		for (i in 0...data.length) {
			bytes.setFloat(i * 4, data[i]);
		}

		uploadFromPointer(bytes, data.length * 4 /*sizeof(Float)*/, startVertex, numVertices);
	}

	public function uploadFromVector(data:Vector<Float>, startVertex:Int, numVertices:Int):Void
	{
		var array:Array<Float> = Lambda.array(data);

		uploadFromArray(array, startVertex, numVertices);
	}

	/*
		public function uploadFromVector(Vector<Float> data, Int startVertex, Int numVertices) :Void
		{
			uploadFromArray(data._GetInnerArray(), startVertex, numVertices);
		}

		public Void uploadFromVector(Vector<Double> data, Int startVertex, Int numVertices) 
		{
			// allocate temporary buffer for conversion
			if (mData == null) {
				mData = new Float[mNumVertices * mVertexSize];
			}

			// convert to Floating poInt
			Int count = numVertices * mVertexSize;
			var array = data._GetInnerArray();
			for (Int i=0; i < count; i++)
			{
				mData[i] = (Float)array[i];
			}

			uploadFromArray(mData, startVertex, numVertices);
		}
		*/

/*Stubs

		public VertexBuffer3D(Context3D context3D, Int numVertices, String bufferUsage)
		{
			throw new NotImplementedException();
		}

		public Void dispose()
		{
			throw new NotImplementedException();
		}

		public Void uploadFromByteArray(ByteArray data, Int byteArrayOffset, Int startVertex, Int numVertices)
		{
			throw new NotImplementedException();
		}

		public Void uploadFromVector(Vector<double> data, Int startVertex, Int numVertices)
		{
			throw new NotImplementedException();
		}

		public Int stride
		{
			get {
				throw new NotImplementedException();
			}
		}

		public UInt id
		{
			get {
				throw new NotImplementedException();
			}
		}

*/

}
	
