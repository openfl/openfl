package com.codeazur.utils
{
	import flash.utils.ByteArray;
	
	class HexUtils
	{
		public static var useUpperCase:Bool = false; 
		
		private static var chars:Array;
	
		public static function dumpByteArray(byteArray:ByteArray, startIndex:Int = 0, endIndex:Int = -1, tab:String = ""):String {
			
			var i:Int, j:Int, len:Int = byteArray.length;
			var line:String, result:String;
			var byte:Int;
			
			if (endIndex == -1) {
				endIndex = len;
			}
			
			if ((startIndex < 0) || (startIndex > len)) {
				throw new RangeError("Start Index Is Out of Bounds");
			}
			
			if ((endIndex < 0) || (endIndex > len) || (endIndex < startIndex)) {
				throw new RangeError("End Index Is Out of Bounds");
			}
			
			j = 1;
			result = line = "";
			
			for (i = startIndex; i < endIndex; i++) {
				
				if (j == 1) {
					line += tab + padLeft(i.toString(16), 8, "0") + "  ";
					chars = [];
				}
				
				byte = byteArray[i];
				chars.push(byte);
				line += padLeft(byte.toString(16), 2, "0") + " ";
				
				if ((j % 4) == 0) {
					line += " ";
				}
				
				j++;
				
				if (j == 17) {					
					line += dumpChars();
					result += (line + "\n");
					j = 1;
					line = "";
				}
			}
			
			if (j != 1) {
				line = padRight(line, 61, " ") + " " + dumpChars();
				result += line + "\n";
			}
			
			return useUpperCase ? result.toLocaleUpperCase() : result;
		}
		
		private static function dumpChars():String {
			var byte:Int;
			var result:String = "";
			while(chars.length) {
				byte = chars.shift();
				if (byte >= 32 && byte <= 126) {	// Only show printable characters
					result += String.fromCharCode(byte);
				}
				else {
					result += ".";
				}
			}
			return result;
		}
		
		private static function padLeft(value:String, digits:Int, pad:String):String {
			return new Array(digits - value.length + 1).join(pad) + value;
		}
		
		private static function padRight(value:String, digits:Int, pad:String):String {
			return value + (new Array(digits - value.length + 1).join(pad));
		}
		
	}
}