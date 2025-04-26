package openfl.display3D;

#if !flash
import openfl.display3D._internal.GLBuffer;
import openfl.utils._internal.ArrayBufferView;
import openfl.utils._internal.UInt8Array;
import openfl.utils._internal.UInt16Array;
import openfl.utils._internal.UInt32Array;
import openfl.utils.ByteArray;
import openfl.Vector;
import openfl.errors.RangeError;
import openfl.errors.TypeError;

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
	@:noCompletion private var __usage:Int;
	@:noCompletion private var __format:Context3DIndexBufferFormat;

	@:noCompletion private function new(context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage, format:Context3DIndexBufferFormat = UINT16)
	{
		__context = context3D;
		__numIndices = numIndices;

		var gl = __context.gl;
		__id = gl.createBuffer();
		__context.__bindGLElementArrayBuffer(__id);

		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;

		__format = format;
		if (format == UINT32)
		{
			var webgl = ~/WebGL\s*([0-9\.]+)/i;
			var opengles = ~/OpenGL\s*ES\s*([0-9\.]+)/i;
			var opengl = ~/^([0-9\.]+)/i;
			var version = gl.getParameter(gl.VERSION);
			if (webgl.match(version))
			{
				if (webgl.matched(1) == "1.0")
				{
					if (gl.getExtension("OES_element_index_uint") == null && gl.getExtension("EXT_element_index_uint") == null)
					{
						__format = UINT16;
					}
				}
			}
			else if (opengles.match(version))
			{
				if (opengles.matched(1) == "1.0" || opengles.matched(1) == "2.0")
				{
					if (gl.getExtension("OES_element_index_uint") == null && gl.getExtension("EXT_element_index_uint") == null)
					{
						__format = UINT16;
					}
				}
			}
			else if (opengl.match(version))
			{
				var major = Std.parseInt(opengl.matched(1));
				if (major < 3)
				{
					if (gl.getExtension("OES_element_index_uint") == null && gl.getExtension("EXT_element_index_uint") == null)
					{
						__format = UINT16;
					}
				}
			}
		}

		switch __format
		{
			case UINT8:
				var tmparray = new ByteArray(__numIndices);
				gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt8Array(tmparray, 0, __numIndices), __usage);

			case UINT16:
				var tmparray = new ByteArray(__numIndices * 2);
				gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt8Array(tmparray, 0, __numIndices * 2), __usage);

			case UINT32:
				var tmparray = new ByteArray(__numIndices * 4);
				gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt8Array(tmparray, 0, __numIndices * 4), __usage);
		}
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
		if (data == null)
		{
			throw new TypeError("Invalid data");
		}
		if (count < 0)
		{
			throw new RangeError("Invalid count");
		}
		if (byteArrayOffset < 0 || byteArrayOffset >= data.length)
		{
			throw new RangeError("Invalid byteArrayOffset");
		}
		if (startOffset < 0)
		{
			throw new RangeError("Invalid startOffset");
		}
		if (startOffset + count > __numIndices)
		{
			throw new RangeError("Invalid combination of count and startOffset");
		}

		var byteLength = count * 2;
		if (__format == UINT8)
		{
			byteLength = count;
		}
		else if (__format == UINT32)
		{
			byteLength = count * 4;
		}
		if (byteArrayOffset + byteLength > data.length)
		{
			throw new RangeError("Invalid combination of count and byteArrayOffset");
		}

		var byteStartOffset = startOffset * 2;
		if (__format == UINT8)
		{
			byteStartOffset = startOffset;
		}
		else if (__format == UINT32)
		{
			byteStartOffset = startOffset * 4;
		}

		var gl = __context.gl;
		__context.__bindGLElementArrayBuffer(__id);
		gl.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, byteStartOffset, new UInt8Array(data, byteArrayOffset, byteLength));
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
		if (data == null)
		{
			throw new TypeError("Invalid data");
		}
		if (count < 0 || count > data.length)
		{
			throw new RangeError("Invalid count");
		}
		if (startOffset + count > __numIndices)
		{
			throw new RangeError("Invalid combination of count and startOffset");
		}
		var tempArray:ByteArray;
		switch __format
		{
			case UINT8:
				tempArray = new ByteArray(count);
				var arrayView = new UInt8Array(tempArray);
				for (i in 0...count)
				{
					arrayView[i] = data[i];
				}

			case UINT16:
				tempArray = new ByteArray(count * 2);
				var arrayView = new UInt16Array(tempArray);
				for (i in 0...count)
				{
					arrayView[i] = data[i];
				}

			case UINT32:
				tempArray = new ByteArray(count * 4);
				var arrayView = new UInt32Array(tempArray);
				for (i in 0...count)
				{
					arrayView[i] = data[i];
				}
		}
		uploadFromByteArray(tempArray, 0, startOffset, count);
		#end
	}
}
#else
typedef IndexBuffer3D = flash.display3D.IndexBuffer3D;
#end
