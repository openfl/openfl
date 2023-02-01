package flash.text;

#if flash
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.geom.Rectangle;

extern class TextField extends InteractiveObject
{
	#if flash
	public var alwaysShowSelection:Bool;
	#end
	public var antiAliasType:AntiAliasType;
	public var autoSize:TextFieldAutoSize;
	public var background:Bool;
	public var backgroundColor:Int;
	public var border:Bool;
	public var borderColor:Int;
	public var bottomScrollV(default, never):Int;
	public var caretIndex(default, never):Int;
	#if flash
	public var condenseWhite:Bool;
	#end
	public var defaultTextFormat:TextFormat;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var htmlText:String;
	public var length(default, never):Int;
	public var maxChars:Int;
	public var maxScrollH(default, never):Int;
	public var maxScrollV(default, never):Int;
	public var mouseWheelEnabled:Bool;
	public var multiline:Bool;
	public var numLines(default, never):Int;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var selectionBeginIndex(default, never):Int;
	public var selectionEndIndex:Int;
	public var sharpness:Float;
	#if flash
	public var styleSheet:StyleSheet;
	#end
	public var text:String;
	public var textColor:Int;
	public var textHeight(default, never):Float;
	#if flash
	@:require(flash11) public var textInteractionMode:String;
	#end
	public var textWidth(default, never):Float;
	#if flash
	public var thickness:Float;
	#end
	public var type:TextFieldType;
	#if flash
	public var useRichTextClipboard:Bool;
	#end
	public var wordWrap:Bool;
	public function new();
	public function appendText(text:String):Void;
	public function getCharBoundaries(charIndex:Int):Rectangle;
	public function getCharIndexAtPoint(x:Float, y:Float):Int;
	public function getFirstCharInParagraph(charIndex:Int):Int;
	#if flash
	public function getImageReference(id:String):DisplayObject;
	#end
	public function getLineIndexAtPoint(x:Float, y:Float):Int;
	public function getLineIndexOfChar(charIndex:Int):Int;
	public function getLineLength(lineIndex:Int):Int;
	public function getLineMetrics(lineIndex:Int):TextLineMetrics;
	public function getLineOffset(lineIndex:Int):Int;
	public function getLineText(lineIndex:Int):String;
	public function getParagraphLength(charIndex:Int):Int;
	public function getTextFormat(beginIndex:Int = 0, endIndex:Int = 0):TextFormat;
	#if flash
	@:require(flash10) public static function isFontCompatible(fontName:String, fontStyle:FontStyle):Bool;
	#end
	public function replaceSelectedText(value:String):Void;
	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void;
	public function setSelection(beginIndex:Int, endIndex:Int):Void;
	public function setTextFormat(format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void;
}
#else
typedef TextField = openfl.text.TextField;
#end
