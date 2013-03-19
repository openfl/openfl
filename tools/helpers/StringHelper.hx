package;


class StringHelper {
	
	
	private static var seedNumber = 0;
	private static var usedFlatNames = new Map <String, String> ();
	
	
	public static function formatArray (array:Array <Dynamic>):String {
		
		var output = "[ ";
		
		for (i in 0...array.length) {
			
			output += array[i];
			
			if (i < array.length - 1) {
				
				output += ", ";
				
			} else {
				
				output += " ";
				
			}
			
		}
		
		output += "]";
		
		return output;
		
	}
	
	
	public static function formatEnum (value:Dynamic):String {
			
		return Type.getEnumName (Type.getEnum (value)) + "." + value;
		
	}
	
	
	public static function formatUppercaseVariable (name:String):String {
		
		var variableName = "";
		var lastWasUpperCase = false;
		
		for (i in 0...name.length) {
			
			var char = name.charAt (i);
			
			if (char == char.toUpperCase () && i > 0) {
				
				if (lastWasUpperCase) {
					
					if (i == name.length - 1 || name.charAt (i + 1) == name.charAt (i + 1).toUpperCase ()) {
						
						variableName += char;
						
					} else {
						
						variableName += "_" + char;
						
					}
					
				} else {
					
					variableName += "_" + char;
					
				}
				
				lastWasUpperCase = true;
				
			} else {
				
				variableName += char.toUpperCase ();
				lastWasUpperCase = false;
				
			}
			
		}
		
		return variableName;
		
	}
	
	
	public static function getFlatName (name:String):String {
		
		var chars = name.toLowerCase ();
		var flatName = "";
		
		for (i in 0...chars.length) {
			
			var code = chars.charCodeAt (i);
			
			if ((i > 0 && code >= "0".charCodeAt (0) && code <= "9".charCodeAt (0)) || (code >= "a".charCodeAt (0) && code <= "z".charCodeAt (0)) || (code == "_".charCodeAt (0))) {
				
				flatName += chars.charAt (i);
				
			} else {
				
				flatName += "_";
				
			}
			
		}
		
		if (flatName == "") {
			
			flatName = "_";
			
		}
		
		if (flatName.substr (0, 1) == "_") {
			
			flatName = "file" + flatName;
			
		}
		
		while (usedFlatNames.exists (flatName)) {
			
			// Find last digit ...
			var match = ~/(.*?)(\d+)/;
			
			if (match.match (flatName)) {
				
				flatName = match.matched (1) + (Std.parseInt (match.matched (2)) + 1);
				
			} else {
				
				flatName += "1";
				
			}
			
		}
		
		usedFlatNames.set (flatName, "1");
		
		return flatName;
		
	}
	
	
	public static function getUniqueID ():String {
		
		return StringTools.hex (seedNumber++, 8);
		
	}
	
	
	public static function underline (string:String, character = "="):String {
		
		return string + "\n" + StringTools.lpad ("", character, string.length);
		
	}
		

}
