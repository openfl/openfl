// Class: haxe.Unserializer

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function haxe__$Unserializer_NullResolver() {return require("./../haxe/_Unserializer/NullResolver");}
function StringTools() {return require("./../StringTools");}
function Std() {return require("./../Std");}
function HxOverrides() {return require("./../HxOverrides");}
function js__$Boot_HaxeError() {return require("./../js/_Boot/HaxeError");}
function Reflect() {return require("./../Reflect");}
function Type() {return require("./../Type");}
function haxe_ds_ObjectMap() {return require("./../haxe/ds/ObjectMap");}
function haxe_ds_StringMap() {return require("./../haxe/ds/StringMap");}
function List() {return require("./../List");}
function haxe_ds_IntMap() {return require("./../haxe/ds/IntMap");}
function haxe_io_Bytes() {return require("./../haxe/io/Bytes");}
function haxe__$Unserializer_DefaultResolver() {return require("./../haxe/_Unserializer/DefaultResolver");}

// Constructor

var Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = [];
	this.cache = [];
	var r = Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = new (haxe__$Unserializer_DefaultResolver().default)();
		Unserializer.DEFAULT_RESOLVER = r;
	}
	this.resolver = r;
}

// Meta

Unserializer.__name__ = ["haxe","Unserializer"];
Unserializer.prototype = {
	setResolver: function(r) {
		if(r == null) {
			this.resolver = (haxe__$Unserializer_NullResolver().default).get_instance();
		} else {
			this.resolver = r;
		}
	},
	get: function(p) {
		return (StringTools().default).fastCodeAt(this.buf,p);
	},
	readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.get(this.pos);
			if((StringTools().default).isEof(c)) {
				break;
			}
			if(c == 45) {
				if(this.pos != fpos) {
					break;
				}
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) {
				break;
			}
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) {
			k *= -1;
		}
		return k;
	},
	readFloat: function() {
		var p1 = this.pos;
		while(true) {
			var c = this.get(this.pos);
			if((StringTools().default).isEof(c)) {
				break;
			}
			if(c >= 43 && c < 58 || c == 101 || c == 69) {
				this.pos++;
			} else {
				break;
			}
		}
		return (Std().default).parseFloat((HxOverrides().default).substr(this.buf,p1,this.pos - p1));
	},
	unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) {
				throw new (js__$Boot_HaxeError().default)("Invalid object");
			}
			if(this.get(this.pos) == 103) {
				break;
			}
			var k = this.unserialize();
			if(typeof(k) != "string") {
				throw new (js__$Boot_HaxeError().default)("Invalid object key");
			}
			var v = this.unserialize();
			(Reflect().default).setField(o,k,v);
		}
		this.pos++;
	},
	unserializeEnum: function(edecl,tag) {
		if(this.get(this.pos++) != 58) {
			throw new (js__$Boot_HaxeError().default)("Invalid enum format");
		}
		var nargs = this.readDigits();
		if(nargs == 0) {
			return (Type().default).createEnum(edecl,tag);
		}
		var args = [];
		while(nargs-- > 0) args.push(this.unserialize());
		return (Type().default).createEnum(edecl,tag,args);
	},
	unserialize: function() {
		var _g = this.get(this.pos++);
		switch(_g) {
		case 65:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) {
				throw new (js__$Boot_HaxeError().default)("Class not found " + name);
			}
			return cl;
		case 66:
			var name1 = this.unserialize();
			var e = this.resolver.resolveEnum(name1);
			if(e == null) {
				throw new (js__$Boot_HaxeError().default)("Enum not found " + name1);
			}
			return e;
		case 67:
			var name2 = this.unserialize();
			var cl1 = this.resolver.resolveClass(name2);
			if(cl1 == null) {
				throw new (js__$Boot_HaxeError().default)("Class not found " + name2);
			}
			var o = (Type().default).createEmptyInstance(cl1);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.get(this.pos++) != 103) {
				throw new (js__$Boot_HaxeError().default)("Invalid custom data");
			}
			return o;
		case 77:
			var h = new (haxe_ds_ObjectMap().default)();
			this.cache.push(h);
			var buf = this.buf;
			while(this.get(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) {
				throw new (js__$Boot_HaxeError().default)("Invalid string reference");
			}
			return this.scache[n];
		case 97:
			var buf1 = this.buf;
			var a = [];
			this.cache.push(a);
			while(true) {
				var c = this.get(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n1 = this.readDigits();
					a[a.length + n1 - 1] = null;
				} else {
					a.push(this.unserialize());
				}
			}
			return a;
		case 98:
			var h1 = new (haxe_ds_StringMap().default)();
			this.cache.push(h1);
			var buf2 = this.buf;
			while(this.get(this.pos) != 104) {
				var s1 = this.unserialize();
				h1.set(s1,this.unserialize());
			}
			this.pos++;
			return h1;
		case 99:
			var name3 = this.unserialize();
			var cl2 = this.resolver.resolveClass(name3);
			if(cl2 == null) {
				throw new (js__$Boot_HaxeError().default)("Class not found " + name3);
			}
			var o1 = (Type().default).createEmptyInstance(cl2);
			this.cache.push(o1);
			this.unserializeObject(o1);
			return o1;
		case 100:
			return this.readFloat();
		case 102:
			return false;
		case 105:
			return this.readDigits();
		case 106:
			var name4 = this.unserialize();
			var edecl = this.resolver.resolveEnum(name4);
			if(edecl == null) {
				throw new (js__$Boot_HaxeError().default)("Enum not found " + name4);
			}
			this.pos++;
			var index = this.readDigits();
			var tag = (Type().default).getEnumConstructs(edecl)[index];
			if(tag == null) {
				throw new (js__$Boot_HaxeError().default)("Unknown enum index " + name4 + "@" + index);
			}
			var e1 = this.unserializeEnum(edecl,tag);
			this.cache.push(e1);
			return e1;
		case 107:
			return NaN;
		case 108:
			var l = new (List().default)();
			this.cache.push(l);
			var buf3 = this.buf;
			while(this.get(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 109:
			return -Infinity;
		case 110:
			return null;
		case 111:
			var o2 = { };
			this.cache.push(o2);
			this.unserializeObject(o2);
			return o2;
		case 112:
			return Infinity;
		case 113:
			var h2 = new (haxe_ds_IntMap().default)();
			this.cache.push(h2);
			var buf4 = this.buf;
			var c1 = this.get(this.pos++);
			while(c1 == 58) {
				var i = this.readDigits();
				h2.set(i,this.unserialize());
				c1 = this.get(this.pos++);
			}
			if(c1 != 104) {
				throw new (js__$Boot_HaxeError().default)("Invalid IntMap format");
			}
			return h2;
		case 114:
			var n2 = this.readDigits();
			if(n2 < 0 || n2 >= this.cache.length) {
				throw new (js__$Boot_HaxeError().default)("Invalid reference");
			}
			return this.cache[n2];
		case 115:
			var len = this.readDigits();
			var buf5 = this.buf;
			if(this.get(this.pos++) != 58 || this.length - this.pos < len) {
				throw new (js__$Boot_HaxeError().default)("Invalid bytes length");
			}
			var codes = Unserializer.CODES;
			if(codes == null) {
				codes = Unserializer.initCodes();
				Unserializer.CODES = codes;
			}
			var i1 = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2 ? rest - 1 : 0);
			var max = i1 + (len - rest);
			var bytes = (haxe_io_Bytes().default).alloc(size);
			var bpos = 0;
			while(i1 < max) {
				var c11 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				var c2 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c11 << 2 | c2 >> 4);
				var c3 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c2 << 4 | c3 >> 2);
				var c4 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c3 << 6 | c4);
			}
			if(rest >= 2) {
				var c12 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				var c21 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c12 << 2 | c21 >> 4);
				if(rest == 3) {
					var c31 = codes[(StringTools().default).fastCodeAt(buf5,i1++)];
					bytes.set(bpos++,c21 << 4 | c31 >> 2);
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 116:
			return true;
		case 118:
			var d;
			if(this.get(this.pos) >= 48 && this.get(this.pos) <= 57 && this.get(this.pos + 1) >= 48 && this.get(this.pos + 1) <= 57 && this.get(this.pos + 2) >= 48 && this.get(this.pos + 2) <= 57 && this.get(this.pos + 3) >= 48 && this.get(this.pos + 3) <= 57 && this.get(this.pos + 4) == 45) {
				d = (HxOverrides().default).strDate((HxOverrides().default).substr(this.buf,this.pos,19));
				this.pos += 19;
			} else {
				var t = this.readFloat();
				d = new Date(t);
			}
			this.cache.push(d);
			return d;
		case 119:
			var name5 = this.unserialize();
			var edecl1 = this.resolver.resolveEnum(name5);
			if(edecl1 == null) {
				throw new (js__$Boot_HaxeError().default)("Enum not found " + name5);
			}
			var e2 = this.unserializeEnum(edecl1,this.unserialize());
			this.cache.push(e2);
			return e2;
		case 120:
			throw (js__$Boot_HaxeError().default).wrap(this.unserialize());
			break;
		case 121:
			var len1 = this.readDigits();
			if(this.get(this.pos++) != 58 || this.length - this.pos < len1) {
				throw new (js__$Boot_HaxeError().default)("Invalid string length");
			}
			var s2 = (HxOverrides().default).substr(this.buf,this.pos,len1);
			this.pos += len1;
			s2 = (StringTools().default).urlDecode(s2);
			this.scache.push(s2);
			return s2;
		case 122:
			return 0;
		default:
		}
		this.pos--;
		throw new (js__$Boot_HaxeError().default)("Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos);
	}
};
Unserializer.prototype.__class__ = Unserializer.prototype.constructor = $hxClasses["haxe.Unserializer"] = Unserializer;

// Init



// Statics

Unserializer.initCodes = function() {
	var codes = [];
	var _g1 = 0;
	var _g = Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[(StringTools().default).fastCodeAt(Unserializer.BASE64,i)] = i;
	}
	return codes;
}
Unserializer.run = function(v) {
	return new Unserializer(v).unserialize();
}
Unserializer.DEFAULT_RESOLVER = new (haxe__$Unserializer_DefaultResolver().default)()
Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:"
Unserializer.CODES = null

// Export

exports.default = Unserializer;