package openfl.text; #if !flash #if (display || openfl_next || js)


import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.opengl.GLTextField;
import openfl._internal.renderer.RenderSession;
import haxe.xml.Fast;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.DivElement;
import js.html.Element;
import js.Browser;
#end

@:access(openfl.display.Graphics)
@:access(openfl.text.TextFormat)


class TextField extends InteractiveObject {
	
	
	@:noCompletion private static var __defaultTextFormat:TextFormat;
	
	public var antiAliasType:AntiAliasType;
	@:isVar public var autoSize (default, set):TextFieldAutoSize;
	@:isVar public var background (default, set):Bool;
	@:isVar public var backgroundColor (default, set):Int;
	@:isVar public var border (default, set):Bool;
	@:isVar public var borderColor (default, set):Int;
	public var bottomScrollV (get, null):Int;
	public var caretIndex:Int;
	public var caretPos (get, null):Int;
	public var defaultTextFormat (get, set):TextFormat;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var htmlText (get, set):String;
	public var length (get, null):Int;
	public var maxChars:Int;
	public var maxScrollH (get, null):Int;
	public var maxScrollV (get, null):Int;
	public var multiline:Bool;
	public var numLines (get, null):Int;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var selectionBeginIndex:Int;
	public var selectionEndIndex:Int;
	public var sharpness:Float;
	public var text (get, set):String;
	public var textColor (get, set):Int;
	public var textHeight (get, null):Float;
	public var textWidth (get, null):Float;
	@:isVar public var type (default, set):TextFieldType;
	@:isVar public var wordWrap (get, set):Bool;
	
	@:noCompletion public var __wrappedText:String;
	
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __height:Float;
	@:noCompletion private var __isHTML:Bool;
	@:noCompletion private var __measuredHeight:Int;
	@:noCompletion private var __measuredWidth:Int;
	@:noCompletion private var __ranges:Array<TextFormatRange>;
	@:noCompletion private var __text:String;
	@:noCompletion private var __textFormat:TextFormat;
	@:noCompletion private var __texture:GLTexture;
	@:noCompletion private var __width:Float;
	
	#if js
	private var __div:DivElement;
	#end
	
	
	public function new () {
		
		super ();
		
		__width = 100;
		__height = 100;
		__text = "";
		__wrappedText = "";
		
		type = TextFieldType.DYNAMIC;
		autoSize = TextFieldAutoSize.NONE;
		displayAsPassword = false;
		embedFonts = false;
		selectable = true;
		borderColor = 0x000000;
		border = false;
		backgroundColor = 0xffffff;
		background = false;
		gridFitType = GridFitType.PIXEL;
		maxChars = 0;
		multiline = false;
		sharpness = 0;
		scrollH = 0;
		scrollV = 1;
		wordWrap = false;
		
		if (__defaultTextFormat == null) {
			
			__defaultTextFormat = new TextFormat ("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
			
		}
		
		__textFormat = __defaultTextFormat.clone ();
		
	}
	
	
	public function appendText (text:String):Void {
		
		this.text += text;
		
	}
	
	
	public function getCharBoundaries (a:Int):Rectangle {
		
		openfl.Lib.notImplemented ("TextField.getCharBoundaries");
		
		return null;
		
	}
	
	
	public function getCharIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getCharIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getLineIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		openfl.Lib.notImplemented ("TextField.getLineMetrics");
		
		return new TextLineMetrics (0, 0, 0, 0, 0, 0);
		
	}
	
	
	public function getLineOffset (lineIndex:Int):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineOffset");
		
		return 0;
		
	}
	
	
	public function getLineText (lineIndex:Int):String {
		
		openfl.Lib.notImplemented ("TextField.getLineText");
		
		return "";
		
	}
	
	
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		openfl.Lib.notImplemented ("TextField.setSelection");
		
	}
	
	
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void {
		
		if (format.font != null) __textFormat.font = format.font;
		if (format.size != null) __textFormat.size = format.size;
		if (format.color != null) __textFormat.color = format.color;
		if (format.bold != null) __textFormat.bold = format.bold;
		if (format.italic != null) __textFormat.italic = format.italic;
		if (format.underline != null) __textFormat.underline = format.underline;
		if (format.url != null) __textFormat.url = format.url;
		if (format.target != null) __textFormat.target = format.target;
		if (format.align != null) __textFormat.align = format.align;
		if (format.leftMargin != null) __textFormat.leftMargin = format.leftMargin;
		if (format.rightMargin != null) __textFormat.rightMargin = format.rightMargin;
		if (format.indent != null) __textFormat.indent = format.indent;
		if (format.leading != null) __textFormat.leading = format.leading;
		if (format.blockIndent != null) __textFormat.blockIndent = format.blockIndent;
		if (format.bullet != null) __textFormat.bullet = format.bullet;
		if (format.kerning != null) __textFormat.kerning = format.kerning;
		if (format.letterSpacing != null) __textFormat.letterSpacing = format.letterSpacing;
		if (format.tabStops != null) __textFormat.tabStops = format.tabStops;
		
		__dirty = true;
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = new Rectangle (0, 0, __width, __height);
		bounds.transform (__worldTransform);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	@:noCompletion private function __getFont (format:TextFormat):String {
		
		var font = format.italic ? "italic " : "normal ";
		font += "normal ";
		font += format.bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.size + format.leading + 4) + "px ";
		
		font += "'" + switch (format.font) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: format.font;
			
		}
		
		font += "'";
		
		return font;
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || (interactiveOnly && !mouseEnabled)) return false;
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __measureText ():Array<Float> {
		
		#if js
		
		if (__ranges == null) {
			
			// HTML5 measureText().width contains full length of string
			// where \n or \r included in the result width like character and we need split text
			// for calculation of width of longest line.
			// http://jsfiddle.net/kpnu9q0t/
			
			if (wordWrap) return [__measureLongestLine(__wrappedText, __textFormat)];
			else return [__measureLongestLine(__text, __textFormat)] ;
			
		} else {
			
			var measurements = [];
			
			for (range in __ranges) {
				
				__context.font = __getFont (range.format);
				measurements.push (__context.measureText (text.substring (range.start, range.end)).width);
				
			}
			
			return measurements;
			
		}
		
		#else
		
		return null;
		
		#end
		
	}
	
	@:noCompletion private function __measureLongestLine(text:String, format:TextFormat):Float
	{
		#if js
		
		var lines = text.split('\n');
		var current = 0.0;
		
		__context.font = __getFont (__textFormat);
		var longest = __context.measureText(lines[0]).width;
		
		for (i in 1...lines.length)
		{
			current = __context.measureText(lines[i]).width;
			
			if (current > longest )
				longest = current;
		}
		
		return longest;
		
		#else
		
		return 0;
		
		#end
	}
	
	@:noCompletion private function __measureTextWithDOM ():Void {
	 	
	 	#if js
	 	
		var div:Element = __div;
		
		if (__div == null) {
			
			div = Browser.document.createElement ("div");
			div.innerHTML = __text;
			div.style.setProperty ("font", __getFont (__textFormat), null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild (div);
			
		}
		
		__measuredWidth = div.clientWidth;
		
		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...
		if (__div == null) {
			
			div.style.width = Std.string (__width) + "px";
			
		}
		
		__measuredHeight = div.clientHeight;
		
		if (__div == null) {
			
			Browser.document.body.removeChild (div);
			
		}
		
		#end
		
	}
	
	@:noCompletion public function __buildWrappedText():String
	{	
		var textLength:Int = __text.length;
		
		if (textLength == 1) return __text;
		
		__wrappedText = '';
		
		#if js
		
		var lineStart:Int = 0;
		var wordStart:Int = 0;
		var lineWidth:Float;
		var str1:String;
		var str2:String;
		var str3:String;
		var e:Int = 0;
		var i:Int = 0;
		var char:String;
		
		if (__ranges == null)
		{
			__context.font = __getFont (__textFormat);
			
			while (true)
			{
				if (i >= __text.length) break;
				
				char = __text.charAt(i);
				
				if (char == "") break;
				
				if (char == '\n' /*|| char == '\r'*/ || char == '\t' || char == ' ' || char == '-')
					wordStart = i + 1;
					
				if (char == '\n' /*|| char == '\r'*/)
						lineStart = i + 1;
				
				str3 = __text.substring(lineStart, i + 1);
				lineWidth = __context.measureText(str3).width;
				
				//make line break
				// CanvasTextField.renderText() is using 2px-left and 2px-right indents for fillText().
				// Therefore here is __width-4
				if (lineWidth >= __width-4 && str3.length > 1)
				{
					if (wordStart == lineStart)
					{
						// cut the word
						__wrappedText += '\n';
						
						lineStart = i ;
						wordStart = lineStart;
						
					}else 
					{	
						str1 = __wrappedText.substring(0, wordStart + e);
						
						if (wordStart > i)		// That means line end is a space-symbol
						{
							__wrappedText = str1 + '\n' + __text.charAt(wordStart);
								
							--e;
							i= wordStart+1;
						}else					// back to word-start and place that word to a new line
						{
						
							str2 = __text.substring(wordStart, i);	// current i-char is out of the text line width, so here just 'i' instead i+1;
								
							__wrappedText = str1 + '\n' + str2;		
						}
						
						lineStart = wordStart ;
					}
					
					e++;
				}else
				{
					__wrappedText += char;
					
					i++;
				}
			}
		}
		else
		{
			
		}
		
		#end
		
		return __wrappedText;
	}
	
	
	@:noCompletion public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTextField.render (this, renderSession);
		
	}
	
	
	@:noCompletion public override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMTextField.render (this, renderSession);
		
	}
	
	
	@:noCompletion public override function __renderGL (renderSession:RenderSession):Void {
		
		GLTextField.render (this, renderSession);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize {
		
		if (value != autoSize) __dirty = true;
		return autoSize = value;
		
	}
	
	
	@:noCompletion private function set_background (value:Bool):Bool {
		
		if (value != background) __dirty = true;
		return background = value;
		
	}
	
	
	@:noCompletion private function set_backgroundColor (value:Int):Int {
		
		if (value != backgroundColor) __dirty = true;
		return backgroundColor = value;
		
	}
	
	
	@:noCompletion private function set_border (value:Bool):Bool {
		
		if (value != border) __dirty = true;
		return border = value;
		
	}
	
	
	@:noCompletion private function set_borderColor (value:Int):Int {
		
		if (value != borderColor) __dirty = true;
		return borderColor = value;
		
	}
	
	
	@:noCompletion private function get_bottomScrollV ():Int {
		
		// TODO: Only return lines that are visible
		
		return numLines;
		
	}
	
	
	@:noCompletion private function get_caretPos ():Int {
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_defaultTextFormat ():TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	@:noCompletion private function set_defaultTextFormat (value:TextFormat):TextFormat {
		
		//__textFormat = __defaultTextFormat.clone ();
		if (__textFormat != value) __dirty = true;
		__textFormat.__merge (value);
		return value;
		
	}
	
	
	@:noCompletion private override function get_height ():Float {
		
		if (autoSize != TextFieldAutoSize.NONE && wordWrap) {
			
			return __height * __scaleY;
			
		} else if (autoSize != TextFieldAutoSize.NONE) {
			
			return (textHeight + 4) * __scaleY;
			
		} else {	
			
			return __height * __scaleY;
			
		}
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		if (value < 0 ) return __height * __scaleY;
		
		if (scaleY != 1 || value != __height) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleY = 1;
		return __height = value;
		
	}
	
	
	@:noCompletion private function get_htmlText ():String {
		
		return __text;
		
		//return mHTMLText;
		
	}
	
	
	@:noCompletion private function set_htmlText (value:String):String {
		
		#if js
		
		if (!__isHTML || __text != value) __dirty = true;
		__ranges = null;
		__isHTML = true;
		
		if (#if dom false && #end __div == null) {
			
			value = new EReg ("<br>", "g").replace (value, "\n");
			value = new EReg ("<br/>", "g").replace (value, "\n");
			
			// crude solution
			
			var segments = value.split ("<font");
			
			if (segments.length == 1) {
				
				value = new EReg ("<.*?>", "g").replace (value, "");
				return __text = value;
				
			} else {
				
				value = "";
				__ranges = [];
				
				// crude search for font
				
				for (segment in segments) {
					
					if (segment == "") continue;
					
					var closeFontIndex = segment.indexOf ("</font>");
					
					if (closeFontIndex > -1) {
						
						var start = segment.indexOf (">") + 1;
						var end = closeFontIndex;
						var format = __textFormat.clone ();
						
						var faceIndex = segment.indexOf ("face=");
						var colorIndex = segment.indexOf ("color=");
						var sizeIndex = segment.indexOf ("size=");
						
						if (faceIndex > -1 && faceIndex < start) {
							
							format.font = segment.substr (faceIndex + 6, segment.indexOf ("\"", faceIndex));
							
						}
						
						if (colorIndex > -1 && colorIndex < start) {
							
							format.color = Std.parseInt ("0x" + segment.substr (colorIndex + 8, 6));
							
						}
						
						if (sizeIndex > -1 && sizeIndex < start) {
							
							format.size = Std.parseInt (segment.substr (sizeIndex + 6, segment.indexOf ("\"", sizeIndex)));
							
						}
						
						var sub = segment.substring (start, end);
						sub = new EReg ("<.*?>", "g").replace (sub, "");
						
						__ranges.push (new TextFormatRange (format, value.length, value.length + sub.length));
						value += sub;
						
						if (closeFontIndex + 7 < segment.length) {
							
							sub = segment.substr (closeFontIndex + 7);
							__ranges.push (new TextFormatRange (__textFormat, value.length, value.length + sub.length));
							value += sub;
							
						}
						
					} else {
						
						__ranges.push (new TextFormatRange (__textFormat, value.length, value.length + segment.length));
						value += segment;
						
					}
					
				}
				
			}
			
		}
		
		#end
		
		return __text = value;
		
	}
	
	
	@:noCompletion private function get_maxScrollH ():Int { return 0; }
	@:noCompletion private function get_maxScrollV ():Int { return 1; }
	
	
	@:noCompletion private function get_numLines ():Int {
		
		if (wordWrap && __wrappedText != "" && __wrappedText != null)
		{
			
			return __wrappedText.split("\n").length;
			
		}else if (text != "" && text != null)
		{
			
			var count = text.split ("\n").length;
			
			if (__isHTML) {
				
				count += text.split ("<br>").length - 1;
				
			}
			
			return count;
		}
		
		return 1;
		
	}
	
	
	@:noCompletion public function get_text ():String {
		
		if (__isHTML) {
			
			
			
		}
		
		return __text;
		
	}
	
	
	@:noCompletion public function set_text (value:String):String {
		
		value = value.split('\r').join('\n');
		
		if (__isHTML || __text != value) __dirty = true;
		__ranges = null;
		__isHTML = false;
		return __text = value;
		
	}
	
	
	@:noCompletion public function get_textColor ():Int { 
		
		return __textFormat.color;
		
	}
	
	
	@:noCompletion public function set_textColor (value:Int):Int {
		
		if (value != __textFormat.color) __dirty = true;
		
		if (__ranges != null) {
			
			for (range in __ranges) {
				
				range.format.color = value;
				
			}
			
		}
		
		return __textFormat.color = value;
		
	}
	
	
	@:noCompletion public function get_textWidth ():Float {
		
		#if js
		
		if (__canvas != null) {
			
			var sizes = __measureText ();
			var total:Float = 0;
			
			for (size in sizes) {
				
				total += size;
				
			}
			
			return total;
			
		} else if (__div != null) {
			
			return __div.clientWidth;
			
		} else {
			
			__measureTextWithDOM ();
			return __measuredWidth;
			
		}
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	@:noCompletion public function get_textHeight ():Float {
		
		#if js
		
		if (__canvas != null) {
			
			// TODO: Make this more accurate
			if (wordWrap && __wrappedText != null && __wrappedText!="") 
				return __wrappedText.split('\n').length * __textFormat.size * 1.185;	
			else if (__text !=null && __text != "")
				return __text.split('\n').length * __textFormat.size * 1.185;
			else return 0;
			
		} else if (__div != null) {
			
			return __div.clientHeight;
			
		} else {
			
			__measureTextWithDOM ();
			
			// Add a litte extra space for descenders...
			return __measuredHeight + __textFormat.size * 0.185;
			
		}
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	@:noCompletion public function set_type (value:TextFieldType):TextFieldType {
		
		//if (value != type) __dirty = true;
		return type = value;
		
	}
	
	
	override public function get_width ():Float {
		
		if (autoSize != TextFieldAutoSize.NONE && wordWrap) {
			
			return __width * scaleX;
			
		} else if (autoSize != TextFieldAutoSize.NONE) {
			
			//return __width * scaleX;
			return (textWidth + 4) * scaleX;
			
		} else {	
			
			return __width * scaleX;
			
		}
		
	}
	
	
	override public function set_width (value:Float):Float {
		
		if (value < 0) return __width * __scaleX;
		
		if (scaleX != 1 || __width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleX = 1;
		return __width = value;
		
	}
	
	
	@:noCompletion public function get_wordWrap ():Bool {
		
		return wordWrap;
		
	}
	
	
	@:noCompletion public function set_wordWrap (value:Bool):Bool {
		
		if (value != wordWrap) __dirty = true;
		return wordWrap = value;
		
	}
	
	@:noCompletion inline private function get_length ():Int {
		
		return __text == null ? 0 : __text.length;
	}
	
}


@:noCompletion @:dox(hide) class TextFormatRange {
	
	
	public var end:Int;
	public var format:TextFormat;
	public var start:Int;
	
	
	public function new (format:TextFormat, start:Int, end:Int) {
		
		this.format = format;
		this.start = start;
		this.end = end;
		
	}
	
	
}


#else
typedef TextField = openfl._v2.text.TextField;
#end
#else
typedef TextField = flash.text.TextField;
#end