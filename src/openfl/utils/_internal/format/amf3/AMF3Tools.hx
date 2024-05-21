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

import openfl.utils._internal.format.amf3.AMF3Array;
import openfl.utils._internal.format.amf3.AMF3Value;
import openfl.utils.ByteArray;
import haxe.ds.ObjectMap;
import haxe.ds.Vector as HaxeVector;
import haxe.Constraints.IMap;
import openfl.Vector;

class AMF3Tools
{
	public static function encode(o:Dynamic):AMF3Value
	{
		return switch (Type.typeof(o))
		{
			case TNull: ANull;
			case TBool: ABool(o);
			case TInt: AInt(o);
			case TFloat: ANumber(o);
			case TObject:
				var h = new Map();
				for (f in Reflect.fields(o))
				{
					h.set(f, encode(Reflect.field(o, f)));
				}
				AObject(h, null, null, false);
			case TClass(c):
				switch (c)
				{
					case cast String:
						AString(o);
					case cast Xml:
						AXml(o);
					case cast haxe.ds.StringMap, haxe.ds.IntMap, haxe.ds.ObjectMap:
						var o:Map<Dynamic, Dynamic> = o;
						var h = new Map();
						for (f in o.keys())
							h.set(encode(f), encode(o.get(f)));
						AMap(h);
					case cast Array:
						var o:Array<Dynamic> = o;
						var a = new Array();
						for (v in o)
							a.push(encode(v));
						AArray(a);
					case cast AMF3Array:
						var o:AMF3Array = o;
						var a = new Array();
						var m = new Map<String, AMF3Value>();
						for (v in o.a)
							a.push(encode(v));
						for (k in o.extra)
							m[k] = encode(o.extra[k]);
						AArray(a, m);
						// TODO: Handle native array types?
					#if !haxe4
					case cast HaxeVector:
						var o:HaxeVector<Dynamic> = o;
						var a = new Vector<AMF3Value>(o.length);
						for (i in 0...o.length)
							a[i] = encode(o[i]);
						AVector(a, false, null);
					#end
					case cast haxe.io.Bytes:
						ABytes(o);
					case cast Date:
						ADate(o);
					case _:
						var h = new Map();
						var i = 0;
						var _class = Type.getClass(o);
						for (f in Type.getInstanceFields(_class))
						{
							h.set(f, encode(Reflect.getProperty(o, f)));
							i++;
						}
						AObject(h, i, Type.getClassName(_class), false);
				}
			default:
				throw "Can't encode " + Std.string(o);
		}
	}

	public static function decode(a:AMF3Value):Dynamic
	{
		return switch (a)
		{
			case AUndefined: undefined(a);
			case ANull: anull(a);
			case ABool(_): bool(a);
			case AInt(_): int(a);
			case ANumber(_): number(a);
			case AString(_): string(a);
			case ADate(_): date(a);
			case AArray(_, _): array(a);
			case AVector(_): vector(a);
			case AObject(_, _, _, _): object(a);
			case AXml(_): xml(a);
			case ABytes(_): bytes(a);
			case AMap(_): map(a);
		}
	}

	public static function undefined(a:AMF3Value)
	{
		return null;
	}

	public static function anull(a:AMF3Value)
	{
		return null;
	}

	public static function bool(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case ABool(b): b;
			default: null;
		}
	}

	public static function int(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AInt(n): n;
			default: null;
		}
	}

	public static function number(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case ANumber(n): n;
			default: null;
		}
	}

	public static function string(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AString(s): s;
			default: null;
		}
	}

	public static function date(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case ADate(d): d;
			default: null;
		}
	}

	public static function array(a:AMF3Value):AMF3Array
	{
		if (a == null) return null;
		return switch (a)
		{
			case AArray(a, m):
				var b = [];
				for (f in a)
					b.push(decode(f));
				var c = new Map<String, Dynamic>();
				for (mk in m.keys())
					c[mk] = decode(m[mk]);
				new AMF3Array(b, c);
			default: null;
		}
	}

	public static function vector(a:AMF3Value):Vector<Dynamic>
	{
		if (a == null) return null;
		return switch (a)
		{
			case AVector(a, fixed, className):
				// Vector is a multi-type abstract in OpenFL
				// Int, Float, Bool, Function, Object
				if (className == "Int")
				{
					var v = new Vector<Int>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = decode(a[i]);
					}
					return cast v;
				}
				else if (className == "Float")
				{
					var v = new Vector<Float>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = decode(a[i]);
					}
					return cast v;
				}
				else
				{
					var v = new Vector<Dynamic>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = decode(a[i]);
					}
					return cast v;
				}

			default: null;
		}
	}

	public static function object(a:AMF3Value)
	{
		// TODO: Merge with unwrapValue?
		// This should instantiate, and should work recursively
		if (a == null) return null;
		return switch (a)
		{
			case AObject(o, _, className, isExternalizable):
				var m = new Map();
				for (f in o.keys())
					m.set(f, decode(o.get(f)));
				m;
			default: null;
		}
	}

	public static function xml(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AXml(x): x;
			default: null;
		}
	}

	public static function bytes(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case ABytes(b): b;
			default: null;
		}
	}

	public static function map(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AMap(m):
				var p = new Map<AMF3Value, AMF3Value>();
				for (f in m.keys())
					p.set(decode(f), decode(m.get(f)));
				p;
			default: null;
		}
	}

	public static function unwrapValue(val:AMF3Value, parent:AMF3Reader = null):Dynamic
	{
		return switch (val)
		{
			case ANumber(f): return f;
			case AInt(n): return n;
			case ABool(b): return b;
			case AString(s): return s;
			case ADate(d): return d;
			case AXml(xml): return xml;
			case AUndefined: return null;
			case ANull: return null;
			case AArray(vals): return vals.map(function(v)
				{
					return unwrapValue(v, parent);
				});
			case AVector(a, fixed, className):
				// Vector is a multi-type abstract in OpenFL
				// Int, Float, Bool, Function, Object
				if (className == "Int")
				{
					var v = new Vector<Int>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = unwrapValue(a[i], parent);
					}
					return cast v;
				}
				else if (className == "Float")
				{
					var v = new Vector<Float>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = unwrapValue(a[i], parent);
					}
					return cast v;
				}
				else
				{
					var v = new Vector<Dynamic>(a.length, fixed);
					for (i in 0...a.length)
					{
						v[i] = unwrapValue(a[i], parent);
					}
					return cast v;
				}
			case ABytes(b):
				var ba = ByteArray.fromBytes(b);
				#if (!display && !flash)
				@:privateAccess (ba : ByteArrayData).__parentAMF3Reader = parent;
				#end
				ba.endian = BIG_ENDIAN;
				return ba;

			case AObject(fields, _, className, isExternalizable):
				var obj:Dynamic = null;

				if (className != null && className != "")
				{
					var cls = openfl.Lib.getClassByAlias(className);
					if (cls == null) cls = Type.resolveClass(className);

					if (cls != null)
					{
						obj = Type.createInstance(cls, []);
					}
				}

				if (obj == null) obj = {};

				if (isExternalizable)
				{
					if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (obj, IExternalizable) && parent != null)
					{
						var externalizable:IExternalizable = cast obj;
						var input = new AMF3ReaderInput(parent);
						externalizable.readExternal(input);
					}
				}
				else
				{
					for (name in fields.keys())
					{
						Reflect.setProperty(obj, name, unwrapValue(fields[name], parent));
					}
				}

				return obj;

			case AMap(vmap):
				var map:IMap<Dynamic, Dynamic> = null;
				for (key in vmap.keys())
				{
					// Get the map type from the type of the first key.
					if (map == null)
					{
						map = switch (key)
						{
							case AString(_): new Map<String, Dynamic>();
							case AInt(_): new Map<Int, Dynamic>();
							default: new ObjectMap<Dynamic, Dynamic>();
						}
					}
					map.set(unwrapValue(key, parent), unwrapValue(vmap[key], parent));
				}

				// Default to StringMap if the map is empty.
				if (map == null)
				{
					map = new Map<String, Dynamic>();
				}
				return map;
		}
	}
}
