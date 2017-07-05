package openfl.display3D;


import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;


class VertexBuffer3D {


	public var context:Context3D;
	public var data32PerVertex:Int;
	public var glBuffer:GLBuffer;
	public var numVertices:Int;
	public var bufferUsage:Int;


	public function new (context:Context3D, glBuffer:GLBuffer, numVertices:Int, data32PerVertex:Int, bufferUsage:Int) {

		this.context = context;
		this.glBuffer = glBuffer;
		this.numVertices = numVertices;
		this.data32PerVertex = data32PerVertex;
		this.bufferUsage = bufferUsage;

	}


	public function dispose ():Void {

		context.__deleteVertexBuffer (this);

	}


	public function uploadFromByteArray (byteArray:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {

		var bytesPerVertex = data32PerVertex * 4;

		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);

		var length:Int = count * bytesPerVertex;
		var offset:Int = byteArrayOffset + startOffset * bytesPerVertex;
		var float32Array:Float32Array;

		#if js
		float32Array = new Float32Array (length);
		byteArray.position = offset;

		var i:Int = 0;

		while (byteArray.position < length + offset) {

			float32Array[i] = byteArray.readUnsignedByte ();
			i++;

		}
		#else
		float32Array = new Float32Array (byteArray, offset, length);
		#end

		GL.bufferData (GL.ARRAY_BUFFER, float32Array, bufferUsage);

	}


	public function uploadFromFloat32Array (data:Float32Array, startVertex:Int, numVertices:Int):Void {

		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, data, bufferUsage);

		#if dev
		if(startVertex != 0) throw "Unsupported";
		#end
	}


	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {

		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);

		var length:Int = numVertices * data32PerVertex;
		var float32Array:Float32Array;

		#if js
		if(startVertex == 0 && length == data.length) {
			float32Array = untyped __js__("new Float32Array(data.data)");
		} else {
			float32Array = new Float32Array (length);

			for (i in startVertex...(startVertex + length)) {
				float32Array[i] = data[i];
			}
		}
		#else
		var offset:Int = startVertex;
		float32Array = new Float32Array (data, offset, length);
		#end

		GL.bufferData (GL.ARRAY_BUFFER, float32Array, bufferUsage);

		float32Array = null;

	}


}
