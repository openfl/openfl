package openfl.text;

import haxe.Timer;
import openfl.text._internal.HTMLParser;
import openfl.text._internal.TextEngine;
import openfl.text._internal.TextFormatRange;
import openfl.text._internal.TextLayoutGroup;
import openfl.desktop.Clipboard;
import openfl.display.DisplayObject;
import openfl.display._DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.display._InteractiveObject;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.net.URLRequest;
import openfl.ui.Keyboard;
import openfl.ui.MouseCursor;
import openfl.Lib;
#if openfl_html5
import js.html.DivElement;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:access(openfl.text._internal.TextEngine)
@:access(openfl.text.TextFormat)
@:noCompletion
class _TextField extends _InteractiveObject
{
	public static var __defaultTextFormat:TextFormat;
	public static var __missingFontWarning:Map<String, Bool> = new Map();

	public var antiAliasType(get, set):AntiAliasType;
	public var autoSize(get, set):TextFieldAutoSize;
	public var background(get, set):Bool;
	public var backgroundColor(get, set):Int;
	public var border(get, set):Bool;
	public var borderColor(get, set):Int;
	public var bottomScrollV(get, never):Int;
	public var caretIndex(get, never):Int;
	public var defaultTextFormat(get, set):TextFormat;
	public var displayAsPassword(get, set):Bool;
	public var embedFonts(get, set):Bool;
	public var gridFitType(get, set):GridFitType;
	public var htmlText(get, set):String;
	public var length(get, never):Int;
	public var maxChars(get, set):Int;
	public var maxScrollH(get, never):Int;
	public var maxScrollV(get, never):Int;
	public var mouseWheelEnabled(get, set):Bool;
	public var multiline(get, set):Bool;
	public var numLines(get, never):Int;
	public var restrict(get, set):String;
	public var scrollH(get, set):Int;
	public var scrollV(get, set):Int;
	public var selectable(get, set):Bool;
	public var selectionBeginIndex(get, never):Int;
	public var selectionEndIndex(get, never):Int;
	public var sharpness(get, set):Float;
	public var text(get, set):String;
	public var textColor(get, set):Int;
	public var textHeight(get, never):Float;
	public var textWidth(get, never):Float;
	public var type(get, set):TextFieldType;
	public var wordWrap(get, set):Bool;

	public var __bounds:Rectangle;
	public var __caretIndex:Int;
	public var __cursorTimer:Timer;
	public var __dirty:Bool;
	public var __displayAsPassword:Bool;
	public var __domRender:Bool;
	public var __inputEnabled:Bool;
	public var __isHTML:Bool;
	public var __layoutDirty:Bool;
	public var __mouseWheelEnabled:Bool;
	public var __offsetX:Float;
	public var __offsetY:Float;
	public var __selectionIndex:Int;
	public var __showCursor:Bool;
	public var __text:String;
	public var __htmlText:String;
	public var __textEngine:TextEngine;
	public var __textFormat:TextFormat;
	#if openfl_html5
	public var __div:DivElement;
	public var __renderedOnCanvasWhileOnDOM:Bool = false;
	public var __rawHtmlText:String;
	public var __forceCachedBitmapUpdate:Bool = false;
	#end

	public function new(textField:TextField)
	{
		super(textField);

		__type = TEXTFIELD;

		__caretIndex = -1;
		__displayAsPassword = false;
		__graphics = new Graphics(this);
		__textEngine = new TextEngine(this);
		__layoutDirty = true;
		__offsetX = 0;
		__offsetY = 0;
		__mouseWheelEnabled = true;
		__text = "";

		doubleClickEnabled = true;

		if (__defaultTextFormat == null)
		{
			__defaultTextFormat = new TextFormat("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
		}

		__textFormat = __defaultTextFormat.clone();
		__textEngine.textFormatRanges.push(new TextFormatRange(__textFormat, 0, 0));

		_ = new _TextField(this);

		addEventListener(MouseEvent.MOUSE_DOWN, this_onMouseDown);
		addEventListener(FocusEvent.FOCUS_IN, this_onFocusIn);
		addEventListener(FocusEvent.FOCUS_OUT, this_onFocusOut);
		addEventListener(KeyboardEvent.KEY_DOWN, this_onKeyDown);
		addEventListener(MouseEvent.MOUSE_WHEEL, this_onMouseWheel);

		addEventListener(MouseEvent.DOUBLE_CLICK, this_onDoubleClick);
	}

	public function appendText(text:String):Void
	{
		if (text == null || text == "") return;

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();

		__updateText(__text + text);

		__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;

		__updateScrollV();
		__updateScrollH();
	}

	public function getCharBoundaries(charIndex:Int):Rectangle
	{
		if (charIndex < 0 || charIndex > __text.length - 1) return null;

		var rect = new Rectangle();

		if (__getCharBoundaries(charIndex, rect))
		{
			return rect;
		}
		else
		{
			return null;
		}
	}

	public function getCharIndexAtPoint(x:Float, y:Float):Int
	{
		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;

		__updateLayout();

		x += scrollH;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		for (group in __textEngine.layoutGroups)
		{
			if (y >= group.offsetY && y <= group.offsetY + group.height)
			{
				if (x >= group.offsetX && x <= group.offsetX + group.width)
				{
					var advance = 0.0;

					for (i in 0...group.positions.length)
					{
						advance += group.getAdvance(i);

						if (x <= group.offsetX + advance)
						{
							return group.startIndex + i;
						}
					}

					return group.endIndex;
				}
			}
		}

		return -1;
	}

	public function getFirstCharInParagraph(charIndex:Int):Int
	{
		if (charIndex < 0 || charIndex > text.length) return -1;

		var index = __textEngine.getLineBreakIndex();
		var startIndex = 0;

		while (index > -1)
		{
			if (index < charIndex)
			{
				startIndex = index + 1;
			}
			else if (index >= charIndex)
			{
				break;
			}

			index = __textEngine.getLineBreakIndex(index + 1);
		}

		return startIndex;
	}

	public function getLineIndexAtPoint(x:Float, y:Float):Int
	{
		__updateLayout();

		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		for (group in __textEngine.layoutGroups)
		{
			if (y >= group.offsetY && y <= group.offsetY + group.height)
			{
				return group.lineIndex;
			}
		}

		return -1;
	}

	public function getLineIndexOfChar(charIndex:Int):Int
	{
		if (charIndex < 0 || charIndex > __text.length) return -1;

		__updateLayout();

		for (group in __textEngine.layoutGroups)
		{
			if (group.startIndex <= charIndex && group.endIndex >= charIndex)
			{
				return group.lineIndex;
			}
		}

		return -1;
	}

	public function getLineLength(lineIndex:Int):Int
	{
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return 0;

		var startIndex = -1;
		var endIndex = -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				if (startIndex == -1) startIndex = group.startIndex;
			}
			else if (group.lineIndex == lineIndex + 1)
			{
				endIndex = group.startIndex;
				break;
			}
		}

		if (endIndex == -1) endIndex = __text.length;
		return endIndex - startIndex;
	}

	public function getLineMetrics(lineIndex:Int):TextLineMetrics
	{
		__updateLayout();

		var ascender = __textEngine.lineAscents[lineIndex];
		var descender = __textEngine.lineDescents[lineIndex];
		var leading = __textEngine.lineLeadings[lineIndex];
		var lineHeight = __textEngine.lineHeights[lineIndex];
		var lineWidth = __textEngine.lineWidths[lineIndex];

		// TODO: Handle START and END based on language (don't assume LTR)

		var margin = switch (__textFormat.align)
		{
			case LEFT, JUSTIFY, START: 2;
			case RIGHT, END: (__textEngine.width - lineWidth) - 2;
			case CENTER: (__textEngine.width - lineWidth) / 2;
		}

		return new TextLineMetrics(margin, lineWidth, lineHeight, ascender, descender, leading);
	}

	public function getLineOffset(lineIndex:Int):Int
	{
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				return group.startIndex;
			}
		}

		return 0;
	}

	public function getLineText(lineIndex:Int):String
	{
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return null;

		var startIndex = -1;
		var endIndex = -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				if (startIndex == -1) startIndex = group.startIndex;
			}
			else if (group.lineIndex == lineIndex + 1)
			{
				endIndex = group.startIndex;
				break;
			}
		}

		if (endIndex == -1) endIndex = __text.length;

		return __textEngine.text.substring(startIndex, endIndex);
	}

	public function getParagraphLength(charIndex:Int):Int
	{
		if (charIndex < 0 || charIndex > text.length) return -1;

		var startIndex = getFirstCharInParagraph(charIndex);

		if (charIndex >= text.length) return text.length - startIndex + 1;

		var endIndex = __textEngine.getLineBreakIndex(charIndex) + 1;

		if (endIndex == 0) endIndex = __text.length;
		return endIndex - startIndex;
	}

	public function getTextFormat(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
	{
		var format = null;

		if (beginIndex >= text.length || beginIndex < -1 || endIndex > text.length || endIndex < -1)
			throw new RangeError("The supplied index is out of bounds");

		if (beginIndex == -1) beginIndex = 0;
		if (endIndex == -1) endIndex = text.length;

		if (beginIndex >= endIndex) return new TextFormat();

		for (group in __textEngine.textFormatRanges)
		{
			if ((group.start <= beginIndex && group.end > beginIndex) || (group.start < endIndex && group.end >= endIndex))
			{
				if (format == null)
				{
					format = group.format._.clone();
				}
				else
				{
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

		if (format == null) format = new TextFormat();
		return format;
	}

	public function replaceSelectedText(value:String):Void
	{
		__replaceSelectedText(value, false);
	}

	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
	{
		__replaceText(beginIndex, endIndex, newText, false);
	}

	public function setSelection(beginIndex:Int, endIndex:Int):Void
	{
		__selectionIndex = beginIndex;
		__caretIndex = endIndex;

		__updateScrollV();

		__stopCursorTimer();
		__startCursorTimer();
	}

	public function setTextFormat(format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void
	{
		var max = text.length;
		var range;

		if (beginIndex < 0) beginIndex = 0;
		if (endIndex < 0) endIndex = 0;

		if (endIndex == 0)
		{
			if (beginIndex == 0)
			{
				endIndex = max;
			}
			else
			{
				endIndex = beginIndex + 1;
			}
		}

		if (endIndex < beginIndex) return;

		if (beginIndex == 0 && endIndex >= max)
		{
			// set text format for the whole textfield
			__textFormat._.__merge(format);

			for (i in 0...__textEngine.textFormatRanges.length)
			{
				range = __textEngine.textFormatRanges[i];
				range.format._.__merge(format);
			}
		}
		else
		{
			var index = 0;
			var newRange;

			while (index < __textEngine.textFormatRanges.length)
			{
				range = __textEngine.textFormatRanges[index];

				if (range.start == beginIndex && range.end == endIndex)
				{
					// set format range matches an existing range exactly
					range.format._.__merge(format);
					break;
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// set format range completely encompasses this existing range
					range.format._.__merge(format);
				}
				else if (range.start >= beginIndex && range.start < endIndex && range.end > beginIndex)
				{
					// set format range is within the first part of the range
					newRange = new TextFormatRange(range.format._.clone(), range.start, endIndex);
					newRange.format._.__merge(format);
					__textEngine.textFormatRanges.insertAt(index, newRange);
					range.start = endIndex;
					index++;
				}
				else if (range.start < beginIndex && range.end > beginIndex && range.end >= endIndex)
				{
					// set format range is within the second part of the range
					newRange = new TextFormatRange(range.format._.clone(), beginIndex, range.end);
					newRange.format._.__merge(format);
					__textEngine.textFormatRanges.insertAt(index + 1, newRange);
					range.end = beginIndex;
					index++;
				}

				index++;
				// TODO: Remove duplicates?
			}
		}

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();
	}

	public override function __allowMouseFocus():Bool
	{
		return __textEngine.type == INPUT || tabEnabled || selectable;
	}

	public function __caretBeginningOfLine():Void
	{
		if (__selectionIndex == __caretIndex || __caretIndex < __selectionIndex)
		{
			__caretIndex = getLineOffset(getLineIndexOfChar(__caretIndex));
		}
		else
		{
			__selectionIndex = getLineOffset(getLineIndexOfChar(__selectionIndex));
		}
	}

	public function __caretEndOfLine():Void
	{
		var lineIndex;

		if (__selectionIndex == __caretIndex)
		{
			lineIndex = getLineIndexOfChar(__caretIndex);
		}
		else
		{
			lineIndex = getLineIndexOfChar(Std.int(Math.max(__caretIndex, __selectionIndex)));
		}

		if (lineIndex < __textEngine.numLines - 1)
		{
			__caretIndex = getLineOffset(lineIndex + 1) - 1;
		}
		else
		{
			__caretIndex = __text.length;
		}
	}

	public function __caretNextCharacter():Void
	{
		if (__caretIndex < __text.length)
		{
			__caretIndex++;
		}
	}

	public function __caretNextLine(lineIndex:Null<Int> = null, caretIndex:Null<Int> = null):Void
	{
		if (lineIndex == null)
		{
			lineIndex = getLineIndexOfChar(__caretIndex);
		}

		if (lineIndex < __textEngine.numLines - 1)
		{
			if (caretIndex == null)
			{
				caretIndex = __caretIndex;
			}

			__caretIndex = __getCharIndexOnDifferentLine(caretIndex, lineIndex + 1);
		}
		else
		{
			__caretIndex = __text.length;
		}
	}

	public function __caretPreviousCharacter():Void
	{
		if (__caretIndex > 0)
		{
			__caretIndex--;
		}
	}

	public function __caretPreviousLine(lineIndex:Null<Int> = null, caretIndex:Null<Int> = null):Void
	{
		if (lineIndex == null)
		{
			lineIndex = getLineIndexOfChar(__caretIndex);
		}

		if (lineIndex > 0)
		{
			if (caretIndex == null)
			{
				caretIndex = __caretIndex;
			}

			__caretIndex = __getCharIndexOnDifferentLine(caretIndex, lineIndex - 1);
		}
		else
		{
			__caretIndex = 0;
		}
	}

	public function __disableInput():Void
	{
		if (__inputEnabled && stage != null)
		{
			var window = stage.limeWindow;

			window.textInputEnabled = false;
			window.onTextInput.remove(window_onTextInput);

			__inputEnabled = false;
			__stopCursorTimer();
		}
	}

	public override function __dispatch(event:Event):Bool
	{
		if (event.eventPhase == AT_TARGET && event.type == MouseEvent.MOUSE_UP)
		{
			var event:MouseEvent = cast event;
			var group = __getGroup(mouseX, mouseY, true);

			if (group != null)
			{
				var url = group.format.url;

				if (url != null && url != "")
				{
					if (StringTools.startsWith(url, "event:"))
					{
						dispatchEvent(new TextEvent(TextEvent.LINK, false, false, url.substr(6)));
					}
					else
					{
						Lib.getURL(new URLRequest(url));
					}
				}
			}
		}

		return super.__dispatch(event);
	}

	public function __enableInput():Void
	{
		if (stage != null)
		{
			var window = stage.limeWindow;

			window.textInputEnabled = true;

			if (!window.onTextInput.has(window_onTextInput))
			{
				window.onTextInput.add(window_onTextInput);
			}

			if (!__inputEnabled)
			{
				__inputEnabled = true;
				__startCursorTimer();
			}
		}
	}

	public inline function __getAdvance(position):Float
	{
		#if openfl_html5
		return position;
		#else
		return position.advance.x;
		#end
	}

	public override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		__updateLayout();

		var bounds = _Rectangle.__pool.get();
		bounds.copyFrom(__textEngine.bounds);

		matrix.tx += __offsetX;
		matrix.ty += __offsetY;

		bounds._.__transform(bounds, matrix);

		rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		_Rectangle.__pool.release(bounds);
	}

	public function __getCharBoundaries(charIndex:Int, rect:Rectangle):Bool
	{
		if (charIndex < 0 || charIndex > __text.length - 1) return false;

		__updateLayout();

		for (group in __textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex < group.endIndex)
			{
				try
				{
					var x = group.offsetX;

					for (i in 0...(charIndex - group.startIndex))
					{
						x += group.getAdvance(i);
					}

					// TODO: Is this actually right for combining characters?
					var lastPosition = group.getAdvance(charIndex - group.startIndex);

					rect.setTo(x, group.offsetY, lastPosition, group.ascent + group.descent);
					return true;
				}
				catch (e:Dynamic) {}
			}
		}

		return false;
	}

	public function __getCharIndexOnDifferentLine(charIndex:Int, lineIndex:Int):Int
	{
		if (charIndex < 0 || charIndex > __text.length) return -1;
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;

		var x:Null<Float> = null, y:Null<Float> = null;

		for (group in __textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex <= group.endIndex)
			{
				x = group.offsetX;

				for (i in 0...(charIndex - group.startIndex))
				{
					x += group.getAdvance(i);
				}

				if (y != null) return __getPosition(x, y);
			}

			if (group.lineIndex == lineIndex)
			{
				y = group.offsetY + group.height / 2;

				for (i in 0...scrollV - 1)
				{
					y -= __textEngine.lineHeights[i];
				}

				if (x != null) return __getPosition(x, y);
			}
		}

		return -1;
	}

	public override function __getCursor():MouseCursor
	{
		var group = __getGroup(mouseX, mouseY, true);

		if (group != null && group.format.url != "")
		{
			return BUTTON;
		}
		else if (__textEngine.selectable)
		{
			return IBEAM;
		}

		return null;
	}

	public function __getGroup(x:Float, y:Float, precise = false):TextLayoutGroup
	{
		__updateLayout();

		x += scrollH;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		if (!precise && y > __textEngine.textHeight) y = __textEngine.textHeight;

		var firstGroup = true;
		var group, nextGroup;

		for (i in 0...__textEngine.layoutGroups.length)
		{
			group = __textEngine.layoutGroups[i];

			if (i < __textEngine.layoutGroups.length - 1)
			{
				nextGroup = __textEngine.layoutGroups[i + 1];
			}
			else
			{
				nextGroup = null;
			}

			if (firstGroup)
			{
				if (y < group.offsetY) y = group.offsetY;
				if (x < group.offsetX) x = group.offsetX;
				firstGroup = false;
			}

			if ((y >= group.offsetY && y <= group.offsetY + group.height) || (!precise && nextGroup == null))
			{
				if ((x >= group.offsetX && x <= group.offsetX + group.width)
					|| (!precise && (nextGroup == null || nextGroup.lineIndex != group.lineIndex)))
				{
					return group;
				}
			}
		}

		return null;
	}

	public function __getPosition(x:Float, y:Float):Int
	{
		var group = __getGroup(x, y);

		if (group == null)
		{
			return __text.length;
		}

		var advance = 0.0;

		for (i in 0...group.positions.length)
		{
			advance += group.getAdvance(i);

			if (x <= group.offsetX + advance)
			{
				if (x <= group.offsetX + (advance - group.getAdvance(i)) + (group.getAdvance(i) / 2))
				{
					return group.startIndex + i;
				}
				else
				{
					return (group.startIndex + i < group.endIndex) ? group.startIndex + i + 1 : group.endIndex;
				}
			}
		}

		return group.endIndex;
	}

	public override function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__scrollRect == null)
		{
			__updateLayout();

			var bounds = _Rectangle.__pool.get();
			bounds.copyFrom(__textEngine.bounds);

			// matrix.tx += __offsetX;
			// matrix.ty += __offsetY;

			bounds._.__transform(bounds, matrix);

			rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

			_Rectangle.__pool.release(bounds);
		}
		else
		{
			super.__getRenderBounds(rect, matrix);
		}
	}

	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		if (mask != null && !(mask._ : _DisplayObject).__hitTestMask(x, y)) return false;

		__getRenderTransform();
		__updateLayout();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

		if (__textEngine.bounds.contains(px, py))
		{
			if (stack != null)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	public override function __hitTestMask(x:Float, y:Float):Bool
	{
		__getRenderTransform();
		__updateLayout();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

		if (__textEngine.bounds.contains(px, py))
		{
			return true;
		}

		return false;
	}

	public function __replaceSelectedText(value:String, restrict:Bool = true):Void
	{
		if (value == null) value = "";
		if (value == "" && __selectionIndex == __caretIndex) return;

		var startIndex = __caretIndex < __selectionIndex ? __caretIndex : __selectionIndex;
		var endIndex = __caretIndex > __selectionIndex ? __caretIndex : __selectionIndex;

		if (startIndex == endIndex && __textEngine.maxChars > 0 && __text.length == __textEngine.maxChars) return;

		if (startIndex > __text.length) startIndex = __text.length;
		if (endIndex > __text.length) endIndex = __text.length;
		if (endIndex < startIndex)
		{
			var cache = endIndex;
			endIndex = startIndex;
			startIndex = cache;
		}
		if (startIndex < 0) startIndex = 0;

		__replaceText(startIndex, endIndex, value, restrict);

		var i = startIndex + value.length;
		if (i > __text.length) i = __text.length;

		setSelection(i, i);

		// TODO: Solution where this is not run twice (run inside replaceText above)
		__updateScrollH();
	}

	public function __replaceText(beginIndex:Int, endIndex:Int, newText:String, restrict:Bool):Void
	{
		if (endIndex < beginIndex || beginIndex < 0 || endIndex > __text.length || newText == null) return;

		if (restrict)
		{
			newText = __textEngine.restrictText(newText);

			if (__textEngine.maxChars > 0)
			{
				var removeLength = (endIndex - beginIndex);
				var maxLength = __textEngine.maxChars - __text.length + removeLength;

				if (maxLength <= 0)
				{
					newText = "";
				}
				else if (maxLength < newText.length)
				{
					newText = newText.substr(0, maxLength);
				}
			}
		}

		__updateText(__text.substring(0, beginIndex) + newText + __text.substring(endIndex));
		if (endIndex > __text.length) endIndex = __text.length;

		var offset = newText.length - (endIndex - beginIndex);

		var i = 0;
		var range;

		while (i < __textEngine.textFormatRanges.length)
		{
			range = __textEngine.textFormatRanges[i];

			if (beginIndex == endIndex)
			{
				if (range.end < beginIndex)
				{
					// do nothing, range is completely before insertion point
				}
				else if (range.start > endIndex)
				{
					// shift range, range is after insertion point
					range.start += offset;
					range.end += offset;
				}
				else
				{
					if (range.start < range.end && range.end == beginIndex && i < __textEngine.textFormatRanges.length - 1)
					{
						// do nothing, insertion point is between two ranges, so it belongs to the next range
						// unless there are no more ranges after this one (inserting at the end of the text)
					}
					else
					{
						// add to range, insertion point is within range
						range.end += offset;
					}
				}
			}
			else
			{
				if (range.end < beginIndex)
				{
					// do nothing, range is before selection
				}
				else if (range.start >= endIndex)
				{
					// shift range, range is completely after selection
					range.start += offset;
					range.end += offset;
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// delete range, range is encompassed by selection
					if (__textEngine.textFormatRanges.length > 1)
					{
						__textEngine.textFormatRanges.splice(i, 1);
					}
					else
					{
						// don't delete if it's the last range though, just modify properties
						range.start = 0;
						range.end = newText.length;
					}
				}
				else if (range.start <= beginIndex)
				{
					if (range.end < endIndex)
					{
						// modify range, range ends before the selection ends
						range.end = beginIndex;
					}
					else
					{
						// modify range, range ends where or after the selection ends
						range.end += offset;
					}
				}
				else
				{
					// modify range, selection begins before the range
					// for deletion: entire range shifts leftward
					// for addition: added text gains the format of endIndex
					range.start = beginIndex;
					range.end += offset;
				}
			}

			i++;
		}

		__updateScrollV();
		__updateScrollH();

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();
	}

	public function __startCursorTimer():Void
	{
		__cursorTimer = Timer.delay(__startCursorTimer, 600);
		__showCursor = !__showCursor;
		__dirty = true;
		__setRenderDirty();
	}

	public function __startTextInput():Void
	{
		if (__caretIndex < 0)
		{
			__caretIndex = __text.length;
			__selectionIndex = __caretIndex;
		}

		var enableInput = #if openfl_html5 (DisplayObject._.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;

		if (enableInput)
		{
			__enableInput();
		}
	}

	public function __stopCursorTimer():Void
	{
		if (__cursorTimer != null)
		{
			__cursorTimer.stop();
			__cursorTimer = null;
		}

		if (__showCursor)
		{
			__showCursor = false;
			__dirty = true;
			__setRenderDirty();
		}
	}

	public function __stopTextInput():Void
	{
		var disableInput = #if openfl_html5 (DisplayObject._.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;

		if (disableInput)
		{
			__disableInput();
		}
	}

	public override function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		var transformDirty = __transformDirty;

		__updateSingle(transformOnly, updateChildren);

		if (transformDirty)
		{
			__renderTransform._.__translateTransformed(__offsetX, __offsetY);
		}
	}

	public function __updateLayout():Void
	{
		if (__layoutDirty)
		{
			var cacheWidth = __textEngine.width;
			__textEngine.update();

			if (__textEngine.autoSize != NONE)
			{
				if (__textEngine.width != cacheWidth)
				{
					switch (__textEngine.autoSize)
					{
						case RIGHT:
							x += cacheWidth - __textEngine.width;

						case CENTER:
							x += (cacheWidth - __textEngine.width) / 2;

						default:
					}
				}

				__textEngine.getBounds();
			}

			__layoutDirty = false;
		}
	}

	public function __updateScrollH():Void
	{
		if (!multiline && type == INPUT)
		{
			__layoutDirty = true;
			__updateLayout();

			var offsetX = __textEngine.textWidth - __textEngine.width + 4;

			if (offsetX > 0)
			{
				// TODO: Handle __selectionIndex on drag select?
				// TODO: Update scrollH by one character width at a time when able

				if (__caretIndex >= text.length)
				{
					scrollH = Math.ceil(offsetX);
				}
				else
				{
					var caret = _Rectangle.__pool.get();
					__getCharBoundaries(__caretIndex, caret);

					if (caret.x < scrollH)
					{
						scrollH = Math.floor(caret.x - 2);
					}
					else if (caret.x > scrollH + __textEngine.width)
					{
						scrollH = Math.ceil(caret.x - __textEngine.width - 2);
					}

					_Rectangle.__pool.release(caret);
				}
			}
			else
			{
				scrollH = 0;
			}
		}
	}

	public function __updateScrollV():Void
	{
		__layoutDirty = true;
		__updateLayout();

		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex == -1 && __caretIndex > 0)
		{
			// new paragraph
			lineIndex = getLineIndexOfChar(__caretIndex - 1) + 1;
		}

		if (lineIndex + 1 < scrollV)
		{
			scrollV = lineIndex + 1;
		}
		else if (lineIndex + 1 > bottomScrollV)
		{
			var i = lineIndex, tempHeight = 0.0;

			while (i >= 0)
			{
				if (tempHeight + __textEngine.lineHeights[i] <= height - 4)
				{
					tempHeight += __textEngine.lineHeights[i];
					i--;
				}
				else
					break;
			}

			scrollV = i + 2;
		}
		else
		{
			// TODO: can this be avoided? this doesn't need to hit the setter each time, just a couple times
			scrollV = scrollV;
		}
	}

	public function __updateText(value:String):Void
	{
		#if openfl_html5
		if (DisplayObject._.__supportDOM && __renderedOnCanvasWhileOnDOM)
		{
			__forceCachedBitmapUpdate = __text != value;
		}
		#end

		// applies maxChars and restrict on text

		__textEngine.text = value;
		__text = __textEngine.text;

		if (__text.length < __caretIndex)
		{
			__selectionIndex = __caretIndex = __text.length;
		}

		if (!__displayAsPassword #if openfl_html5 || (DisplayObject._.__supportDOM && !__renderedOnCanvasWhileOnDOM) #end)
		{
			__textEngine.text = __text;
		}
		else
		{
			var length = text.length;
			var mask = "";

			for (i in 0...length)
			{
				mask += "*";
			}

			__textEngine.text = mask;
		}
	}

	// Getters & Setters
	private function get_antiAliasType():AntiAliasType
	{
		return __textEngine.antiAliasType;
	}

	private function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		if (value != __textEngine.antiAliasType)
		{
			// __dirty = true;
		}

		return __textEngine.antiAliasType = value;
	}

	private function get_autoSize():TextFieldAutoSize
	{
		return __textEngine.autoSize;
	}

	private function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		if (value != __textEngine.autoSize)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.autoSize = value;
	}

	private function get_background():Bool
	{
		return __textEngine.background;
	}

	private function set_background(value:Bool):Bool
	{
		if (value != __textEngine.background)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.background = value;
	}

	private function get_backgroundColor():Int
	{
		return __textEngine.backgroundColor;
	}

	private function set_backgroundColor(value:Int):Int
	{
		if (value != __textEngine.backgroundColor)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.backgroundColor = value;
	}

	private function get_border():Bool
	{
		return __textEngine.border;
	}

	private function set_border(value:Bool):Bool
	{
		if (value != __textEngine.border)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.border = value;
	}

	private function get_borderColor():Int
	{
		return __textEngine.borderColor;
	}

	private function set_borderColor(value:Int):Int
	{
		if (value != __textEngine.borderColor)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.borderColor = value;
	}

	private function get_bottomScrollV():Int
	{
		__updateLayout();

		return __textEngine.bottomScrollV;
	}

	private function get_caretIndex():Int
	{
		return __caretIndex;
	}

	private function get_defaultTextFormat():TextFormat
	{
		return __textFormat.clone();
	}

	private function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		__textFormat._.__merge(value);

		__layoutDirty = true;
		__dirty = true;
		__setRenderDirty();

		return value;
	}

	private function get_displayAsPassword():Bool
	{
		return __displayAsPassword;
	}

	private function set_displayAsPassword(value:Bool):Bool
	{
		if (value != __displayAsPassword)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();

			__displayAsPassword = value;
			__updateText(__text);
		}

		return value;
	}

	private function get_embedFonts():Bool
	{
		return __textEngine.embedFonts;
	}

	private function set_embedFonts(value:Bool):Bool
	{
		// if (value != __textEngine.embedFonts) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		return __textEngine.embedFonts = value;
	}

	private function get_gridFitType():GridFitType
	{
		return __textEngine.gridFitType;
	}

	private function set_gridFitType(value:GridFitType):GridFitType
	{
		// if (value != __textEngine.gridFitType) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		return __textEngine.gridFitType = value;
	}

	public override function get_height():Float
	{
		__updateLayout();
		return __textEngine.height * Math.abs(scaleY);
	}

	public override function set_height(value:Float):Float
	{
		if (value != __textEngine.height)
		{
			__setTransformDirty();
			__setParentRenderDirty();
			__setRenderDirty();
			__dirty = true;
			__layoutDirty = true;

			__textEngine.height = value;
		}

		return __textEngine.height * Math.abs(scaleY);
	}

	private function get_htmlText():String
	{
		#if openfl_html5
		return __isHTML ? __rawHtmlText : __text;
		#else
		return __text;
		#end
	}

	private function set_htmlText(value:String):String
	{
		if (!__isHTML || __text != value)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		__isHTML = true;

		#if openfl_html5
		__rawHtmlText = value;
		#end

		value = HTMLParser.parse(value, __textFormat, __textEngine.textFormatRanges);

		#if openfl_html5
		if (DisplayObject._.__supportDOM)
		{
			if (__textEngine.textFormatRanges.length > 1)
			{
				__textEngine.textFormatRanges.splice(1, __textEngine.textFormatRanges.length - 1);
			}

			var range = __textEngine.textFormatRanges[0];
			range.format = __textFormat;
			range.start = 0;

			if (__renderedOnCanvasWhileOnDOM)
			{
				range.end = value.length;
				__updateText(value);
			}
			else
			{
				range.end = __rawHtmlText.length;
				__updateText(__rawHtmlText);
			}
		}
		else
		{
			__updateText(value);
		}
		#else
		__updateText(value);
		#end
		__updateScrollV();

		return value;
	}

	private function get_length():Int
	{
		if (__text != null)
		{
			return __text.length;
		}

		return 0;
	}

	private function get_maxChars():Int
	{
		return __textEngine.maxChars;
	}

	private function set_maxChars(value:Int):Int
	{
		if (value != __textEngine.maxChars)
		{
			__textEngine.maxChars = value;

			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return value;
	}

	private function get_maxScrollH():Int
	{
		__updateLayout();

		return __textEngine.maxScrollH;
	}

	private function get_maxScrollV():Int
	{
		__updateLayout();

		return __textEngine.maxScrollV;
	}

	private function get_mouseWheelEnabled():Bool
	{
		return __mouseWheelEnabled;
	}

	private function set_mouseWheelEnabled(value:Bool):Bool
	{
		return __mouseWheelEnabled = value;
	}

	private function get_multiline():Bool
	{
		return __textEngine.multiline;
	}

	private function set_multiline(value:Bool):Bool
	{
		if (value != __textEngine.multiline)
		{
			__dirty = true;
			__layoutDirty = true;
			__updateText(__text);
			// __updateScrollV();
			__updateScrollH();
			__setRenderDirty();
		}

		return __textEngine.multiline = value;
	}

	private function get_numLines():Int
	{
		__updateLayout();

		return __textEngine.numLines;
	}

	private function get_restrict():String
	{
		return __textEngine.restrict;
	}

	private function set_restrict(value:String):String
	{
		if (__textEngine.restrict != value)
		{
			__textEngine.restrict = value;
			__updateText(__text);
		}

		return value;
	}

	private function get_scrollH():Int
	{
		return __textEngine.scrollH;
	}

	private function set_scrollH(value:Int):Int
	{
		__updateLayout();

		if (value > __textEngine.maxScrollH) value = __textEngine.maxScrollH;
		if (value < 0) value = 0;

		if (value != __textEngine.scrollH)
		{
			__dirty = true;
			__setRenderDirty();
			__textEngine.scrollH = value;
			dispatchEvent(new Event(Event.SCROLL));
		}

		return __textEngine.scrollH;
	}

	private function get_scrollV():Int
	{
		return __textEngine.scrollV;
	}

	private function set_scrollV(value:Int):Int
	{
		__updateLayout();

		if (value > 0 && value != __textEngine.scrollV)
		{
			__dirty = true;
			__setRenderDirty();
			__textEngine.scrollV = value;
			dispatchEvent(new Event(Event.SCROLL));
		}

		return __textEngine.scrollV;
	}

	private function get_selectable():Bool
	{
		return __textEngine.selectable;
	}

	private function set_selectable(value:Bool):Bool
	{
		if (value != __textEngine.selectable && type == INPUT)
		{
			if (stage != null && stage.focus == this)
			{
				__startTextInput();
			}
			else if (!value)
			{
				__stopTextInput();
			}
		}

		return __textEngine.selectable = value;
	}

	private function get_selectionBeginIndex():Int
	{
		return Std.int(Math.min(__caretIndex, __selectionIndex));
	}

	private function get_selectionEndIndex():Int
	{
		return Std.int(Math.max(__caretIndex, __selectionIndex));
	}

	private function get_sharpness():Float
	{
		return __textEngine.sharpness;
	}

	private function set_sharpness(value:Float):Float
	{
		if (value != __textEngine.sharpness)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.sharpness = value;
	}

	public override function get_tabEnabled():Bool
	{
		return (__tabEnabled == null ? __textEngine.type == INPUT : __tabEnabled);
	}

	private function get_text():String
	{
		return __text;
	}

	private function set_text(value:String):String
	{
		if (__isHTML || __text != value)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}
		else
		{
			return value;
		}

		if (__textEngine.textFormatRanges.length > 1)
		{
			__textEngine.textFormatRanges.splice(1, __textEngine.textFormatRanges.length - 1);
		}

		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = value.length;

		__isHTML = false;

		__updateText(value);
		__updateScrollV();

		return value;
	}

	private function get_textColor():Int
	{
		return __textFormat.color;
	}

	private function set_textColor(value:Int):Int
	{
		if (value != __textFormat.color)
		{
			__dirty = true;
			__setRenderDirty();
		}

		for (range in __textEngine.textFormatRanges)
		{
			range.format.color = value;
		}

		return __textFormat.color = value;
	}

	private function get_textWidth():Float
	{
		__updateLayout();
		return __textEngine.textWidth;
	}

	private function get_textHeight():Float
	{
		__updateLayout();
		return __textEngine.textHeight;
	}

	private function get_type():TextFieldType
	{
		return __textEngine.type;
	}

	private function set_type(value:TextFieldType):TextFieldType
	{
		if (value != __textEngine.type)
		{
			if (value == TextFieldType.INPUT)
			{
				addEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);

				this_onFocusIn(null);
				__textEngine._.__useIntAdvances = true;
			}
			else
			{
				removeEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);

				__stopTextInput();
				__textEngine._.__useIntAdvances = null;
			}

			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.type = value;
	}

	public override function get_width():Float
	{
		__updateLayout();
		return __textEngine.width * Math.abs(__scaleX);
	}

	public override function set_width(value:Float):Float
	{
		if (value != __textEngine.width)
		{
			__setTransformDirty();
			__setParentRenderDirty();
			__setRenderDirty();
			__dirty = true;
			__layoutDirty = true;

			__textEngine.width = value;
		}

		return __textEngine.width * Math.abs(__scaleX);
	}

	private function get_wordWrap():Bool
	{
		return __textEngine.wordWrap;
	}

	private function set_wordWrap(value:Bool):Bool
	{
		if (value != __textEngine.wordWrap)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.wordWrap = value;
	}

	public override function get_x():Float
	{
		return __transform.tx + __offsetX;
	}

	public override function set_x(value:Float):Float
	{
		if (value != __transform.tx + __offsetX)
		{
			__setTransformDirty();
			__setParentRenderDirty();
		}

		return __transform.tx = value - __offsetX;
	}

	public override function get_y():Float
	{
		return __transform.ty + __offsetY;
	}

	public override function set_y(value:Float):Float
	{
		if (value != __transform.ty + __offsetY)
		{
			__setTransformDirty();
			__setParentRenderDirty();
		}

		return __transform.ty = value - __offsetY;
	}

	// Event Handlers
	public function stage_onMouseMove(event:MouseEvent):Void
	{
		if (stage == null) return;

		if (selectable && __selectionIndex >= 0)
		{
			__updateLayout();

			var position = __getPosition(mouseX + scrollH, mouseY);

			if (position != __caretIndex)
			{
				__caretIndex = position;

				var setDirty = true;

				#if openfl_html5
				if (DisplayObject._.__supportDOM)
				{
					if (__renderedOnCanvasWhileOnDOM)
					{
						__forceCachedBitmapUpdate = true;
					}
					setDirty = false;
				}
				#end

				if (setDirty)
				{
					__dirty = true;
					__setRenderDirty();
				}
			}
		}
	}

	public function stage_onMouseUp(event:MouseEvent):Void
	{
		if (stage == null) return;

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);

		if (stage.focus == this)
		{
			__getWorldTransform();
			__updateLayout();

			var upPos:Int = __getPosition(mouseX + scrollH, mouseY);
			var leftPos:Int;
			var rightPos:Int;

			leftPos = Std.int(Math.min(__selectionIndex, upPos));
			rightPos = Std.int(Math.max(__selectionIndex, upPos));

			__selectionIndex = leftPos;
			__caretIndex = rightPos;

			if (__inputEnabled)
			{
				this_onFocusIn(null);

				__stopCursorTimer();
				__startCursorTimer();

				#if openfl_html5
				if (DisplayObject._.__supportDOM && __renderedOnCanvasWhileOnDOM)
				{
					__forceCachedBitmapUpdate = true;
				}
				#end
			}
		}
	}

	public function this_onAddedToStage(event:Event):Void
	{
		this_onFocusIn(null);
	}

	public function this_onFocusIn(event:FocusEvent):Void
	{
		if (type == INPUT && stage != null && stage.focus == this)
		{
			__startTextInput();
		}
	}

	public function this_onFocusOut(event:FocusEvent):Void
	{
		__stopCursorTimer();

		// TODO: Better system

		if (event.relatedObject == null || !Std.is(event.relatedObject, TextField))
		{
			__stopTextInput();
		}
		else
		{
			if (stage != null)
			{
				var window = stage.limeWindow;
				window.onTextInput.remove(window_onTextInput);
			}

			__inputEnabled = false;
		}

		if (__selectionIndex != __caretIndex)
		{
			__selectionIndex = __caretIndex;
			__dirty = true;
			__setRenderDirty();
		}
	}

	public function this_onKeyDown(event:KeyboardEvent):Void
	{
		#if !openfl_doc_gen
		if (type == INPUT)
		{
			switch (event.keyCode)
			{
				case Keyboard.ENTER, Keyboard.NUMPAD_ENTER:
					if (__textEngine.multiline)
					{
						var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, "\n");

						dispatchEvent(te);

						if (!te.isDefaultPrevented())
						{
							__replaceSelectedText("\n", true);

							dispatchEvent(new Event(Event.CHANGE, true));
						}
					}

				case Keyboard.BACKSPACE:
					if (__selectionIndex == __caretIndex && __caretIndex > 0)
					{
						__selectionIndex = __caretIndex - 1;
					}

					if (__selectionIndex != __caretIndex)
					{
						replaceSelectedText("");
						__selectionIndex = __caretIndex;

						dispatchEvent(new Event(Event.CHANGE, true));
					}

				case Keyboard.DELETE:
					if (__selectionIndex == __caretIndex && __caretIndex < __text.length)
					{
						__selectionIndex = __caretIndex + 1;
					}

					if (__selectionIndex != __caretIndex)
					{
						replaceSelectedText("");
						__selectionIndex = __caretIndex;

						dispatchEvent(new Event(Event.CHANGE, true));
					}

				case Keyboard.LEFT if (selectable):
					if (event.commandKey)
					{
						__caretBeginningOfLine();

						if (!event.shiftKey)
						{
							__selectionIndex = __caretIndex;
						}
					}
					else if (event.shiftKey)
					{
						__caretPreviousCharacter();
					}
					else
					{
						if (__selectionIndex == __caretIndex)
						{
							__caretPreviousCharacter();
						}
						else
						{
							__caretIndex = Std.int(Math.min(__caretIndex, __selectionIndex));
						}

						__selectionIndex = __caretIndex;
					}

					__updateScrollH();
					__updateScrollV();
					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.RIGHT if (selectable):
					if (event.commandKey)
					{
						__caretEndOfLine();

						if (!event.shiftKey)
						{
							__selectionIndex = __caretIndex;
						}
					}
					else if (event.shiftKey)
					{
						__caretNextCharacter();
					}
					else
					{
						if (__selectionIndex == __caretIndex)
						{
							__caretNextCharacter();
						}
						else
						{
							__caretIndex = Std.int(Math.max(__caretIndex, __selectionIndex));
						}

						__selectionIndex = __caretIndex;
					}

					__updateScrollH();
					__updateScrollV();

					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.DOWN if (selectable):
					if (!__textEngine.multiline) return;

					if (event.shiftKey)
					{
						__caretNextLine();
					}
					else
					{
						if (__selectionIndex == __caretIndex)
						{
							__caretNextLine();
						}
						else
						{
							var lineIndex = getLineIndexOfChar(Std.int(Math.max(__caretIndex, __selectionIndex)));
							__caretNextLine(lineIndex, Std.int(Math.min(__caretIndex, __selectionIndex)));
						}

						__selectionIndex = __caretIndex;
					}

					__updateScrollV();

					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.UP if (selectable):
					if (!__textEngine.multiline) return;

					if (event.shiftKey)
					{
						__caretPreviousLine();
					}
					else
					{
						if (__selectionIndex == __caretIndex)
						{
							__caretPreviousLine();
						}
						else
						{
							var lineIndex = getLineIndexOfChar(Std.int(Math.min(__caretIndex, __selectionIndex)));
							__caretPreviousLine(lineIndex, Std.int(Math.min(__caretIndex, __selectionIndex)));
						}

						__selectionIndex = __caretIndex;
					}

					__updateScrollV();

					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.HOME if (selectable):
					__caretBeginningOfLine();
					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.END if (selectable):
					__caretEndOfLine();
					__stopCursorTimer();
					__startCursorTimer();

				case Keyboard.C if (#if mac event.commandKey #else event.ctrlKey #end):
					if (__caretIndex != __selectionIndex)
					{
						Clipboard.generalClipboard.setData(TEXT_FORMAT, __text.substring(__caretIndex, __selectionIndex));
					}

				case Keyboard.X if (#if mac event.commandKey #else event.ctrlKey #end):
					if (__caretIndex != __selectionIndex)
					{
						Clipboard.generalClipboard.setData(TEXT_FORMAT, __text.substring(__caretIndex, __selectionIndex));

						replaceSelectedText("");
						dispatchEvent(new Event(Event.CHANGE, true));
					}

				#if !js
				case Keyboard.V:
					if (#if mac event.commandKey #else event.ctrlKey #end)
					{
						if (Clipboard.generalClipboard.getData(TEXT_FORMAT) != null)
						{
							var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, Clipboard.generalClipboard.getData(TEXT_FORMAT));

							dispatchEvent(te);

							if (!te.isDefaultPrevented())
							{
								__replaceSelectedText(Clipboard.generalClipboard.getData(TEXT_FORMAT), true);

								dispatchEvent(new Event(Event.CHANGE, true));
							}
						}
					}
					else
					{
						// TODO: does this need to occur?
						__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;
					}
				#end

				case Keyboard.A if (selectable):
					if (#if mac event.commandKey #else event.ctrlKey #end)
					{
						__caretIndex = __text.length;
						__selectionIndex = 0;
					}

				default:
			}
		}
		else if (selectable && event.keyCode == Keyboard.C && (event.commandKey || event.ctrlKey))
		{
			if (__caretIndex != __selectionIndex)
			{
				Clipboard.generalClipboard.setData(TEXT_FORMAT, __text.substring(__caretIndex, __selectionIndex));
			}
		}
		#end
	}

	public function this_onMouseDown(event:MouseEvent):Void
	{
		if (!selectable && type != INPUT) return;

		__updateLayout();

		__caretIndex = __getPosition(mouseX + scrollH, mouseY);
		__selectionIndex = __caretIndex;

		if (!DisplayObject._.__supportDOM)
		{
			__dirty = true;
			__setRenderDirty();
		}

		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
	}

	public function this_onMouseWheel(event:MouseEvent):Void
	{
		if (mouseWheelEnabled)
		{
			scrollV -= event.delta;
		}
	}

	public function this_onDoubleClick(event:MouseEvent):Void
	{
		if (selectable)
		{
			__updateLayout();

			var delimiters:Array<String> = ['\n', '.', '!', '?', ',', ' ', ';', ':', '(', ')', '-', '_', '/'];

			var txtStr:String = __text;
			var leftPos:Int = -1;
			var rightPos:Int = txtStr.length;
			var pos:Int = 0;
			var startPos:Int = Std.int(Math.max(__caretIndex, 1));
			if (txtStr.length > 0 && __caretIndex >= 0 && rightPos >= __caretIndex)
			{
				for (c in delimiters)
				{
					pos = txtStr.lastIndexOf(c, startPos - 1);
					if (pos > leftPos) leftPos = pos + 1;

					pos = txtStr.indexOf(c, startPos);
					if (pos < rightPos && pos != -1) rightPos = pos;
				}

				if (leftPos != rightPos)
				{
					setSelection(leftPos, rightPos);

					var setDirty:Bool = true;
					#if openfl_html5
					if (DisplayObject._.__supportDOM)
					{
						if (__renderedOnCanvasWhileOnDOM)
						{
							__forceCachedBitmapUpdate = true;
						}
						setDirty = false;
					}
					#end
					if (setDirty)
					{
						__dirty = true;
						__setRenderDirty();
					}
				}
			}
		}
	}

	public function window_onTextInput(value:String):Void
	{
		parent._.__replaceSelectedText(value, true);

		// TODO: Dispatch change if at max chars?
		parent.dispatchEvent(new Event(Event.CHANGE, true));
	}
}
