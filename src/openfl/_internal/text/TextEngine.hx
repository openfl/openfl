package openfl._internal.text;


import haxe.Timer;
import haxe.Utf8;
import lime.graphics.cairo.CairoFontFace;
import lime.graphics.opengl.GLTexture;
import lime.system.System;
import lime.text.GlyphPosition;
import lime.text.TextLayout;
import lime.text.UTF8String;
import openfl.Vector;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

#if sys
import haxe.io.Path;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)


class TextEngine {
	
	
	private static inline var UTF8_TAB = 9;
	private static inline var UTF8_ENDLINE = 10;
	private static inline var UTF8_SPACE = 32;
	private static inline var UTF8_HYPHEN = 0x2D;
	
	private static var __defaultFonts = new Map<String, Font> ();
	
	#if (js && html5)
	private static var __canvas:CanvasElement;
	private static var __context:CanvasRenderingContext2D;
	#end
	
	public var antiAliasType:AntiAliasType;
	public var autoSize:TextFieldAutoSize;
	public var background:Bool;
	public var backgroundColor:Int;
	public var border:Bool;
	public var borderColor:Int;
	public var bottomScrollV (default, null):Int;
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
	public var maxScrollH (default, null):Int;
	public var maxScrollV (default, null):Int;
	public var multiline:Bool;
	public var numLines (default, null):Int;
	public var restrict (default, set):UTF8String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var sharpness:Float;
	public var text (default, set):UTF8String;
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
	@:noCompletion private var __showCursor:Bool;
	@:noCompletion private var __textFormat:TextFormat;
	@:noCompletion private var __textLayout:TextLayout;
	@:noCompletion private var __texture:GLTexture;
	//@:noCompletion private var __tileData:Map<Tilesheet, Array<Float>>;
	//@:noCompletion private var __tileDataLength:Map<Tilesheet, Int>;
	//@:noCompletion private var __tilesheets:Map<Tilesheet, Bool>;
	private var __useIntAdvances:Null<Bool>;
	
	@:noCompletion @:dox(hide) public var __cairoFont:CairoFontFace;
	@:noCompletion @:dox(hide) public var __font:Font;
	
	
	public function new (textField:TextField) {
		
		this.textField = textField;
		
		width = 100;
		height = 100;
		text = "";
		
		bounds = new Rectangle (0, 0, 0, 0);
		
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
		sharpness = 0;
		scrollH = 0;
		scrollV = 1;
		wordWrap = false;
		
		lineAscents = new Vector ();
		lineBreaks = new Vector ();
		lineDescents = new Vector ();
		lineLeadings = new Vector ();
		lineHeights = new Vector ();
		lineWidths = new Vector ();
		layoutGroups = new Vector ();
		textFormatRanges = new Vector ();
		
		#if (js && html5)
		__canvas = cast Browser.document.createElement ("canvas");
		__context = __canvas.getContext ("2d");
		#end
		
	}
	
	
	private function createRestrictRegexp (restrict:String):EReg {
		
		var declinedRange = ~/\^(.-.|.)/gu;
		var declined = '';
		
		var accepted = declinedRange.map (restrict, function (ereg) {
			
			declined += ereg.matched (1);
			return '';
			
		});
		
		var testRegexpParts:Array<String> = [];
		
		if (accepted.length > 0) {
			
			testRegexpParts.push ('[^$restrict]');
			
		}
		
		if (declined.length > 0) {
			
			testRegexpParts.push ('[$declined]');
			
		}
		
		return new EReg ('(${testRegexpParts.join('|')})', 'g');
		
	}
	
	
	private static function findFont (name:String):Font {
		
		#if (lime_cffi)
		
		for (registeredFont in Font.__registeredFonts) {
			
			if (registeredFont == null) continue;
			
			if (registeredFont.fontName == name || (registeredFont.__fontPath != null && (registeredFont.__fontPath == name || registeredFont.__fontPathWithoutDirectory == name))) {
				
				if (registeredFont.__initialize ()) {
					
					return registeredFont;
					
				}
				
			}
			
		}
		
		var font = Font.fromFile (name);
		
		if (font != null) {
			
			Font.__registeredFonts.push (font);
			return font;
			
		}
		
		#end
		
		return null;
		
	}
	
	
	private static function findFontVariant (format:TextFormat):Font {
		
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;
		
		var fontNamePrefix = StringTools.replace (StringTools.replace (fontName, " Normal", ""), " Regular", "");
		
		if (bold && italic && Font.__fontByName.exists (fontNamePrefix + " Bold Italic")) {
			
			return findFont (fontNamePrefix + " Bold Italic");
			
		} else if (bold && Font.__fontByName.exists (fontNamePrefix + " Bold")) {
			
			return findFont (fontNamePrefix + " Bold");
			
		} else if (italic && Font.__fontByName.exists (fontNamePrefix + " Italic")) {
			
			return findFont (fontNamePrefix + " Italic");
			
		}
		
		return findFont (fontName);
		
	}
	
	
	private function getBounds ():Void {
		
		var padding = border ? 1 : 0;
		
		bounds.width = width + padding;
		bounds.height = height + padding;
		
	}
	
	
	public static function getFormatHeight (format:TextFormat):Float {
		
		var ascent:Float, descent:Float, leading:Int;
		
		#if (js && html5)
		
		__context.font = getFont (format);

		if (format.__ascent != null) {

			ascent = format.size * format.__ascent;
			descent = format.size * format.__descent;

		} else {
			
			ascent = format.size;
			descent = format.size * 0.185;
			
		}
		
		leading = format.leading;
		
		#elseif (lime_cffi)
		
		var font = getFontInstance (format);
		
		if (format.__ascent != null) {

			ascent = format.size * format.__ascent;
			descent = format.size * format.__descent;

		} else if (font != null) {

			ascent = (font.ascender / font.unitsPerEM) * format.size;
			descent = Math.abs ((font.descender / font.unitsPerEM) * format.size);

		} else {
			
			ascent = format.size;
			descent = format.size * 0.185;
			
		}
		
		leading = format.leading;
		
		#else
		
		ascent = descent = leading = 0;
		
		#end
		
		return ascent + descent + leading;
		
	}
	
	
	public static function getFont (format:TextFormat):String {
		
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;
		
		if (fontName == null) fontName = "_serif";
		var fontNamePrefix = StringTools.replace (StringTools.replace (fontName, " Normal", ""), " Regular", "");
		
		if (bold && italic && Font.__fontByName.exists (fontNamePrefix + " Bold Italic")) {
			
			fontName = fontNamePrefix + " Bold Italic";
			bold = false;
			italic = false;
			
		} else if (bold && Font.__fontByName.exists (fontNamePrefix + " Bold")) {
			
			fontName = fontNamePrefix + " Bold";
			bold = false;
			
		} else if (italic && Font.__fontByName.exists (fontNamePrefix + " Italic")) {
			
			fontName = fontNamePrefix + " Italic";
			italic = false;
			
		} else {
			
			// Prevent "extra" bold and italic fonts
			
			if (bold && (fontName.indexOf (" Bold ") > -1 || StringTools.endsWith (fontName, " Bold"))) {
				
				bold = false;
				
			}
			
			if (italic && (fontName.indexOf (" Italic ") > -1 || StringTools.endsWith (fontName, " Italic"))) {
				
				italic = false;
				
			}
			
		}
		
		var font = italic ? "italic " : "normal ";
		font += "normal ";
		font += bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.leading + format.size + 3) + "px ";
		
		font += "" + switch (fontName) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: "'" + ~/^[\s'"]+(.*)[\s'"]+$/.replace (fontName, '$1') + "'";
			
		}
		
		return font;
		
	}
	
	
	public static function getFontInstance (format:TextFormat):Font {
		
		#if (lime_cffi)
		
		var instance = null;
		var fontList = null;
		
		if (format != null && format.font != null) {
			
			if (__defaultFonts.exists (format.font)) {
				
				return __defaultFonts.get (format.font);
				
			}
			
			instance = findFontVariant (format);
			if (instance != null) return instance;
			
			var systemFontDirectory = System.fontsDirectory;
			
			switch (format.font) {
				
				case "_sans":
					
					#if windows
					if (format.bold) {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/arialbi.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/arialbd.ttf" ];
							
						}
						
					} else {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/ariali.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/arial.ttf" ];
							
						}
						
					}
					#elseif (mac || ios || tvos)
					fontList = [ systemFontDirectory + "/Arial.ttf", systemFontDirectory + "/Helvetica.ttf", systemFontDirectory + "/Cache/Arial.ttf", systemFontDirectory + "/Cache/Helvetica.ttf", systemFontDirectory + "/Core/Arial.ttf", systemFontDirectory + "/Core/Helvetica.ttf", systemFontDirectory + "/CoreAddition/Arial.ttf", systemFontDirectory + "/CoreAddition/Helvetica.ttf" ];
					#elseif linux
					fontList = [ new sys.io.Process('fc-match', ['sans', '-f%{file}']).stdout.readLine() ];
					#elseif android
					fontList = [ systemFontDirectory + "/DroidSans.ttf" ];
					#elseif blackberry
					fontList = [ systemFontDirectory + "/arial.ttf" ];
					#end
				
				case "_serif":
					
					// pass through
				
				case "_typewriter":
					
					#if windows
					if (format.bold) {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/courbi.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/courbd.ttf" ];
							
						}
						
					} else {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/couri.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/cour.ttf" ];
							
						}
						
					}
					#elseif (mac || ios || tvos)
					fontList = [ systemFontDirectory + "/Courier New.ttf", systemFontDirectory + "/Courier.ttf", systemFontDirectory + "/Cache/Courier New.ttf", systemFontDirectory + "/Cache/Courier.ttf", systemFontDirectory + "/Core/Courier New.ttf", systemFontDirectory + "/Core/Courier.ttf", systemFontDirectory + "/CoreAddition/Courier New.ttf", systemFontDirectory + "/CoreAddition/Courier.ttf" ];
					#elseif linux
					fontList = [ new sys.io.Process('fc-match', ['mono', '-f%{file}']).stdout.readLine() ];
					#elseif android
					fontList = [ systemFontDirectory + "/DroidSansMono.ttf" ];
					#elseif blackberry
					fontList = [ systemFontDirectory + "/cour.ttf" ];
					#end
				
				default:
					
					fontList = [ systemFontDirectory + "/" + format.font ];
				
			}
			
			#if lime_console
				
				// TODO(james4k): until we figure out our story for the above switch
				// statement, always load arial unless a file is specified.
				if (format == null
					|| StringTools.startsWith (format.font,  "_")
					|| format.font.indexOf(".") == -1
				) {
					fontList = [ "arial.ttf" ];
				}
				
			#end
			
			if (fontList != null) {
				
				for (font in fontList) {
					
					instance = findFont (font);
					
					if (instance != null) {
						
						__defaultFonts.set (format.font, instance);
						return instance;
						
					}
					
				}
				
			}
			
			instance = findFont ("_serif");
			if (instance != null) return instance;
			
		}
		
		var systemFontDirectory = System.fontsDirectory;
		
		#if windows
		if (format.bold) {
			
			if (format.italic) {
				
				fontList = [ systemFontDirectory + "/timesbi.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/timesbd.ttf" ];
				
			}
			
		} else {
			
			if (format.italic) {
				
				fontList = [ systemFontDirectory + "/timesi.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/times.ttf" ];
				
			}
			
		}
		#elseif (mac || ios || tvos)
		fontList = [ systemFontDirectory + "/Georgia.ttf", systemFontDirectory + "/Times.ttf", systemFontDirectory + "/Times New Roman.ttf", systemFontDirectory + "/Cache/Georgia.ttf", systemFontDirectory + "/Cache/Times.ttf", systemFontDirectory + "/Cache/Times New Roman.ttf", systemFontDirectory + "/Core/Georgia.ttf", systemFontDirectory + "/Core/Times.ttf", systemFontDirectory + "/Core/Times New Roman.ttf", systemFontDirectory + "/CoreAddition/Georgia.ttf", systemFontDirectory + "/CoreAddition/Times.ttf", systemFontDirectory + "/CoreAddition/Times New Roman.ttf" ];
		#elseif linux
		fontList = [ new sys.io.Process('fc-match', ['serif', '-f%{file}']).stdout.readLine() ];
		#elseif android
		fontList = [ systemFontDirectory + "/DroidSerif-Regular.ttf", systemFontDirectory + "/NotoSerif-Regular.ttf" ];
		#elseif blackberry
		fontList = [ systemFontDirectory + "/georgia.ttf" ];
		#else
		fontList = [];
		#end
		
		for (font in fontList) {
			
			instance = findFont (font);
			
			if (instance != null) {
				
				__defaultFonts.set (format.font, instance);
				return instance;
				
			}
			
		}
		
		__defaultFonts.set (format.font, null);
		
		#end
		
		return null;
		
	}
	
	
	public function getLine (index:Int):String {
		
		if (index < 0 || index > lineBreaks.length + 1) {
			
			return null;
			
		}
		
		if (lineBreaks.length == 0) {
			
			return text;
			
		} else {
			
			return text.substring (index > 0 ? lineBreaks[index - 1] : 0, lineBreaks[index]);
			
		}
		
	}
	
	
	public function getLineBreakIndex (startIndex:Int = 0):Int {

		var br = text.indexOf ("<br>", startIndex);
		var cr = text.indexOf ("\n", startIndex);
		var lf = text.indexOf ("\r", startIndex);
		
		if (cr == -1 && br == -1) return lf;
		if (lf == -1 && br == -1) return cr;
		if (lf == -1 && cr == -1) return br;

		if (cr == -1) return Std.int (Math.min (br, lf));
		if (lf == -1) return Std.int (Math.min (br, cr));
		if (br == -1) return Std.int (Math.min (cr, lf));

		return Std.int (Math.min (Math.min (cr, lf), br));
		
	}
	
	
	private function getLineMeasurements ():Void {
		
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
		bottomScrollV = 0;
		maxScrollH = 0;
		
		for (group in layoutGroups) {
			
			while (group.lineIndex > numLines - 1) {
				
				lineAscents.push (currentLineAscent);
				lineDescents.push (currentLineDescent);
				lineLeadings.push (currentLineLeading != null ? currentLineLeading : 0);
				lineHeights.push (currentLineHeight);
				lineWidths.push (currentLineWidth);
				
				currentLineAscent = 0;
				currentLineDescent = 0;
				currentLineLeading = null;
				currentLineHeight = 0;
				currentLineWidth = 0;
				
				numLines++;
				
				if (textHeight <= height - 2) {
					
					bottomScrollV++;
					
				}
				
			}
			
			currentLineAscent = Math.max (currentLineAscent, group.ascent);
			currentLineDescent = Math.max (currentLineDescent, group.descent);
			
			if (currentLineLeading == null) {
				
				currentLineLeading = group.leading;
				
			} else {
				
				currentLineLeading = Std.int (Math.max (currentLineLeading, group.leading));
				
			}
			
			currentLineHeight = Math.max (currentLineHeight, group.height);
			currentLineWidth = group.offsetX - 2 + group.width;
			
			if (currentLineWidth > textWidth) {
				
				textWidth = currentLineWidth;
				
			}
			
			currentTextHeight = group.offsetY - 2 + group.ascent + group.descent;
			
			if (currentTextHeight > textHeight) {
				
				textHeight = currentTextHeight;
				
			}
			
		}
		
		if (textHeight == 0 && textField != null) {
			
			var currentFormat = textField.__textFormat;
			var ascent, descent, leading, heightValue;
			
			#if js
			
			// __context.font = getFont (currentFormat);
			
			if (currentFormat.__ascent != null) {
				
				ascent = currentFormat.size * currentFormat.__ascent;
				descent = currentFormat.size * currentFormat.__descent;
				
			} else {
				
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
				
			}
			
			leading = currentFormat.leading;
			
			heightValue = ascent + descent + leading;
			
			#elseif (lime_cffi)
			
			var font = getFontInstance (currentFormat);
			
			if (currentFormat.__ascent != null) {
				
				ascent = currentFormat.size * currentFormat.__ascent;
				descent = currentFormat.size * currentFormat.__descent;
				
			} else if (font != null) {
				
				ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
				descent = Math.abs ((font.descender / font.unitsPerEM) * currentFormat.size);
				
			} else {
				
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
				
			}
			
			leading = currentFormat.leading;
			
			heightValue = ascent + descent + leading;
			
			#end
			
			currentLineAscent = ascent;
			currentLineDescent = descent;
			currentLineLeading = leading;
			
			currentTextHeight = ascent + descent;
			textHeight = currentTextHeight;
			
		}
		
		lineAscents.push (currentLineAscent);
		lineDescents.push (currentLineDescent);
		lineLeadings.push (currentLineLeading != null ? currentLineLeading : 0);
		lineHeights.push (currentLineHeight);
		lineWidths.push (currentLineWidth);
		
		if (numLines == 1) {
			
			bottomScrollV = 1;
			
			if (currentLineLeading > 0) {
				
				textHeight += currentLineLeading;
				
			}
			
		} else if (textHeight <= height - 2) {
			
			bottomScrollV++;
			
		}
		
		if (autoSize != NONE) {
			
			switch (autoSize) {
				
				case LEFT, RIGHT, CENTER:
					
					if (!wordWrap /*&& (width < textWidth + 4)*/) {
						
						width = textWidth + 4;
						
					}
					
					height = textHeight + 4;
					bottomScrollV = numLines;
				
				default:
					
				
			}
			
		}
		
		if (textWidth > width - 4) {
			
			maxScrollH = Std.int (textWidth - width + 4);
			
		} else {
			
			maxScrollH = 0;
			
		}
		
		maxScrollV = numLines - bottomScrollV + 1;
		
	}
	
	
	private function getLayoutGroups ():Void {
		
		layoutGroups.length = 0;
		
		if (text == null || text == "") return;
		
		var rangeIndex = -1;
		var formatRange:TextFormatRange = null;
		var font = null;
		
		var currentFormat = TextField.__defaultTextFormat.clone ();
		
		var leading = 0;
		var ascent = 0.0, maxAscent = 0.0;
		var descent = 0.0;
		
		var layoutGroup:TextLayoutGroup = null, positions = null;
		var widthValue = 0.0, heightValue = 0.0, maxHeightValue = 0.0;
		
		var previousSpaceIndex = -2; // -1 equals not found, -2 saves extra comparison in `breakIndex == previousSpaceIndex`
		var spaceIndex = text.indexOf (" ");
		var breakIndex = getLineBreakIndex ();
		
		var offsetX = 2.0;
		var offsetY = 2.0;
		var textIndex = 0;
		var lineIndex = 0;
		var lineFormat = null;
		
		inline function getPositions (text:UTF8String, startIndex:Int, endIndex:Int) {
			
			// TODO: optimize
			
			var positions = [];
			
			#if (js && html5)
			
			if (__useIntAdvances == null) {
				
				__useIntAdvances = ~/Trident\/7.0/.match (Browser.navigator.userAgent); // IE
				
			}
			
			if (__useIntAdvances) {
				
				// slower, but more accurate if browser returns Int measurements
				
				var previousWidth = 0.0;
				var width;
				
				for (i in startIndex...endIndex) {
					
					width = __context.measureText (text.substring (startIndex, i + 1)).width;
					
					positions.push (width - previousWidth);
					
					previousWidth = width;
					
				}
				
			} else {
				
				for (i in startIndex...endIndex) {
					
					var advance;
					
					if (i < text.length-1) {
						
						// Advance can be less for certain letter combinations, e.g. 'Yo' vs. 'Do'
						var nextWidth = __context.measureText (text.charAt (i + 1)).width;
						var twoWidths = __context.measureText (text.substr (i,  2)).width;
						advance = twoWidths - nextWidth;
						
					} else {
						
						advance = __context.measureText (text.charAt (i)).width;
						
					}
					
					positions.push (advance);
					
				}
				
			}
			
			return positions;
			
			#else
			
			if (__textLayout == null) {
				
				__textLayout = new TextLayout ();
				
			}
			
			var width = 0.0;
			
			__textLayout.text = null;
			__textLayout.font = font;
			
			if (formatRange.format.size != null) {
				
				__textLayout.size = formatRange.format.size;
				
			}
			
			__textLayout.text = text.substring (startIndex, endIndex);
			return __textLayout.positions;
			
			#end
			
		}
		
		inline function getPositionsWidth (positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end):Float {
			
			var width = 0.0;
			
			for (position in positions) {
				
				#if (js && html5)
				width += position;
				#else
				width += position.advance.x;
				#end
				
			}
			
			return width;
			
		}
		
		inline function getTextWidth (text:String):Float {
			
			#if (js && html5)
			
			return __context.measureText (text).width;
			
			#else
			
			if (__textLayout == null) {
				
				__textLayout = new TextLayout ();
				
			}
			
			var width = 0.0;
			
			__textLayout.text = null;
			__textLayout.font = font;
			
			if (formatRange.format.size != null) {
				
				__textLayout.size = formatRange.format.size;
				
			}
			
			__textLayout.text = text;
			
			for (position in __textLayout.positions) {
				
				width += position.advance.x;
				
			}
			
			return width;
			
			#end
			
		}
		
		inline function nextLayoutGroup (startIndex, endIndex):Void {
			
			if (layoutGroup == null || layoutGroup.startIndex != layoutGroup.endIndex) {
				
				layoutGroup = new TextLayoutGroup (formatRange.format, startIndex, endIndex);
				layoutGroups.push (layoutGroup);
				
			} else {
				
				layoutGroup.format = formatRange.format;
				layoutGroup.startIndex = startIndex;
				layoutGroup.endIndex = endIndex;
				
			}
			
		}
		
		inline function nextFormatRange ():Void {
			
			if (rangeIndex < textFormatRanges.length - 1) {
				
				rangeIndex++;
				formatRange = textFormatRanges[rangeIndex];
				currentFormat.__merge (formatRange.format);
				
				#if (js && html5)
				
				__context.font = getFont (currentFormat);
				
				if (currentFormat.__ascent != null) {
					
					ascent = currentFormat.size * currentFormat.__ascent;
					descent = currentFormat.size * currentFormat.__descent;
					
				} else {
					
					ascent = currentFormat.size;
					descent = currentFormat.size * 0.185;
					
				}
				
				leading = currentFormat.leading;
				
				heightValue = ascent + descent + leading;
				
				#elseif (lime_cffi)
				
				font = getFontInstance (currentFormat);
				
				if (currentFormat.__ascent != null) {
					
					ascent = currentFormat.size * currentFormat.__ascent;
					descent = currentFormat.size * currentFormat.__descent;
					
				} else if (font != null) {
					
					ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
					descent = Math.abs ((font.descender / font.unitsPerEM) * currentFormat.size);
					
				} else {
					
					ascent = currentFormat.size;
					descent = currentFormat.size * 0.185;
					
				}
				
				leading = currentFormat.leading;
				
				heightValue = ascent + descent + leading;
				
				#end
				
			}
			
			if (heightValue > maxHeightValue) {
				
				maxHeightValue = heightValue;
				
			}
			
			if (ascent > maxAscent) {
				
				maxAscent = ascent;
				
			}
			
		}
		
		inline function alignBaseline ():Void {
			
			// since nextFormatRange may not have been called, have to update these manually
			if (ascent > maxAscent) {
				
				maxAscent = ascent;
				
			}
			
			if (heightValue > maxHeightValue) {
				
				maxHeightValue = heightValue;
				
			}
			
			for (lg in layoutGroups) {
				
				if (lg.lineIndex < lineIndex) continue;
				if (lg.lineIndex > lineIndex) break;
				
				lg.ascent = maxAscent;
				lg.height = maxHeightValue;
				
			}
			
			offsetY += maxHeightValue;
			
			maxAscent = 0.0;
			maxHeightValue = 0.0;
			
			++lineIndex;
			offsetX = 2;
			
		}
		
		inline function breakLongWords (endIndex:Int):Void {
			
			var tempWidth = getTextWidth (text.substring (textIndex, endIndex));
			
			while (offsetX + tempWidth > width - 2) {
				
				var i = 1;
				
				while (textIndex + i < endIndex + 1) {
					
					tempWidth = getTextWidth (text.substr (textIndex, i));
					
					if (offsetX + tempWidth > width - 2) {
						
						i--;
						break;
						
					}
					
					i++;
					
				}
				
				if (i == 0 && tempWidth > width - 4) {
					// if the textfield is smaller than a single character
					
					i = text.length;
					
				}
				
				if (i == 0) {
					// if a single character in a new format made the line too long
					
					offsetX = 2;
					offsetY += layoutGroup.height;
					++lineIndex;
					
					break;
					
				}
				
				else {
					
					nextLayoutGroup (textIndex, textIndex + i);
					layoutGroup.positions = getPositions (text, textIndex, textIndex + i);
					layoutGroup.offsetX = offsetX;
					layoutGroup.ascent = ascent;
					layoutGroup.descent = descent;
					layoutGroup.leading = leading;
					layoutGroup.lineIndex = lineIndex;
					layoutGroup.offsetY = offsetY;
					layoutGroup.width = getPositionsWidth (layoutGroup.positions);
					layoutGroup.height = heightValue;
					
					layoutGroup = null;
					
					alignBaseline ();
					
					textIndex += i;
					
					positions = getPositions (text, textIndex, endIndex);
					widthValue = getPositionsWidth (positions);
					
					tempWidth = widthValue;
					
				}
				
			}
			
		}
		
		nextFormatRange ();
		
		lineFormat = formatRange.format;
		var wrap;
		var maxLoops = text.length + 1; // Do an extra iteration to ensure a LayoutGroup is created in case the last line is empty (multiline or trailing line break).
		
		while (textIndex < maxLoops) {
			
			if ((breakIndex > -1) && (spaceIndex == -1 || breakIndex < spaceIndex) && (formatRange.end >= breakIndex)) {
				// if a line break is the next thing that needs to be dealt with
				
				if (textIndex <= breakIndex) {
					
					if (wordWrap && previousSpaceIndex <= textIndex && width >= 4) {
						
						breakLongWords (breakIndex);
						
					}
					
					nextLayoutGroup (textIndex, breakIndex);
					
					layoutGroup.positions = getPositions (text, textIndex, breakIndex);
					layoutGroup.offsetX = offsetX;
					layoutGroup.ascent = ascent;
					layoutGroup.descent = descent;
					layoutGroup.leading = leading;
					layoutGroup.lineIndex = lineIndex;
					layoutGroup.offsetY = offsetY;
					layoutGroup.width = getPositionsWidth (layoutGroup.positions);
					layoutGroup.height = heightValue;
					
					layoutGroup = null;
					
				} else if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex) {
					
					// Trim the last space from the line width, for correct TextFormatAlign.RIGHT alignment
					if (layoutGroup.endIndex == spaceIndex) {
						
						layoutGroup.width -= layoutGroup.getAdvance (layoutGroup.positions.length - 1);
						
					}
					
					layoutGroup = null;
					
				}
				
				if (formatRange.end == breakIndex) {
					
					nextFormatRange ();
					lineFormat = formatRange.format;
					
				}
				
				if (breakIndex >= text.length - 1) {
					
					// Trailing line breaks do not add to textHeight (offsetY), but they do add to numLines (lineIndex)
					offsetY -= maxHeightValue;
					
				}
				
				alignBaseline ();
				
				textIndex = breakIndex + 1;
				breakIndex = getLineBreakIndex (textIndex);
				
			} else if (formatRange.end >= spaceIndex && spaceIndex > -1 && textIndex < formatRange.end) {
				// if a space is the next thing that needs to be dealt with
				
				if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex) {
					
					layoutGroup = null;
					
				}
				
				wrap = false;
				
				while (true) {
					
					if (textIndex == formatRange.end) break;
					
					var endIndex = -1;
					
					if (spaceIndex == -1) {
						
						endIndex = breakIndex;
						
					}
					
					else {
						
						endIndex = spaceIndex + 1;
						
						if (breakIndex > -1 && breakIndex < endIndex) {
							
							endIndex = breakIndex;
							
						}
						
					}
					
					if (endIndex == -1 || endIndex > formatRange.end) {
						
						endIndex = formatRange.end;
						
					}
					
					positions = getPositions (text, textIndex, endIndex);
					widthValue = getPositionsWidth (positions);
					
					if (lineFormat.align == JUSTIFY) {
						
						if (positions.length > 0 && textIndex == previousSpaceIndex) {
							
							// Trim left space of this word
							textIndex++;
							
							var spaceWidth = #if (js && html5) positions.shift () #else positions.shift ().advance.x #end;
							widthValue -= spaceWidth;
							offsetX += spaceWidth;
							
						}
						
						if (positions.length > 0 && endIndex == spaceIndex+1) {
							
							// Trim right space of this word
							endIndex--;
							
							var spaceWidth = #if (js && html5) positions.pop () #else positions.pop ().advance.x #end;
							widthValue -= spaceWidth;
							
						}
						
					}
					
					if (wordWrap) {
						
						if (offsetX + widthValue > width - 2) {
							
							wrap = true;
							
							if (positions.length > 0 && endIndex == spaceIndex + 1) {
								
								// if last letter is a space, avoid word wrap if possible
								// TODO: Handle multiple spaces
								
								var lastPosition = positions[positions.length - 1];
								var spaceWidth = #if (js && html5) lastPosition #else lastPosition.advance.x #end;
								
								if (offsetX + widthValue - spaceWidth <= width - 2) {
									
									wrap = false;
									
								}
								
							}
							
						}
						
					}
					
					if (wrap) {
						
						if (lineFormat.align != JUSTIFY && (layoutGroup != null || layoutGroups.length > 0)) {
							
							var previous = layoutGroup;
							if (previous == null) {
								previous = layoutGroups[layoutGroups.length - 1];
							}
							
							// For correct selection rectangles and alignment, trim the trailing space of the previous line:
							previous.width -= previous.getAdvance (previous.positions.length - 1);
							previous.endIndex--;
							
						}
						
						var i = layoutGroups.length - 1;
						var offsetCount = 0;
						
						while (true) {
							
							layoutGroup = layoutGroups[i];
							
							if (i > 0 && layoutGroup.startIndex > previousSpaceIndex) {
								
								offsetCount++;
								
							} else {
								
								break;
								
							}
							
							i--;
							
						}
						
						if (textIndex == previousSpaceIndex + 1) {
							
							alignBaseline();
							
						}
						
						offsetX = 2;
						
						if (offsetCount > 0) {
							
							var bumpX = layoutGroups[layoutGroups.length - offsetCount].offsetX;
							
							for (i in (layoutGroups.length - offsetCount)...layoutGroups.length) {
								
								layoutGroup = layoutGroups[i];
								layoutGroup.offsetX -= bumpX;
								layoutGroup.offsetY = offsetY;
								layoutGroup.lineIndex = lineIndex;
								offsetX += layoutGroup.width;
								
							}
							
						}
						
						if (width >= 4) breakLongWords(endIndex);
						
						nextLayoutGroup (textIndex, endIndex);
						
						layoutGroup.positions = positions;
						layoutGroup.offsetX = offsetX;
						layoutGroup.ascent = ascent;
						layoutGroup.descent = descent;
						layoutGroup.leading = leading;
						layoutGroup.lineIndex = lineIndex;
						layoutGroup.offsetY = offsetY;
						layoutGroup.width = widthValue;
						layoutGroup.height = heightValue;
						
						offsetX += widthValue;
						
						textIndex = endIndex;
						
						wrap = false;
						
					} else {
						
						if (layoutGroup != null && textIndex == spaceIndex) {
							
							if (lineFormat.align != JUSTIFY) {
								
								layoutGroup.endIndex = spaceIndex;
								layoutGroup.positions = layoutGroup.positions.concat (positions);
								layoutGroup.width += widthValue;
								
							}
							
						} else if (layoutGroup == null || lineFormat.align == JUSTIFY) {
							
							nextLayoutGroup (textIndex, endIndex);
							
							layoutGroup.positions = positions;
							layoutGroup.offsetX = offsetX;
							layoutGroup.ascent = ascent;
							layoutGroup.descent = descent;
							layoutGroup.leading = leading;
							layoutGroup.lineIndex = lineIndex;
							layoutGroup.offsetY = offsetY;
							layoutGroup.width = widthValue;
							layoutGroup.height = heightValue;
							
						} else {
							
							layoutGroup.endIndex = endIndex;
							layoutGroup.positions = layoutGroup.positions.concat (positions);
							layoutGroup.width += widthValue;
							
							// If next char is newline, process it immediately and prevent useless extra layout groups
							if (breakIndex == endIndex) endIndex++;
							
						}
						
						offsetX += widthValue;
						
						textIndex = endIndex;
						
					}
					
					var nextSpaceIndex = text.indexOf (" ", textIndex);
					
					if (formatRange.end <= previousSpaceIndex) {
						
						layoutGroup = null;
						textIndex = formatRange.end;
						nextFormatRange ();
						
					} else {
						
						// Check if we can continue wrapping this line until the next line-break or end-of-String.
						// When `previousSpaceIndex == breakIndex`, the loop has finished growing layoutGroup.endIndex until the end of this line.
						
						if (breakIndex == previousSpaceIndex) {
							
							layoutGroup.endIndex = breakIndex;
							
							if (breakIndex - layoutGroup.startIndex - layoutGroup.positions.length < 0) {
								
								// Newline has no size
								layoutGroup.positions.push (#if (js && html5) 0.0 #else null #end);
								
							}
							
							textIndex = breakIndex + 1;
							
						}
						
						previousSpaceIndex = spaceIndex;
						spaceIndex = nextSpaceIndex;
						
					}
					
					if ((breakIndex > -1 && breakIndex <= textIndex && (spaceIndex > breakIndex || spaceIndex == -1)) || textIndex > text.length || spaceIndex > formatRange.end) {
						
						break;
						
					}
					
				}
				
			} else {
				// if there are no line breaks or spaces to deal with next, place remaining text in the format range
				
				if (textIndex > formatRange.end) {
					
					break;
					
				} else if (textIndex < formatRange.end || textIndex == text.length) {
					
					if (wordWrap && width >= 4) {
						
						breakLongWords(formatRange.end);
						
					}
					
					positions = getPositions (text, textIndex, formatRange.end);
					widthValue = getPositionsWidth (positions);
					
					nextLayoutGroup (textIndex, formatRange.end);
					
					layoutGroup.positions = getPositions (text, textIndex, formatRange.end);
					layoutGroup.offsetX = offsetX;
					layoutGroup.ascent = ascent;
					layoutGroup.descent = descent;
					layoutGroup.leading = leading;
					layoutGroup.lineIndex = lineIndex;
					layoutGroup.offsetY = offsetY;
					layoutGroup.width = getPositionsWidth (layoutGroup.positions);
					layoutGroup.height = heightValue;
					
					offsetX += widthValue;
					textIndex = formatRange.end;
					
				}
				
				nextFormatRange ();
				
				if (textIndex == formatRange.end) {
					
					alignBaseline();
					
					textIndex++;
					break;
					
				}
				
			}
			
		}
		
		#if openfl_trace_text_layout_groups
		for (lg in layoutGroups) {
			trace("LG", lg.positions.length - (lg.endIndex - lg.startIndex), "line:" + lg.lineIndex, "w:" + lg.width, "h:" + lg.height, "x:" + Std.int(lg.offsetX), "y:" + Std.int(lg.offsetY), '"${text.substring(lg.startIndex, lg.endIndex)}"', lg.startIndex, lg.endIndex);
		}
		#end
		
	}
	
	
	private function setTextAlignment ():Void {
		
		var lineIndex = -1;
		var offsetX = 0.0;
		var totalWidth = this.width - 4;
		var group, lineLength;
		
		for (i in 0...layoutGroups.length) {
			
			group = layoutGroups[i];
			
			if (group.lineIndex != lineIndex) {
				
				lineIndex = group.lineIndex;
				
				switch (group.format.align) {
					
					case CENTER:
						
						if (lineWidths[lineIndex] < totalWidth) {
							
							offsetX = Math.round ((totalWidth - lineWidths[lineIndex]) / 2);
							
						} else {
							
							offsetX = 0;
							
						}
					
					case RIGHT:
						
						if (lineWidths[lineIndex] < totalWidth) {
							
							offsetX = Math.round (totalWidth - lineWidths[lineIndex]);
							
						} else {
							
							offsetX = 0;
							
						}
					
					case JUSTIFY:
						
						if (lineWidths[lineIndex] < totalWidth) {
							
							lineLength = 1;
							
							for (j in (i + 1)...layoutGroups.length) {
								
								if (layoutGroups[j].lineIndex == lineIndex) {
									
									if (j == 0 || text.charCodeAt (layoutGroups[j].startIndex - 1) == " ".code){
										
										lineLength++;
										
									}
									
								} else {
									
									break;
									
								}
								
							}
							
							if (lineLength > 1) {
								
								group = layoutGroups[i + lineLength - 1];
								
								var endChar = text.charCodeAt (group.endIndex);
								if (group.endIndex < text.length && endChar != "\n".code && endChar != "\r".code) {
									
									offsetX = (totalWidth - lineWidths[lineIndex]) / (lineLength - 1);
									
									var j = 0;
									do {
										
										if (j > 1 && text.charCodeAt (layoutGroups[j].startIndex - 1) != " ".code) {
											
											layoutGroups[i + j].offsetX += (offsetX * (j-1));
											j++;
											
										}
										
										layoutGroups[i + j].offsetX += (offsetX * j);
										
									} while (++j < lineLength);
									
								}
								
							}
							
						}
						
						offsetX = 0;
					
					default:
						
						offsetX = 0;
					
				}
				
			}
			
			if (offsetX > 0) {
				
				group.offsetX += offsetX;
				
			}
			
		}
		
	}
	
	
	private function update ():Void {
		
		if (text == null /*|| text == ""*/ || textFormatRanges.length == 0) {
			
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
			
		} else {
			
			getLayoutGroups ();
			getLineMeasurements ();
			setTextAlignment ();
			
		}
		
		getBounds ();
		
	}
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_restrict (value:String):String {
		
		if (restrict == value) {
			
			return restrict;
			
		}
		
		restrict = value;
		
		if (restrict == null || restrict.length == 0) {
			
			__restrictRegexp = null;
			
		} else {
			
			__restrictRegexp = createRestrictRegexp (value);
			
		}
		
		return restrict;
		
	}
	
	
	private function set_text (value:String):String {
		
		if (value == null) {
			
			return text = value;
			
		}
		
		if (__restrictRegexp != null) {
			
			value = __restrictRegexp.split (value).join ('');
			
		}
		
		if (maxChars > 0 && value.length > maxChars) {
			
			value = value.substr (0, maxChars);
			
		}
		
		text = value;
		
		return text;
		
	}
	
	
}
