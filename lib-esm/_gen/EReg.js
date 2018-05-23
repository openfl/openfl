// Class: EReg

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function js__$Boot_HaxeError() {return require("./js/_Boot/HaxeError");}
function HxOverrides() {return require("./HxOverrides");}
function StringBuf() {return require("./StringBuf");}

// Constructor

var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
}

// Meta

EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) {
			this.r.lastIndex = 0;
		}
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	},
	matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) {
			return this.r.m[n];
		} else {
			throw new (js__$Boot_HaxeError().default)("EReg::matched");
		}
	},
	matchedRight: function() {
		if(this.r.m == null) {
			throw new (js__$Boot_HaxeError().default)("No string matched");
		}
		var sz = this.r.m.index + this.r.m[0].length;
		return (HxOverrides().default).substr(this.r.s,sz,this.r.s.length - sz);
	},
	matchedPos: function() {
		if(this.r.m == null) {
			throw new (js__$Boot_HaxeError().default)("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	},
	matchSub: function(s,pos,len) {
		if(len == null) {
			len = -1;
		}
		if(this.r.global) {
			this.r.lastIndex = pos;
			var tmp = this.r;
			var tmp1 = len < 0 ? s : (HxOverrides().default).substr(s,0,pos + len);
			this.r.m = tmp.exec(tmp1);
			var b = this.r.m != null;
			if(b) {
				this.r.s = s;
			}
			return b;
		} else {
			var b1 = this.match(len < 0 ? (HxOverrides().default).substr(s,pos,null) : (HxOverrides().default).substr(s,pos,len));
			if(b1) {
				this.r.s = s;
				this.r.m.index += pos;
			}
			return b1;
		}
	},
	split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	},
	replace: function(s,by) {
		return s.replace(this.r,by);
	},
	map: function(s,f) {
		var offset = 0;
		var buf = new (StringBuf().default)();
		while(true) {
			if(offset >= s.length) {
				break;
			} else if(!this.matchSub(s,offset)) {
				buf.add((HxOverrides().default).substr(s,offset,null));
				break;
			}
			var p = this.matchedPos();
			buf.add((HxOverrides().default).substr(s,offset,p.pos - offset));
			buf.add(f(this));
			if(p.len == 0) {
				buf.add((HxOverrides().default).substr(s,p.pos,1));
				offset = p.pos + 1;
			} else {
				offset = p.pos + p.len;
			}
			if(!this.r.global) {
				break;
			}
		}
		if(!this.r.global && offset > 0 && offset < s.length) {
			buf.add((HxOverrides().default).substr(s,offset,null));
		}
		return buf.toString();
	}
};
EReg.prototype.__class__ = EReg.prototype.constructor = $hxClasses["EReg"] = EReg;

// Init



// Statics




// Export

exports.default = EReg;