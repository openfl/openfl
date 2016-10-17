package openfl._internal.text;


import haxe.Timer;
import haxe.Utf8;
import lime.graphics.cairo.CairoFontFace;
import lime.graphics.opengl.GLTexture;
import lime.system.System;
import lime.text.TextLayout;
import openfl.display.Tilesheet;
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
import js.html.CSSStyleDeclaration;
import js.html.InputElement;
import js.html.KeyboardEvent in HTMLKeyboardEvent;
import js.Browser;
#end

#if sys
import haxe.io.Path;
#end

typedef FontData = {
	var name:String;
	var ascent: Float;
	var descent: Float;
};

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
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var height:Float;
	public var layoutGroups:Array<TextLayoutGroup>;
	public var lineLayoutGroups:Array<Array<TextLayoutGroup>>;
	public var lineAscents:Array<Float>;
	public var lineBreaks:Array<Int>;
	public var lineDescents:Array<Float>;
	public var lineLeadings:Array<Float>;
	public var lineHeights:Array<Float>;
	public var lineWidths:Array<Float>;
	public var maxChars:Int;
	public var maxScrollH (default, null):Int;
	public var maxScrollV (default, null):Int;
	public var multiline:Bool;
	public var numLines (default, null):Int;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var sharpness:Float;
	public var text:String;
	public var textHeight:Float;
	public var textFormatRanges:Array<TextFormatRange>;
	public var textWidth:Float;
	public var type:TextFieldType;
	public var width:Float;
	public var wordWrap:Bool;
	
	private var textField:TextField;
	
	@:noCompletion private var __cursorPosition:Int;
	@:noCompletion private var __cursorTimer:Timer;
	@:noCompletion private var __hasFocus:Bool;
	@:noCompletion private var __isKeyDown:Bool;
	@:noCompletion private var __measuredHeight:Int;
	@:noCompletion private var __measuredWidth:Int;
	@:noCompletion private var __selectionStart:Int;
	@:noCompletion private var __showCursor:Bool;
	@:noCompletion private var __textFormat:TextFormat;
	@:noCompletion private var __textLayout:TextLayout;
	@:noCompletion private var __texture:GLTexture;
	@:noCompletion private var __tileData:Map<Tilesheet, Array<Float>>;
	@:noCompletion private var __tileDataLength:Map<Tilesheet, Int>;
	@:noCompletion private var __tilesheets:Map<Tilesheet, Bool>;
	
	@:noCompletion @:dox(hide) public var __cairoFont:CairoFontFace;
	@:noCompletion @:dox(hide) public var __font:Font;
	
	#if (js && html5)
	private var __hiddenInput:InputElement;
	#end
	
	
	public function new (textField:TextField) {
		
		this.textField = textField;
		
		width = 100;
		height = 100;
		text = "";
		
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
		
		lineAscents = new Array ();
		lineBreaks = new Array ();
		lineDescents = new Array ();
		lineLeadings = new Array ();
		lineHeights = new Array ();
		lineWidths = new Array ();
		layoutGroups = new Array ();
		lineLayoutGroups = new Array();
		textFormatRanges = new Array ();
		
		#if (js && html5)
		__canvas = cast Browser.document.createElement ("canvas");
		__context = __canvas.getContext ("2d");
		#end
		
	}

	#if (cpp || neko || nodejs)
	private static function findFont (name:String):Font {


		for (registeredFont in Font.__registeredFonts) {
			
			if (registeredFont == null) continue;
			
			if (registeredFont.fontName == name || (registeredFont.__fontPath != null && (registeredFont.__fontPath == name || registeredFont.__fontPathWithoutDirectory == name))) {
				
				return registeredFont;
				
			}
			
		}
		
		var font = Font.fromFile (name);
		
		if (font != null) {
			
			Font.__registeredFonts.push (font);
			return font;
			
		}

		return null;
		
	}

	#end


	private function getBounds ():Void {
		
		var padding = border ? 1 : 0;
		
		bounds.width = width + padding;
		bounds.height = height + padding;
		
	}


	public static function getFont (format:TextFormat):FontData {

		var logicalFontName = format.font;
		logicalFontName += format.bold ? " Bold" : "";
		logicalFontName += format.italic ? " Italic" : "";

		var font = "normal normal normal ";
		font += format.size + "px";
		font += "/" + (format.size + format.leading + 6) + "px ";
		
		font += "" + switch (format.font) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: "'" + logicalFontName + "'";
			
		}

		var fontData: Dynamic = Reflect.getProperty( @:privateAccess Assets.getLibrary("default"), "fontData" ).get( logicalFontName );

		if (fontData == null){
			trace("Warning: No font data found for font: " + logicalFontName + ". Falling back to " + format.font );
			fontData = Reflect.getProperty( @:privateAccess Assets.getLibrary("default"), "fontData" ).get( format.font );
			font = format.italic ? "italic " : "normal ";
			font += "normal ";
			font += format.bold ? "bold " : "normal ";
			font += format.size + "px";
			font += "/" + (format.size + format.leading + 6) + "px ";

			if ( fontData == null ) {
				trace("Fallback didn't contain font data. Falling back to defaults." );
				return {name:font, ascent: 0.825, descent:0.175};
			}
		}

		return {name:font, ascent:fontData.ascent, descent:fontData.descent };

	}
	
	
	public static function getFontInstance (format:TextFormat):Font {
		
		#if (cpp || neko || nodejs)
		
		var instance = null;
		var fontList = null;
		
		if (format != null && format.font != null) {
			
			if (__defaultFonts.exists (format.font)) {
				
				return __defaultFonts.get (format.font);
				
			}
			
			instance = findFont (format.font);
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
					fontList = [ systemFontDirectory + "/Arial Black.ttf", systemFontDirectory + "/Arial.ttf", systemFontDirectory + "/Helvetica.ttf", systemFontDirectory + "/Cache/Arial Black.ttf", systemFontDirectory + "/Cache/Arial.ttf", systemFontDirectory + "/Cache/Helvetica.ttf", systemFontDirectory + "/Core/Arial Black.ttf", systemFontDirectory + "/Core/Arial.ttf", systemFontDirectory + "/Core/Helvetica.ttf", systemFontDirectory + "/CoreAddition/Arial Black.ttf", systemFontDirectory + "/CoreAddition/Arial.ttf", systemFontDirectory + "/CoreAddition/Helvetica.ttf" ];
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
				
				fontList = [ systemFontDirectory + "/timesb.ttf" ];
				
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
	
	
	private function getLineMeasurements ():Void {
		
		lineAscents.splice (0, lineAscents.length);
		lineDescents.splice (0, lineDescents.length);
		lineLeadings.splice (0, lineLeadings.length);
		lineHeights.splice (0, lineHeights.length);
		lineWidths.splice (0, lineWidths.length);
		
		var currentLineAscent = 0.0;
		var currentLineDescent = 0.0;
		var currentLineLeading:Null<Float> = null;
		var currentLineHeight = 0.0;
		var currentLineWidth = 0.0;
		
		textWidth = 0;
		textHeight = 0;
		numLines = 1;
		bottomScrollV = 0;
		maxScrollH = 0;
		
		for (groups in lineLayoutGroups) {
			if ( groups.length > 0 ) {
				var group = groups[0];
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

				textHeight = group.offsetY - 2 + group.ascent + group.descent;

				currentLineWidth = 0;

				for(group in groups) {

					currentLineWidth += group.width;
			
					if (currentLineWidth > textWidth) {
						
						textWidth = currentLineWidth;
						
					}
			
				}
			}
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
		
		if (textWidth > width - 4) {
			
			maxScrollH = Std.int (textWidth - width + 4);
			
		} else {
			
			maxScrollH = 0;
			
		}
		
		maxScrollV = numLines - bottomScrollV + 1;
		
	}
	
	
	private function getLayoutGroups ():Void {
		
		layoutGroups.splice (0, layoutGroups.length);
		lineLayoutGroups.splice (0, lineLayoutGroups.length);
		
		var rangeIndex = -1;
		var formatRange:TextFormatRange = null;
		var font = null;
		
		var currentFormat = this.textField.defaultTextFormat;

		var leading = 0.0;
		var ascent = 0.0;
		var descent = 0.0;
		
		var layoutGroup;
		var advances: Array<Float> = new Array();
		var widthValue = 0.0;
		var heightValue = 0.0;
		
		var offsetX = 2.0;
		var offsetY = 2.0;
		var textIndex = 0;
		var lineIndex = 0;
		var lineFormat = null;
		
		var itHasAddedAdvance: Bool = false;

		var textLength = this.text.length;
			
		inline function fillLayoutGroup (format:TextFormat, startIndex:Int, endIndex:Int):Void {
			layoutGroup = new TextLayoutGroup (format, startIndex, endIndex);
			layoutGroup.offsetX = offsetX;
			layoutGroup.ascent = ascent;
			layoutGroup.descent = descent;
			layoutGroup.leading = leading;
			layoutGroup.lineIndex = lineIndex;
			layoutGroup.offsetY = offsetY;
			//layoutGroup.width = widthValue;
			layoutGroup.height = heightValue;
			widthValue = 0;
			advances.splice(0,advances.length);
		}
			
		inline function getAdvance (text:String, startIndex:Int):Float {
			
			var width:Float = 0;
			#if (js && html5)
			
			var text_buffer: String = "";
			var char = text.charAt(startIndex);

			// :HACK: increase accuracy on browsers returning measurements as integers 
			for( iterator in 0...128 ) {
				text_buffer += char;
			}

			width = __context.measureText (text_buffer).width / 128.0;
			
			#else
			
			if (__textLayout == null) {
				
				__textLayout = new TextLayout ();
				
			}
			
			__textLayout.text = null;
			__textLayout.font = font;
			
			if (formatRange.format.size != null) {
				
				__textLayout.size = formatRange.format.size;
				
			}
			
			__textLayout.text = text.charAt(startIndex);
			
			for (position in __textLayout.positions) {
				
				width = position.advance.x;
				
			}
			
			#end
			
			return width;
			
		}
		
		inline function nextFormatRange ():Void {
			
			if (rangeIndex < textFormatRanges.length - 1) {
				
				rangeIndex++;
				formatRange = textFormatRanges[rangeIndex];
				currentFormat.__merge (formatRange.format);
				
				#if (js && html5)

				var fontData = getFont (currentFormat);
				__context.font = fontData.name;

				ascent = currentFormat.size * fontData.ascent;
				descent = currentFormat.size * fontData.descent;
				leading = currentFormat.leading / 20;

				heightValue = ascent + descent + leading;
				
				#elseif (cpp || neko || nodejs)
				
				font = getFontInstance (currentFormat);
				
				if (font != null) {
					
					ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
					descent = Math.abs ((font.descender / font.unitsPerEM) * currentFormat.size);
					leading = currentFormat.leading;
					
					heightValue = ascent + descent + leading;
					
				} else {
					
					ascent = currentFormat.size;
					descent = currentFormat.size * 0.185;
					leading = currentFormat.leading;
					
					heightValue = ascent + descent + leading;
					
				}
				
				#end
				
			}

		}
					
		inline function pushLayoutGroup() {
			layoutGroups.push (layoutGroup);
					
			if ( lineLayoutGroups.length == lineIndex ) {
				lineLayoutGroups.push([]);
			}
				
			lineLayoutGroups[lineIndex].push(layoutGroup);
		}
			
		inline function pushNewLine(textIndex:Int) {
			layoutGroup.width = widthValue;
			layoutGroup.advances = advances;
			layoutGroup.endIndex = textIndex;
			pushLayoutGroup();
			offsetY += heightValue;
			offsetX = 2; // :NOTE: I have no idea why this is here.
			lineIndex++;
			fillLayoutGroup(formatRange.format, textIndex, formatRange.end);
			lineFormat = formatRange.format;
		}

		inline function addAdvance(text, textIndex) {
			if (!itHasAddedAdvance) {
				itHasAddedAdvance = true;
				var character_advance = getAdvance(text,textIndex);
				advances.push(character_advance);
				widthValue += character_advance;

			}
		}

		inline function removeLastAdvance() {
			var value = advances[advances.length-1];
			advances[advances.length-1] = 0;
			widthValue -= value;
		}

		nextFormatRange();

		fillLayoutGroup(formatRange.format, formatRange.start, formatRange.end);
		lineFormat = formatRange.format;
		var previousChar:String = "";
		while( textIndex < this.text.length ) {
			itHasAddedAdvance = false;
			var char = this.text.charAt(textIndex);
			if ( char == "\n" ) {
				// don't add the advance for this character
				itHasAddedAdvance = true;
				pushNewLine(textIndex);
			}
			// remove the space.
			if ( previousChar == " " || previousChar == "-" ) {
				var iterator = textIndex-1;
				var width_till_next_word = getAdvance(text,iterator);
				iterator++;
				if ( wordWrap && Math.floor( layoutGroup.offsetX + widthValue + width_till_next_word ) > width - 2 ) {
					removeLastAdvance();
					pushNewLine(textIndex);
				} else {
					var next_space = text.indexOf(" ", textIndex);
					var next_hyphen = text.indexOf("-", textIndex);
					var next_break = -1;
					if ( next_space > -1 ) {
						if ( next_hyphen > -1 ) {
							next_break = Std.int(Math.min(next_space, next_hyphen));
						} else {
							next_break = next_space;
						}
					} else {
						if ( next_hyphen > -1 ) {
							next_break = next_hyphen;
						} else {
							next_break = text.length;
						}
					}

					while(iterator < next_break) {
						width_till_next_word += getAdvance(text,iterator);
						iterator++;
					}
					if ( wordWrap && Math.floor( layoutGroup.offsetX + widthValue + width_till_next_word ) > width - 2 ) {
						removeLastAdvance();
						pushNewLine(textIndex);
					} else if ( formatRange.format.align == JUSTIFY ) {
						layoutGroup.endIndex = textIndex;
						layoutGroup.advances = advances;
						layoutGroup.width = widthValue;
						offsetX = layoutGroup.offsetX + layoutGroup.width;
						pushLayoutGroup();
						fillLayoutGroup(formatRange.format, textIndex, formatRange.end);
					}
				}
			} else {
				// :NOTE: Why the offset by 2 pixels?
				if ( wordWrap && layoutGroup.offsetX + widthValue > width - 2 ) {
					pushNewLine(textIndex);
				}
			}

			// add text advance and check for updated format range.
			if ( ( textIndex == formatRange.end ) ) {
				layoutGroup.advances = advances;
				layoutGroup.width = widthValue;
				offsetX = layoutGroup.offsetX + layoutGroup.width;
				pushLayoutGroup();

				nextFormatRange();
				fillLayoutGroup(formatRange.format, formatRange.start, formatRange.end);
			}
		
			addAdvance(text,textIndex);

			textIndex++;
			previousChar = char;
		}
		layoutGroup.advances = advances;
		layoutGroup.width = widthValue;
		pushLayoutGroup();

		if ( rangeIndex < textFormatRanges.length - 1 ) {
			throw "not all text ranges were processed by the text engine.";
		}
		
	}
	
	
	private function setTextAlignment ():Void {
		
		var lineIndex = -1;
		var offsetX = 0.0;
		var group, groups, lineLength;

		var realWidth:Float = width;
		if (autoSize != TextFieldAutoSize.NONE && !multiline)
		{
			realWidth = textWidth;
		}
		
		if( lineLayoutGroups.length > 0 ) {
			for (i in 0...lineLayoutGroups.length) {
				groups = lineLayoutGroups[i];
				if ( groups.length > 0 ) {
					group = groups[0];
				
					lineIndex = group.lineIndex;
					
					switch (group.format.align) {
						
						case CENTER:
							
							if (lineWidths[lineIndex] < realWidth - 4) {
								
								offsetX = Math.round ((realWidth - 4 - lineWidths[lineIndex]) / 2);
								
							} else {
								
								offsetX = 0;
								
							}
						
						case RIGHT:
							
							if (lineWidths[lineIndex] < realWidth - 4) {
								
								offsetX = Math.round (realWidth - 4 - lineWidths[lineIndex]);
								
							} else {
								
								offsetX = 0;
								
							}
						
						case JUSTIFY:
							
							if (lineWidths[lineIndex] < realWidth - 4) {
								if ( groups.length > 1 ) {
									group = groups[groups.length-1];
									if (group.endIndex < text.length && text.charAt (group.endIndex) != "\n") {
										
										offsetX = (realWidth - 4 - lineWidths[lineIndex]) / (groups.length - 1);
										
										for (j in 0...groups.length ) {
											
											groups[j].offsetX += (offsetX * j);
											
										}
										
									}
								}
							}
							offsetX = 0;
						
						default:
							
							offsetX = 0;
						
					}
				}
				
				if (offsetX > 0) {
					
					for ( group in groups ) {
						group.offsetX += offsetX;
						
					}
				
				}
			
			}
		}

	}
	
	
	private function update ():Void {
		
		if (text == null || StringTools.trim (text) == "" || textFormatRanges.length == 0) {
			
			lineAscents.splice (0, lineAscents.length);
			lineBreaks.splice (0, lineBreaks.length);
			lineDescents.splice (0, lineDescents.length);
			lineLeadings.splice (0, lineLeadings.length);
			lineHeights.splice (0, lineHeights.length);
			lineWidths.splice (0, lineWidths.length);
			layoutGroups.splice (0, layoutGroups.length);
			lineLayoutGroups.splice (0, lineLayoutGroups.length);
			
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
	
	
}
