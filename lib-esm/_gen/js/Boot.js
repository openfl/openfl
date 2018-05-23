// Class: js.Boot

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function js__$Boot_HaxeError() {return require("./../js/_Boot/HaxeError");}
function Std() {return require("./../Std");}

// Constructor

var Boot = function(){}

// Meta

Boot.__name__ = ["js","Boot"];
Boot.prototype = {
	
};
Boot.prototype.__class__ = Boot.prototype.constructor = $hxClasses["js.Boot"] = Boot;

// Init



// Statics

Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
Boot.__trace = function(v,i) {
	var msg = i != null ? i.fileName + ":" + i.lineNumber + ": " : "";
	msg += Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + Boot.__string_rec(v1,"");
		}
	}
	var d;
	var tmp;
	if(typeof(document) != "undefined") {
		d = document.getElementById("haxe:trace");
		tmp = d != null;
	} else {
		tmp = false;
	}
	if(tmp) {
		d.innerHTML += Boot.__unhtml(msg) + "<br/>";
	} else if(typeof console != "undefined" && console.log != null) {
		console.log(msg);
	}
}
Boot.isClass = function(o) {
	return o.__name__;
}
Boot.isEnum = function(e) {
	return e.__ename__;
}
Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = Boot.__nativeClassName(o);
		if(name != null) {
			return Boot.__resolveNativeClass(name);
		}
		return null;
	}
}
Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (Boot.isClass(o) || Boot.isEnum(o))) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + Boot.__string_rec(o[i],s);
					} else {
						str += Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
}
Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return Boot.__interfLoop(cc.__super__,cl);
}
Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case $hxClasses["Bool"]:
		return typeof(o) == "boolean";
	case $hxClasses["Dynamic"]:
		return true;
	case $hxClasses["Float"]:
		return typeof(o) == "number";
	case $hxClasses["Int"]:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(Boot.__interfLoop(Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == $hxClasses["Class"] ? o.__name__ != null : false) {
			return true;
		}
		if(cl == $hxClasses["Enum"] ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
}
Boot.__cast = function(o,t) {
	if(Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw new (js__$Boot_HaxeError().default)("Cannot cast " + (Std().default).string(o) + " to " + (Std().default).string(t));
	}
}
Boot.__nativeClassName = function(o) {
	var name = Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
}
Boot.__isNativeObj = function(o) {
	return Boot.__nativeClassName(o) != null;
}
Boot.__resolveNativeClass = function(name) {
	return $global[name];
}
Boot.__toStr = ({ }).toString

// Export

exports.default = Boot;