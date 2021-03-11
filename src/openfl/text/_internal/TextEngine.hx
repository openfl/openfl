package openfl.text._internal;

import haxe.Timer;
import openfl.display3D._internal.GLTexture;
import openfl.utils._internal.Log;
import openfl.Vector;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
#if lime
import lime.graphics.cairo.CairoFontFace;
import lime.system.System;
#end
#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)
@SuppressWarnings("checkstyle:FieldDocComment")
class TextEngine
{
	private static inline var GUTTER:Int = 2;
	private static inline var UTF8_TAB:Int = 9;
	private static inline var UTF8_ENDLINE:Int = 10;
	private static inline var UTF8_SPACE:Int = 32;
	private static inline var UTF8_HYPHEN:Int = 0x2D;
	private static var __defaultFonts:Map<String, Font> = new Map();
	#if (js && html5)
	private static var __context:CanvasRenderingContext2D;
	#end

	public var antiAliasType:AntiAliasType;
	public var autoSize:TextFieldAutoSize;
	public var background:Bool;
	public var backgroundColor:Int;
	public var border:Bool;
	public var borderColor:Int;
	public var bottomScrollV(get, null):Int;
	public var bounds:Rectangle;
	public var caretIndex:Int;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var height:Float;
	public var layoutGroups:Vector<TextLayoutGroup>;
	public var lineAscents:Vector<Float>;
	public var lineBreaks:Vector<Int>;
	public var lineDescents:Vector<Float>;
	public var lineLeadings:Vector<Float>;
	public var lineHeights:Vector<Float>;
	public var lineWidths:Vector<Float>;
	public var maxChars:Int;
	public var maxScrollH(default, null):Int;
	public var maxScrollV(get, null):Int;
	public var multiline:Bool;
	public var numLines(default, null):Int;
	public var restrict(default, set):UTF8String;
	public var scrollH:Int;
	@:isVar public var scrollV(get, set):Int;
	public var selectable:Bool;
	public var sharpness:Float;
	public var text(default, set):UTF8String;
	public var textBounds:Rectangle;
	public var textHeight:Float;
	public var textFormatRanges:Vector<TextFormatRange>;
	public var textWidth:Float;
	public var type:TextFieldType;
	public var width:Float;
	public var wordWrap:Bool;

	private var textField:TextField;
	@:noCompletion private var __cursorTimer:Timer;
	@:noCompletion private var __hasFocus:Bool;
	@:noCompletion private var __isKeyDown:Bool;
	@:noCompletion private var __measuredHeight:Int;
	@:noCompletion private var __measuredWidth:Int;
	@:noCompletion private var __restrictRegexp:EReg;
	@:noCompletion private var __selectionStart:Int;
	@:noCompletion private var __shapeCache:ShapeCache;
	@:noCompletion private var __showCursor:Bool;
	@:noCompletion private var __textFormat:TextFormat;
	@:noCompletion private var __textLayout:TextLayout;
	@:noCompletion private var __texture:GLTexture;
	// @:noCompletion private var __tileData:Map<Tilesheet, Array<Float>>;
	// @:noCompletion private var __tileDataLength:Map<Tilesheet, Int>;
	// @:noCompletion private var __tilesheets:Map<Tilesheet, Bool>;
	private var __useIntAdvances:Null<Bool>;

	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion @:dox(hide) public var __cairoFont:#if lime CairoFontFace #else Dynamic #end;
	@:noCompletion @:dox(hide) public var __font:Font;

	public function new(textField:TextField)
	{
		__shapeCache = new ShapeCache();
		this.textField = textField;

		width = 100;
		height = 100;
		text = "";

		bounds = new Rectangle(0, 0, 0, 0);
		textBounds = new Rectangle(0, 0, 0, 0);

		type = TextFieldType.DYNAMIC;
		autoSize = TextFieldAutoSize.NONE;
		embedFonts = false;
		selectable = true;
		borderColor = 0x000000;
		border = false;
		backgroundColor = 0xffffff;
		background = false;
		gridFitType = GridFitType.PIXEL;
		maxChars = 0;
		multiline = false;
		numLines = 1;
		sharpness = 0;
		scrollH = 0;
		scrollV = 1;
		wordWrap = false;

		lineAscents = new Vector();
		lineBreaks = new Vector();
		lineDescents = new Vector();
		lineLeadings = new Vector();
		lineHeights = new Vector();
		lineWidths = new Vector();
		layoutGroups = new Vector();
		textFormatRanges = new Vector();

		#if (js && html5)
		if (__context == null)
		{
			__context = (cast Browser.document.createElement("canvas") : CanvasElement).getContext("2d");
		}
		#end
	}

	private function createRestrictRegexp(restrict:String):EReg
	{
		var declinedRange = ~/\^(.-.|.)/gu;
		var declined = "";

		var accepted = declinedRange.map(restrict, function(ereg)
		{
			declined += ereg.matched(1);
			return "";
		});

		var testRegexpParts:Array<String> = [];

		if (accepted.length > 0)
		{
			testRegexpParts.push('[^$restrict]');
		}

		if (declined.length > 0)
		{
			testRegexpParts.push('[$declined]');
		}

		return new EReg('(${testRegexpParts.join('|')})', "g");
	}

	private static function findFont(name:String):Font
	{
		#if (js && html5)
		return Font.__fontByName.get(name);
		#elseif lime_cffi
		for (registeredFont in Font.__registeredFonts)
		{
			if (registeredFont == null) continue;

			if (registeredFont.fontName == name
				|| (registeredFont.__fontPath != null
					&& (registeredFont.__fontPath == name || registeredFont.__fontPathWithoutDirectory == name)))
			{
				if (registeredFont.__initialize())
				{
					return registeredFont;
				}
			}
		}

		#if lime_switch
		if (name != null && name.indexOf(":/") == -1) name = null;
		#end

		var font = Font.fromFile(name);

		if (font != null)
		{
			Font.__registeredFonts.push(font);
			return font;
		}
		#end

		return null;
	}

	private static function findFontVariant(format:TextFormat):Font
	{
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;

		if (fontName == null) fontName = "_serif";
		var fontNamePrefix = StringTools.replace(StringTools.replace(fontName, " Normal", ""), " Regular", "");

		if (bold && italic && Font.__fontByName.exists(fontNamePrefix + " Bold Italic"))
		{
			return findFont(fontNamePrefix + " Bold Italic");
		}
		else if (bold && Font.__fontByName.exists(fontNamePrefix + " Bold"))
		{
			return findFont(fontNamePrefix + " Bold");
		}
		else if (italic && Font.__fontByName.exists(fontNamePrefix + " Italic"))
		{
			return findFont(fontNamePrefix + " Italic");
		}

		return findFont(fontName);
	}

	private function getBounds():Void
	{
		var padding = border ? 1 : 0;

		bounds.width = width + padding;
		bounds.height = height + padding;

		var x = width, y = width;

		for (group in layoutGroups)
		{
			if (group.offsetX < x) x = group.offsetX;
			if (group.offsetY < y) y = group.offsetY;
		}

		if (x >= width) x = 2;
		if (y >= height) y = 2;

		#if (js && html5)
		var textHeight = textHeight * 1.185; // measurement isn't always accurate, add padding
		#end

		textBounds.setTo(Math.max(x - 2, 0), Math.max(y - 2, 0), Math.min(textWidth + 4, bounds.width + 4), Math.min(textHeight + 4, bounds.height + 4));
	}

	public static function getFormatHeight(format:TextFormat):Float
	{
		var ascent:Float, descent:Float, leading:Int;

		#if (js && html5)
		__context.font = getFont(format);
		#end

		var font = getFontInstance(format);

		if (format.__ascent != null)
		{
			ascent = format.size * format.__ascent;
			descent = format.size * format.__descent;
		}
		else if (#if lime font != null && font.unitsPerEM != 0 #else false #end)
		{
			#if lime
			ascent = (font.ascender / font.unitsPerEM) * format.size;
			descent = Math.abs((font.descender / font.unitsPerEM) * format.size);
			#else
			ascent = format.size;
			descent = format.size * 0.185;
			#end
		}
		else
		{
			ascent = format.size;
			descent = format.size * 0.185;
		}

		leading = format.leading;

		return ascent + descent + leading;
	}

	public static function getFont(format:TextFormat):String
	{
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;

		if (fontName == null) fontName = "_serif";
		var fontNamePrefix = StringTools.replace(StringTools.replace(fontName, " Normal", ""), " Regular", "");

		if (bold && italic && Font.__fontByName.exists(fontNamePrefix + " Bold Italic"))
		{
			fontName = fontNamePrefix + " Bold Italic";
			bold = false;
			italic = false;
		}
		else if (bold && Font.__fontByName.exists(fontNamePrefix + " Bold"))
		{
			fontName = fontNamePrefix + " Bold";
			bold = false;
		}
		else if (italic && Font.__fontByName.exists(fontNamePrefix + " Italic"))
		{
			fontName = fontNamePrefix + " Italic";
			italic = false;
		}
		else
		{
			// Prevent "extra" bold and italic fonts

			if (bold && (fontName.indexOf(" Bold ") > -1 || StringTools.endsWith(fontName, " Bold")))
			{
				bold = false;
			}

			if (italic && (fontName.indexOf(" Italic ") > -1 || StringTools.endsWith(fontName, " Italic")))
			{
				italic = false;
			}
		}

		var font = italic ? "italic " : "normal ";
		font += "normal ";
		font += bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.leading + format.size + 3) + "px ";

		font += "" + switch (fontName)
		{
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: "'" + ~/^[\s'"]+(.*)[\s'"]+$/.replace(fontName, '$1') + "'";
		}

		return font;
	}

	public static function getFontInstance(format:TextFormat):Font
	{
		#if (js && html5)
		return findFontVariant(format);
		#elseif lime_cffi
		var instance = null;
		var fontList = null;

		if (format != null && format.font != null)
		{
			if (__defaultFonts.exists(format.font))
			{
				return __defaultFonts.get(format.font);
			}

			instance = findFontVariant(format);
			if (instance != null) return instance;

			var systemFontDirectory = System.fontsDirectory;

			switch (format.font)
			{
				case "_sans":
					#if windows
					if (format.bold)
					{
						if (format.italic)
						{
							fontList = [systemFontDirectory + "/arialbi.ttf"];
						}
						else
						{
							fontList = [systemFontDirectory + "/arialbd.ttf"];
						}
					}
					else
					{
						if (format.italic)
						{
							fontList = [systemFontDirectory + "/ariali.ttf"];
						}
						else
						{
							fontList = [systemFontDirectory + "/arial.ttf"];
						}
					}
					#elseif (mac || ios || tvos)
					fontList = [
						systemFontDirectory + "/Arial.ttf",
						systemFontDirectory + "/Helvetica.ttf",
						systemFontDirectory + "/Cache/Arial.ttf",
						systemFontDirectory + "/Cache/Helvetica.ttf",
						systemFontDirectory + "/Core/Arial.ttf",
						systemFontDirectory + "/Core/Helvetica.ttf",
						systemFontDirectory + "/CoreAddition/Arial.ttf",
						systemFontDirectory + "/CoreAddition/Helvetica.ttf",
						"/System/Library/Fonts/Supplemental/Arial.ttf"
					];
					#elseif linux
					fontList = [new sys.io.Process("fc-match", ["sans", "-f%{file}"]).stdout.readLine()];
					#elseif android
					fontList = [systemFontDirectory + "/DroidSans.ttf"];
					#else
					fontList = ["Noto Sans Regular"];
					#end

				case "_serif":

				// pass through

				case "_typewriter":
					#if windows
					if (format.bold)
					{
						if (format.italic)
						{
							fontList = [systemFontDirectory + "/courbi.ttf"];
						}
						else
						{
							fontList = [systemFontDirectory + "/courbd.ttf"];
						}
					}
					else
					{
						if (format.italic)
						{
							fontList = [systemFontDirectory + "/couri.ttf"];
						}
						else
						{
							fontList = [systemFontDirectory + "/cour.ttf"];
						}
					}
					#elseif (mac || ios || tvos)
					fontList = [
						systemFontDirectory + "/Courier New.ttf",
						systemFontDirectory + "/Courier.ttf",
						systemFontDirectory + "/Cache/Courier New.ttf",
						systemFontDirectory + "/Cache/Courier.ttf",
						systemFontDirectory + "/Core/Courier New.ttf",
						systemFontDirectory + "/Core/Courier.ttf",
						systemFontDirectory + "/CoreAddition/Courier New.ttf",
						systemFontDirectory + "/CoreAddition/Courier.ttf",
						"/System/Library/Fonts/Supplemental/Courier New.ttf"
					];
					#elseif linux
					fontList = [new sys.io.Process("fc-match", ["mono", "-f%{file}"]).stdout.readLine()];
					#elseif android
					fontList = [systemFontDirectory + "/DroidSansMono.ttf"];
					#else
					fontList = ["Noto Mono"];
					#end

				default:
					fontList = [systemFontDirectory + "/" + format.font];
			}

			if (fontList != null)
			{
				for (font in fontList)
				{
					instance = findFont(font);

					if (instance != null)
					{
						__defaultFonts.set(format.font, instance);
						return instance;
					}
				}
			}

			instance = findFont("_serif");
			if (instance != null) return instance;
		}

		var systemFontDirectory = System.fontsDirectory;

		#if windows
		if (format.bold)
		{
			if (format.italic)
			{
				fontList = [systemFontDirectory + "/timesbi.ttf"];
			}
			else
			{
				fontList = [systemFontDirectory + "/timesbd.ttf"];
			}
		}
		else
		{
			if (format.italic)
			{
				fontList = [systemFontDirectory + "/timesi.ttf"];
			}
			else
			{
				fontList = [systemFontDirectory + "/times.ttf"];
			}
		}
		#elseif (mac || ios || tvos)
		fontList = [
			systemFontDirectory + "/Georgia.ttf", systemFontDirectory + "/Times.ttf", systemFontDirectory + "/Times New Roman.ttf",
			systemFontDirectory + "/Cache/Georgia.ttf", systemFontDirectory + "/Cache/Times.ttf", systemFontDirectory + "/Cache/Times New Roman.ttf",
			systemFontDirectory + "/Core/Georgia.ttf", systemFontDirectory + "/Core/Times.ttf", systemFontDirectory + "/Core/Times New Roman.ttf",
			systemFontDirectory + "/CoreAddition/Georgia.ttf", systemFontDirectory + "/CoreAddition/Times.ttf",
			systemFontDirectory + "/CoreAddition/Times New Roman.ttf", "/System/Library/Fonts/Supplemental/Times New Roman.ttf"
		];
		#elseif linux
		fontList = [new sys.io.Process("fc-match", ["serif", "-f%{file}"]).stdout.readLine()];
		#elseif android
		fontList = [
			systemFontDirectory + "/DroidSerif-Regular.ttf",
			systemFontDirectory + "/NotoSerif-Regular.ttf"
		];
		#else
		fontList = ["Noto Serif Regular"];
		#end

		for (font in fontList)
		{
			instance = findFont(font);

			if (instance != null)
			{
				__defaultFonts.set(format.font, instance);
				return instance;
			}
		}

		__defaultFonts.set(format.font, null);
		#end

		return null;
	}

	public function getLine(index:Int):String
	{
		if (index < 0 || index > lineBreaks.length + 1)
		{
			return null;
		}

		if (lineBreaks.length == 0)
		{
			return text;
		}
		else
		{
			return text.substring(index > 0 ? lineBreaks[index - 1] : 0, lineBreaks[index]);
		}
	}

	public function getLineBreaks():Void
	{
		lineBreaks.length = 0;

		var index = -1;

		var cr = -1, lf = -1;
		while (index < text.length)
		{
			lf = text.indexOf("\n", index + 1);
			cr = text.indexOf("\r", index + 1);

			index = if (cr == -1) lf; else if (lf == -1) cr; else if (cr < lf) cr; else lf;

			if (index > -1) lineBreaks.push(index);
			else
				break;
		}
	}

	public function getLineBreakIndex(startIndex:Int = 0):Int
	{
		for (lineBreak in lineBreaks)
		{
			if (lineBreak >= startIndex) return lineBreak;
		}

		return -1;
	}

	private function getLineMeasurements():Void
	{
		lineAscents.length = 0;
		lineDescents.length = 0;
		lineLeadings.length = 0;
		lineHeights.length = 0;
		lineWidths.length = 0;

		var currentLineAscent = 0.0;
		var currentLineDescent = 0.0;
		var currentLineLeading:Null<Int> = null;
		var currentLineHeight = 0.0;
		var currentLineWidth = 0.0;
		var currentTextHeight = 0.0;

		textWidth = 0;
		textHeight = 0;
		numLines = 1;
		maxScrollH = 0;

		for (group in layoutGroups)
		{
			while (group.lineIndex > numLines - 1)
			{
				lineAscents.push(currentLineAscent);
				lineDescents.push(currentLineDescent);
				lineLeadings.push(currentLineLeading != null ? currentLineLeading : 0);
				lineHeights.push(currentLineHeight);
				lineWidths.push(currentLineWidth);

				currentLineAscent = 0;
				currentLineDescent = 0;
				currentLineLeading = null;
				currentLineHeight = 0;
				currentLineWidth = 0;

				numLines++;
			}

			currentLineAscent = Math.max(currentLineAscent, group.ascent);
			currentLineDescent = Math.max(currentLineDescent, group.descent);

			if (currentLineLeading == null)
			{
				currentLineLeading = group.leading;
			}
			else
			{
				currentLineLeading = Std.int(Math.max(currentLineLeading, group.leading));
			}

			currentLineHeight = Math.max(currentLineHeight, group.height);
			currentLineWidth = group.offsetX - 2 + group.width;

			if (currentLineWidth > textWidth)
			{
				textWidth = currentLineWidth;
			}

			currentTextHeight = group.offsetY - 2 + group.ascent + group.descent;

			if (currentTextHeight > textHeight)
			{
				textHeight = currentTextHeight;
			}
		}

		if (textHeight == 0 && textField != null && textField.type == INPUT)
		{
			var currentFormat = textField.__textFormat;
			var ascent, descent, leading, heightValue;

			var font = getFontInstance(currentFormat);

			if (currentFormat.__ascent != null)
			{
				ascent = currentFormat.size * currentFormat.__ascent;
				descent = currentFormat.size * currentFormat.__descent;
			}
			else if (#if lime font != null && font.unitsPerEM != 0 #else false #end)
			{
				#if lime
				ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
				descent = Math.abs((font.descender / font.unitsPerEM) * currentFormat.size);
				#else
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
				#end
			}
			else
			{
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
			}

			leading = currentFormat.leading;

			heightValue = ascent + descent + leading;

			currentLineAscent = ascent;
			currentLineDescent = descent;
			currentLineLeading = leading;

			currentTextHeight = ascent + descent;
			textHeight = currentTextHeight;
		}

		lineAscents.push(currentLineAscent);
		lineDescents.push(currentLineDescent);
		lineLeadings.push(currentLineLeading != null ? currentLineLeading : 0);
		lineHeights.push(currentLineHeight);
		lineWidths.push(currentLineWidth);

		if (numLines == 1)
		{
			if (currentLineLeading > 0)
			{
				textHeight += currentLineLeading;
			}
		}

		if (layoutGroups.length > 0)
		{
			var group = layoutGroups[layoutGroups.length - 1];

			if (group != null && group.startIndex == group.endIndex)
			{
				textHeight -= currentLineHeight;
			}
		}

		if (autoSize != NONE)
		{
			switch (autoSize)
			{
				case LEFT, RIGHT, CENTER:
					if (!wordWrap /*&& (width < textWidth + 4)*/)
					{
						width = textWidth + 4;
					}

					height = textHeight + 4;
					bottomScrollV = numLines;

				default:
			}
		}

		if (textWidth > width - 4)
		{
			maxScrollH = Std.int(textWidth - width + 4); // TODO: incorrect
		}
		else
		{
			maxScrollH = 0;
		}

		if (scrollH > maxScrollH) scrollH = maxScrollH;
	}

	private function getLayoutGroups():Void
	{
		layoutGroups.length = 0;

		if (text == null || text == "") return;

		var rangeIndex = -1;
		var formatRange:TextFormatRange = null;
		var font = null;

		var currentFormat = TextField.__defaultTextFormat.clone();

		// line metrics
		var leading = 0; // the leading of the 0th character in a line is what's used for the whole line
		var ascent = 0.0, maxAscent = 0.0;
		var descent = 0.0;

		// paragraph metrics
		var align:TextFormatAlign = LEFT; // the metrics of the 0th character in a paragraph are used for the whole paragraph
		var blockIndent = 0;
		var bullet = false;
		var indent = 0;
		var leftMargin = 0;
		var rightMargin = 0;
		var firstLineOfParagraph = true;

		var tabStops = null; // TODO: maybe there's a better init value (not sure what this actually is)

		var layoutGroup:TextLayoutGroup = null, positions = null;
		var widthValue = 0.0, heightValue = 0, maxHeightValue = 0;
		var previousSpaceIndex = -2; // -1 equals not found, -2 saves extra comparison in `breakIndex == previousSpaceIndex`
		var previousBreakIndex = -1;
		var spaceIndex = text.indexOf(" ");
		var breakCount = 0;
		var breakIndex = breakCount < lineBreaks.length ? lineBreaks[breakCount] : -1;

		var offsetX = 0.0;
		var offsetY = 0.0;
		var textIndex = 0;
		var lineIndex = 0;

		#if !js
		inline
		#end
		function getPositions(text:UTF8String, startIndex:Int, endIndex:Int):Array<#if (js && html5) Float #else GlyphPosition #end>
		{
			// TODO: optimize

			var letterSpacing = 0.0;

			if (formatRange.format.letterSpacing != null)
			{
				letterSpacing = formatRange.format.letterSpacing;
			}

			#if (js && html5)
			function html5Positions():Array<Float>
			{
				var positions = [];

				if (__useIntAdvances == null)
				{
					__useIntAdvances = ~/Trident\/7.0/.match(Browser.navigator.userAgent); // IE
				}

				if (__useIntAdvances)
				{
					// slower, but more accurate if browser returns Int measurements

					var previousWidth = 0.0;
					var width;

					for (i in startIndex...endIndex)
					{
						width = __context.measureText(text.substring(startIndex, i + 1)).width;
						// if (i > 0) width += letterSpacing;

						positions.push(width - previousWidth);

						previousWidth = width;
					}
				}
				else
				{
					for (i in startIndex...endIndex)
					{
						var advance;

						if (i < text.length - 1)
						{
							// Advance can be less for certain letter combinations, e.g. 'Yo' vs. 'Do'
							var nextWidth = __context.measureText(text.charAt(i + 1)).width;
							var twoWidths = __context.measureText(text.substr(i, 2)).width;
							advance = twoWidths - nextWidth;
						}
						else
						{
							advance = __context.measureText(text.charAt(i)).width;
						}

						// if (i > 0) advance += letterSpacing;

						positions.push(advance);
					}
				}

				return positions;
			}
			return __shapeCache.cache(formatRange, html5Positions, text.substring(startIndex, endIndex));
			#else
			if (__textLayout == null)
			{
				__textLayout = new TextLayout();
			}

			var width = 0.0;

			__textLayout.text = null;
			__textLayout.font = font;

			if (formatRange.format.size != null)
			{
				__textLayout.size = formatRange.format.size;
			}

			__textLayout.letterSpacing = letterSpacing;
			__textLayout.autoHint = (antiAliasType != ADVANCED || sharpness < 400);

			// __textLayout.direction = RIGHT_TO_LEFT;
			// __textLayout.script = ARABIC;

			__textLayout.text = text.substring(startIndex, endIndex);
			return __shapeCache.cache(formatRange, __textLayout);
			#end
		}

		#if !js inline #end function getPositionsWidth(positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end):Float

		{
			var width = 0.0;

			for (position in positions)
			{
				#if (js && html5)
				width += position;
				#else
				width += position.advance.x;
				#end
			}

			return width;
		}

		#if !js inline #end function getTextWidth(text:String):Float

		{
			#if (js && html5)
			return __context.measureText(text).width;
			#else
			if (__textLayout == null)
			{
				__textLayout = new TextLayout();
			}

			var width = 0.0;

			__textLayout.text = null;
			__textLayout.font = font;

			if (formatRange.format.size != null)
			{
				__textLayout.size = formatRange.format.size;
			}

			// __textLayout.direction = RIGHT_TO_LEFT;
			// __textLayout.script = ARABIC;

			__textLayout.text = text;

			for (position in __textLayout.positions)
			{
				width += position.advance.x;
			}

			return width;
			#end
		}

		#if !js inline #end function getBaseX():Float

		{
			// TODO: swap margins in RTL
			return GUTTER + leftMargin + blockIndent + (firstLineOfParagraph ? indent : 0);
		}

		#if !js inline #end function getWrapWidth():Float

		{
			// TODO: swap margins in RTL
			return width - GUTTER - rightMargin - getBaseX();
		}

		#if !js inline #end function nextLayoutGroup(startIndex, endIndex):Void

		{
			if (layoutGroup == null || layoutGroup.startIndex != layoutGroup.endIndex)
			{
				layoutGroup = new TextLayoutGroup(formatRange.format, startIndex, endIndex);
				layoutGroups.push(layoutGroup);
			}
			else
			{
				layoutGroup.format = formatRange.format;
				layoutGroup.startIndex = startIndex;
				layoutGroup.endIndex = endIndex;
			}
		}

		#if !js inline #end function setLineMetrics():Void

		{
			if (currentFormat.__ascent != null)
			{
				ascent = currentFormat.size * currentFormat.__ascent;
				descent = currentFormat.size * currentFormat.__descent;
			}
			else if (#if lime font != null && font.unitsPerEM != 0 #else false #end)
			{
				#if lime
				ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
				descent = Math.abs((font.descender / font.unitsPerEM) * currentFormat.size);
				#end
			}
			else
			{
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
			}

			leading = currentFormat.leading;

			heightValue = Math.ceil(ascent + descent + leading);

			if (heightValue > maxHeightValue)
			{
				maxHeightValue = heightValue;
			}

			if (ascent > maxAscent)
			{
				maxAscent = ascent;
			}
		}

		#if !js inline #end function setParagraphMetrics():Void

		{
			firstLineOfParagraph = true;

			align = currentFormat.align != null ? currentFormat.align : LEFT;
			blockIndent = currentFormat.blockIndent != null ? currentFormat.blockIndent : 0;
			indent = currentFormat.indent != null ? currentFormat.indent : 0;
			leftMargin = currentFormat.leftMargin != null ? currentFormat.leftMargin : 0;
			rightMargin = currentFormat.rightMargin != null ? currentFormat.rightMargin : 0;

			if (currentFormat.bullet != null)
			{
				// TODO
			}

			if (currentFormat.tabStops != null)
			{
				// TODO, may not actually belong in paragraph metrics
			}
		}

		#if !js inline #end function nextFormatRange():Bool

		{
			if (rangeIndex < textFormatRanges.length - 1)
			{
				rangeIndex++;
				formatRange = textFormatRanges[rangeIndex];
				currentFormat.__merge(formatRange.format);

				#if (js && html5)
				__context.font = getFont(currentFormat);
				#end

				font = getFontInstance(currentFormat);

				return true;
			}

			return false;
		}

		#if !js inline #end function setFormattedPositions(startIndex:Int, endIndex:Int)

		{
			// sets the positions of the text from start to end, including format changes if there are any
			if (startIndex >= endIndex)
			{
				positions = [];
				widthValue = 0;
			}
			else if (endIndex <= formatRange.end)
			{
				positions = getPositions(text, startIndex, endIndex);
				widthValue = getPositionsWidth(positions);
			}
			else
			{
				var tempIndex = startIndex;
				var tempRangeEnd = formatRange.end;
				var countRanges = 0;

				positions = [];
				widthValue = 0;

				while (true)
				{
					if (tempIndex != tempRangeEnd)
					{
						var tempPositions = getPositions(text, tempIndex, tempRangeEnd);
						positions = positions.concat(tempPositions);
					}

					if (tempRangeEnd != endIndex)
					{
						if (!nextFormatRange())
						{
							Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
							break;
						}

						tempIndex = tempRangeEnd;
						tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

						countRanges++;
					}
					else
					{
						widthValue = getPositionsWidth(positions);
						break;
					}
				}

				rangeIndex -= countRanges + 1;
				nextFormatRange(); // get back to the formatRange and font
			}
		}

		#if !js inline #end function placeFormattedText(endIndex:Int):Void

		{
			if (endIndex <= formatRange.end)
			{
				// don't worry about placing multiple formats if a space or break happens first

				positions = getPositions(text, textIndex, endIndex);
				widthValue = getPositionsWidth(positions);

				nextLayoutGroup(textIndex, endIndex);

				layoutGroup.positions = positions;
				layoutGroup.offsetX = offsetX + getBaseX();
				layoutGroup.ascent = ascent;
				layoutGroup.descent = descent;
				layoutGroup.leading = leading;
				layoutGroup.lineIndex = lineIndex;
				layoutGroup.offsetY = offsetY + GUTTER;
				layoutGroup.width = widthValue;
				layoutGroup.height = heightValue;

				offsetX += widthValue;

				if (endIndex == formatRange.end)
				{
					layoutGroup = null;
					nextFormatRange();
					setLineMetrics();
				}
			}
			else
			{
				// fill in all text from start to end, including any format changes

				while (true)
				{
					var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

					if (textIndex != tempRangeEnd)
					{
						positions = getPositions(text, textIndex, tempRangeEnd);
						widthValue = getPositionsWidth(positions);

						nextLayoutGroup(textIndex, tempRangeEnd);

						layoutGroup.positions = positions;
						layoutGroup.offsetX = offsetX + getBaseX();
						layoutGroup.ascent = ascent;
						layoutGroup.descent = descent;
						layoutGroup.leading = leading;
						layoutGroup.lineIndex = lineIndex;
						layoutGroup.offsetY = offsetY + GUTTER;
						layoutGroup.width = widthValue;
						layoutGroup.height = heightValue;

						offsetX += widthValue;

						textIndex = tempRangeEnd;
					}

					if (tempRangeEnd == formatRange.end) layoutGroup = null;

					if (tempRangeEnd == endIndex) break;

					if (!nextFormatRange())
					{
						Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
						break;
					}

					setLineMetrics();
				}
			}

			textIndex = endIndex;
		}

		#if !js inline #end function alignBaseline():Void

		{
			// aligns the baselines of all characters in a single line

			setLineMetrics();

			var i = layoutGroups.length;

			while (--i > -1)
			{
				var lg = layoutGroups[i];

				if (lg.lineIndex < lineIndex) break;
				if (lg.lineIndex > lineIndex) continue;

				lg.ascent = maxAscent;
				lg.height = maxHeightValue;
			}

			offsetY += maxHeightValue;

			maxAscent = 0.0;
			maxHeightValue = 0;

			++lineIndex;
			offsetX = 0;

			firstLineOfParagraph = false; // TODO: need to thoroughly test this
		}

		#if !js inline #end function breakLongWords(endIndex:Int):Void

		{
			// breaks up words that are too long to fit in a single line

			var remainingPositions = positions;
			var i, bufferCount, placeIndex, positionWidth;
			var currentPosition;

			var tempWidth = getPositionsWidth(remainingPositions);

			while (remainingPositions.length > 0 && offsetX + tempWidth > getWrapWidth())
			{
				i = bufferCount = 0;
				positionWidth = 0.0;

				while (offsetX + positionWidth < getWrapWidth())
				{
					currentPosition = remainingPositions[i];

					if (#if (js && html5) currentPosition #else currentPosition.advance.x #end == 0.0)
					{
						// skip Unicode character buffer positions
						i++;
						bufferCount++;
					}
					else
					{
						positionWidth += #if (js && html5) currentPosition #else currentPosition.advance.x #end;
						i++;
					}
				}

				// if there's no room to put even a single character, automatically wrap the next character
				if (i == bufferCount)
				{
					i = bufferCount + 1;
				}
				else
				{
					// remove characters until the text fits one line
					// because of combining letters potentially being broken up now, we have to redo the formatted positions each time
					// TODO: this may not work exactly with Unicode buffer characters...
					// TODO: maybe assume no combining letters, then compare result to i+1 and i-1 results?
					while (i > 1 && offsetX + positionWidth > getWrapWidth())
					{
						i--;

						if (i - bufferCount > 0)
						{
							setFormattedPositions(textIndex, textIndex + i - bufferCount);
							positionWidth = widthValue;
						}
						else
						{
							// TODO: does this run anymore?

							i = 1;
							bufferCount = 0;

							setFormattedPositions(textIndex, textIndex + 1);
							positionWidth = 0; // breaks out of the loops
						}
					}
				}

				placeIndex = textIndex + i - bufferCount;
				placeFormattedText(placeIndex);
				alignBaseline();

				setFormattedPositions(placeIndex, endIndex);

				remainingPositions = positions;
				tempWidth = widthValue;
			}

			// positions only contains the final unbroken line at the end
		}

		#if !js inline #end function placeText(endIndex:Int):Void

		{
			if (width >= GUTTER * 2 && wordWrap)
			{
				breakLongWords(endIndex);
			}

			placeFormattedText(endIndex);
		}

		nextFormatRange();
		setParagraphMetrics();
		setLineMetrics();

		var wrap;
		var maxLoops = text.length +
			1; // Do an extra iteration to ensure a LayoutGroup is created in case the last line is empty (multiline or trailing line break).
		// TODO: check if the +1 is still needed, since the extra layout group is handled separately

		while (textIndex < maxLoops)
		{
			if ((breakIndex > -1) && (spaceIndex == -1 || breakIndex < spaceIndex))
			{
				// if a line break is the next thing that needs to be dealt with
				// TODO: when is this condition ever false?
				if (textIndex <= breakIndex)
				{
					setFormattedPositions(textIndex, breakIndex);
					placeText(breakIndex);

					layoutGroup = null;
				}
				else if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					// Trim the last space from the line width, for correct TextFormatAlign.RIGHT alignment
					if (layoutGroup.endIndex == spaceIndex)
					{
						layoutGroup.width -= layoutGroup.getAdvance(layoutGroup.positions.length - 1);
					}

					layoutGroup = null;
				}

				alignBaseline();

				// TODO: is this necessary or already handled by placeText above?
				if (formatRange.end == breakIndex)
				{
					nextFormatRange();
					setLineMetrics();
				}

				textIndex = breakIndex + 1;
				previousBreakIndex = breakIndex;
				breakCount++;
				breakIndex = breakCount < lineBreaks.length ? lineBreaks[breakCount] : -1;

				setParagraphMetrics();
			}
			else if (spaceIndex > -1)
			{
				// if a space is the next thing that needs to be dealt with

				if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					layoutGroup = null;
				}

				wrap = false;

				while (true)
				{
					if (textIndex >= text.length) break;

					var endIndex = -1;

					if (spaceIndex == -1)
					{
						endIndex = breakIndex;
					}
					else
					{
						endIndex = spaceIndex + 1;

						if (breakIndex > -1 && breakIndex < endIndex)
						{
							endIndex = breakIndex;
						}
					}

					if (endIndex == -1)
					{
						endIndex = text.length;
					}

					setFormattedPositions(textIndex, endIndex);

					if (align == JUSTIFY)
					{
						if (positions.length > 0 && textIndex == previousSpaceIndex)
						{
							// Trim left space of this word
							textIndex++;

							var spaceWidth = #if (js && html5) positions.shift() #else positions.shift().advance.x #end;
							widthValue -= spaceWidth;
							offsetX += spaceWidth;
						}

						if (positions.length > 0 && endIndex == spaceIndex + 1)
						{
							// Trim right space of this word
							endIndex--;

							var spaceWidth = #if (js && html5) positions.pop() #else positions.pop().advance.x #end;
							widthValue -= spaceWidth;
						}
					}

					if (wordWrap)
					{
						if (offsetX + widthValue > getWrapWidth())
						{
							wrap = true;

							if (positions.length > 0 && endIndex == spaceIndex + 1)
							{
								// if last letter is a space, avoid word wrap if possible
								// TODO: Handle multiple spaces

								var lastPosition = positions[positions.length - 1];
								var spaceWidth = #if (js && html5) lastPosition #else lastPosition.advance.x #end;

								if (offsetX + widthValue - spaceWidth <= getWrapWidth())
								{
									wrap = false;
								}
							}
						}
					}

					if (wrap)
					{
						if (align != JUSTIFY && (layoutGroup != null || layoutGroups.length > 0))
						{
							var previous = layoutGroup;
							if (previous == null)
							{
								previous = layoutGroups[layoutGroups.length - 1];
							}

							// For correct selection rectangles and alignment, trim the trailing space of the previous line:
							previous.width -= previous.getAdvance(previous.positions.length - 1);
							previous.endIndex--;
						}

						var i = layoutGroups.length - 1;
						var offsetCount = 0;

						while (true)
						{
							layoutGroup = layoutGroups[i];

							if (i > 0 && layoutGroup.startIndex > previousSpaceIndex)
							{
								offsetCount++;
							}
							else
							{
								break;
							}

							i--;
						}

						if (textIndex == previousSpaceIndex + 1)
						{
							alignBaseline();
						}

						offsetX = 0;

						if (offsetCount > 0)
						{
							var bumpX = layoutGroups[layoutGroups.length - offsetCount].offsetX;

							for (i in (layoutGroups.length - offsetCount)...layoutGroups.length)
							{
								layoutGroup = layoutGroups[i];
								layoutGroup.offsetX -= bumpX;
								layoutGroup.offsetY = offsetY + GUTTER;
								layoutGroup.lineIndex = lineIndex;
								offsetX += layoutGroup.width;
							}
						}

						placeText(endIndex);

						wrap = false;
					}
					else
					{
						if (layoutGroup != null && textIndex == spaceIndex)
						{
							// TODO: does this case ever happen?
							if (align != JUSTIFY)
							{
								layoutGroup.endIndex = spaceIndex;
								layoutGroup.positions = layoutGroup.positions.concat(positions);
								layoutGroup.width += widthValue;
							}

							offsetX += widthValue;

							textIndex = endIndex;
						}
						else if (layoutGroup == null || align == JUSTIFY)
						{
							placeText(endIndex);
							if (endIndex == text.length) alignBaseline();
						}
						else
						{
							var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

							if (tempRangeEnd < endIndex)
							{
								positions = getPositions(text, textIndex, tempRangeEnd);
								widthValue = getPositionsWidth(positions);
							}

							layoutGroup.endIndex = tempRangeEnd;
							layoutGroup.positions = layoutGroup.positions.concat(positions);
							layoutGroup.width += widthValue;

							offsetX += widthValue;

							if (tempRangeEnd == formatRange.end)
							{
								layoutGroup = null;
								nextFormatRange();
								setLineMetrics();

								textIndex = tempRangeEnd;

								if (tempRangeEnd != endIndex)
								{
									placeFormattedText(endIndex);
								}
							}

							// If next char is newline, process it immediately and prevent useless extra layout groups
							// TODO: is this needed?
							if (breakIndex == endIndex) endIndex++;

							textIndex = endIndex;

							if (endIndex == text.length) alignBaseline();
						}
					}

					var nextSpaceIndex = text.indexOf(" ", textIndex);

					// Check if we can continue wrapping this line until the next line-break or end-of-String.
					// When `previousSpaceIndex == breakIndex`, the loop has finished growing layoutGroup.endIndex until the end of this line.

					if (breakIndex == previousSpaceIndex)
					{
						layoutGroup.endIndex = breakIndex;

						if (breakIndex - layoutGroup.startIndex - layoutGroup.positions.length < 0)
						{
							// Newline has no size
							layoutGroup.positions.push(#if (js && html5) 0.0 #else null #end);
						}

						textIndex = breakIndex + 1;
					}

					previousSpaceIndex = spaceIndex;
					spaceIndex = nextSpaceIndex;

					if ((breakIndex > -1 && breakIndex <= textIndex && (spaceIndex > breakIndex || spaceIndex == -1))
						|| textIndex > text.length)
					{
						break;
					}
				}
			}
			else
			{
				if (textIndex < text.length)
				{
					// if there are no line breaks or spaces to deal with next, place all remaining text

					setFormattedPositions(textIndex, text.length);
					placeText(text.length);

					alignBaseline();
				}

				textIndex++;
			}
		}

		// if final char is a line break, create an empty layoutGroup for it
		if (previousBreakIndex == textIndex - 2 && previousBreakIndex > -1)
		{
			nextLayoutGroup(textIndex - 1, textIndex - 1);

			layoutGroup.positions = [];
			layoutGroup.ascent = ascent;
			layoutGroup.descent = descent;
			layoutGroup.leading = leading;
			layoutGroup.lineIndex = lineIndex;
			layoutGroup.offsetX = getBaseX(); // TODO: double check it doesn't default to GUTTER or something
			layoutGroup.offsetY = offsetY + GUTTER;
			layoutGroup.width = 0;
			layoutGroup.height = type == "input" ? heightValue : 0;
		}

		#if openfl_trace_text_layout_groups
		for (lg in layoutGroups)
		{
			Log.info('LG ${lg.positions.length - (lg.endIndex - lg.startIndex)},line:${lg.lineIndex},w:${lg.width},h:${lg.height},x:${Std.int(lg.offsetX)},y:${Std.int(lg.offsetY)},"${text.substring(lg.startIndex, lg.endIndex)}",${lg.startIndex},${lg.endIndex}');
		}
		#end
	}

	public function restrictText(value:UTF8String):UTF8String
	{
		if (value == null)
		{
			return value;
		}

		if (__restrictRegexp != null)
		{
			value = __restrictRegexp.split(value).join("");
		}

		// if (maxChars > 0 && value.length > maxChars) {

		// 	value = value.substr (0, maxChars);

		// }

		return value;
	}

	private function setTextAlignment():Void
	{
		var lineIndex = -1;
		var offsetX = 0.0;
		var totalWidth = this.width - 4; // TODO: do margins and stuff affect this?
		var group, lineLength;
		var lineMeasurementsDirty = false;

		for (i in 0...layoutGroups.length)
		{
			group = layoutGroups[i];

			if (group.lineIndex != lineIndex)
			{
				lineIndex = group.lineIndex;
				totalWidth = this.width - GUTTER * 2 - group.format.rightMargin;

				switch (group.format.align)
				{
					case CENTER:
						if (lineWidths[lineIndex] < totalWidth)
						{
							offsetX = Math.round((totalWidth - lineWidths[lineIndex]) / 2);
						}
						else
						{
							offsetX = 0;
						}

					case RIGHT:
						if (lineWidths[lineIndex] < totalWidth)
						{
							offsetX = Math.round(totalWidth - lineWidths[lineIndex]);
						}
						else
						{
							offsetX = 0;
						}

					case JUSTIFY:
						if (lineWidths[lineIndex] < totalWidth)
						{
							lineLength = 1;

							for (j in (i + 1)...layoutGroups.length)
							{
								if (layoutGroups[j].lineIndex == lineIndex)
								{
									if (j == 0 || text.charCodeAt(layoutGroups[j].startIndex - 1) == " ".code)
									{
										lineLength++;
									}
								}
								else
								{
									break;
								}
							}

							if (lineLength > 1)
							{
								group = layoutGroups[i + lineLength - 1];

								var endChar = text.charCodeAt(group.endIndex);
								if (group.endIndex < text.length && endChar != "\n".code && endChar != "\r".code)
								{
									offsetX = (totalWidth - lineWidths[lineIndex]) / (lineLength - 1);
									lineMeasurementsDirty = true;

									var j = 1;
									do
									{
										// if (text.charCodeAt (layoutGroups[j].startIndex - 1) != " ".code) {

										// 	layoutGroups[i + j].offsetX += (offsetX * (j-1));
										// 	j++;

										// }

										layoutGroups[i + j].offsetX += (offsetX * j);
									}
									while (++j < lineLength);
								}
							}
						}

						offsetX = 0;

					default:
						offsetX = 0;
				}
			}

			if (offsetX > 0)
			{
				group.offsetX += offsetX;
			}
		}

		if (lineMeasurementsDirty)
		{
			// TODO: Better way to fix justify textWidth?

			getLineMeasurements();
		}
	}

	public function trimText(value:UTF8String):UTF8String
	{
		if (value == null)
		{
			return value;
		}

		if (maxChars > 0 && value.length > maxChars)
		{
			value = value.substr(0, maxChars);
		}

		return value;
	}

	private function update():Void
	{
		if (text == null /*|| text == ""*/ || textFormatRanges.length == 0)
		{
			lineAscents.length = 0;
			lineBreaks.length = 0;
			lineDescents.length = 0;
			lineLeadings.length = 0;
			lineHeights.length = 0;
			lineWidths.length = 0;
			layoutGroups.length = 0;

			textWidth = 0;
			textHeight = 0;
			numLines = 1;
			maxScrollH = 0;
			maxScrollV = 1;
			bottomScrollV = 1;
		}
		else
		{
			getLineBreaks();
			getLayoutGroups();
			getLineMeasurements();
			setTextAlignment();
		}

		getBounds();
	}

	// Get & Set Methods
	private function get_bottomScrollV():Int
	{
		// TODO: only update when dirty
		if (numLines == 1 || lineHeights == null)
		{
			return 1;
		}
		else
		{
			var ret = lineHeights.length;
			// TODO: update for loop with leading checks, remove below line. Leading of lineIndex == bottomScroll is ignored
			var tempHeight = (lineLeadings.length == ret) ? -lineLeadings[ret - 1] : 0.0;

			for (i in scrollV - 1...lineHeights.length)
			{
				if (tempHeight + lineHeights[i] <= height - 4)
				{
					tempHeight += lineHeights[i];
				}
				else
				{
					ret = i;
					break;
				}
			}

			if (ret < scrollV) return scrollV;
			return ret;
		}
	}

	private function get_maxScrollV():Int
	{
		// TODO: only update when dirty
		if (numLines == 1 || lineHeights == null)
		{
			return 1;
		}
		else
		{
			var i = numLines - 1, tempHeight = 0.0;
			var j = i;
			// TODO: update while loop with leading checks. Leading of lineIndex == bottomScroll is ignored

			while (i >= 0)
			{
				if (tempHeight + lineHeights[i] <= height - 4)
				{
					tempHeight += lineHeights[i];
					i--;
				}
				else
					break;
			}

			if (i == j) i = numLines; // maxScrollV defaults to numLines if the height - 4 is less than the line's height
			// TODO: check if it's based on the first or last line's height
			else
				i += 2;

			if (i < 1) return 1;
			return i;
		}
	}

	private function set_restrict(value:String):String
	{
		if (restrict == value)
		{
			return restrict;
		}

		restrict = value;

		if (restrict == null || restrict.length == 0)
		{
			__restrictRegexp = null;
		}
		else
		{
			__restrictRegexp = createRestrictRegexp(value);
		}

		return restrict;
	}

	private function get_scrollV():Int
	{
		if (numLines == 1 || lineHeights == null) return 1;

		var max = maxScrollV;
		if (scrollV > max) return max;
		return scrollV;
	}

	private function set_scrollV(value:Int):Int
	{
		if (value < 1) value = 1;
		return scrollV = value;
	}

	private function set_text(value:String):String
	{
		return text = value;
	}
}
