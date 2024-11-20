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

package openfl.utils._internal.format.amf;

class AMFWriter
{
	var o:haxe.io.Output;

	public function new(o)
	{
		this.o = o;
		o.bigEndian = true;
	}

	public function write(v:AMFValue)
	{
		var o = this.o;
		switch (v)
		{
			case ANumber(n):
				o.writeByte(0x00);
				o.writeDouble(n);
			case ABool(b):
				o.writeByte(0x01);
				o.writeByte(if (b) 1 else 0);
			case AString(s):
				if (s.length <= 0xFFFF)
				{
					o.writeByte(0x02);
					o.writeUInt16(s.length);
				}
				else
				{
					o.writeByte(0x0C);
					#if haxe3
					o.writeInt32(s.length);
					#else
					o.writeUInt30(s.length);
					#end
				}
				o.writeString(s);
			case AObject(h, size):
				if (size == null) o.writeByte(0x03);
				else
				{
					o.writeByte(0x08);
					#if haxe3
					o.writeInt32(size);
					#else
					o.writeUInt30(size);
					#end
				}
				for (f in h.keys())
				{
					o.writeUInt16(f.length);
					o.writeString(f);
					write(h.get(f));
				}
				o.writeByte(0);
				o.writeByte(0);
				o.writeByte(0x09);
			case ANull:
				o.writeByte(0x05);
			case AUndefined:
				o.writeByte(0x06);
			case ADate(d):
				o.writeByte(0x0B);
				o.writeDouble(d.getTime());
				o.writeUInt16(0); // loose TZ
			case AArray(a):
				o.writeByte(0x0A);
				#if haxe3
				o.writeInt32(a.length);
				#else
				o.writeUInt30(a.length);
				#end
				for (f in a)
					write(f);
		}
	}
}
