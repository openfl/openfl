package openfl.text;


import haxe.Timer;
import lime.system.Clipboard;
import lime.text.UTF8String;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseCursor;
import lime.utils.Log;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl._internal.swf.SWFLite;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.text.HTMLParser;
import openfl._internal.text.TextEngine;
import openfl._internal.text.TextFormatRange;
import openfl._internal.text.TextLayoutGroup;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.display.IShaderDrawable;
import openfl.display.Shader;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.filters.GlowFilter;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.ui.Keyboard;
import openfl.Lib;

#if (js && html5)
import js.html.DivElement;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)
@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextFormat)


class TextField extends InteractiveObject implements IShaderDrawable {
	
	
	private static var __defaultTextFormat:TextFormat;
	private static var __missingFontWarning = new Map<String, Bool> ();
	
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
	public var htmlText (get, set):UTF8String;
	public var length (get, never):Int;
	public var maxChars (get, set):Int;
	public var maxScrollH (get, never):Int;
	public var maxScrollV (get, never):Int;
	public var mouseWheelEnabled (get, set):Bool;
	public var multiline (get, set):Bool;
	public var numLines (get, never):Int;
	public var restrict (get, set):UTF8String;
	public var scrollH (get, set):Int;
	public var scrollV (get, set):Int;
	public var selectable (get, set):Bool;
	public var selectionBeginIndex (get, never):Int;
	public var selectionEndIndex (get, never):Int;
	@:beta public var shader:Shader;
	public var sharpness (get, set):Float;
	public var text (get, set):UTF8String;
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
	private var __text:UTF8String;
	private var __htmlText:UTF8String;
	private var __textEngine:TextEngine;
	private var __textFormat:TextFormat;
	
	#if (js && html5)
	private var __div:DivElement;
	private var __renderedOnCanvasWhileOnDOM:Bool = false;
	private var __rawHtmlText:String;
	private var __forceCachedBitmapUpdate:Bool = false;
	#end
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (TextField.prototype, {
			"antiAliasType": { get: untyped __js__ ("function () { return this.get_antiAliasType (); }"), set: untyped __js__ ("function (v) { return this.set_antiAliasType (v); }") },
			"autoSize": { get: untyped __js__ ("function () { return this.get_autoSize (); }"), set: untyped __js__ ("function (v) { return this.set_autoSize (v); }") },
			"background": { get: untyped __js__ ("function () { return this.get_background (); }"), set: untyped __js__ ("function (v) { return this.set_background (v); }") },
			"backgroundColor": { get: untyped __js__ ("function () { return this.get_backgroundColor (); }"), set: untyped __js__ ("function (v) { return this.set_backgroundColor (v); }") },
			"border": { get: untyped __js__ ("function () { return this.get_border (); }"), set: untyped __js__ ("function (v) { return this.set_border (v); }") },
			"borderColor": { get: untyped __js__ ("function () { return this.get_borderColor (); }"), set: untyped __js__ ("function (v) { return this.set_borderColor (v); }") },
			"bottomScrollV": { get: untyped __js__ ("function () { return this.get_bottomScrollV (); }") },
			"defaultTextFormat": { get: untyped __js__ ("function () { return this.get_defaultTextFormat (); }"), set: untyped __js__ ("function (v) { return this.set_defaultTextFormat (v); }") },
			"displayAsPassword": { get: untyped __js__ ("function () { return this.get_displayAsPassword (); }"), set: untyped __js__ ("function (v) { return this.set_displayAsPassword (v); }") },
			"embedFonts": { get: untyped __js__ ("function () { return this.get_embedFonts (); }"), set: untyped __js__ ("function (v) { return this.set_embedFonts (v); }") },
			"gridFitType": { get: untyped __js__ ("function () { return this.get_gridFitType (); }"), set: untyped __js__ ("function (v) { return this.set_gridFitType (v); }") },
			"htmlText": { get: untyped __js__ ("function () { return this.get_htmlText (); }"), set: untyped __js__ ("function (v) { return this.set_htmlText (v); }") },
			"length": { get: untyped __js__ ("function () { return this.get_length (); }") },
			"maxChars": { get: untyped __js__ ("function () { return this.get_maxChars (); }"), set: untyped __js__ ("function (v) { return this.set_maxChars (v); }") },
			"maxScrollH": { get: untyped __js__ ("function () { return this.get_maxScrollH (); }") },
			"maxScrollV": { get: untyped __js__ ("function () { return this.get_maxScrollV (); }") },
			"mouseWheelEnabled": { get: untyped __js__ ("function () { return this.get_mouseWheelEnabled (); }"), set: untyped __js__ ("function (v) { return this.set_mouseWheelEnabled (v); }") },
			"multiline": { get: untyped __js__ ("function () { return this.get_multiline (); }"), set: untyped __js__ ("function (v) { return this.set_multiline (v); }") },
			"numLines": { get: untyped __js__ ("function () { return this.get_numLines (); }") },
			"restrict": { get: untyped __js__ ("function () { return this.get_restrict (); }"), set: untyped __js__ ("function (v) { return this.set_restrict (v); }") },
			"scrollH": { get: untyped __js__ ("function () { return this.get_scrollH (); }"), set: untyped __js__ ("function (v) { return this.set_scrollH (v); }") },
			"scrollV": { get: untyped __js__ ("function () { return this.get_scrollV (); }"), set: untyped __js__ ("function (v) { return this.set_scrollV (v); }") },
			"selectable": { get: untyped __js__ ("function () { return this.get_selectable (); }"), set: untyped __js__ ("function (v) { return this.set_selectable (v); }") },
			"selectionBeginIndex": { get: untyped __js__ ("function () { return this.get_selectionBeginIndex (); }") },
			"selectionEndIndex": { get: untyped __js__ ("function () { return this.get_selectionEndIndex (); }") },
			"sharpness": { get: untyped __js__ ("function () { return this.get_sharpness (); }"), set: untyped __js__ ("function (v) { return this.set_sharpness (v); }") },
			"text": { get: untyped __js__ ("function () { return this.get_text (); }"), set: untyped __js__ ("function (v) { return this.set_text (v); }") },
			"textColor": { get: untyped __js__ ("function () { return this.get_textColor (); }"), set: untyped __js__ ("function (v) { return this.set_textColor (v); }") },
			"textHeight": { get: untyped __js__ ("function () { return this.get_textHeight (); }") },
			"textWidth": { get: untyped __js__ ("function () { return this.get_textWidth (); }") },
			"type": { get: untyped __js__ ("function () { return this.get_type (); }"), set: untyped __js__ ("function (v) { return this.set_type (v); }") },
			"wordWrap": { get: untyped __js__ ("function () { return this.get_wordWrap (); }"), set: untyped __js__ ("function (v) { return this.set_wordWrap (v); }") },
		});
		
	}
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
		addEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
		addEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
		addEventListener (KeyboardEvent.KEY_DOWN, this_onKeyDown);
		
	}
	
	
	public function appendText (text:String):Void {
		
		if (text == null || text == "") return;
		
		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty ();
		
		__updateText (__text + text);
		
		__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;
		__updateScrollH ();
		
	}
	
	
	public function getCharBoundaries (charIndex:Int):Rectangle {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return null;
		
		var rect = new Rectangle ();
		
		if (__getCharBoundaries (charIndex, rect)) {
			
			return rect;
			
		} else {
			
			return null;
			
		}
		
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
					
					for (i in 0...group.positions.length) {
						
						advance += group.getAdvance (i);
						
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
		
		if (charIndex < 0 || charIndex > __text.length) return -1;
		
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
		
		if (startIndex == endIndex && __textEngine.maxChars > 0 && __text.length == __textEngine.maxChars) return;
		
		if (startIndex > __text.length) startIndex = __text.length;
		if (endIndex > __text.length) endIndex = __text.length;
		if (endIndex < startIndex) {
			
			var cache = endIndex;
			endIndex = startIndex;
			startIndex = cache;
			
		}
		if (startIndex < 0) startIndex = 0;
		
		replaceText (startIndex, endIndex, value);
		
		var i = startIndex + cast (value, UTF8String).length;
		if (i > __text.length) i = __text.length;
		
		setSelection (i, i);
		
		// TODO: Solution where this is not run twice (run inside replaceText above)
		__updateScrollH ();
		
	}
	
	
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String):Void {
		
		if (endIndex < beginIndex || beginIndex < 0 || endIndex > __text.length || newText == null) return;
		
		__updateText (__text.substring (0, beginIndex) + newText + __text.substring (endIndex));
		if (endIndex > __text.length) endIndex = __text.length;
		
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
					range.end = beginIndex + newText.length;
					i++;
					
				}
				
				offset -= (range.end - range.start);
				
			} else if (range.start > beginIndex && range.start <= endIndex) {
				
				range.start += offset;
				i++;
				
			} else {
				
				i++;
				
			}
			
		}
		
		__updateScrollH ();
		
		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty ();
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		__selectionIndex = beginIndex;
		__caretIndex = endIndex;
		__stopCursorTimer ();
		__startCursorTimer ();

	}
	
	
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void {
		
		var max = text.length;
		var range;
		
		if (beginIndex < 0) beginIndex = 0;
		if (endIndex < 0) endIndex = 0;
		
		if (endIndex == 0) {
			
			if (beginIndex == 0) {
				
				endIndex = max;
				
			} else {
				
				endIndex = beginIndex + 1;
				
			}
			
		}
		
		if (endIndex < beginIndex) return;
		
		if (beginIndex == 0 && endIndex >= max) {
			
			// set text format for the whole textfield
			
			__textFormat.__merge (format);
			
			for (i in 0...__textEngine.textFormatRanges.length) {

				range = __textEngine.textFormatRanges[i];
				range.format.__merge (__textFormat);

			}
			
		} else {
			
			var index = __textEngine.textFormatRanges.length;
			var searchIndex;
			
			while (index > 0) {
				
				index--;
				range = __textEngine.textFormatRanges[index];
				
				if (range.start == beginIndex && range.end == endIndex) {
					
					// the new incoming text format range matches an existing range exactly, just replace it
					
					range.format = __defaultTextFormat.clone ();
					range.format.__merge (format);
					return;
					
				}
				
				if (range.start >= beginIndex && range.end <= endIndex) {
					
					// the new incoming text format range completely encompasses this existing range, let's remove it
					
					searchIndex = __textEngine.textFormatRanges.indexOf (range);
					
					if (searchIndex > -1) {
						
						__textEngine.textFormatRanges.splice (searchIndex, 1);
						
					}
					
				}
				
			}
			
			var prevRange = null, nextRange = null;
			
			// find the ranges before and after the new incoming range
			
			if (beginIndex > 0) {
				
				for (i in 0...__textEngine.textFormatRanges.length) {
					
					range = __textEngine.textFormatRanges[i];
					
					if (range.end >= beginIndex) {
						
						prevRange = range;
						
						break;
						
					}
					
				}
			}
			
			if (endIndex < max) {
				
				var ni = __textEngine.textFormatRanges.length;
				
				while (--ni >= 0 ) {
					
					range = __textEngine.textFormatRanges[ni];
					
					if (range.start <= endIndex) {
						
						nextRange = range;
						
						break;
						
					}
					
				}
				
			}
			
			if (nextRange == prevRange) {
				
				// the new incoming text format range is completely within this existing range, let's divide it up
				
				nextRange = new TextFormatRange (nextRange.format.clone (), nextRange.start, nextRange.end);
				__textEngine.textFormatRanges.push (nextRange);
				
			}
			
			if (prevRange != null) {
				
				prevRange.end = beginIndex;
				
			}
			
			if (nextRange != null) {
				
				nextRange.start = endIndex;
				
			}
			
			var textFormat = __defaultTextFormat.clone ();
			textFormat.__merge (format);
			
			__textEngine.textFormatRanges.push (new TextFormatRange (textFormat, beginIndex, endIndex));
			
			__textEngine.textFormatRanges.sort (function (a:TextFormatRange, b:TextFormatRange):Int {
				
				if (a.start < b.start || a.end < b.end) {
					
					return -1;
					
				} else if (a.start > b.start || a.end > b.end) {
					
					return 1;
					
				}
				
				return 0;
				
			});
			
		}
		
		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty ();
		
	}
	
	
	private override function __allowMouseFocus ():Bool {
		
		return __textEngine.type == INPUT || tabEnabled || selectable;
		
	}
	
	
	private function __caretBeginningOfLine ():Void {
		
		if (__selectionIndex == __caretIndex || __caretIndex < __selectionIndex) {
			
			__caretIndex = getLineOffset (getLineIndexOfChar (__caretIndex));
			
		} else {
			
			__selectionIndex = getLineOffset (getLineIndexOfChar (__selectionIndex));
			
		}
		
	}
	
	
	private function __caretEndOfLine ():Void {
		
		var lineIndex;
		
		if (__selectionIndex == __caretIndex) {
			
			lineIndex = getLineIndexOfChar (__caretIndex);
			
		} else {
			
			lineIndex = getLineIndexOfChar (Std.int (Math.max (__caretIndex, __selectionIndex)));
			
		}
		
		if (lineIndex < __textEngine.numLines - 1) {
			
			__caretIndex = getLineOffset (lineIndex + 1) - 1;
			
		} else {
			
			__caretIndex = __text.length;
			
		}
		
	}
	
	
	private function __caretNextCharacter ():Void {
		
		if (__caretIndex < __text.length) {
			
			__caretIndex++;
			
		}
		
	}
	
	
	private function __caretNextLine (lineIndex:Null<Int> = null, caretIndex:Null<Int> = null):Void {
		
		if (lineIndex == null) {
			
			lineIndex = getLineIndexOfChar (__caretIndex);
			
		}
		
		if (lineIndex < __textEngine.numLines - 1) {
			
			if (caretIndex == null) {
				
				caretIndex = __caretIndex;
				
			}
			
			__caretIndex = __getCharIndexOnDifferentLine (caretIndex, lineIndex + 1);
			
		} else {
			
			__caretIndex = __text.length;
			
		}
		
	}
	
	
	private function __caretPreviousCharacter ():Void {
		
		if (__caretIndex > 0) {
			
			__caretIndex--;
			
		}
		
	}
	
	
	private function __caretPreviousLine (lineIndex:Null<Int> = null, caretIndex:Null<Int> = null):Void {
		
		if (lineIndex == null) {
			
			lineIndex = getLineIndexOfChar (__caretIndex);
			
		}
		
		if (lineIndex > 0) {
			
			if (caretIndex == null) {
				
				caretIndex = __caretIndex;
				
			}
			
			__caretIndex = __getCharIndexOnDifferentLine (caretIndex, lineIndex - 1);
			
		} else {
			
			__caretIndex = 0;
			
		}
		
	}
	
	
	private function __disableInput ():Void {
		
		if (__inputEnabled && stage != null) {
			
			stage.window.enableTextEvents = false;
			stage.window.onTextInput.remove (window_onTextInput);
			stage.window.onKeyDown.remove (window_onKeyDown);
			
			__inputEnabled = false;
			__stopCursorTimer ();
			
		}
		
	}
	
	
	private override function __dispatch (event:Event):Bool {
		
		if (event.eventPhase == AT_TARGET && event.type == MouseEvent.MOUSE_UP) {
			
			var event:MouseEvent = cast event;
			var group = __getGroup (mouseX, mouseY, true);
			
			if (group != null) {
				
				var url = group.format.url;
				
				if (url != null && url != "") {
					
					if (StringTools.startsWith (url, "event:")) {
						
						dispatchEvent (new TextEvent (TextEvent.LINK, false, false, url.substr (6)));
						
					} else {
						
						Lib.getURL (new URLRequest (url));
						
					}
					
				}
				
			}
			
		}
		
		return super.__dispatch (event);
		
	}
	
	
	private function __enableInput ():Void {
		
		if (stage != null) {
			
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
			
		}
		
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
			
			format.__ascent = ((font.ascent / 20) / 1024);
			format.__descent = ((font.descent / 20) / 1024);
			
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
		
		if (!found) {
			
			var alpha = ~/[^a-zA-Z]+/g;
			
			for (font in Font.enumerateFonts ()) {
				
				if (alpha.replace (font.fontName, "").substr (0, symbol.fontName.length) == symbol.fontName) {
					
					format.font = font.fontName;
					found = true;
					break;
					
				}
				
			}
			
		}
		
		if (found) {
			
			embedFonts = true;
			
		} else if (!__missingFontWarning.exists (format.font)) {
			
			__missingFontWarning[format.font] = true;
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
	
	
	private inline function __getAdvance (position):Float {
		
		#if (js && html5)
		return position;
		#else
		return position.advance.x;
		#end
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		__updateLayout ();
		
		var bounds = Rectangle.__pool.get ();
		bounds.copyFrom (__textEngine.bounds);
		bounds.x += __offsetX;
		bounds.y += __offsetY;
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
		Rectangle.__pool.release (bounds);
		
	}
	
	
	private function __getCharBoundaries (charIndex:Int, rect:Rectangle):Bool {
		
		if (charIndex < 0 || charIndex > __text.length - 1) return false;
		
		__updateLayout ();
		
		for (group in __textEngine.layoutGroups) {
			
			if (charIndex >= group.startIndex && charIndex <= group.endIndex) {
				
				try {
					
					var x = group.offsetX;
					
					for (i in 0...(charIndex - group.startIndex)) {
						
						x += group.getAdvance (i);
						
					}
					
					// TODO: Is this actually right for combining characters?
					var lastPosition = group.getAdvance (charIndex - group.startIndex);
					
					rect.setTo (x, group.offsetY, lastPosition, group.ascent + group.descent);
					return true;
					
				} catch (e:Dynamic) {}
				
			}
			
		}
		
		return false;
		
	}
	
	
	private function __getCharIndexOnDifferentLine (charIndex:Int, lineIndex:Int):Int {
		
		if (charIndex < 0 || charIndex > __text.length) return -1;
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;
		
		var x:Null<Float> = null, y:Null<Float> = null;
		
		for (group in __textEngine.layoutGroups) {
			
			if (charIndex >= group.startIndex && charIndex <= group.endIndex) {
				
				x = group.offsetX;
				
				for (i in 0...(charIndex - group.startIndex)) {
					
					x += group.getAdvance (i);
					
				}
				
				if (y != null) return __getPosition (x, y);
				
			}
			
			if (group.lineIndex == lineIndex) {
				
				y = group.offsetY + group.height / 2;
				
				if (x != null) return __getPosition (x, y);
				
			}
			
		}
		
		return -1;
		
	}
	
	
	private override function __getCursor ():MouseCursor {
		
		var group = __getGroup (mouseX, mouseY, true);
		
		if (group != null && group.format.url != "") {
			
			return POINTER;
			
		} else if (__textEngine.selectable) {
			
			return TEXT;
			
		}
		
		return null;
		
	}
	
	
	private function __getGroup (x:Float, y:Float, precise = false):TextLayoutGroup {
		
		__updateLayout ();
		
		x += scrollH;
		
		for (i in 0...scrollV - 1) {
			
			y += __textEngine.lineHeights[i];
			
		}
		
		if (!precise && y > __textEngine.textHeight) y = __textEngine.textHeight;
		
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
			
			if ((y >= group.offsetY && y <= group.offsetY + group.height) || (!precise && nextGroup == null)) {
				
				if ((x >= group.offsetX && x <= group.offsetX + group.width) || (!precise && (nextGroup == null || nextGroup.lineIndex != group.lineIndex))) {
					
					return group;
					
				}
				
			}
			
		}
		
		return null;
		
	}
	
	
	private function __getPosition (x:Float, y:Float):Int {
		
		var group = __getGroup (x, y);
		
		if (group == null) {
			
			return __text.length;
			
		}
		
		var advance = 0.0;
		
		for (i in 0...group.positions.length) {
			
			advance += group.getAdvance (i);
			
			if (x <= group.offsetX + advance) {
				
				if (x <= group.offsetX + (advance - group.getAdvance (i)) + (group.getAdvance (i) / 2)) {
					
					return group.startIndex + i;
					
				} else {
					
					return (group.startIndex + i < group.endIndex) ? group.startIndex + i + 1 : group.endIndex;
					
				}
				
			}
			
		}
		
		return group.endIndex;
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
		
		#if lime_cairo
		CairoTextField.render (this, renderSession, __worldTransform);
		super.__renderCairo (renderSession);
		#end
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		// TODO: Better DOM workaround on cacheAsBitmap
		
		if (renderSession.renderType == DOM && !__renderedOnCanvasWhileOnDOM) {
			
			__renderedOnCanvasWhileOnDOM = true;
			
			if (type == TextFieldType.INPUT) {
				
				replaceText (0, __text.length, __text);
				
			}
			
			if (__isHTML) {
				
				__updateText (HTMLParser.parse (__text, __textFormat, __textEngine.textFormatRanges));
				
			}
			
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
		}
		
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
		
		#end
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		__updateCacheBitmap (renderSession, __forceCachedBitmapUpdate || !__worldColorTransform.__isDefault ());
		__forceCachedBitmapUpdate = false;
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			__renderDOMClear (renderSession);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			if (__renderedOnCanvasWhileOnDOM) {
				
				__renderedOnCanvasWhileOnDOM = false;
				
				if (__isHTML && __rawHtmlText != null) {
					
					__updateText (__rawHtmlText);
					__dirty = true;
					__layoutDirty = true;
					__setRenderDirty ();
					
				}
				
			}
			
			DOMTextField.render (this, renderSession);
			
		}
		
		#end
		
	}
	
	
	private override function __renderDOMClear (renderSession:RenderSession):Void {
		
		DOMTextField.clear (this, renderSession);
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		#if (js && html5)
		CanvasTextField.render (this, renderSession, __worldTransform);
		#elseif lime_cairo
		CairoTextField.render (this, renderSession, __worldTransform);
		#end
		
		super.__renderGL (renderSession);
		
	}
	
	
	private override function __renderGLMask (renderSession:RenderSession):Void {
		
		#if (js && html5)
		CanvasTextField.render (this, renderSession, __worldTransform);
		#elseif lime_cairo
		CairoTextField.render (this, renderSession, __worldTransform);
		#end
		
		super.__renderGLMask (renderSession);
		
	}
	
	
	private function __startCursorTimer ():Void {
		
		__cursorTimer = Timer.delay (__startCursorTimer, 600);
		__showCursor = !__showCursor;
		__dirty = true;
		__setRenderDirty ();
		
	}
	
	
	private function __startTextInput ():Void {
		
		if (__caretIndex < 0) {
			
			__caretIndex = __text.length;
			__selectionIndex = __caretIndex;
			
		}
		
		var enableInput = #if (js && html5) (DisplayObject.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;
		
		if (enableInput) {
			
			__enableInput ();
			
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
			__setRenderDirty ();
			
		}

	}
	
	
	private function __stopTextInput ():Void {
		
		var disableInput = #if (js && html5) (DisplayObject.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;
		
		if (disableInput) {
			
			__disableInput ();
			
		}
		
	}
	
	
	private override function __updateCacheBitmap (renderSession:RenderSession, force:Bool):Bool {
		
		if (super.__updateCacheBitmap (renderSession, force)) {
			
			if (__cacheBitmap != null) {
				
				__cacheBitmap.__renderTransform.tx -= __offsetX;
				__cacheBitmap.__renderTransform.ty -= __offsetY;
				
			}
			
			return true;
			
		}
		
		return false;
		
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
	
	
	private function __updateScrollH ():Void {
		
		if (!multiline && type == INPUT) {
			
			__layoutDirty = true;
			__updateLayout ();
			
			var offsetX = __textEngine.textWidth - __textEngine.width + 4;
			
			if (offsetX > 0) {
				
				// TODO: Handle __selectionIndex on drag select?
				// TODO: Update scrollH by one character width at a time when able
				
				if (__caretIndex >= text.length) {
					
					scrollH = Math.ceil (offsetX);
					
				} else {
					
					var caret = Rectangle.__pool.get ();
					__getCharBoundaries (__caretIndex, caret);
					
					if (caret.x < scrollH) {
						
						scrollH = Math.floor (caret.x - 2);
						
					} else if (caret.x > scrollH + __textEngine.width) {
						
						scrollH = Math.ceil (caret.x - __textEngine.width - 2);
						
					}
					
					Rectangle.__pool.release (caret);
					
				}
				
			} else {
				
				scrollH = 0;
				
			}
			
		}
		
	}
	
	
	private function __updateText (value:String):Void {
		
		#if (js && html5)
		if (DisplayObject.__supportDOM && __renderedOnCanvasWhileOnDOM) {
			
			__forceCachedBitmapUpdate = __text != value;
			
		}
		#end
		
		// applies maxChars and restrict on text
		
		__textEngine.text = value;
		__text = __textEngine.text;
		
		if (__text.length < __caretIndex) {
			
			__selectionIndex = __caretIndex = __text.length;
			
		}
		
		if (!__displayAsPassword #if (js && html5) || (DisplayObject.__supportDOM && !__renderedOnCanvasWhileOnDOM) #end) {
			
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
	
	
	public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		__renderTransform.__translateTransformed (__offsetX, __offsetY);
		
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
			__layoutDirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.autoSize = value;
		
	}
	
	
	private function get_background ():Bool {
		
		return __textEngine.background;
		
	}
	
	
	private function set_background (value:Bool):Bool {
		
		if (value != __textEngine.background) {
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.background = value;
		
	}
	
	
	private function get_backgroundColor ():Int {
		
		return __textEngine.backgroundColor;
		
	}
	
	
	private function set_backgroundColor (value:Int):Int {
		
		if (value != __textEngine.backgroundColor) {
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.backgroundColor = value;
		
	}
	
	
	private function get_border ():Bool {
		
		return __textEngine.border;
		
	}
	
	
	private function set_border (value:Bool):Bool {
		
		if (value != __textEngine.border) {
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.border = value;
		
	}
	
	
	private function get_borderColor ():Int {
		
		return __textEngine.borderColor;
		
	}
	
	
	private function set_borderColor (value:Int):Int {
		
		if (value != __textEngine.borderColor) {
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.borderColor = value;
		
	}
	
	
	private function get_bottomScrollV ():Int {
		
		__updateLayout ();
		
		return __textEngine.bottomScrollV;
		
	}
	
	
	private override function get_cacheAsBitmap ():Bool {
		
		// HACK
		if (__filters != null && __filters.length == 1 && Std.is (__filters[0], GlowFilter)) return false;
		return super.get_cacheAsBitmap ();
		
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
		__setRenderDirty ();
		
		return value;
		
	}
	
	
	private function get_displayAsPassword ():Bool {
		
		return __displayAsPassword;
		
	}
	
	
	private function set_displayAsPassword (value:Bool):Bool {
		
		if (value != __displayAsPassword) {
			
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
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
			__layoutDirty = true;
			__setRenderDirty ();
			
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
			__layoutDirty = true;
			__setRenderDirty ();
			
		}
		
		__isHTML = true;
		
		#if (js && html5)
		if (DisplayObject.__supportDOM) {
			
			__rawHtmlText = value;
			
		}
		#end
		
		value = HTMLParser.parse(value, __textFormat, __textEngine.textFormatRanges);
		
		#if (js && html5)
		
		if (DisplayObject.__supportDOM) {
			
			if (__textEngine.textFormatRanges.length > 1) {
				
				__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
				
			}
			
			var range = __textEngine.textFormatRanges[0];
			range.format = __textFormat;
			range.start = 0;
			
			if (__renderedOnCanvasWhileOnDOM) {
				
				range.end = value.length;
				__updateText (value);
				
			} else {
				
				range.end = __rawHtmlText.length;
				__updateText (__rawHtmlText);
				
			}
			
		} else {
			
			__updateText (value);
			
		}
		#else
		__updateText (value);
		#end
		
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
			
			__textEngine.maxChars = value;
			
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
		}
		
		return value;
		
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
			__layoutDirty = true;
			__updateText (__text);
			__updateScrollH ();
			__setRenderDirty ();
			
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
		
		if (__textEngine.restrict != value) {
			
			__textEngine.restrict = value;
			__updateText (__text);
			
		}
		
		return value;
		
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
			__setRenderDirty ();
			dispatchEvent (new Event (Event.SCROLL));
			
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
			__setRenderDirty ();
			dispatchEvent(new Event(Event.SCROLL));
			
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
			__setRenderDirty ();
			
		}
		
		return __textEngine.sharpness = value;
		
	}
	
	
	private override function get_tabEnabled ():Bool {
		
		return (__tabEnabled == null ? __textEngine.type == INPUT : __tabEnabled);
		
	}
	
	
	private function get_text ():String {
		
		return __text;
		
	}
	
	
	private function set_text (value:String):String {
		
		if (__isHTML || __text != value) {
			
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
		} else {
			
			return value;
			
		}
		
		if (__textEngine.textFormatRanges.length > 1) {
			
			__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
			
		}
		
		var utfValue:UTF8String = value;
		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = utfValue.length;
		
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
			__setRenderDirty ();
			
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
				
				addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
				
				this_onFocusIn (null);
				__textEngine.__useIntAdvances = true;
				
			} else {
				
				removeEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
				
				__stopTextInput ();
				__textEngine.__useIntAdvances = null;
				
			}
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.type = value;
		
	}
	
	
	override private function get_width ():Float {
		
		__updateLayout ();
		return __textEngine.width * Math.abs (__scaleX);
		
	}
	
	
	override private function set_width (value:Float):Float {
		
		if (value != __textEngine.width) {
			
			__setTransformDirty ();
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
			__textEngine.width = value;
			
		}
		
		return __textEngine.width * Math.abs (__scaleX);
		
	}
	
	
	private function get_wordWrap ():Bool {
		
		return __textEngine.wordWrap;
		
	}
	
	
	private function set_wordWrap (value:Bool):Bool {
		
		if (value != __textEngine.wordWrap) {
			
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty ();
			
		}
		
		return __textEngine.wordWrap = value;
		
	}
	
	
	private override function get_x ():Float {
		
		return __transform.tx + __offsetX;
		
	}
	
	
	private override function set_x (value:Float):Float {
		
		if (value != __transform.tx + __offsetX) __setTransformDirty ();
		return __transform.tx = value - __offsetX;
		
	}
	
	
	private override function get_y ():Float {
		
		return __transform.ty + __offsetY;
		
	}
	
	
	private override function set_y (value:Float):Float {
		
		if (value != __transform.ty + __offsetY) __setTransformDirty ();
		return __transform.ty = value - __offsetY;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onMouseMove (event:MouseEvent) {
		
		if (stage == null) return;
		
		if (__textEngine.selectable && __selectionIndex >= 0) {
			
			__updateLayout ();
			
			var position = __getPosition (mouseX + scrollH, mouseY);
			
			if (position != __caretIndex) {
				
				__caretIndex = position;
				
				#if (js && html5) if (DisplayObject.__supportDOM) {
					
					if (__renderedOnCanvasWhileOnDOM) {
						__forceCachedBitmapUpdate = true;
					}
					
				} else #end {
					
					__dirty = true;
					__setRenderDirty ();
					
				}
				
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
			
			var upPos:Int = __getPosition (mouseX + scrollH, mouseY);
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
				
				#if (js && html5)
				if (DisplayObject.__supportDOM && __renderedOnCanvasWhileOnDOM) {
					__forceCachedBitmapUpdate = true;
				}
				#end
				
			}
			
		}
		
	}
	
	
	private function this_onAddedToStage (event:Event):Void {
		
		this_onFocusIn (null);
		
	}
	
	
	private function this_onFocusIn (event:FocusEvent):Void {
		
		if (type == INPUT && stage != null && stage.focus == this) {
			
			__startTextInput ();
			
		}
		
	}
	
	
	private function this_onFocusOut (event:FocusEvent):Void {
		
		__stopCursorTimer ();
		
		// TODO: Better system
		
		if (event.relatedObject == null || !Std.is (event.relatedObject, TextField)) {
			
			__stopTextInput ();
			
		} else {
			
			stage.window.onTextInput.remove (window_onTextInput);
			stage.window.onKeyDown.remove (window_onKeyDown);
			__inputEnabled = false;
			
		}
		
		if (__selectionIndex != __caretIndex) {
			
			__selectionIndex = __caretIndex;
			__dirty = true;
			__setRenderDirty ();
			
		}
		
	}
	
	
	private function this_onKeyDown (event:KeyboardEvent):Void {
		
		if (selectable && type != INPUT && event.keyCode == Keyboard.C && (event.commandKey || event.ctrlKey)) {
			
			if (__caretIndex != __selectionIndex) {
				
				Clipboard.text = __text.substring (__caretIndex, __selectionIndex);
				
			}
			
		}
		
	}
	
	
	private function this_onMouseDown (event:MouseEvent):Void {
		
		if (!selectable && type != INPUT) return;
		
		__updateLayout ();
		
		__caretIndex = __getPosition (mouseX + scrollH, mouseY);
		__selectionIndex = __caretIndex;
		
		if (!DisplayObject.__supportDOM) {
			
			__dirty = true;
			__setRenderDirty ();
			
		}
		
		stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	
	
	private function window_onKeyDown (key:KeyCode, modifier:KeyModifier):Void {
		
		switch (key) {
			
			case RETURN, NUMPAD_ENTER:
				
				if (__textEngine.multiline) {
					
					replaceSelectedText ("\n");
					dispatchEvent (new Event (Event.CHANGE, true));
					
				}
			
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
				
				if (modifier.metaKey) {
					
					__caretBeginningOfLine ();
					
					if (!modifier.shiftKey) {
						
						__selectionIndex = __caretIndex;
						
					}
					
				} else if (modifier.shiftKey) {
					
					__caretPreviousCharacter ();
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						__caretPreviousCharacter ();
						
					} else {
						
						__caretIndex = Std.int (Math.min (__caretIndex, __selectionIndex));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__updateScrollH ();
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case RIGHT:
				
				if (modifier.metaKey) {
					
					__caretEndOfLine ();
					
					if (!modifier.shiftKey) {
						
						__selectionIndex = __caretIndex;
						
					}
					
				} else if (modifier.shiftKey) {
					
					__caretNextCharacter ();
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						__caretNextCharacter ();
						
					} else {
						
						__caretIndex = Std.int (Math.max (__caretIndex, __selectionIndex));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__updateScrollH ();
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case DOWN:
				
				if (modifier.shiftKey) {
					
					__caretNextLine ();
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						__caretNextLine ();
						
					} else {
						
						var lineIndex = getLineIndexOfChar (Std.int (Math.max (__caretIndex, __selectionIndex)));
						__caretNextLine (lineIndex, Std.int (Math.min (__caretIndex, __selectionIndex)));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case UP:
				
				if (modifier.shiftKey) {
					
					__caretPreviousLine ();
					
				} else {
					
					if (__selectionIndex == __caretIndex) {
						
						__caretPreviousLine ();
						
					} else {
						
						var lineIndex = getLineIndexOfChar (Std.int (Math.min (__caretIndex, __selectionIndex)));
						__caretPreviousLine (lineIndex, Std.int (Math.min (__caretIndex, __selectionIndex)));
						
					}
					
					__selectionIndex = __caretIndex;
					
				}
				
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case HOME:
				
				__caretBeginningOfLine ();
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case END:
				
				__caretEndOfLine ();
				__stopCursorTimer ();
				__startCursorTimer ();
			
			case C:
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end) {
					
					if (__caretIndex != __selectionIndex) {
						
						Clipboard.text = __text.substring (__caretIndex, __selectionIndex);
						
					}
					
				}
			
			case X:
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end) {
					
					if (__caretIndex != __selectionIndex) {
						
						Clipboard.text = __text.substring (__caretIndex, __selectionIndex);
						
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
				
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end) {
					
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
