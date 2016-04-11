// Based on original haxe.ds.StringMap class but removes all reserved keys checks

/*
 * Copyright (C)2005-2016 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package openfl.utils;

#if (js && html5)
private class UnsafeStringMapIterator<T> {
	var map : UnsafeStringMap<T>;
	var keys : Array<String>;
	var index : Int;
	var count : Int;
	public inline function new(map:UnsafeStringMap<T>, keys:Array<String>) {
		this.map = map;
		this.keys = keys;
		this.index = 0;
		this.count = keys.length;
	}
	public inline function hasNext() {
		return index < count;
	}
	public inline function next() {
		return map.get(keys[index++]);
	}
}

class UnsafeStringMap<T> implements haxe.Constraints.IMap<String,T> {

	private var h : Dynamic;

	public inline function new() : Void {
		h = {};
	}

	public inline function set( key : String, value : T ) : Void {
		h[cast key] = value;
	}

	public inline function get( key : String ) : Null<T> {
		return h[cast key];
	}

	public inline function exists( key : String ) : Bool {
		return h.hasOwnProperty(key);
	}

	public function remove( key : String ) : Bool {
		if( !h.hasOwnProperty(key) )
			return false;
		untyped __js__("delete")(h[key]);
		return true;
	}

	public function keys() : Iterator<String> {
		return arrayKeys().iterator();
	}

	function arrayKeys() : Array<String> {
		var out = [];
		untyped {
			__js__("for( var key in this.h ) {");
				if( h.hasOwnProperty(key) )
					out.push(key);
			__js__("}");
		}
		return out;
	}

	public inline function iterator() : Iterator<T> {
		return new UnsafeStringMapIterator(this, arrayKeys());
	}

	public function toString() : String {
		var s = new StringBuf();
		s.add("{");
		var keys = arrayKeys();
		for( i in 0...keys.length ) {
			var k = keys[i];
			s.add(k);
			s.add(" => ");
			s.add(Std.string(get(k)));
			if( i < keys.length-1 )
				s.add(", ");
		}
		s.add("}");
		return s.toString();
	}
}
#else
typedef UnsafeStringMap<T> = haxe.ds.StringMap<T>;
#end
