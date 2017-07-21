package flash.text; #if (!display && flash)


import openfl.display.InteractiveObject;
import openfl.geom.Rectangle;


extern class TextField extends InteractiveObject {
	
	
	public var antiAliasType:AntiAliasType;
	public var autoSize:TextFieldAutoSize;
	public var background:Bool;
	public var backgroundColor:Int;
	public var border:Bool;
	public var borderColor:Int;
	public var bottomScrollV (default, null):Int;
	public var caretIndex (default, null):Int;
	public var defaultTextFormat:TextFormat;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var htmlText:String;
	public var length (default, null):Int;
	public var maxChars:Int;
	public var maxScrollH (default, null):Int;
	public var maxScrollV (default, null):Int;
	public var mouseWheelEnabled:Bool;
	public var multiline:Bool;
	public var numLines (default, null):Int;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var selectionBeginIndex (default, null):Int;
	public var selectionEndIndex:Int;
	public var sharpness:Float;
	public var text:String;
	public var textColor:Int;
	public var textHeight (default, null):Float;
	public var textWidth (default, null):Float;
	public var type:TextFieldType;
	public var wordWrap:Bool;
	
	public function new ();
	public function appendText (text:String):Void;
	public function getCharBoundaries (charIndex:Int):Rectangle;
	public function getCharIndexAtPoint (x:Float, y:Float):Int;
	public function getFirstCharInParagraph (charIndex:Int):Int;
	public function getLineIndexAtPoint (x:Float, y:Float):Int;
	public function getLineIndexOfChar (charIndex:Int):Int;
	public function getLineLength (lineIndex:Int):Int;
	public function getLineMetrics (lineIndex:Int):TextLineMetrics;
	public function getLineOffset (lineIndex:Int):Int;
	public function getLineText (lineIndex:Int):String;
	public function getParagraphLength (charIndex:Int):Int;
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat;
	public function replaceSelectedText (value:String):Void;
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String):Void;
	public function setSelection (beginIndex:Int, endIndex:Int):Void;
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void;
	
	
}


#else
typedef TextField = openfl.text.TextField;
#end