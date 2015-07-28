package openfl.text;
import haxe.Utf8;

/**
 * ...
 * @author larsiusprime
 */

@:access(openfl.text.Font)
@:access(openfl.text.TextField)

class TextUtil
{
	public static var __utf8_tab_code:Int = 9;
	public static var __utf8_endline_code:Int = 10;
	public static var __utf8_space_code:Int = 32;
	public static var __utf8_hyphen_code:Int = 0x2D;
	
	/**
	 * Returns an array of the starting indeces of all the words in the text field.
	 * Word boundaries are detected after whitespace and hyphens
	 * @param	textField
	 * @return
	 */
	
	public static function getWordIndices (textField:TextField):Array<Int> {
		
		var lastChar:Int = -1;
		var words = [];
		var i:Int = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char != lastChar) {
				
				//If the last character is not the same as this
				//and the last character was whitespace/hyphen
				//and this character is not one of those
				
				if ((lastChar == __utf8_endline_code ||
				     lastChar == __utf8_space_code   ||
				     lastChar == __utf8_tab_code     ||
				     lastChar == __utf8_hyphen_code)
					&&
					(char != __utf8_endline_code  &&
					 char != __utf8_space_code    &&
					 char != __utf8_tab_code      &&
					 char != __utf8_hyphen_code))
				{
					words.push(i);
				}
				
			}
			
			lastChar = char;
			
			i++;
			
		});
		
		return words;
	}
	
	public static function getLineBreaks (textField:TextField):Int {
		
		//returns the number of line breaks in the text
		
		var lines = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				lines++;
				
			}
			
		});
		
		return lines;
	}
	
	public static function getLineBreaksInRange (textField:TextField, i:Int):Int {
		
		//returns the number of line breaks that occur within a given format range
		
		var lines = 0;
		
		if (textField.__ranges.length > i && i >= 0) {
			
			var range = textField.__ranges[i];
			
			//TODO: this could quite possibly cause crash errors if range indeces are not based on Utf8 character indeces
			
			if (range.start > 0 && range.end < textField.text.length) {
				
				Utf8.iter(textField.text, function(char:Int) {
					
					if (char == __utf8_endline_code) {
						
						lines++;
						
					}
					
				});
				
			}
			
		}
		
		return lines;
		
	}
	
	public static function getLineIndices (textField:TextField, line:Int):Array<Int> {
		
		//tells you what the first and last (non-linebreak) character indeces are in a given line
		
		var breaks = getLineBreakIndices (textField);
		var i = 0;
		var first_char = 0;
		var last_char:Int = textField.text.length - 1;
		
		for (br in breaks) {
			
			//if this is the line we care about
			
			if (i == line) {
				
				//the first actual character in our line is the index after this line break
				
				first_char = br + 1;
				
				//if there's another line break left in the list
				
				if (i != breaks.length-1) {
					
					//the last character is the index before the next line break
					//(otherwise it's the last character in the text field)
					
					last_char = breaks[i + 1] - 1;
					
				}
				
			}
			
			i++;
			
		}
		
		return [ first_char, last_char ];
		
	}
	
	public static function getLineBreakIndices (textField:TextField):Array<Int> {
		
		//returns the exact character indeces where the line breaks occur
		
		var breaks = [];
		
		var i = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				breaks.push (i);
				
			}
			
			i++;
			
		});
		
		return breaks;
		
	}
}