package openfl._internal.text;


import haxe.Timer;
import lime.graphics.cairo.CairoFont;
import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextLineMetrics;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.DivElement;
import js.html.InputElement;
import js.html.KeyboardEvent in HTMLKeyboardEvent;
import js.Browser;
#end

@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)


class TextEngine {
	
	
	@:noCompletion private static var __defaultTextFormat:TextFormat;
	
	public var antiAliasType:AntiAliasType;
	public var autoSize:TextFieldAutoSize;
	public var background:Bool;
	public var backgroundColor:Int;
	public var border:Bool;
	public var borderColor:Int;
	public var bounds:Rectangle;
	public var caretIndex:Int;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var height:Float;
	public var maxChars:Int;
	public var multiline:Bool;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var sharpness:Float;
	public var text:String;
	public var type:TextFieldType;
	public var width:Float;
	public var wordWrap:Bool;
	
	private var layout:TextLayout;
	private var textField:TextField;
	
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __dirtyBounds:Bool;
	@:noCompletion private var __cursorPosition:Int;
	@:noCompletion private var __cursorTimer:Timer;
	@:noCompletion private var __hasFocus:Bool;
	@:noCompletion private var __isKeyDown:Bool;
	@:noCompletion private var __isHTML:Bool;
	@:noCompletion private var __measuredHeight:Int;
	@:noCompletion private var __measuredWidth:Int;
	@:noCompletion private var __ranges:Array<TextFormatRange>;
	@:noCompletion private var __selectionStart:Int;
	@:noCompletion private var __showCursor:Bool;
	@:noCompletion private var __textFormat:TextFormat;
	@:noCompletion private var __texture:GLTexture;
	@:noCompletion private var __tileData:Map<Tilesheet, Array<Float>>;
	@:noCompletion private var __tileDataLength:Map<Tilesheet, Int>;
	@:noCompletion private var __tilesheets:Map<Tilesheet, Bool>;
	@:noCompletion public var __cairoFont:CairoFont;
	
	#if (js && html5)
	private var __div:DivElement;
	private var __hiddenInput:InputElement;
	#end
	
	
	public function new (textField:TextField) {
		
		this.textField = textField;
		
		layout = new TextLayout ("", 100, 100);
		
		width = 100;
		height = 100;
		text = "";
		__dirtyBounds = true;
		
		bounds = new Rectangle (0, 0, 0, 0);
		
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
	
	
	public function getBottomScrollV ():Int {
		
		// TODO: Only return lines that are visible
		
		return getNumLines ();
		
	}
	
	
	public function getBounds ():Rectangle {
		
		if (!__dirtyBounds) {
			
			return bounds;
			
		}
		
		if (autoSize != TextFieldAutoSize.NONE) {
			
			bounds.width = (getTextWidth () + 4) + (border ? 1 : 0);
			bounds.height = (getTextHeight () + 4) + (border ? 1 : 0);
			
		} else {
			
			bounds.width = width;
			bounds.height = height;
			
		}
		
		__dirtyBounds = false;
		
		return bounds;
		
	}
	
	
	public function getCaretIndex ():Int {
		
		return __cursorPosition;
		
	}
	
	
	public function getCharBoundaries (a:Int):Rectangle {
		
		openfl.Lib.notImplemented ("TextField.getCharBoundaries");
		
		return null;
		
	}
	
	
	public function getCharIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getCharIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getDefaultTextFormat ():TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	public function getHeight ():Float {
		
		return getBounds ().height;
		
	}
	
	
	public function getHTMLText ():String {
		
		return text;
		
		//return mHTMLText;
		
	}
	
	
	public function getLength ():Int {
		
		if (text != null) {
			
			return text.length;
			
		}
		
		return 0;
		
	}
	
	
	public function getLineIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		updateLayout ();
		
		var lineWidth = layout.lineWidth[lineIndex];
		var ascender = layout.lineAscent[lineIndex];
		var descender = layout.lineDescent[lineIndex];
		var leading = layout.lineLeading[lineIndex];
		var lineHeight = ascender + descender + leading;
		
		var margin = switch (__textFormat.align) {
			
			case LEFT, JUSTIFY: 2;
			case RIGHT: (getWidth () - lineWidth) - 2;
			case CENTER: (getHeight () - lineWidth) / 2;
			
		}
		
		return new TextLineMetrics (margin, lineWidth, lineHeight, ascender, descender, leading); 
		
	}
	
	
	public function getLineOffset (lineIndex:Int):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineOffset");
		
		return 0;
		
	}
	
	
	public function getLineText (lineIndex:Int):String {
		
		openfl.Lib.notImplemented ("TextField.getLineText");
		
		return "";
		
	}
	
	
	public function getMaxScrollH ():Int {
		
		return 0;
		
	}
	
	
	public function getMaxScrollV ():Int {
		
		return 1;
		
	}
	
	
	public function getNumLines ():Int {
		
		if (getText () != "" && getText () != null) {
			
			var count = getText ().split ("\n").length;
			
			if (__isHTML) {
				
				count += getText ().split ("<br>").length - 1;
				
			}
			
			return count;
			
		}
		
		return 1;
		
	}
	
	
	public function getSelectionBeginIndex ():Int {
		
		return Std.int (Math.min (__cursorPosition, __selectionStart));
		
	}
	
	
	public function getSelectionEndIndex ():Int {
		
		return Std.int (Math.max (__cursorPosition, __selectionStart));
		
	}
	
	
	public function getText ():String {
		
		if (__isHTML) {
			
			
			
		}
		
		return text;
		
	}
	
	
	public function getTextColor ():Int {
		
		return __textFormat.color;
		
	}
	
	
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	public function getTextHeight ():Float {
		
		updateLayout ();
		
		var textHeight = 0;
		
		for (ascent in layout.lineAscent) {
			
			textHeight += ascent;
			
		}
		
		for (descent in layout.lineDescent) {
			
			textHeight += descent;
			
		}
		
		for (leading in layout.lineLeading) {
			
			textHeight += leading;
			
		}
		
		return textHeight;
		
	}
	
	
	public function getTextWidth ():Float {
		
		updateLayout ();
		
		var textWidth = 0.0;
		
		for (width in layout.lineWidth) {
			
			if (width > textWidth) {
				
				textWidth = width;
				
			}
			
		}
		
		return textWidth;
		
	}
	
	
	public function getWidth ():Float {
		
		return getBounds ().width;
		
	}
	
	
	public function getWordWrap ():Bool {
		
		return wordWrap;
		
	}
	
	
	public function renderCairo (renderSession:RenderSession):Void {
		
		CairoTextField.render (this, renderSession);
		
	}
	
	
	public function renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTextField.render (this, renderSession);
		
	}
	
	
	public function renderDOM (renderSession:RenderSession):Void {
		
		DOMTextField.render (this, renderSession);
		
	}
	
	
	public function renderGL (renderSession:RenderSession):Void {
		
		#if !disable_cairo_graphics
		
		#if lime_cairo
		CairoTextField.render (this, renderSession);
		#else
		CanvasTextField.render (this, renderSession);
		#end
		
		GLRenderer.renderBitmap (textField, renderSession);
		
		#else
		
		GLTextField.render (this, renderSession);
		
		#end
		
	}
	
	
	public function setAntiAliasType (value:AntiAliasType):AntiAliasType {
		
		if (value != antiAliasType) {
			
			__dirty = true;
			
		}
		
		return antiAliasType = value;
		
	}
	
	
	public function setAutoSize (value:TextFieldAutoSize):TextFieldAutoSize {
		
		if (value != autoSize) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return autoSize = value;
		
	}
	
	
	public function setBackground (value:Bool):Bool {
		
		if (value != background) {
			
			__dirty = true;
			
		}
		
		return background = value;
		
	}
	
	
	public function setBackgroundColor (value:Int):Int {
		
		if (value != backgroundColor) __dirty = true;
		return backgroundColor = value;
		
	}
	
	
	public function setBorder (value:Bool):Bool {
		
		if (value != border) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return border = value;
		
	}
	
	
	public function setBorderColor (value:Int):Int {
		
		if (value != borderColor) __dirty = true;
		return borderColor = value;
		
	}
	
	
	public function setDefaultTextFormat (value:TextFormat):TextFormat {
		
		//__textFormat = __defaultTextFormat.clone ();
		__textFormat.__merge (value);
		return value;
		
	}
	
	
	public function setDisplayAsPassword (value:Bool):Bool {
		
		if (value != displayAsPassword) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return displayAsPassword = value;
		
	}
	
	
	public function setEmbedFonts (value:Bool):Bool {
		
		//if (value != embedFonts) {
			//
			//__dirty = true;
			//__dirtyBounds = true;
			//
		//}
		
		return embedFonts = value;
		
	}
	
	
	public function setGridFitType (value:GridFitType):GridFitType {
		
		//if (value != gridFitType) {
			//
			//__dirty = true;
			//__dirtyBounds = true;
			//
		//}
		
		return gridFitType = value;
		
	}
	
	
	public function setHeight (value:Float):Float {
		
		if (textField.scaleY != 1 || value != height) {
			
			textField.__setTransformDirty ();
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		textField.scaleY = 1;
		return height = value;
		
	}
	
	
	public function setHTMLText (value:String):String {
		
		if (!__isHTML || text != value) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		__ranges = null;
		__isHTML = true;
		
		if (#if (js && html5) #if dom false && #end __div == null #else true #end) {
			
			value = new EReg ("<br>", "g").replace (value, "\n");
			value = new EReg ("<br/>", "g").replace (value, "\n");
			
			// crude solution
			
			var segments = value.split ("<font");
			
			if (segments.length == 1) {
				
				value = new EReg ("<.*?>", "g").replace (value, "");
				#if (js && html5)
				if (text != value && __hiddenInput != null) {
					
					var selectionStart = __hiddenInput.selectionStart;
					var selectionEnd = __hiddenInput.selectionEnd;
					__hiddenInput.value = value;
					__hiddenInput.selectionStart = selectionStart;
					__hiddenInput.selectionEnd = selectionEnd;
					
				}	
				#end
				return text = value;
				
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
		
		#if (js && html5)
		if (text != value && __hiddenInput != null) {
			
			var selectionStart = __hiddenInput.selectionStart;
			var selectionEnd = __hiddenInput.selectionEnd;
			__hiddenInput.value = value;
			__hiddenInput.selectionStart = selectionStart;
			__hiddenInput.selectionEnd = selectionEnd;
			
		}	
		#end
		return text = value;
		
	}
	
	
	public function setMaxChars (value:Int):Int {
		
		if (value != maxChars) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return maxChars = value;
		
	}
	
	
	public function setMultiline (value:Bool):Bool {
		
		if (value != multiline) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return multiline = value;
		
	}
	
	
	public function setRestrict (value:String):String {
		
		if (value != restrict) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		return restrict = value;
		
	}
	
	
	public function setScrollH (value:Int):Int {
		
		//if (value != scrollH) {
			//
			//__dirty = true;
			//__dirtyBounds = true;
			//
		//}
		
		return scrollH = value;
		
	}
	
	
	public function setScrollV (value:Int):Int {
		
		//if (value != scrollV) {
			//
			//__dirty = true;
			//__dirtyBounds = true;
			//
		//}
		
		return scrollV = value;
		
	}
	
	
	public function setSelectable (value:Bool):Bool {
		
		#if (js && html5)
		if (!value && selectable && type == TextFieldType.INPUT) {
			
			this_onRemovedFromStage (null);
			
		}
		#end
		
		return selectable = value;
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		openfl.Lib.notImplemented ("TextField.setSelection");
		
	}
	
	
	public function setSharpness (value:Float):Float {
		
		//if (value != sharpness) {
			//
			//__dirty = true;
			//__dirtyBounds = true;
			//
		//}
		
		return sharpness = value;
		
	}
	
	
	public function setText (value:String):String {
		
		#if (js && html5)
		if (text != value && __hiddenInput != null) {
			
			var selectionStart = __hiddenInput.selectionStart;
			var selectionEnd = __hiddenInput.selectionEnd;
			__hiddenInput.value = value;
			__hiddenInput.selectionStart = selectionStart;
			__hiddenInput.selectionEnd = selectionEnd;
			
		}	
		#end
		
		if (__isHTML || text != value) {
			
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		__ranges = null;
		__isHTML = false;
		
		return text = value;
		
	}
	
	
	public function setTextColor (value:Int):Int {
		
		if (value != __textFormat.color) __dirty = true;
		
		if (__ranges != null) {
			
			for (range in __ranges) {
				
				range.format.color = value;
				
			}
			
		}
		
		return __textFormat.color = value;
		
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
		__dirtyBounds = true;
		
	}
	
	
	public function setType (value:TextFieldType):TextFieldType {
		
		if (value != type) {
			
			#if !dom
			if (value == TextFieldType.INPUT) {
				
				CanvasTextField.enableInputMode (this);
				
			} else {
				
				CanvasTextField.disableInputMode (this);
				
			}
			#end
			
			__dirty = true;
			
		}
		
		return type = value;
		
	}
	
	
	public function setWidth (value:Float):Float {
		
		if (textField.scaleX != 1 || width != value) {
			
			textField.__setTransformDirty ();
			__dirty = true;
			__dirtyBounds = true;
			
		}
		
		textField.scaleX = 1;
		return width = value;
		
	}
	
	
	public function setWordWrap (value:Bool):Bool {
		
		//if (value != wordWrap) __dirty = true;
		return wordWrap = value;
		
	}
	
	
	private function updateLayout ():Void {
		
		// TODO: make automatic
		
		layout.text = text;
		
		if (__ranges != null) {
			
			layout.textFormat = __ranges;
			
		} else {
			
			layout.textFormat = [ new TextFormatRange (__textFormat, 0, text.length) ];
			
		}
		
		layout.update ();
		
	}
	
	
	@:noCompletion private function __getPosition (x:Float, y:Float):Int {
		
		if (x <= 2 || x > width + 4 || y <= 0 || y > width + 4) return 0;
		
		updateLayout ();
		
		var currentY = 0;
		var lineIndex = -1;
		
		for (i in 0...layout.lineAscent.length) {
			
			currentY += layout.lineAscent[i] + layout.lineDescent[i] + layout.lineLeading[i];
			
			if (y < currentY) {
				
				lineIndex = i;
				break;
				
			}
			
		}
		
		if (lineIndex == -1) return 0;
		
		// TODO: handle word wrap
		
		var startIndex = 0;
		var endIndex = text.length;
		
		if (layout.numLines > 1) {
			
			endIndex = layout.lineBreaks[lineIndex];
			
		}
		
		if (lineIndex > 0) {
			
			startIndex = layout.lineBreaks[lineIndex - 1];
			
		}
		
		if (x >= layout.lineWidth[lineIndex]) {
			
			return endIndex;
			
		}
		
		// TODO: keep track of actual positions
		
		var length = endIndex - startIndex;
		return Math.round ((x / layout.lineWidth[lineIndex]) * length) + startIndex;
		
	}
	
	
	@:noCompletion private function __startCursorTimer ():Void {
		
		__cursorTimer = Timer.delay (__startCursorTimer, 500);
		__showCursor = !__showCursor;
		__dirty = true;
		
	}
	
	
	@:noCompletion private function __stopCursorTimer ():Void {
		
		if (__cursorTimer != null) {
			
			__cursorTimer.stop ();
			
		}
		
	}
	
	
	
	// Event Handlers
	
	
	
	
	#if (js && html5)
	@:noCompletion private function input_onKeyUp (event:HTMLKeyboardEvent):Void {
		
		__isKeyDown = false;
		if (event == null) event == untyped Browser.window.event;
		
		text = __hiddenInput.value;
		__ranges = null;
		__isHTML = false;
		
		if (__hiddenInput.selectionDirection == "backward") {
			
			__cursorPosition = __hiddenInput.selectionStart;
			__selectionStart = __hiddenInput.selectionEnd;
			
		} else {
			
			__cursorPosition = __hiddenInput.selectionEnd;
			__selectionStart = __hiddenInput.selectionStart;
			
		}
		
		__dirty = true;
		
		textField.dispatchEvent (new Event (Event.CHANGE, true));
		
	}
	
	
	@:noCompletion private function input_onKeyDown (event:#if (js && html5) HTMLKeyboardEvent #else Dynamic #end):Void {
		
		__isKeyDown = true;
		if (event == null) event == untyped Browser.window.event;
		
		var keyCode = event.which;
		var isShift = event.shiftKey;
		
		//if (keyCode == 65 && (event.ctrlKey || event.metaKey)) { // Command/Ctrl + A
			//
			//__hiddenInput.selectionStart = 0;
			//__hiddenInput.selectionEnd = text.length;
			//event.preventDefault ();
			//__dirty = true;
			//return;
			//
		//}
		//
		//if (keyCode == 17 || event.metaKey || event.ctrlKey) {
			//
			//return;
			//
		//}
		
		text = __hiddenInput.value;
		__ranges = null;
		__isHTML = false;
		
		if (__hiddenInput.selectionDirection == "backward") {
			
			__cursorPosition = __hiddenInput.selectionStart;
			__selectionStart = __hiddenInput.selectionEnd;
			
		} else {
			
			__cursorPosition = __hiddenInput.selectionEnd;
			__selectionStart = __hiddenInput.selectionStart;
			
		}
		
		__dirty = true;
		
	}
	
	
	@:noCompletion private function stage_onMouseMove (event:MouseEvent) {
		
		if (__hasFocus && __selectionStart >= 0) {
			
			var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
			__cursorPosition = __getPosition (localPoint.x, localPoint.y);
			__dirty = true;
			
		}
		
	}
	
	
	@:noCompletion private function stage_onMouseUp (event:MouseEvent):Void {
		
		Lib.current.stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		Lib.current.stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
		if (Lib.current.stage.focus == textField) {
			
			var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
			var upPos:Int = __getPosition (localPoint.x, localPoint.y);
			var leftPos:Int;
			var rightPos:Int;
			
			leftPos = Std.int (Math.min (__selectionStart, upPos));
			rightPos = Std.int (Math.max (__selectionStart, upPos));
			
			__selectionStart = leftPos;
			__cursorPosition = rightPos;
			
			this_onFocusIn (null);
			
		}
		
	}
	
	
	@:noCompletion private function this_onAddedToStage (event:Event):Void {
		
		textField.addEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
		textField.addEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
		
		__hiddenInput.addEventListener ('keydown', input_onKeyDown, true);
		__hiddenInput.addEventListener ('keyup', input_onKeyUp, true);
		__hiddenInput.addEventListener ('input', input_onKeyUp, true);
		
		textField.addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		
		if (Lib.current.stage.focus == textField) {
			
			this_onFocusIn (null);
			
		}
		
	}
	
	
	@:noCompletion private function this_onFocusIn (event:Event):Void {
		
		if (__cursorPosition < 0) {
			
			__cursorPosition = text.length;
			__selectionStart = __cursorPosition;
			
		}
		
		__hiddenInput.focus ();
		__hiddenInput.selectionStart = __selectionStart;
		__hiddenInput.selectionEnd = __cursorPosition;
		
		__stopCursorTimer ();
		__startCursorTimer ();
		
		__hasFocus = true;
		__dirty = true;
		
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	
	
	@:noCompletion private function this_onFocusOut (event:Event):Void {
		
		__cursorPosition = -1;
		__hasFocus = false;
		__stopCursorTimer ();
		if (__hiddenInput != null) __hiddenInput.blur ();
		__dirty = true;
		
	}
	
	
	@:noCompletion private function this_onMouseDown (event:MouseEvent):Void {
		
		if (!selectable) return;
		
		var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
		__selectionStart = __getPosition (localPoint.x, localPoint.y);
		__cursorPosition = __selectionStart;
		
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	
	
	@:noCompletion private function this_onRemovedFromStage (event:Event):Void {
		
		textField.removeEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
		textField.removeEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
		
		this_onFocusOut (null);
		
		if (__hiddenInput != null) __hiddenInput.removeEventListener ('keydown', input_onKeyDown, true);
		if (__hiddenInput != null) __hiddenInput.removeEventListener ('keyup', input_onKeyUp, true);
		if (__hiddenInput != null) __hiddenInput.removeEventListener ('input', input_onKeyUp, true);
		
		textField.removeEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		Lib.current.stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		Lib.current.stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	#end
	
	
}