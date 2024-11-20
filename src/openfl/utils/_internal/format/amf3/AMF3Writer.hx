/*
 * format - Haxe File Formats
 *
 * Copyright (c) 2008, The Haxe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

package openfl.utils._internal.format.amf3;

import openfl.utils._internal.format.amf3.AMF3Value;
import openfl.Lib;

@:access(openfl.Lib)
class AMF3Writer
{
	var o:haxe.io.Output;

	public function new(o)
	{
		this.o = o;
		o.bigEndian = true;
	}

	function writeInt(i:Int)
	{
		if (i > 0xfffffff || i < -268435456)
		{
			o.writeByte(0x05);
			o.writeDouble(i);
		}
		else
		{
			o.writeByte(0x04);
			writeUInt(i);
		}
	}

	function writeUInt(u:UInt, shiftLeft:Bool = false)
	{
		if (shiftLeft) u = (u << 1) | 0x01;
		if (((u >> 31) & 0x01) == 1) u &= 0x1fffffff;
		var bits = 22, started = false;
		var chunk = u >> bits - 1;
		if (chunk > 0)
		{
			chunk >>= 1;
			o.writeByte(chunk | 0x80);
			u -= chunk << bits;
			bits++;
			started = true;
		}
		bits -= 8;
		chunk = u >> bits;
		if (started || chunk > 0)
		{
			o.writeByte(chunk | 0x80);
			u -= chunk << bits;
			started = true;
		}
		bits -= 7;
		chunk = u >> bits;
		if (started || chunk > 0)
		{
			o.writeByte(chunk | 0x80);
			u -= chunk << bits;
			started = true;
		}
		o.writeByte(u);
	}

	function writeString(s:String)
	{
		#if haxe4
		var bytes = haxe.io.Bytes.ofString(s, UTF8);
		writeUInt(bytes.length, true);
		o.writeBytes(bytes, 0, bytes.length);
		#else
		// TODO: multibyte chars are broken in haxe3, we need to write the length in bytes!
		writeUInt(s.length, true);
		var j = 0, it = 0;
		for (i in 0...s.length)
		{
			j = s.charCodeAt(i);
			if (j < 0x7f)
			{
				o.writeByte(j);
				it = 0;
			}
			else if (j < 0x7ff)
			{
				o.writeByte(j >> 6 | 0xc0);
				j &= 0x3f;
				it = 1;
			}
			else if (j < 0xffff)
			{
				o.writeByte(j >> 12 | 0xe0);
				j &= 0x0fff;
				it = 2;
			}
			else if (j < 0x10ffff)
			{
				o.writeByte(j >> 18 | 0xf0);
				j &= 0x2ffff;
				it = 3;
			}
			while (it-- > 0)
				o.writeByte(j >> (6 * it));
		}
		#end
	}

	function writeIntVector(v:Vector<Int>)
	{
		writeUInt(v.length, true);
		o.writeByte(v.fixed ? 1 : 0);

		for (r in 0...v.length)
		{
			o.writeInt32(v[r]);
		}
	}

	function writeFloatVector(v:Vector<Float>)
	{
		writeUInt(v.length, true);
		o.writeByte(v.fixed ? 1 : 0);

		for (r in 0...v.length)
		{
			o.writeDouble(v[r]);
		}
	}

	function writeObjectVector(v:Vector<AMF3Value>, ?type:String)
	{
		writeUInt(v.length, true);
		o.writeByte(v.fixed ? 1 : 0);
		o.writeString(type);

		for (r in 0...v.length)
		{
			write(v[r]);
		}
	}

	function writeObject(h:Map<String, AMF3Value>, ?size:Int, ?className:String)
	{
		// TODO: Support writing className
		if (size == null) o.writeByte(0x0b);
		else
			writeUInt(size << 4 | 0x03);
		o.writeByte(0x01);
		if (size == null)
		{
			for (f in h.keys())
			{
				writeString(f);
				write(h.get(f));
			}
			o.writeByte(0x01);
		}
		else
		{
			var k = new Array();
			for (f in h.keys())
			{
				k.push(f);
				writeString(f);
			}
			for (i in 0...k.length)
				write(h.get(k[i]));
		}
	}

	public function writeExternal(external:IExternalizable)
	{
		var isExternal = true;
		var isDynamic = false;
		var traitsCount = 0;
		writeUInt(3 | (isExternal ? 4 : 0) | (isDynamic ? 8 : 0) | (traitsCount << 4));
		var cls = Type.getClass(external);
		var className = null;
		if (Lib.__registeredClasses.exists(cls))
		{
			className = Lib.__registeredClasses[cls];
		}
		// TODO: Write as anonymous object if not registered as alias
		if (className == null)
		{
			className = Type.getClassName(cls);
		}
		writeString(className);
		// TODO: Write directly to output stream
		var ba = new ByteArray();
		ba.endian = BIG_ENDIAN;
		external.writeExternal(ba);
		o.writeBytes(ba, 0, ba.length);
	}

	public function write(v:AMF3Value)
	{
		var o = this.o;
		switch (v)
		{
			case AUndefined:
				o.writeByte(0x00);
			case ANull:
				o.writeByte(0x01);
			case ABool(b):
				o.writeByte(b ? 0x03 : 0x02);
			case AInt(i):
				writeInt(i);
			case ANumber(n):
				o.writeByte(0x05);
				o.writeDouble(n);
			case AString(s):
				o.writeByte(0x06);
				writeString(s);
			case ADate(d):
				o.writeByte(0x08);
				o.writeByte(0x01);
				o.writeDouble(d.getTime());
			case AArray(a, extra):
				o.writeByte(0x09);
				writeUInt(a.length, true);
				if (extra != null) // check for assoc array values
				{
					for (mk in extra.keys())
					{
						o.writeString(mk);
						write(extra[mk]);
					}
				}
				o.writeByte(0x01); // end of assoc array values
				for (f in a)
					write(f);
			case AIntVector(v):
				o.writeByte(0x0d); // TODO: Support UIntVector as well?
				writeIntVector(v);
			case AFloatVector(v):
				o.writeByte(0x0f);
				writeFloatVector(v);
			case AObjectVector(v):
				o.writeByte(0x10);
				writeObjectVector(v);
			case AObject(h, n, className):
				o.writeByte(0x0a);
				writeObject(h, n, className);
			case AExternal(e):
				o.writeByte(0x0a);
				writeExternal(e);
			case AXml(x):
				o.writeByte(0x0b);
				writeString(x.toString());
			case AByteArray(b):
				o.writeByte(0x0c);
				writeUInt(b.length, true);
				o.write(b);
			case AMap(m):
				o.writeByte(0x11);
				writeUInt(Lambda.count(m), true);
				o.writeByte(0x00);
				for (f in m.keys())
				{
					write(f);
					write(m.get(f));
				}
			default:
				throw "Unsupported type";
		}
	}
}
