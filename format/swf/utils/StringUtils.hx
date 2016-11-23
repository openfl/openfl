package format.swf.utils;

import haxe.crypto.BaseCode;

//import flash.events.*;

class StringUtils
{
	public static function trim(input:String):String {
		return StringUtils.ltrim(StringUtils.rtrim(input));
	}

	public static function ltrim(input:String):String {
		if (input != null) {
			var size:Int = input.length;
			for(i in 0...size) {
				if(input.charCodeAt(i) > 32) {
					return input.substring(i);
				}
			}
		}
		return "";
	}

	public static function rtrim(input:String):String {
		if (input != null) {
			var size:Int = input.length;
			var i:Int = size;
			while(i > 0) {
				if(input.charCodeAt(i - 1) > 32) {
					return input.substring(0, i);
				}
				i--;
			}
		}
		return "";
	}

	public static function simpleEscape(input:String):String {
		input = input.split("\n").join("\\n");
		input = input.split("\r").join("\\r");
		input = input.split("\t").join("\\t");
		//input = input.split("\f").join("\\f");
		//input = input.split("\b").join("\\b");
		return input;
	}
	
	public static function strictEscape(input:String, trim:Bool = true):String {
		if (input != null && input.length > 0) {
			if (trim) {
				input = StringUtils.trim(input);
			}
			input = StringTools.urlEncode(input);
			var a = input.split("");
			for (i in 0...a.length) {
				switch(a[i]) {
					case "!": a[i] = "%21";
					case "'": a[i] = "%27";
					case "(": a[i] = "%28";
					case ")": a[i] = "%29";
					case "*": a[i] = "%2A";
					case "-": a[i] = "%2D";
					case ".": a[i] = "%2E";
					case "_": a[i] = "%5F";
					case "~": a[i] = "%7E";
				}
			}
			return a.join("");
		}
		return "";
	}
	
	public static function repeat(n:Int, str:String = " "):String {
		var ret = "";
		for (i in 0...n) {
			ret += str;
		}
		return ret;
	}
	
	
	private static var i:Int = 0;
	
	private static inline var SIGN_UNDEF:Int = 0;
	private static inline var SIGN_POS:Int = -1;
	private static inline var SIGN_NEG:Int = 1;
	
	public static function printf(format:String, args:Array<Dynamic>):String {
		var result:String = "";
		var indexValue:Int = 0;
		var isIndexed:Int = -1;
		var typeLookup:String = "diufFeEgGxXoscpn";
		var i = 0;
		while (i < format.length) {
			var c:String = format.charAt(i);
			if(c == "%") {
				if(++i < format.length) {
					c = format.charAt(i);
					if(c == "%") {
						result += c;
					} else {
						var flagSign:Bool = false;
						var flagLeftAlign:Bool = false;
						var flagAlternate:Bool = false;
						var flagLeftPad:Bool = false;
						var flagZeroPad:Bool = false;
						var width:Int = -1;
						var precision:Int = -1;
						var type:String = "";
						var value:Dynamic;
						var j:Int;
						
						///////////////////////////
						// parse parameter
						///////////////////////////
						var idx:Int = getIndex(format);
						if(idx < -1 || idx == 0) {
							trace("ERR parsing index");
							break;
						} else if(idx == -1) {
							if(isIndexed == 1) { trace("ERR: indexed placeholder expected"); break; }
							if(isIndexed == -1) { isIndexed = 0; }
							indexValue++;
						} else {
							if(isIndexed == 0) { trace("ERR: non-indexed placeholder expected"); break; }
							if(isIndexed == -1) { isIndexed = 1; }
							indexValue = idx;
						}
						
						///////////////////////////
						// parse flags
						///////////////////////////
						c = format.charAt(i);
						while(c == "+" || c == "-" || c == "#" || c == " " || c == "0") {
							switch(c) {
								case "+": flagSign = true;
								case "-": flagLeftAlign = true;
								case "#": flagAlternate = true;
								case " ": flagLeftPad = true;
								case "0": flagZeroPad = true;
							}
							if(++i == format.length) { break; }
							c = format.charAt(i);
						}
						if(i == format.length) { break; }
						
						///////////////////////////
						// parse width
						///////////////////////////
						if(c == "*") {
							var widthIndex:Int = 0;
							if(++i == format.length) { break; }
							idx = getIndex(format);
							if(idx < -1 || idx == 0) {
								trace("ERR parsing index for width");
								break;
							} else if(idx == -1) {
								if(isIndexed == 1) { trace("ERR: indexed placeholder expected for width"); break; }
								if(isIndexed == -1) { isIndexed = 0; }
								widthIndex = indexValue++;
							} else {
								if(isIndexed == 0) { trace("ERR: non-indexed placeholder expected for width"); break; }
								if(isIndexed == -1) { isIndexed = 1; }
								widthIndex = idx;
							}
							widthIndex--;
							if(args.length > widthIndex && widthIndex >= 0) {
								width = Std.int(args[widthIndex]);
								if(Math.isNaN(width)) {
									width = -1;
									trace("ERR NaN while parsing width");
									break;
								}
							} else {
								trace("ERR index out of bounds while parsing width");
								break;
							}
							c = format.charAt(i);
						} else {
							var hasWidth:Bool = false;
							while(c >= "0" && c <= "9") {
								if(width == -1) { width = 0; }
								width = (width * 10) + Std.parseInt(c);
								if(++i == format.length) { break; }
								c = format.charAt(i);
							}
							if(width != -1 && i == format.length) {
								trace("ERR eof while parsing width");
								break;
							}
						}
						
						///////////////////////////
						// parse precision
						///////////////////////////
						if(c == ".") {
							if(++i == format.length) { break; }
							c = format.charAt(i);
							if(c == "*") {
								var precisionIndex:Int = 0;
								if(++i == format.length) { break; }
								idx = getIndex(format);
								if(idx < -1 || idx == 0) {
									trace("ERR parsing index for precision");
									break;
								} else if(idx == -1) {
									if(isIndexed == 1) { trace("ERR: indexed placeholder expected for precision"); break; }
									if(isIndexed == -1) { isIndexed = 0; }
									precisionIndex = indexValue++;
								} else {
									if(isIndexed == 0) { trace("ERR: non-indexed placeholder expected for precision"); break; }
									if(isIndexed == -1) { isIndexed = 1; }
									precisionIndex = idx;
								}
								precisionIndex--;
								if(args.length > precisionIndex && precisionIndex >= 0) {
									precision = Std.int(args[precisionIndex]);
									if(Math.isNaN(precision)) {
										precision = -1;
										trace("ERR NaN while parsing precision");
										break;
									}
								} else {
									trace("ERR index out of bounds while parsing precision");
									break;
								}
								c = format.charAt(i);
							} else {
								while(c >= "0" && c <= "9") {
									if(precision == -1) { precision = 0; }
									precision = (precision * 10) + Std.parseInt(c);
									if(++i == format.length) { break; }
									c = format.charAt(i);
								}
								if(precision != -1 && i == format.length) {
									trace("ERR eof while parsing precision");
									break;
								}
							}
						}
						
						///////////////////////////
						// parse length (ignored)
						///////////////////////////
						switch(c) {
							case "h":
							case "l":
								if(++i == format.length) { trace("ERR eof after length"); break; }
								var c1:String = format.charAt(i);
								if((c == "h" && c1 == "h") || (c == "l" && c1 == "l")) {
									if(++i == format.length) { trace("ERR eof after length"); break; }
									c = format.charAt(i);
								} else {
									c = c1;
								}
								break;
							case "L":
							case "z":
							case "j":
							case "t":
								if(++i == format.length) { trace("ERR eof after length"); break; }
								c = format.charAt(i);
								break;
						}
						
						///////////////////////////
						// parse type
						///////////////////////////
						if(typeLookup.indexOf(c) >= 0) {
							type = c;
						} else {
							trace("ERR unknown type: " + c);
							break;
						}
						
						if(args.length >= indexValue && indexValue > 0) {
							value = args[indexValue - 1];
						} else {
							trace("ERR value index out of bounds (" + indexValue + ")");
							break;
						}
						
						var valueStr:String = "";
						var valueFloat:Float;
						var valueInt:Int;
						var sign:Int = SIGN_UNDEF;
						switch(type) {
							case "s":
								valueStr = Std.string (value);
								if(precision != -1) { valueStr = valueStr.substr(0, precision); }
								break;
							case "c":
								//valueStr = Std.string (value).getAt(0);
								valueStr = Std.string (value).charAt(0);
								break;
							case "d":
							case "i":
								valueInt = ((Std.is (value, Float)) ? cast value : Std.parseInt(Std.string (value)));
								valueStr = Std.string (Math.abs(valueInt));
								sign = (valueInt < 0) ? SIGN_NEG : SIGN_POS;
								break;
							case "u":
								valueStr = Std.string ((Std.is (value, Float)) ? cast value : Std.parseInt(Std.string (value)));
								break;
							case "f":
							case "F":
							case "e":
							case "E":
							case "g":
							case "G":
								if(precision == -1) { precision = 6; }
								var exp10:Float = Math.pow(10, precision);
								valueFloat = (Std.is (value, Float)) ? cast value : Std.parseFloat(Std.string (value));
								valueStr = Std.string (Math.round(Math.abs(valueFloat) * exp10) / exp10);
								if(precision > 0) {
									var numZerosToAppend:Int;
									var dotPos:Int = valueStr.indexOf(".");
									if(dotPos == -1) {
										valueStr += ".";
										numZerosToAppend = precision;
									} else {
										numZerosToAppend = precision - (valueStr.length - dotPos - 1);
									}
									for(j in 0...numZerosToAppend) {
										valueStr += "0";
									}
								}
								sign = (valueFloat < 0) ? SIGN_NEG : SIGN_POS;
								break;
							case "x":
							case "X":
							case "p":
								valueStr = (Std.is (value, Float)) ? Std.string (Std.int(value)) : StringTools.hex (Std.parseInt(value));
								if(type == "X") { valueStr = valueStr.toUpperCase(); }
								break;
							case "o":
								valueStr = BaseCode.encode (Std.string (((Std.is (value, Float)) ? Std.int(value) : Std.int(value))), "01234567");
								break;
						}
						
						var hasSign:Bool = ((sign == SIGN_NEG) || flagSign || flagLeftPad);
						if(width > -1) {
							var numFill:Int = width - valueStr.length;
							if(hasSign) { numFill--; }
							if(numFill > 0) {
								var fillChar:String = (flagZeroPad && !flagLeftAlign) ? "0" : " ";
								if(flagLeftAlign) {
									for(j in 0...numFill) {
										valueStr += fillChar;
									}
								} else {
									for(j in 0...numFill) {
										valueStr = fillChar + valueStr;
									}
								}
							}
						}
						if(hasSign) {
							if(sign == SIGN_POS) {
								valueStr = (flagLeftPad ? " " : "0") + valueStr;
							} else {
								valueStr = "-" + valueStr;
							}
						}
						
						result += valueStr;
						
						///////////////////////////
						// debug
						///////////////////////////
						/*
						var d:String = "";
						d += "type:" + type + " ";
						d += "width:" + width + " ";
						d += "precision:" + precision + " ";
						d += "flags:";
						var da:Array = [];
						if(flagSign) { da.push("sign"); }
						if(flagLeftAlign) { da.push("leftalign"); }
						if(flagAlternate) { da.push("alternate"); }
						if(flagLeftPad) { da.push("leftpad"); }
						if(flagZeroPad) { da.push("zeropad"); }
						d += ((da.length == 0) ? "-" : da.toString()) + " ";
						d += "index:" + indexValue + " ";
						d += "value:" + value + " ";
						d += "result:" + valueStr;
						trace(d);
						*/
						
					}
				} else {
					result += c;
				}
			} else {
				result += c;
			}
			i++;
		}
		return result;
	}
	
	private static function getIndex(format:String):Int {
		var result:Int = 0;
		var isIndexed:Bool = false;
		var c:String = "";
		var iTmp:Int = i;
		while((c = format.charAt(i)) >= "0" && c <= "9") {
			isIndexed = true;
			result = (result * 10) + Std.parseInt(c);
			if(++i == format.length) { return -2; }
		}
		if(isIndexed) {
			if(c != "$") {
				i = iTmp;
				return -1;
			}
			if(++i == format.length) { return -2; }
			return result;
		} else {
			return -1;
		}
	}
}