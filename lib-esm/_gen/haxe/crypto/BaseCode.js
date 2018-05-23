// Class: haxe.crypto.BaseCode

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function Std() {return require("./../../Std");}
function haxe_io_Bytes() {return require("./../../haxe/io/Bytes");}
function js__$Boot_HaxeError() {return require("./../../js/_Boot/HaxeError");}

// Constructor

var BaseCode = function(base) {
	var len = base.get_length();
	var nbits = 1;
	while(len > 1 << nbits) ++nbits;
	if(nbits > 8 || len != 1 << nbits) {
		throw new (js__$Boot_HaxeError().default)("BaseCode : base length must be a power of two.");
	}
	this.base = base;
	this.nbits = nbits;
}

// Meta

BaseCode.__name__ = ["haxe","crypto","BaseCode"];
BaseCode.prototype = {
	encodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		var size = (Std().default)["int"](b.get_length() * 8 / nbits);
		var out = (haxe_io_Bytes().default).alloc(size + (b.get_length() * 8 % nbits == 0 ? 0 : 1));
		var buf = 0;
		var curbits = 0;
		var mask = (1 << nbits) - 1;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < nbits) {
				curbits += 8;
				buf <<= 8;
				buf |= b.get(pin++);
			}
			curbits -= nbits;
			out.set(pout++,base.get(buf >> curbits & mask));
		}
		if(curbits > 0) {
			out.set(pout++,base.get(buf << nbits - curbits & mask));
		}
		return out;
	},
	initTable: function() {
		var tbl = [];
		var _g = 0;
		while(_g < 256) {
			var i = _g++;
			tbl[i] = -1;
		}
		var _g1 = 0;
		var _g2 = this.base.get_length();
		while(_g1 < _g2) {
			var i1 = _g1++;
			tbl[this.base.get(i1)] = i1;
		}
		this.tbl = tbl;
	},
	decodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		if(this.tbl == null) {
			this.initTable();
		}
		var tbl = this.tbl;
		var size = b.get_length() * nbits >> 3;
		var out = (haxe_io_Bytes().default).alloc(size);
		var buf = 0;
		var curbits = 0;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < 8) {
				curbits += nbits;
				buf <<= nbits;
				var i = tbl[b.get(pin++)];
				if(i == -1) {
					throw new (js__$Boot_HaxeError().default)("BaseCode : invalid encoded char");
				}
				buf |= i;
			}
			curbits -= 8;
			out.set(pout++,buf >> curbits & 255);
		}
		return out;
	}
};
BaseCode.prototype.__class__ = BaseCode.prototype.constructor = $hxClasses["haxe.crypto.BaseCode"] = BaseCode;

// Init



// Statics




// Export

exports.default = BaseCode;