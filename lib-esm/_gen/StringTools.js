// Class: StringTools

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function HxOverrides() {return require("./HxOverrides");}

// Constructor

var StringTools = function(){}

// Meta

StringTools.__name__ = ["StringTools"];
StringTools.prototype = {
	
};
StringTools.prototype.__class__ = StringTools.prototype.constructor = $hxClasses["StringTools"] = StringTools;

// Init



// Statics

StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	if(quotes) {
		return s.split("\"").join("&quot;").split("'").join("&#039;");
	} else {
		return s;
	}
}
StringTools.startsWith = function(s,start) {
	if(s.length >= start.length) {
		return (HxOverrides().default).substr(s,0,start.length) == start;
	} else {
		return false;
	}
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	if(slen >= elen) {
		return (HxOverrides().default).substr(s,slen - elen,elen) == end;
	} else {
		return false;
	}
}
StringTools.isSpace = function(s,pos) {
	var c = (HxOverrides().default).cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return (HxOverrides().default).substr(s,r,l - r);
	} else {
		return s;
	}
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return (HxOverrides().default).substr(s,0,l - r);
	} else {
		return s;
	}
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	while(true) {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
		if(!(n > 0)) {
			break;
		}
	}
	if(digits != null) {
		while(s.length < digits) s = "0" + s;
	}
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
}
StringTools.isEof = function(c) {
	return c != c;
}


// Export

exports.default = StringTools;