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
import openfl.utils.Dictionary;
import haxe.ds.ObjectMap;
import haxe.ds.Vector as HaxeVector;
import haxe.Constraints.IMap;
import openfl.Lib;
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
				AObject(h, null, null);
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
					// #if !haxe4
					// case cast HaxeVector:
					// 	var o:HaxeVector<Dynamic> = o;
					// 	var a = new HaxeVector<AMF3Value>(o.length);
					// 	for (i in 0...o.length)
					// 		a[i] = encode(o[i]);
					// 	AVector(a, false, null);
					// #end
					case cast haxe.io.Bytes:
						AByteArray(ByteArray.fromBytes(o));
					case cast ByteArrayData:
						AByteArray(o);
					case cast Date:
						ADate(o);
					case _:
						/*if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (o, Vector))
							{
								// // case cast openfl.Vector.IntVector:
								// // 	AIntVector(o);
								// // case cast(@:privateAccess openfl.Vector.FloatVector):
								// // 	AFloatVector(o);
								// case cast IntVector:
								var o:Vector<Dynamic> = o;
								var v = new Vector<AMF3Value>();
								for (val in o)
									v.push(encode(val));
								AObjectVector(v);
							}
							else */
						if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (o, IExternalizable))
						{
							AExternal(o);
						}
						else
						{
							// var h = new Map();
							// var className = Type.getClassName(c);
							// for (f in Reflect.fields(o))
							// {
							// 	h.set(f, encode(Reflect.field(o, f)));
							// }
							// AObject(h, null, className);
							ANull;
						}
				}
			case TFunction: ANull;
			default:
				throw "Can't encode " + Std.string(o);
		}
	}

	public static function decode(a:AMF3Value):Dynamic
	{
		if (a == null) return null;

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
			case AIntVector(_): intVector(a);
			case AFloatVector(_): floatVector(a);
			case AObjectVector(_): objectVector(a);
			case AObject(_, _, _): object(a);
			case AExternal(_): external(a);
			case AXml(_): xml(a);
			case AByteArray(_): byteArray(a);
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

	// public static function array(a:AMF3Value):AMF3Array
	// {
	// 	if (a == null) return null;
	// 	return switch (a)
	// 	{
	// 		case AArray(a, m):
	// 			var b = [];
	// 			for (f in a)
	// 				b.push(decode(f));
	// 			var c = new Map<String, Dynamic>();
	// 			for (mk in m.keys())
	// 				c[mk] = decode(m[mk]);
	// 			new AMF3Array(b, c);
	// 		default: null;
	// 	}
	// }

	public static function array(a:AMF3Value):Array<Dynamic>
	{
		if (a == null) return null;
		return switch (a)
		{
			case AArray(a, m):
				var b = [];
				for (f in a)
					b.push(decode(f));
				b;
			default: null;
		}
	}

	public static function intVector(a:AMF3Value):Vector<Int>
	{
		if (a == null) return null;
		return switch (a)
		{
			case AIntVector(v): v;
			default: null;
		}
	}

	public static function floatVector(a:AMF3Value):Vector<Float>
	{
		if (a == null) return null;
		return switch (a)
		{
			case AFloatVector(v): v;
			default: null;
		}
	}

	public static function objectVector(a:AMF3Value):Vector<{}>
	{
		if (a == null) return null;
		return switch (a)
		{
			case AObjectVector(v, type):
				var ret = new Vector<{}>(v.length, v.fixed);
				for (i in 0...v.length)
				{
					ret[i] = decode(v[i]);
				}
				ret;
			default: null;
		}
	}

	public static function object(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AObject(f, _, className):
				var o = null;
				if (className != null && className != "")
				{
					var cls = Lib.getClassByAlias(className);
					if (cls == null) cls = Type.resolveClass(className);

					if (cls != null)
					{
						o = Type.createInstance(cls, []);
					}
				}
				else
				{
					o = {};
				}

				if (o != null && f != null)
				{
					for (name in f.keys())
					{
						Reflect.setProperty(o, name, decode(f[name]));
					}
				}
				o;
			default: null;
		}
	}

	public static function external(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AExternal(e): e;
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

	public static function byteArray(a:AMF3Value)
	{
		if (a == null) return null;
		return switch (a)
		{
			case AByteArray(b): b;
			default: null;
		}
	}

	public static function map(a:AMF3Value)
	{
		// TODO: Remove map type?
		if (a == null) return null;
		return switch (a)
		{
			case AMap(m):
				for (f in m.keys())
				{
					if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (f, Int))
					{
						var p = new Map<Int, Dynamic>();
						for (f in m.keys())
							p.set(decode(f), decode(m.get(f)));
						p;
					}
					else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (f, String))
					{
						var p = new Map<String, Dynamic>();
						for (f in m.keys())
							p.set(decode(f), decode(m.get(f)));
						p;
					}
					else
					{
						var p = new Map<{}, Dynamic>();
						for (f in m.keys())
							p.set(decode(f), decode(m.get(f)));
						p;
					}
					break;
				}
				new Map<{}, Dynamic>();
			default: null;
		}
	}
}
