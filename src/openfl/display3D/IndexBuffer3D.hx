package openfl.display3D;

#if !flash
import openfl.display3D._internal.GLBuffer;
import openfl.utils._internal.ArrayBufferView;
import openfl.utils._internal.UInt16Array;
import openfl.utils.ByteArray;
import openfl.Vector;

/**
	IndexBuffer3D is used to represent lists of vertex indices comprising graphic elements
	retained by the graphics subsystem.

	Indices managed by an IndexBuffer3D object may be used to select vertices from a
	vertex stream. Indices are 16-bit unsigned integers. The maximum allowable index
	value is 65535 (0xffff). The graphics subsystem does not retain a reference to
	vertices provided to this object. Data uploaded to this object may be modified or
	discarded without affecting the stored values.

	IndexBuffer3D cannot be instantiated directly. Create instances by using
	`context3D.createIndexBuffer()`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:final class IndexBuffer3D
{
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __id:GLBuffer;
	@:noCompletion private var __memoryUsage:Int;
	@:noCompletion private var __numIndices:Int;
	@:noCompletion private var __tempUInt16Array:UInt16Array;
	@:noCompletion private var __usage:Int;

	@:noCompletion private function new(context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage)
	{
		__context = context3D;
		__numIndices = numIndices;

		var gl = __context.gl;
		__id = gl.createBuffer();

		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
	}

	/**
		Free all native GPU resources associated with this object. No `upload()` calls
		on this object will work and using the object in rendering will also fail.
	**/
	public function dispose():Void
	{
		var gl = __context.gl;
		gl.deleteBuffer(__id);
	}

	/**
		Store in the graphics subsystem vertex indices.

		@param	data	a ByteArray containing index data. Each index is represented by
		16-bits (two bytes) in the array. The number of bytes in data should be
		`byteArrayOffset` plus two times count.
		@param	byteArrayOffset	offset, in bytes, into the data ByteArray from where to
		start reading.
		@param	startOffset	The index in this IndexBuffer3D object of the first index to
		be loaded in this IndexBuffer3D object. A value for `startIndex` not equal to zero
		may be used to load a sub-region of the index data.
		@param	count	The number of indices represented by data.
		@throws	TypeError	kNullPointerError when data is null.
		@throws	RangeError	kBadInputSize when any of `count`, `byteArrayOffset`, or
		`startOffset` is less than 0, or if `byteArrayOffset` is greater than or equal
		to the length of data, or if two times count plus `byteArrayOffset` is greater
		than the length of data, or if `startOffset + count` is greater than `numIndices`
		given in `context3D.createIndexBuffer()`.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void
	{
		#if lime
		var offset = byteArrayOffset + startOffset * 2;
		uploadFromTypedArray(new UInt16Array(data.toArrayBuffer(), offset, count));
		#end
	}

	/**
		Store in the graphics subsystem vertex indices.

		@param	data	an ArrayBufferView containing index data. Each index is represented by
		16-bits (two bytes) in the array.
		@param	byteLength	The number of bytes to read.
	**/
	public function uploadFromTypedArray(data:ArrayBufferView, byteLength:Int = -1):Void
	{
		if (data == null) return;
		var gl = __context.gl;
		__context.__bindGLElementArrayBuffer(__id);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, data, __usage);
	}

	/**
		Store in the graphics subsystem vertex indices.

		@param	data	a vector of vertex indices. Only the low 16 bits of each index
		value are used. The length of the vector must be greater than or equal to count.
		@param	startOffset	The index in this IndexBuffer3D object of the first index to
		be loaded. A value for startOffset not equal to zero may be used to load a
		sub-region of the index data.
		@param	count	The number of indices in `data`.
		@throws	TypeError	kNullPointerError when `data` is `null`.
		@throws	RangeError	kBadInputSize when `count is less than 0 or greater than the
		length of `data`, or when `startOffset + count` is greater than `numIndices`
		given in `context3D.createIndexBuffer()`.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromVector(data:Vector<UInt>, startOffset:Int, count:Int):Void
	{
		#if lime
		// TODO: Optimize more

		if (data == null) return;
		var gl = __context.gl;

		var length = startOffset + count;
		var existingUInt16Array = __tempUInt16Array;

		if (__tempUInt16Array == null || __tempUInt16Array.length < count)
		{
			__tempUInt16Array = new UInt16Array(count);

			if (existingUInt16Array != null)
			{
				__tempUInt16Array.set(existingUInt16Array);
			}
		}

		for (i in startOffset...length)
		{
			__tempUInt16Array[i - startOffset] = data[i];
		}

		uploadFromTypedArray(__tempUInt16Array);
		#end
	}
}
#else
typedef IndexBuffer3D = flash.display3D.IndexBuffer3D;
#end
