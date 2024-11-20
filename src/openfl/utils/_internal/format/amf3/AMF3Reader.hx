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

import haxe.extern.EitherType;
import haxe.io.Bytes;
import openfl.utils._internal.format.amf3.AMF3Value;
import openfl.utils.ByteArray;

typedef Traits =
{
	isExternalizable:Bool,
	isDynamic:Bool,
	className:AMF3Value, // "" for anonymous
	sealedMemberNames:Array<String>
}

class AMF3Reader
{
	// reference table for complex objects
	var complexObjectsTable:Array<AMF3Value>; // anonymous objects, typed objects, arrays, dates, xmldocuments, xmls, and bytearrays
	// reference table for object traits
	var objectTraitsTable:Array<Traits>;
	// reference table for strings
	var stringTable:Array<AMF3Value>;
	var i:haxe.io.Input;

	public function new(i:haxe.io.Input, ?parent:AMF3Reader)
	{
		if (parent == null)
		{
			this.complexObjectsTable = [];
			this.objectTraitsTable = [];
			this.stringTable = [];
		}
		else
		{
			this.complexObjectsTable = parent.complexObjectsTable;
			this.objectTraitsTable = parent.objectTraitsTable;
			this.stringTable = parent.stringTable;
		}
		this.i = i;
		i.bigEndian = true;
	}

	function readObject()
	{
		var dyn = false;
		var isExternalizable = false;
		var className = null;
		var sealedMemberNames = new Array<String>();

		var n = readInt(); // get header

		if (n & 1 == 0)
		{
			// object reference
			return complexObjectsTable[n >> 1];
		}
		else if (n & 3 == 1)
		{
			// object traits reference
			n >>= 2;

			// test?
			// Does this reference a different traits table, previously sent?
			// if (n > objectTraitsTable.length - 1)
			// {
			// 	objectTraitsTable[n] = {
			// 		isExternalizable:false,
			// 		isDynamic:true,
			// 		className:null,
			// 		sealedMemberNames:[]
			// 	};
			// }

			var refTraits = objectTraitsTable[n];
			dyn = refTraits.isDynamic;
			isExternalizable = refTraits.isExternalizable;
			className = refTraits.className;
			sealedMemberNames = refTraits.sealedMemberNames;
		}
		else if (n & 7 == 3)
		{
			// object traits
			dyn = ((n >> 3) & 0x01) == 1;
			n >>= 4; // the rest of the header is the count of sealed members
			className = readString();

			// grab sealed member names from traits section, if any
			for (j in 0...n)
				sealedMemberNames.push(AMF3Tools.decode(readString()));

			// save new traits in reference table
			objectTraitsTable.push({
				isExternalizable: isExternalizable,
				isDynamic: dyn,
				className: className,
				sealedMemberNames: sealedMemberNames
			});
		}
		else if (n & 7 == 7)
		{
			// externalizable
			isExternalizable = true;
			className = readString();
		}
		else
		{
			throw "Invalid object traits";
		}

		var ret = null;

		if (isExternalizable)
		{
			var o = AMF3Tools.object(AObject(null, null, AMF3Tools.decode(className)));

			if (o != null && #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (o, IExternalizable))
			{
				var external:IExternalizable = cast o;
				external.readExternal(new AMF3ReaderInput(this));

				ret = AExternal(external);
			}
			else
			{
				ret = ANull;
			}
		}
		else
		{
			var h = new Map();

			ret = AObject(h, null, className != null ? AMF3Tools.decode(className) : null);

			// parse sealed member values
			for (j in 0...sealedMemberNames.length)
				h.set(sealedMemberNames[j], read());

			// parse any dynamic members (name-value pairs) until empty string name is found
			if (dyn)
			{
				var s:Dynamic;
				while (true)
				{
					s = AMF3Tools.decode(readString());
					if (s == "") break;
					h.set(s, read());
				}
			}
		}

		// save new object in reference table
		complexObjectsTable.push(ret);

		return ret;
	}

	function readMap()
	{
		var n:Int = readInt(); // get header
		if (n & 1 == 0)
		{
			// reference previous array object
			return complexObjectsTable[n >> 1];
		}
		n >>= 1; // the rest of the header is the number of entries in the map
		var h = new Map();
		var ret = AMap(h);
		complexObjectsTable.push(ret);
		i.readByte(); // skip weakKeys
		// var weakKeys = i.readByte() != 0;
		// if( weakKeys )
		//	throw "Dictionary with weakKeys not supported";
		for (i in 0...n)
			h.set(read(), read());
		return ret;
	}

	function readArray()
	{
		var n:Int = readInt(); // get header
		if (n & 1 == 0)
		{
			// reference previous array object
			return complexObjectsTable[n >> 1];
		}
		n >>= 1; // the rest of the header is the dense indexed array length
		var a = new Array();
		var m = new Map<String, AMF3Value>();
		var ret = AArray(a, m);
		complexObjectsTable.push(ret);
		var assocName:String = AMF3Tools.decode(readString());
		while (assocName.length != 0)
		{
			// got associative array element, get value
			m[assocName] = read();

			// next name
			assocName = AMF3Tools.decode(readString());
		}
		for (i in 0...n)
			a.push(read());
		return ret;
	}

	function readIntVector()
	{
		var header:Int = readInt();
		if (header & 1 == 0)
		{
			// reference previous vector object
			return complexObjectsTable[header >> 1];
		}
		var len = header >> 1;
		var fixed = i.readByte() != 0;
		var v = new Vector<Int>(len);
		v.fixed = fixed;

		for (r in 0...len)
		{
			v[r] = i.readInt32();
		}

		var ret = AIntVector(v);

		complexObjectsTable.push(ret);

		return ret;
	}

	function readFloatVector()
	{
		var header:Int = readInt();
		if (header & 1 == 0)
		{
			// reference previous vector object
			return complexObjectsTable[header >> 1];
		}
		var len = header >> 1;
		var fixed = i.readByte() != 0;
		var v = new Vector<Float>(len);
		v.fixed = fixed;

		for (r in 0...len)
		{
			v[r] = i.readDouble();
		}

		var ret = AFloatVector(v);

		complexObjectsTable.push(ret);

		return ret;
	}

	function readObjectVector()
	{
		var header:Int = readInt();
		if (header & 1 == 0)
		{
			// reference previous vector object
			return complexObjectsTable[header >> 1];
		}
		var len = header >> 1;
		var fixed = i.readByte() != 0;
		var type = AMF3Tools.decode(readString());

		var v = new Vector<AMF3Value>(len);
		v.fixed = fixed;

		var ret = AObjectVector(v, type);

		complexObjectsTable.push(ret);

		for (r in 0...len)
		{
			v[r] = read();
		}

		return ret;
	}

	function readByteArray()
	{
		var n = readInt(); // get header
		if (n & 1 == 0)
		{
			// reference previous bytearray object
			return complexObjectsTable[n >> 1];
		}
		n >>= 1; // the rest of the header is the bytearray byte-length
		var b = Bytes.alloc(n);
		for (j in 0...n)
			b.set(j, i.readByte());
		var ba = ByteArray.fromBytes(b);
		ba.endian = BIG_ENDIAN;
		#if (!display && !flash)
		@:privateAccess (ba : ByteArrayData).__amf3Reader = this;
		#end
		var ret = AByteArray(ba);
		complexObjectsTable.push(ret);
		return ret;
	}

	function readInt(signExtend:Bool = false, preShift:Int = 0)
	{
		var c = i.readByte() & 0xFF;
		if (c < 0x80) return c >> preShift;

		var ret:Int = (c & 0x7f) << 7;
		c = i.readByte() & 0xFF;
		if (c < 0x80) return (ret | c) >> preShift;

		ret |= (c & 0x7f);
		ret <<= 7;
		c = i.readByte() & 0xFF;
		if (c < 0x80) return (ret | c) >> preShift;

		ret |= (c & 0x7f);
		ret <<= 8;
		c = i.readByte() & 0xFF;
		ret |= c;

		if (signExtend && (ret & 0x10000000) != 0) ret |= 0xE0000000; // add sign extension

		return ret >> preShift;
	}

	function readString()
	{
		var header = readInt();
		if (header & 1 == 0)
		{
			// get referenced string
			var strRefIdx = header >> 1;
			return stringTable[strRefIdx];
		}
		// now we know this string is a value, next get the length
		var len = header >> 1;
		return readStringNoHeader(len);
	}

	function readStringNoHeader(len:Int)
	{
		if (len == 0) return AString(""); // 0x01 is empty string and is never sent by reference
		// get the string characters
		#if haxe4
		var ret = AString(i.readString(len, UTF8));
		#else
		var u = new haxe.Utf8(len);
		var c = 0, d = 0, j:Int = 0, it = 0;
		while (j < len)
		{
			c = i.readByte();
			if (c < 0x80)
			{
				it = 0;
				d = c;
			}
			else if (c < 0xe0)
			{
				it = 1;
				d = c & 0x1f;
			}
			else if (c < 0xf0)
			{
				it = 2;
				d = c & 0x0f;
			}
			else if (c < 0xf1)
			{
				it = 3;
				d = c & 0x07;
			}
			c = it;
			while (c-- > 0)
			{
				d <<= 6;
				d |= i.readByte() & 0x3f;
			}
			j += it + 1;
			if (d != 0x01)
			{
				u.addChar(d);
			}
		}
		var ret = AString(u.toString());
		#end

		// store the string off for if it gets referenced later
		stringTable.push(ret);
		return ret;
	}

	function readDate()
	{
		var n = readInt(); // get header
		if (n & 1 == 0)
		{
			// reference previous date object
			return complexObjectsTable[n >> 1];
		}
		var date = Date.fromTime(i.readDouble());
		var ret = ADate(date);
		complexObjectsTable.push(ret);
		return ret;
	}

	function readXml()
	{
		var n = readInt(); // get header
		if (n & 1 == 0)
		{
			// reference previous xml object
			return complexObjectsTable[n >> 1];
		}
		n >>= 1; // the rest of the header is the xml string length
		var xml = Xml.parse(AMF3Tools.decode(readStringNoHeader(n)));
		var ret = AXml(xml);
		complexObjectsTable.push(ret);
		return ret;
	}

	public function readWithCode(id)
	{
		var i = this.i;
		return switch (id)
		{
			case 0x00:
				AUndefined;
			case 0x01:
				ANull;
			case 0x02:
				ABool(false);
			case 0x03:
				ABool(true);
			case 0x04:
				AInt(readInt(true));
			case 0x05:
				ANumber(i.readDouble());
			case 0x06:
				readString();
			case 0x07:
				throw "XMLDocument unsupported";
			case 0x08:
				readDate();
			case 0x09:
				readArray();
			case 0x0a:
				readObject();
			case 0x0b:
				readXml();
			case 0x0c:
				readByteArray();
			case 0x0d, 0x0e:
				readIntVector(); // int or uint vector
			case 0x0f:
				readFloatVector();
			case 0x10:
				readObjectVector();
			case 0x11:
				readMap();
			default:
				throw "Unknown AMF " + id;
		}
	}

	public function read()
	{
		var byte = i.readByte();
		return readWithCode(byte);
	}
}
