// Class: haxe.Serializer

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function StringTools() {return require("./../StringTools");}
function Reflect() {return require("./../Reflect");}
function Type() {return require("./../Type");}
function Std() {return require("./../Std");}
function js__$Boot_HaxeError() {return require("./../js/_Boot/HaxeError");}
function List() {return require("./../List");}
function haxe_ds_IntMap() {return require("./../haxe/ds/IntMap");}
function haxe_ds_ObjectMap() {return require("./../haxe/ds/ObjectMap");}
function haxe_ds_StringMap() {return require("./../haxe/ds/StringMap");}
function haxe_io_Bytes() {return require("./../haxe/io/Bytes");}
function HxOverrides() {return require("./../HxOverrides");}
function StringBuf() {return require("./../StringBuf");}

// Constructor

var Serializer = function() {
	this.buf = new (StringBuf().default)();
	this.cache = [];
	this.useCache = Serializer.USE_CACHE;
	this.useEnumIndex = Serializer.USE_ENUM_INDEX;
	this.shash = new (haxe_ds_StringMap().default)();
	this.scount = 0;
}

// Meta

Serializer.__name__ = ["haxe","Serializer"];
Serializer.prototype = {
	toString: function() {
		return this.buf.toString();
	},
	serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.add("R");
			this.buf.add(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.add("y");
		s = (StringTools().default).urlEncode(s);
		this.buf.add(s.length);
		this.buf.add(":");
		this.buf.add(s);
	},
	serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0;
		var _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.add("r");
				this.buf.add(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	},
	serializeFields: function(v) {
		var _g = 0;
		var _g1 = (Reflect().default).fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize((Reflect().default).field(v,f));
		}
		this.buf.add("g");
	},
	serialize: function(v) {
		var _g = (Type().default)["typeof"](v);
		switch((Type().default).enumIndex(_g)) {
		case 0:
			this.buf.add("n");
			break;
		case 1:
			var v1 = v;
			if(v1 == 0) {
				this.buf.add("z");
				return;
			}
			this.buf.add("i");
			this.buf.add(v1);
			break;
		case 2:
			var v2 = v;
			if(isNaN(v2)) {
				this.buf.add("k");
			} else if(!isFinite(v2)) {
				this.buf.add(v2 < 0 ? "m" : "p");
			} else {
				this.buf.add("d");
				this.buf.add(v2);
			}
			break;
		case 3:
			this.buf.add(v ? "t" : "f");
			break;
		case 4:
			if((Std().default)["is"](v,$hxClasses["Class"])) {
				var className = (Type().default).getClassName(v);
				this.buf.add("A");
				this.serializeString(className);
			} else if((Std().default)["is"](v,$hxClasses["Enum"])) {
				this.buf.add("B");
				this.serializeString((Type().default).getEnumName(v));
			} else {
				if(this.useCache && this.serializeRef(v)) {
					return;
				}
				this.buf.add("o");
				this.serializeFields(v);
			}
			break;
		case 5:
			throw new (js__$Boot_HaxeError().default)("Cannot serialize function");
			break;
		case 6:
			var c = _g[2];
			if(c == String) {
				this.serializeString(v);
				return;
			}
			if(this.useCache && this.serializeRef(v)) {
				return;
			}
			switch(c) {
			case Array:
				var ucount = 0;
				this.buf.add("a");
				var l = v["length"];
				var _g1 = 0;
				var _g2 = l;
				while(_g1 < _g2) {
					var i = _g1++;
					if(v[i] == null) {
						++ucount;
					} else {
						if(ucount > 0) {
							if(ucount == 1) {
								this.buf.add("n");
							} else {
								this.buf.add("u");
								this.buf.add(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) {
						this.buf.add("n");
					} else {
						this.buf.add("u");
						this.buf.add(ucount);
					}
				}
				this.buf.add("h");
				break;
			case Date:
				var d = v;
				this.buf.add("v");
				this.buf.add(d.getTime());
				break;
			case (List().default):
				this.buf.add("l");
				var v3 = v;
				var i1 = v3.iterator();
				while(i1.hasNext()) {
					var i2 = i1.next();
					this.serialize(i2);
				}
				this.buf.add("h");
				break;
			case (haxe_ds_IntMap().default):
				this.buf.add("q");
				var v4 = v;
				var k = v4.keys();
				while(k.hasNext()) {
					var k1 = k.next();
					this.buf.add(":");
					this.buf.add(k1);
					this.serialize(v4.get(k1));
				}
				this.buf.add("h");
				break;
			case (haxe_ds_ObjectMap().default):
				this.buf.add("M");
				var v5 = v;
				var k2 = v5.keys();
				while(k2.hasNext()) {
					var k3 = k2.next();
					var id = (Reflect().default).field(k3,"__id__");
					(Reflect().default).deleteField(k3,"__id__");
					this.serialize(k3);
					(Reflect().default).setField(k3,"__id__",id);
					this.serialize(v5.get(k3));
				}
				this.buf.add("h");
				break;
			case (haxe_ds_StringMap().default):
				this.buf.add("b");
				var v6 = v;
				var k4 = v6.keys();
				while(k4.hasNext()) {
					var k5 = k4.next();
					this.serializeString(k5);
					this.serialize(v6.get(k5));
				}
				this.buf.add("h");
				break;
			case (haxe_io_Bytes().default):
				var v7 = v;
				this.buf.add("s");
				this.buf.add(Math.ceil(v7.get_length() * 8 / 6));
				this.buf.add(":");
				var i3 = 0;
				var max = v7.get_length() - 2;
				var b64 = Serializer.BASE64_CODES;
				if(b64 == null) {
					var length = Serializer.BASE64.length;
					var this1 = new Array(length);
					b64 = this1;
					var _g11 = 0;
					var _g3 = Serializer.BASE64.length;
					while(_g11 < _g3) {
						var i4 = _g11++;
						b64[i4] = (HxOverrides().default).cca(Serializer.BASE64,i4);
					}
					Serializer.BASE64_CODES = b64;
				}
				while(i3 < max) {
					var b1 = v7.get(i3++);
					var b2 = v7.get(i3++);
					var b3 = v7.get(i3++);
					this.buf.addChar(b64[b1 >> 2]);
					this.buf.addChar(b64[(b1 << 4 | b2 >> 4) & 63]);
					this.buf.addChar(b64[(b2 << 2 | b3 >> 6) & 63]);
					this.buf.addChar(b64[b3 & 63]);
				}
				if(i3 == max) {
					var b11 = v7.get(i3++);
					var b21 = v7.get(i3++);
					this.buf.addChar(b64[b11 >> 2]);
					this.buf.addChar(b64[(b11 << 4 | b21 >> 4) & 63]);
					this.buf.addChar(b64[b21 << 2 & 63]);
				} else if(i3 == max + 1) {
					var b12 = v7.get(i3++);
					this.buf.addChar(b64[b12 >> 2]);
					this.buf.addChar(b64[b12 << 4 & 63]);
				}
				break;
			default:
				if(this.useCache) {
					this.cache.pop();
				}
				if(v.hxSerialize != null) {
					this.buf.add("C");
					this.serializeString((Type().default).getClassName(c));
					if(this.useCache) {
						this.cache.push(v);
					}
					v.hxSerialize(this);
					this.buf.add("g");
				} else {
					this.buf.add("c");
					this.serializeString((Type().default).getClassName(c));
					if(this.useCache) {
						this.cache.push(v);
					}
					this.serializeFields(v);
				}
			}
			break;
		case 7:
			var e = _g[2];
			if(this.useCache) {
				if(this.serializeRef(v)) {
					return;
				}
				this.cache.pop();
			}
			this.buf.add(this.useEnumIndex ? "j" : "w");
			this.serializeString((Type().default).getEnumName(e));
			if(this.useEnumIndex) {
				this.buf.add(":");
				this.buf.add(v[1]);
			} else {
				this.serializeString(v[0]);
			}
			this.buf.add(":");
			var l1 = v["length"];
			this.buf.add(l1 - 2);
			var _g12 = 2;
			var _g4 = l1;
			while(_g12 < _g4) {
				var i5 = _g12++;
				this.serialize(v[i5]);
			}
			if(this.useCache) {
				this.cache.push(v);
			}
			break;
		default:
			throw new (js__$Boot_HaxeError().default)("Cannot serialize " + (Std().default).string(v));
		}
	}
};
Serializer.prototype.__class__ = Serializer.prototype.constructor = $hxClasses["haxe.Serializer"] = Serializer;

// Init



// Statics

Serializer.run = function(v) {
	var s = new Serializer();
	s.serialize(v);
	return s.toString();
}
Serializer.USE_CACHE = false
Serializer.USE_ENUM_INDEX = false
Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:"
Serializer.BASE64_CODES = null

// Export

exports.default = Serializer;