package openfl.text;


import haxe.Timer;
import lime.system.Clipboard;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseCursor;
import lime.utils.Log;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl._internal.swf.SWFLite;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.text.TextEngine;
import openfl._internal.text.TextFormatRange;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Lib;

#if (js && html5)
import js.html.DivElement;
#end

@:access(openfl.display.Graphics)
@:access(openfl.geom.Rectangle)
@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextFormat)


class TextField extends InteractiveObject {
	
	
	private static var __defaultTextFormat:TextFormat;
	private static var __regexAlign = ~/align=("([^"]+)"|'([^']+)')/i;
	private static var __regexColor = ~/color=("#([^"]+)"|'#([^']+)')/i;
	private static var __regexBlockIndent = ~/blockindent=("([^"]+)"|'([^']+)')/i;
	private static var __regexBreakTag = ~/<br\s*\/?>/gi;
	private static var __regexEntities = [ ~/&quot;/g, ~/&apos;/g, ~/&amp;/g, ~/&lt;/g, ~/&gt;/g ];
	private static var __regexFace = ~/face=("([^"]+)"|'([^']+)')/i;
	private static var __regexHTMLTag = ~/<.*?>/g;
	private static var __regexIndent = ~/ indent=("([^"]+)"|'([^']+)')/i;
	private static var __regexLeading = ~/leading=("([^"]+)"|'([^']+)')/i;
	private static var __regexLeftMargin = ~/leftmargin=("([^"]+)"|'([^']+)')/i;
	private static var __regexRightMargin = ~/rightmargin=("([^"]+)"|'([^']+)')/i;
	private static var __regexTabStops = ~/tabstops=("([^"]+)"|'([^']+)')/i;
	private static var __regexSize = ~/size=("([^"]+)"|'([^']+)')/i;
	
	public var antiAliasType (get, set):AntiAliasType;
	public var autoSize (get, set):TextFieldAutoSize;
	public var background (get, set):Bool;
	public var backgroundColor (get, set):Int;
	public var border (get, set):Bool;
	public var borderColor (get, set):Int;
	public var bottomScrollV (get, never):Int;
	public var caretIndex (get, never):Int;
	public var defaultTextFormat (get, set):TextFormat;
	public var displayAsPassword (get, set):Bool;
	public var embedFonts (get, set):Bool;
	public var gridFitType (get, set):GridFitType;
	public var htmlText (get, set):String;
	public var length (get, never):Int;
	public var maxChars (get, set):Int;
	public var maxScrollH (get, never):Int;
	public var maxScrollV (get, never):Int;
	public var mouseWheelEnabled (get, set):Bool;
	public var multiline (get, set):Bool;
	public var numLines (get, never):Int;
	public var restrict (get, set):String;
	public var scrollH (get, set):Int;
	public var scrollV (get, set):Int;
	public var selectable (get, set):Bool;
	public var selectionBeginIndex (get, never):Int;
	public var selectionEndIndex (get, never):Int;
	public var sharpness (get, set):Float;
	public var text (get, set):String;
	public var textColor (get, set):Int;
	public var textHeight (get, never):Float;
	public var textWidth (get, never):Float;
	public var type (get, set):TextFieldType;
	public var wordWrap (get, set):Bool;
	
	private var __bounds:Rectangle;
	private var __caretIndex:Int;
	private var __cursorTimer:Timer;
	private var __dirty:Bool;
	private var __displayAsPassword:Bool;
	private var __inputEnabled:Bool;
	private var __isHTML:Bool;
	private var __layoutDirty:Bool;
	private var __mouseWheelEnabled:Bool;
	private var __offsetX:Float;
	private var __offsetY:Float;
	private var __selectionIndex:Int;
	private var __showCursor:Bool;
	private var __symbol:DynamicTextSymbol;
	private var __text:String;
	private var __textEngine:TextEngine;
	private var __textFormat:TextFormat;
	
	#if (js && html5)
	private var __div:DivElement;
	#end
	
	
	public function new () {
		
		super ();
		
		__caretIndex = -1;
		__displayAsPassword = false;
		__graphics = new Graphics (this);
		__textEngine = new TextEngine (this);
		__layoutDirty = true;
		__offsetX = 0;
		__offsetY = 0;
		__tabEnabled = true;
		__mouseWheelEnabled = true;
		__text = "";
		
		if (__defaultTextFormat == null) {
			
			__defaultTextFormat = new TextFormat ("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
			
		}
		
		__textFormat = __defaultTextFormat.clone ();
		__textEngine.textFormatRanges.push (new TextFormatRange (__textFormat, 0, 0));
		
		addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		
	}
	
	
	public function appendText (text:String):Void {
		
		__text += text;
		__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;
		
		__dirty = true;
		__filterDirty = true;
		__layoutDirty = true;
		
	}
	
	
	public function getCharBoundaries (charIndex:Int):Rectangle {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return null;
		
		__updateLayout ();
		
		for (group in __textEngine.layoutGroups) {
			
			if (charIndex >= group.startIndex && charIndex <= group.endIndex) {
				
				var x = group.offsetX;
				
				for (i in 0...(charIndex - group.startIndex)) {
					
					x += group.advances[i];
					
				}
				
				return new Rectangle (x, group.offsetY, group.advances[charIndex - group.startIndex], group.ascent + group.descent);
				
			}
			
		}
		
		return null;
		
	}
	
	
	public function getCharIndexAtPoint (x:Float, y:Float):Int {
		
		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;
		
		__updateLayout ();
		
		x += scrollH;
		
		for (i in 0...scrollV - 1) {
			
			y += __textEngine.lineHeights[i];
			
		}
		
		for (group in __textEngine.layoutGroups) {
			
			if (y >= group.offsetY && y <= group.offsetY + group.height) {
				
				if (x >= group.offsetX && x <= group.offsetX + group.width) {
					
					var advance = 0.0;
					
					for (i in 0...group.advances.length) {
						
						advance += group.advances[i];
						
						if (x <= group.offsetX + advance) {
							
							return group.startIndex + i;
							
						}
						
					}
					
					return group.endIndex;
					
				}
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function getFirstCharInParagraph (charIndex:Int):Int {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return 0;
		
		var index = __textEngine.getLineBreakIndex ();
		var startIndex = 0;
		
		while (index > -1) {
			
			if (index <= charIndex) {
				
				startIndex = index + 1;
				
			} else if (index > charIndex) {
				
				break;
				
			}
			
			index = __textEngine.getLineBreakIndex (index + 1);
			
		}
		
		return startIndex;
		
	}
	
	
	public function getLineIndexAtPoint (x:Float, y:Float):Int {
		
		__updateLayout ();
		
		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;
		
		for (i in 0...scrollV - 1) {
			
			y += __textEngine.lineHeights[i];
			
		}
		
		for (group in __textEngine.layoutGroups) {
			
			if (y >= group.offsetY && y <= group.offsetY + group.height) {
				
				return group.lineIndex;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function getLineIndexOfChar (charIndex:Int):Int {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return -1;
		
		__updateLayout ();
		
		for (group in __textEngine.layoutGroups) {
			
			if (group.startIndex <= charIndex && group.endIndex >= charIndex) {
				
				return group.lineIndex;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function getLineLength (lineIndex:Int):Int {
		
		__updateLayout ();
		
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return 0;
		
		var startIndex = -1;
		var endIndex = -1;
		
		for (group in __textEngine.layoutGroups) {
			
			if (group.lineIndex == lineIndex) {
				
				if (startIndex == -1) startIndex = group.startIndex;
				
			} else if (group.lineIndex == lineIndex + 1) {
				
				endIndex = group.startIndex;
				break;
				
			}
			
		}
		
		if (endIndex == -1) endIndex = __text.length;
		return endIndex - startIndex;
		
	}
	
	
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		__updateLayout ();
		
		var ascender = __textEngine.lineAscents[lineIndex];
		var descender = __textEngine.lineDescents[lineIndex];
		var leading = __textEngine.lineLeadings[lineIndex];
		var lineHeight = __textEngine.lineHeights[lineIndex];
		var lineWidth = __textEngine.lineWidths[lineIndex];
		
		// TODO: Handle START and END based on language (don't assume LTR)
		
		var margin = switch (__textFormat.align) {
			
			case LEFT, JUSTIFY, START: 2;
			case RIGHT, END: (__textEngine.width - lineWidth) - 2;
			case CENTER: (__textEngine.width - lineWidth) / 2;
			
		}
		
		return new TextLineMetrics (margin, lineWidth, lineHeight, ascender, descender, leading); 
		
	}
	
	
	public function getLineOffset (lineIndex:Int):Int {
		
		__updateLayout ();
		
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;
		
		for (group in __textEngine.layoutGroups) {
			
			if (group.lineIndex == lineIndex) {
				
				return group.startIndex;
				
			}
			
		}
		
		return 0;
		
	}
	
	
	public function getLineText (lineIndex:Int):String {
		
		__updateLayout ();
		
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return null;
		
		var startIndex = -1;
		var endIndex = -1;
		
		for (group in __textEngine.layoutGroups) {
			
			if (group.lineIndex == lineIndex) {
				
				if (startIndex == -1) startIndex = group.startIndex;
				
			} else if (group.lineIndex == lineIndex + 1) {
				
				endIndex = group.startIndex;
				break;
				
			}
			
		}
		
		if (endIndex == -1) endIndex = __text.length;
		
		return __textEngine.text.substring (startIndex, endIndex);
		
	}
	
	
	public function getParagraphLength (charIndex:Int):Int {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return 0;
		
		var startIndex = getFirstCharInParagraph (charIndex);
		var endIndex = __textEngine.getLineBreakIndex (charIndex) + 1;
		
		if (endIndex == 0) endIndex = __text.length;
		return endIndex - startIndex;
		
	}
	
	
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		
		var format = null;
		
		for (group in __textEngine.textFormatRanges) {
			
			if ((group.start <= beginIndex && group.end >= beginIndex) || (group.start <= endIndex && group.end >= endIndex)) {
				
				if (format == null) {
					
					format = group.format.clone ();
					
				} else {
					
					if (group.format.font != format.font) format.font = null;
					if (group.format.size != format.size) format.size = null;
					if (group.format.color != format.color) format.color = null;
					if (group.format.bold != format.bold) format.bold = null;
					if (group.format.italic != format.italic) format.italic = null;
					if (group.format.underline != format.underline) format.underline = null;
					if (group.format.url != format.url) format.url = null;
					if (group.format.target != format.target) format.target = null;
					if (group.format.align != format.align) format.align = null;
					if (group.format.leftMargin != format.leftMargin) format.leftMargin = null;
					if (group.format.rightMargin != format.rightMargin) format.rightMargin = null;
					if (group.format.indent != format.indent) format.indent = null;
					if (group.format.leading != format.leading) format.leading = null;
					if (group.format.blockIndent != format.blockIndent) format.blockIndent = null;
					if (group.format.bullet != format.bullet) format.bullet = null;
					if (group.format.kerning != format.kerning) format.kerning = null;
					if (group.format.letterSpacing != format.letterSpacing) format.letterSpacing = null;
					if (group.format.tabStops != format.tabStops) format.tabStops = null;
					
				}
				
			}
			
		}
		
		return format;
		
	}
	
	
	public function replaceSelectedText (value:String):Void {
		
		if (value == "" && __selectionIndex == __caretIndex) return;
		
		var startIndex = __caretIndex < __selectionIndex ? __caretIndex : __selectionIndex;
		var endIndex = __caretIndex > __selectionIndex ? __caretIndex : __selectionIndex;
		
		replaceText (startIndex, endIndex, value);
		
		var i = startIndex + value.length;
		setSelection(i,i);
		
	}
	
	
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String):Void {
		
		if (endIndex < beginIndex || beginIndex < 0 || endIndex > __text.length || newText == null) return;
		
		__updateText (__text.substring (0, beginIndex) + newText + __text.substring (endIndex));
		
		var offset = newText.length - (endIndex - beginIndex);
		
		var i = 0;
		var range;
		
		while (i < __textEngine.textFormatRanges.length) {
			
			range = __textEngine.textFormatRanges[i];
			
			if (range.start <= beginIndex && range.end >= endIndex) {
				
				range.end += offset;
				i++;
				
			} else if (range.start >= beginIndex && range.end <= endIndex) {
				
				if (i > 0) {
					
					__textEngine.textFormatRanges.splice (i, 1);
					
				} else {
					
					range.start = 0;
					range.end = 0;
					
				}
				
				offset -= (range.end - range.start);
				
			} else if (range.start > beginIndex && range.start <= endIndex) {
				
				range.start += offset;
				i++;
				
			} else {
				
				i++;
				
			}
			
		}
		
		__dirty = true;
		__filterDirty = true;
		__layoutDirty = true;
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		__selectionIndex = beginIndex;
		__caretIndex = endIndex;
		
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
		__filterDirty = true;
		__layoutDirty = true;
		
	}
	
	
	public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		
		__renderTransform.__translateTransformed (__offsetX, __offsetY);
		
	}
	
	
	private function __fromSymbol (swf:SWFLite, symbol:DynamicTextSymbol):Void {
		
		__symbol = symbol;
		
		width = symbol.width;
		height = symbol.height;
		
		__offsetX = symbol.x;
		__offsetY = symbol.y;
		
		multiline = symbol.multiline;
		wordWrap = symbol.wordWrap;
		displayAsPassword = symbol.password;
		
		if (symbol.border) {
			
			border = true;
			background = true;
			
		}
		
		selectable = symbol.selectable;
		
		if (symbol.input) {
			
			type = INPUT;
			
		}
		
		var format = new TextFormat ();
		if (symbol.color != null) format.color = (symbol.color & 0x00FFFFFF);
		format.size = Math.round (symbol.fontHeight / 20);
		
		var font:FontSymbol = cast swf.symbols.get (symbol.fontID);
		
		if (font != null) {
			
			// TODO: Bold and italic are handled in the font already
			// Setting this can cause "extra" bold in HTML5
			
			//format.bold = font.bold;
			//format.italic = font.italic;
			//format.leading = Std.int (font.leading / 20 + (format.size * 0.2) #if flash + 2 #end);
			//embedFonts = true;
			
		}
		
		format.font = symbol.fontName;
		
		var found = false;
		
		switch (format.font) {
			
			case "_sans", "_serif", "_typewriter", "", null:
				
				found = true;
			
			default:
				
				for (font in Font.enumerateFonts ()) {
					
					if (font.fontName == format.font) {
						
						found = true;
						break;
						
					}
					
				}
			
		}
		
		if (found) {
			
			embedFonts = true;
			
		} else {
			
			Log.warn ("Could not find required font \"" + format.font + "\", it has not been embedded");
			
		}
		
		if (symbol.align != null) {
			
			if (symbol.align == "center") format.align = TextFormatAlign.CENTER;
			else if (symbol.align == "right") format.align = TextFormatAlign.RIGHT;
			else if (symbol.align == "justify") format.align = TextFormatAlign.JUSTIFY;
			
			format.leftMargin = Std.int (symbol.leftMargin / 20);
			format.rightMargin = Std.int (symbol.rightMargin / 20);
			format.indent = Std.int (symbol.indent / 20);
			format.leading = Std.int (symbol.leading / 20);
			
			if (embedFonts) format.leading += 4; // TODO: Why is this necessary?
			
		}
		
		defaultTextFormat = format;
		
		if (symbol.text != null) {
			
			if (symbol.html) {
				
				htmlText = symbol.text;
				
			} else {
				
				text = symbol.text;
				
			}
			
		}
		
		//autoSize = (tag.autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		
	}
	
	
	private function __getAttributeMatch (regex:EReg):String {
		
		return regex.matched (2) != null ? regex.matched (2) : regex.matched (3);
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		__updateLayout ();
		
		var bounds = Rectangle.__temp;
		bounds.copyFrom (__textEngine.bounds);
		bounds.x += __offsetX;
		bounds.y += __offsetY;
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private override function __getCursor ():MouseCursor {
		
		return __textEngine.selectable ? TEXT : null;
		
	}
	
	
	private function __getPosition (x:Float, y:Float):Int {
		
		__updateLayout ();
		
		x += scrollH;
		
		for (i in 0...scrollV - 1) {
			
			y += __textEngine.lineHeights[i];
			
		}
		
		if (y > __textEngine.textHeight) y = __textEngine.textHeight;
		
		var firstGroup = true;
		var group, nextGroup;
		
		for (i in 0...__textEngine.layoutGroups.length) {
			
			group = __textEngine.layoutGroups[i];
			
			if (i < __textEngine.layoutGroups.length - 1) {
				
				nextGroup = __textEngine.layoutGroups[i + 1];
				
			} else {
				
				nextGroup = null;
				
			}
			
			if (firstGroup) {
				
				if (y < group.offsetY) y = group.offsetY;
				if (x < group.offsetX) x = group.offsetX;
				firstGroup = false;
				
			}
			
			if ((y >= group.offsetY && y <= group.offsetY + group.height) || nextGroup == null) {
				
				if ((x >= group.offsetX && x <= group.offsetX + group.width) || (nextGroup == null || nextGroup.lineIndex != group.lineIndex)) {
					
					var advance = 0.0;
					
					for (i in 0...group.advances.length) {
						
						advance += group.advances[i];
						
						if (x <= group.offsetX + advance) {
							
							if (x <= group.offsetX + (advance - group.advances[i]) + (group.advances[i] / 2)) {
								
								return group.startIndex + i;
								
							} else {
								
								return (group.startIndex + i < group.endIndex) ? group.startIndex + i + 1 : group.endIndex;
								
							}
							
						}
						
					}
					
					return group.endIndex;
					
				}
				
			}
			
		}
		
		return __text.length;
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		__updateLayout ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (__textEngine.bounds.contains (px, py)) {
			
			if (stack != null) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		__getRenderTransform ();
		__updateLayout ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (__textEngine.bounds.contains (px, py)) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		CairoTextField.render (this, renderSession, __worldTransform);
		super.__renderCairo (renderSession);
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTextField.render (this, renderSession, __worldTransform);
		
		if (__textEngine.antiAliasType == ADVANCED && __textEngine.gridFitType == PIXEL) {
			
			var smoothingEnabled = untyped (renderSession.context).imageSmoothingEnabled;
			
			if (smoothingEnabled) {
				
				untyped (renderSession.context).mozImageSmoothingEnabled = false;
				//untyped (renderSession.context).webkitImageSmoothingEnabled = false;
				untyped (renderSession.context).msImageSmoothingEnabled = false;
				untyped (renderSession.context).imageSmoothingEnabled = false;
				
			}
			
			super.__renderCanvas (renderSession);
			
			if (smoothingEnabled) {
				
				untyped (renderSession.context).mozImageSmoothingEnabled = true;
				//untyped (renderSession.context).webkitImageSmoothingEnabled = true;
				untyped (renderSession.context).msImageSmoothingEnabled = true;
				untyped (renderSession.context).imageSmoothingEnabled = true;
				
			}
			
		} else {
			
			super.__renderCanvas (renderSession);
			
		}
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMTextField.render (this, renderSession);
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		#if (js && html5)
		CanvasTextField.render (this, renderSession, __worldTransform);
		#elseif lime_cairo
		CairoTextField.render (this, renderSession, __worldTransform);
		#end
		
		super.__renderGL (renderSession);
		
	}
	
	
	private function __startCursorTimer ():Void {
		
		__cursorTimer = Timer.delay (__startCursorTimer, 600);
		__showCursor = !__showCursor;
		__dirty = true;
		
	}
	
	
	private function __startTextInput ():Void {
		
		if (__caretIndex < 0) {
			
			__caretIndex = __text.length;
			__selectionIndex = __caretIndex;
			
		}
		
		if (stage != null) {
			
			#if !dom
			
			stage.window.enableTextEvents = true;
			
			if (!__inputEnabled) {
				
				stage.window.enableTextEvents = true;
				
				if (!stage.window.onTextInput.has (window_onTextInput)) {
					
					stage.window.onTextInput.add (window_onTextInput);
					stage.window.onKeyDown.add (window_onKeyDown);
					
				}
				
				__inputEnabled = true;
				__startCursorTimer ();
				
			}
			
			#end
			
		}
		
	}
	
	
	private function __stopCursorTimer ():Void {
		
		if (__cursorTimer != null) {
			
			__cursorTimer.stop ();
			__cursorTimer = null;
			
		}
		
		if (__showCursor) {
			
			__showCursor = false;
			__dirty = true;
			
		}
		
	}
	
	
	private function __stopTextInput ():Void {
		
		#if !dom
		
		if (__inputEnabled && stage != null) {
			
			stage.window.enableTextEvents = false;
			stage.window.onTextInput.remove (window_onTextInput);
			stage.window.onKeyDown.remove (window_onKeyDown);
			
			__inputEnabled = false;
			__stopCursorTimer ();
			
		}
		
		#end
		
	}
	
	
	private function __updateLayout ():Void {
		
		if (__layoutDirty) {
			
			var cacheWidth = __textEngine.width;
			var cacheHeight = __textEngine.height;
			
			__textEngine.update ();
			
			if (__textEngine.autoSize != NONE) {
				
				if (__textEngine.width != cacheWidth) {
					
					switch (__textEngine.autoSize) {
						
						case RIGHT:
							
							x += cacheWidth - __textEngine.width;
						
						case CENTER:
							
							x += (cacheWidth - __textEngine.width) / 2;
						
						default:
							
						
					}
					
					
				}
				
				__textEngine.getBounds ();
				
			}
			
			__layoutDirty = false;
			
		}
		
	}
	
	
	private function __updateText (value:String):Void {
		
		__text = value;
		
		if (__text.length < __caretIndex) {
			
			__selectionIndex = __caretIndex = __text.length;
			
		}
		
		if (!__displayAsPassword #if (js && html5 && dom) || true #end) {
			
			__textEngine.text = __text;
			
		} else {
			
			var length = text.length;
			var mask = "";
			
			for (i in 0...length) {
				
				mask += "*";
				
			}
			
			__textEngine.text = mask;
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_antiAliasType ():AntiAliasType {
		
		return __textEngine.antiAliasType;
		
	}
	
	
	private function set_antiAliasType (value:AntiAliasType):AntiAliasType {
		
		if (value != __textEngine.antiAliasType) {
			
			//__dirty = true;
			
		}
		
		return __textEngine.antiAliasType = value;
		
	}
	
	
	private function get_autoSize ():TextFieldAutoSize {
		
		return __textEngine.autoSize;
		
	}
	
	
	private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize {
		
		if (value != __textEngine.autoSize) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.autoSize = value;
		
	}
	
	
	private function get_background ():Bool {
		
		return __textEngine.background;
		
	}
	
	
	private function set_background (value:Bool):Bool {
		
		if (value != __textEngine.background) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.background = value;
		
	}
	
	
	private function get_backgroundColor ():Int {
		
		return __textEngine.backgroundColor;
		
	}
	
	
	private function set_backgroundColor (value:Int):Int {
		
		if (value != __textEngine.backgroundColor) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.backgroundColor = value;
		
	}
	
	
	private function get_border ():Bool {
		
		return __textEngine.border;
		
	}
	
	
	private function set_border (value:Bool):Bool {
		
		if (value != __textEngine.border) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.border = value;
		
	}
	
	
	private function get_borderColor ():Int {
		
		return __textEngine.borderColor;
		
	}
	
	
	private function set_borderColor (value:Int):Int {
		
		if (value != __textEngine.borderColor) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.borderColor = value;
		
	}
	
	
	private function get_bottomScrollV ():Int {
		
		__updateLayout ();
		
		return __textEngine.bottomScrollV;
		
	}
	
	
	private function get_caretIndex ():Int {
		
		return __caretIndex;
		
	}
	
	
	private function get_defaultTextFormat ():TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	private function set_defaultTextFormat (value:TextFormat):TextFormat {
		
		__textFormat.__merge (value);
		
		__layoutDirty = true;
		__dirty = true;
		__filterDirty = true;

		return value;
		
	}
	
	
	private function get_displayAsPassword ():Bool {
		
		return __displayAsPassword;
		
	}
	
	
	private function set_displayAsPassword (value:Bool):Bool {
		
		if (value != __displayAsPassword) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
			__displayAsPassword = value;
			__updateText (__text);
			
		}
		
		return value;
		
	}
	
	
	private function get_embedFonts ():Bool {
		
		return __textEngine.embedFonts;
		
	}
	
	
	private function set_embedFonts (value:Bool):Bool {
		
		//if (value != __textEngine.embedFonts) {
			//
			//__dirty = true;
			//__layoutDirty = true;
			//
		//}
		
		return __textEngine.embedFonts = value;
		
	}
	
	
	private function get_gridFitType ():GridFitType {
		
		return __textEngine.gridFitType;
		
	}
	
	
	private function set_gridFitType (value:GridFitType):GridFitType {
		
		//if (value != __textEngine.gridFitType) {
			//
			//__dirty = true;
			//__layoutDirty = true;
			//
		//}
		
		return __textEngine.gridFitType = value;
		
	}
	
	
	private override function get_height ():Float {
		
		__updateLayout ();
		return __textEngine.height * Math.abs (scaleY);
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (value != __textEngine.height) {
			
			__setTransformDirty ();
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
			__textEngine.height = value;
			
		}
		
		return __textEngine.height * Math.abs (scaleY);
		
	}
	
	
	private function get_htmlText ():String {
		
		return __text;
		
	}
	
	
	private function set_htmlText (value:String):String {
		
		if (!__isHTML || __text != value) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		}
		
		__isHTML = true;
		
		if (#if (js && html5) #if dom false && #end __div == null #else true #end) {
			
			value = __regexBreakTag.replace (value, "\n");
			value = __regexEntities[0].replace (value, "\"");
			value = __regexEntities[1].replace (value, "'");
			value = __regexEntities[2].replace (value, "&");
			
			// crude solution
			
			var segments = value.split ("<");
			
			if (segments.length == 1) {
				
				value = __regexHTMLTag.replace (value, "");
				
				if (__textEngine.textFormatRanges.length > 1) {
					
					__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
					
				}
				
				value = __regexEntities[3].replace (value, "<");
				value = __regexEntities[4].replace (value, ">");
				
				var range = __textEngine.textFormatRanges[0];
				range.format = __textFormat;
				range.start = 0;
				range.end = value.length;
				
				__updateText (value);
				
				return value;
				
			} else {
				
				__textEngine.textFormatRanges.splice (0, __textEngine.textFormatRanges.length);
				
				value = "";
				var segment;
				
				for (i in 0...segments.length) {
					
					segment = segments[i];
					segment = __regexEntities[3].replace (segment, "<");
					segment = __regexEntities[4].replace (segment, ">");
					segments[i] = segment;
					
				}
				
				var formatStack = [ __textFormat.clone () ];
				var sub:String;
				var noLineBreak = false;
				
				for (segment in segments) {
					
					if (segment == "") continue;
					
					var isClosingTag = segment.substr (0, 1) == "/";
					var tagEndIndex = segment.indexOf (">");
					var start = tagEndIndex + 1;
					var spaceIndex = segment.indexOf (" ");
					var tagName = segment.substring (isClosingTag ? 1 : 0, spaceIndex > -1 && spaceIndex < tagEndIndex ? spaceIndex : tagEndIndex);
					var format:TextFormat;
					
					if (isClosingTag) {
						
						formatStack.pop ();
						format = formatStack[formatStack.length - 1].clone ();
						
						if (tagName.toLowerCase () == "p" && __textEngine.textFormatRanges.length > 0) {
							
							value += "\n";
							noLineBreak = true;
							
						}
						
						if (start < segment.length) {
							
							sub = segment.substr (start);
							__textEngine.textFormatRanges.push (new TextFormatRange (format, value.length, value.length + sub.length));
							value += sub;
							noLineBreak = false;
							
						}
						
					} else {
						
						format = formatStack[formatStack.length - 1].clone ();
						
						if (tagEndIndex > -1) {
							
							switch (tagName.toLowerCase ()) {
								
								case "p":
									
									if (__textEngine.textFormatRanges.length > 0 && !noLineBreak) {
										
										value += "\n";
										
									}
									
									if (__regexAlign.match (segment)) {
										
										format.align = __getAttributeMatch (__regexAlign).toLowerCase ();
										
									}
								
								case "font":
									
									if (__regexFace.match (segment)) {
										
										format.font = __getAttributeMatch (__regexFace);
										
									}
									
									if (__regexColor.match (segment)) {
										
										format.color = Std.parseInt ("0x" + __getAttributeMatch (__regexColor));
										
									}
									
									if (__regexSize.match (segment)) {
										
										var sizeAttr = __getAttributeMatch (__regexSize);
										var firstChar = sizeAttr.charCodeAt (0);
										
										if (firstChar == "+".code || firstChar == "-".code) {
											
											var parentFormat = (formatStack.length >= 2) ? formatStack[formatStack.length - 2] : __textFormat;
											format.size = parentFormat.size + Std.parseInt (sizeAttr);
											
										} else {
											
											format.size = Std.parseInt (sizeAttr);
											
										}
										
									}
								
								case "b":
									
									format.bold = true;
								
								case "u":
									
									format.underline = true;
								
								case "i", "em":
									
									format.italic = true;
								
								case "textformat":
									
									if (__regexBlockIndent.match (segment)) {
										
										format.blockIndent = Std.parseInt (__getAttributeMatch (__regexBlockIndent));
										
									}
									
									if (__regexIndent.match (segment)) {
										
										format.indent = Std.parseInt (__getAttributeMatch (__regexIndent));
										
									}
									
									if (__regexLeading.match (segment)) {
										
										format.leading = Std.parseInt (__getAttributeMatch (__regexLeading));
										
									}
									
									if (__regexLeftMargin.match (segment)) {
										
										format.leftMargin = Std.parseInt (__getAttributeMatch (__regexLeftMargin));
										
									}
									
									if (__regexRightMargin.match (segment)) {
										
										format.rightMargin = Std.parseInt (__getAttributeMatch (__regexRightMargin));
										
									}
									
									if (__regexTabStops.match (segment)) {
										
										var values = __getAttributeMatch (__regexTabStops).split (" ");
										var tabStops = [];
										
										for (stop in values) {
											
											tabStops.push (Std.parseInt (stop));
											
										}
										
										format.tabStops = tabStops;
										
									}
								
							}
							
							formatStack.push (format);
							
							if (start < segment.length) {
								
								sub = segment.substring (start);
								__textEngine.textFormatRanges.push (new TextFormatRange (format, value.length, value.length + sub.length));
								value += sub;
								noLineBreak = false;
								
							}
							
						} else {
							
							__textEngine.textFormatRanges.push (new TextFormatRange (format, value.length, value.length + segment.length));
							value += segment;
							noLineBreak = false;
							
						}
						
					}
					
				}
				
				if (__textEngine.textFormatRanges.length == 0) {
					
					__textEngine.textFormatRanges.push (new TextFormatRange (formatStack[0], 0, 0));
					
				}
				
			}
			
		}
		
		__updateText (value);
		
		return value;
		
	}
	
	
	private function get_length ():Int {
		
		if (__text != null) {
			
			return __text.length;
			
		}
		
		return 0;
		
	}
	
	
	private function get_maxChars ():Int {
		
		return __textEngine.maxChars;
		
	}
	
	
	private function set_maxChars (value:Int):Int {
		
		if (value != __textEngine.maxChars) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.maxChars = value;
		
	}
	
	
	private function get_maxScrollH ():Int { 
		
		__updateLayout ();
		
		return __textEngine.maxScrollH;
		
	}
	
	
	private function get_maxScrollV ():Int { 
		
		__updateLayout ();
		
		return __textEngine.maxScrollV;
		
	}
	
	
	private function get_mouseWheelEnabled ():Bool {
		
		return __mouseWheelEnabled;
		
	}
	
	
	private function set_mouseWheelEnabled (value:Bool):Bool {
		
		return __mouseWheelEnabled = value;
		
	}
	
	
	private function get_multiline ():Bool {
		
		return __textEngine.multiline;
		
	}
	
	
	private function set_multiline (value:Bool):Bool {
		
		if (value != __textEngine.multiline) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.multiline = value;
		
	}
	
	
	private function get_numLines ():Int {
		
		__updateLayout ();
		
		return __textEngine.numLines;
		
	}
	
	
	private function get_restrict ():String {
		
		return __textEngine.restrict;
		
	}
	
	
	private function set_restrict (value:String):String {
		
		return __textEngine.restrict = value;
		
	}
	
	
	private function get_scrollH ():Int {
		
		return __textEngine.scrollH;
		
	}
	
	
	private function set_scrollH (value:Int):Int {
		
		__updateLayout ();
		
		if (value > __textEngine.maxScrollH) value = __textEngine.maxScrollH;
		if (value < 0) value = 0;
		
		if (value != __textEngine.scrollH) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.scrollH = value;
		
	}
	
	
	private function get_scrollV ():Int {
		
		return __textEngine.scrollV;
		
	}
	
	
	private function set_scrollV (value:Int):Int {
		
		__updateLayout ();
		
		if (value > __textEngine.maxScrollV) value = __textEngine.maxScrollV;
		if (value < 1) value = 1;
		
		if (value != __textEngine.scrollV) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.scrollV = value;
		
	}
	
	
	private function get_selectable ():Bool {
		
		return __textEngine.selectable;
		
	}
	
	
	private function set_selectable (value:Bool):Bool {
		
		if (value != __textEngine.selectable && type == INPUT) {
			
			if (stage != null && stage.focus == this) {
				
				__startTextInput ();
				
			} else if (!value) {
				
				__stopTextInput ();
				
			}
			
		}
		
		return __textEngine.selectable = value;
		
	}
	
	
	private function get_selectionBeginIndex ():Int {
		
		return Std.int (Math.min (__caretIndex, __selectionIndex));
		
	}
	
	
	private function get_selectionEndIndex ():Int {
		
		return Std.int (Math.max (__caretIndex, __selectionIndex));
		
	}
	
	
	private function get_sharpness ():Float {
		
		return __textEngine.sharpness;
		
	}
	
	
	private function set_sharpness (value:Float):Float {
		
		if (value != __textEngine.sharpness) {
			
			__dirty = true;
			__filterDirty = true;

		}
		
		return __textEngine.sharpness = value;
		
	}
	
	
	private function get_text ():String {
		
		return __text;
		
	}
	
	
	private function set_text (value:String):String {
		
		if (__isHTML || __text != value) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		} else {
			
			return value;
			
		}
		
		if (__textEngine.textFormatRanges.length > 1) {
			
			__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
			
		}
		
		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = value.length;
		
		__isHTML = false;
		
		__updateText (value);
		
		return value;
		
	}
	
	
	private function get_textColor ():Int { 
		
		return __textFormat.color;
		
	}
	
	
	private function set_textColor (value:Int):Int {
		
		if (value != __textFormat.color) {
			__dirty = true;
			__filterDirty = true;
		}
		
		for (range in __textEngine.textFormatRanges) {
			
			range.format.color = value;
			
		}
		
		return __textFormat.color = value;
		
	}
	
	private function get_textWidth ():Float {
		
		__updateLayout ();
		return __textEngine.textWidth;
		
	}
	
	
	private function get_textHeight ():Float {
		
		__updateLayout ();
		return __textEngine.textHeight;
		
	}
	
	
	private function get_type ():TextFieldType {
		
		return __textEngine.type;
		
	}
	
	
	private function set_type (value:TextFieldType):TextFieldType {
		
		if (value != __textEngine.type) {
			
			if (value == TextFieldType.INPUT) {
				
				addEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
				addEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
				addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
				
				this_onFocusIn (null);
				
			} else {
				
				removeEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
				removeEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
				removeEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
				
				__stopTextInput ();
				
			}
			
			__dirty = true;
			__filterDirty = true;
			
		}
		
		return __textEngine.type = value;
		
	}
	
	
	override private function get_width ():Float {
		
		__updateLayout ();
		return __textEngine.width * Math.abs (scaleX);
		
	}
	
	
	override private function set_width (value:Float):Float {
		
		if (value != __textEngine.width) {
			
			__setTransformDirty ();
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
			__textEngine.width = value;
			
		}
		
		return __textEngine.width * Math.abs (scaleX);
		
	}
	
	
	private function get_wordWrap ():Bool {
		
		return __textEngine.wordWrap;
		
	}
	
	
	private function set_wordWrap (value:Bool):Bool {
		
		if (value != __textEngine.wordWrap) {
			
			__dirty = true;
			__filterDirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.wordWrap = value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onMouseMove (event:MouseEvent) {
		
		if (stage == null) return;
		
		if (__textEngine.selectable && __selectionIndex >= 0) {
			
			__updateLayout ();
			
			var position = __getPosition (mouseX, mouseY);
			
			if (position != __caretIndex) {
				
				__caretIndex = position;
				__dirty = true;
				
			}
			
		}
		
	}
	
	
	private function stage_onMouseUp (event:MouseEvent):Void {
		
		if (stage == null) return;
		
		stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
		if (stage.focus == this) {
			
			__getWorldTransform ();
			__updateLayout ();
			
			var px = __worldTransform.__transformInverseX (x, y);
			var py = __worldTransform.__transformInverseY (x, y);
			
			var upPos:Int = __getPosition (mouseX, mouseY);
			var leftPos:Int;
			var rightPos:Int;
			
			leftPos = Std.int (Math.min (__selectionIndex, upPos));
			rightPos = Std.int (Math.max (__selectionIndex, upPos));
			
			__selectionIndex = leftPos;
			__caretIndex = rightPos;
			
			if (__inputEnabled) {
				
				this_onFocusIn (null);
				
				__stopCursorTimer ();
				__startCursorTimer ();
				
			}
			
		}
		
	}
	
	
	private function this_onAddedToStage (event:Event):Void {
		
		this_onFocusIn (null);
		
	}
	
	
	private function this_onFocusIn (event:FocusEvent):Void {
		
		if (selectable && type == INPUT && stage != null && stage.focus == this) {
			
			__startTextInput ();
			
		}
		
	}
	
	
	private function this_onFocusOut (event:FocusEvent):Void {
		
		__stopTextInput ();
		
	}
	
	
	private function this_onMouseDown (event:MouseEvent):Void {
		
		if (!selectable) return;
		
		__updateLayout ();
		
		__caretIndex = __getPosition (mouseX, mouseY);
		__selectionIndex = __caretIndex;
		__dirty = true;
		
		stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	
	
	private function window_onKeyDown (key:KeyCode, modifier:KeyModifier):Void {
		
		switch (key) {
			
			case RETURN, NUMPAD_ENTER:

				replaceSelectedText ("\n");
				dispatchEvent (new Event (Event.CHANGE, true));

			case BACKSPACE:
				
				if (__selectionIndex == __caretIndex && __caretIndex > 0) {
					
					__selectionIndex = __caretIndex - 1;
					
				}
				
				if (__selectionIndex != __caretIndex) {
					
					replaceSelectedText ("");
					__selectionIndex = __caretIndex;
					
					dispatchEvent (new Event (Event.CHANGE, true));
					
				}
			
			case DELETE:
				
				if (__selectionIndex == __caretIndex && __caretIndex < __text.length) {
					
					__selectionIndex = __caretIndex + 1;
					
				}
				
				if (__selectionIndex != __caretIndex) {
					
					replaceSelectedText ("");
					__selectionIndex = __caretIndex;
					
					dispatchEvent (new Event (Event.CHANGE, true));
					
				}
			
			case LEFT:
				
				if (modifier.shiftKey) {
					
					if (__caretIndex > 0) {
						
						__caretIndex--;
						
					}
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						if (__caretIndex > 0) {
							
							__caretIndex--;
							
						}
						
					} else {
						
						__caretIndex = Std.int (Math.min (__caretIndex, __selectionIndex));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case RIGHT:
				
				if (modifier.shiftKey) {
					
					if (__caretIndex < __text.length) {
						
						__caretIndex++;
						
					}
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						if (__caretIndex < __text.length) {
							
							__caretIndex++;
							
						}
						
					} else {
						
						__caretIndex = Std.int (Math.max (__caretIndex, __selectionIndex));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case C:
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || #end modifier.ctrlKey) {
					
					Clipboard.text = __text.substring (__caretIndex, __selectionIndex);
					
				}
			
			case X:
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || #end modifier.ctrlKey) {
					
					Clipboard.text = __text.substring (__caretIndex, __selectionIndex);
					
					if (__caretIndex != __selectionIndex) {
						
						replaceSelectedText ("");
						dispatchEvent (new Event (Event.CHANGE, true));
						
					}
					
				}
			
			#if !js
			case V:
				
				if (#if mac modifier.metaKey #else modifier.ctrlKey #end) {
					
					var text = Clipboard.text;
					
					if (text != null) {
						
						replaceSelectedText (text);
						
					} else {
						
						replaceSelectedText ("");
						
					}
					
					dispatchEvent (new Event (Event.CHANGE, true));
					
				} else {
					
					__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;
					
				}
			#end
			
			case A:
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || #end modifier.ctrlKey) {
					
					__caretIndex = __text.length;
					__selectionIndex = 0;
					
				}
			
			default:
			
		}
		
	}
	
	
	private function window_onTextInput (value:String):Void {
		
		replaceSelectedText (value);
		
		dispatchEvent (new Event (Event.CHANGE, true));
		
	}
	
	
}
