package openfl._internal.text;


import haxe.Timer;
import haxe.Utf8;
import lime.graphics.cairo.CairoFont;
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

@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)


class TextEngine {
	
	
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
	public var bounds:Rectangle;
	public var caretIndex:Int;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var height:Float;
	public var lineAscents:Array<Int>;
	public var lineBreaks:Array<Int>;
	public var lineDescents:Array<Int>;
	public var lineLeadings:Array<Int>;
	public var lineHeights:Array<Float>;
	public var lineWidths:Array<Float>;
	public var maxChars:Int;
	public var multiline:Bool;
	public var layoutGroups:Array<TextLayoutGroup>;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var sharpness:Float;
	public var text:String;
	public var textHeight:Int;
	public var textFormatRanges:Array<TextFormatRange>;
	public var textWidth:Int;
	public var type:TextFieldType;
	public var width:Float;
	public var wordWrap:Bool;
	
	public static inline var UTF8_TAB:Int     = 9;
	public static inline var UTF8_ENDLINE:Int = 10;
	public static inline var UTF8_SPACE:Int   = 32;
	public static inline var UTF8_HYPHEN:Int  = 0x2D;
	
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
	@:noCompletion public var __cairoFont:CairoFont;
	
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
		textFormatRanges = new Array ();
		
		#if (js && html5)
		__canvas = cast Browser.document.createElement ("canvas");
		__context = __canvas.getContext ("2d");
		#end
		
	}
	
	
	private static function findFont (name:String):Font {
		
		#if (cpp || neko || nodejs)
		
		for (registeredFont in Font.__registeredFonts) {
			
			if (registeredFont == null) continue;
			
			if (registeredFont.fontName == name || (registeredFont.__fontPath != null && (registeredFont.__fontPath == name || Path.withoutDirectory (registeredFont.__fontPath) == name))) {
				
				return registeredFont;
				
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
	
	
	public static function getFont (format:TextFormat):String {
		
		var font = format.italic ? "italic " : "normal ";
		font += "normal ";
		font += format.bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.size + format.leading + 6) + "px ";
		
		font += "" + switch (format.font) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: "'" + format.font + "'";
			
		}
		
		return font;
		
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
					#elseif (mac || ios)
					fontList = [ systemFontDirectory + "/Arial Black.ttf", systemFontDirectory + "/Arial.ttf", systemFontDirectory + "/Helvetica.ttf" ];
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
					#elseif (mac || ios)
					fontList = [ systemFontDirectory + "/Courier New.ttf", systemFontDirectory + "/Courier.ttf" ];
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
		#elseif (mac || ios)
		fontList = [ systemFontDirectory + "/Georgia.ttf", systemFontDirectory + "/Times.ttf", systemFontDirectory + "/Times New Roman.ttf" ];
		#elseif linux
		fontList = [ new sys.io.Process('fc-match', ['serif', '-f%{file}']).stdout.readLine() ];
		#elseif android
		fontList = [ systemFontDirectory + "/DroidSerif-Regular.ttf", systemFontDirectory + "NotoSerif-Regular.ttf" ];
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
	
	
	private function getLineBreaks ():Void {
		
		lineBreaks.splice (0, lineBreaks.length);
		
		//if (wordWrap && multiline) {
			//
			//// TODO: do this without string splicing
			//
			////var lines = [];
			//var words = text.split (" ");
			//var line = "";
			//
			//var word, newLineIndex, test;
			//var index = 0;
			//
			//for (i in 0...words.length) {
				//
				//word = words[i];
				////index += word.length;
				//newLineIndex = word.indexOf ("\n");
				//
				//if (newLineIndex > -1) {
					//
					//while (newLineIndex > -1) {
						//
						//test = line + word.substring (0, newLineIndex) + " ";
						//
						//if (__context.measureText (test).width > this.width - 4 && i > 0) {
							//
							//lineBreaks.push (index > 0 ? index -1 : 0);
							//index += newLineIndex;
							//lineBreaks.push (index);
							//
							////lines.push (line);
							////lines.push (word.substring (0, newLineIndex));
							//
						//} else {
							//
							//index += newLineIndex;
							//lineBreaks.push (index);
							//index++;
							//
							////lines.push (line + word.substring (0, newLineIndex));
							//
						//}
						//
						////index += newLineIndex + 1;
						//
						//word = word.substr (newLineIndex + 1);
						//newLineIndex = word.indexOf ("\n");
						//line = "";
						//
					//}
					//
					//if (word != "") {
						//
						//line = word + " ";
						//
					//}
					//
				//} else {
					//
					//test = line + words[i] + " ";
					//
					//if (__context.measureText (test).width > this.width - 4 && i > 0) {
						//
						//lineBreaks.push (index > 0 ? index -1 : 0);
						//
						////lines.push (line);
						//line = words[i] + " ";
						//
					//} else {
						//
						//line = test;
						//
					//}
					//
					//index += words[i].length + 1;
					//
				//}
				//
			//}
			//
			//if (line != "") {
				//
				////lines.push (line);
				//
			//}
			//
			////var index = 1;
			////
			////for (line in lines) {
				////
				////index += line.length - 1;
				////lineBreaks.push (index);
				////
			////}
			//
			////
			////for (line in lines) {
				////
				////switch (format.align) {
					////
					////case TextFormatAlign.CENTER:
						////
						////context.textAlign = "center";
						////context.fillText (line, offsetX + textEngine.width / 2, 2 + yOffset, textEngine.getTextWidth ());
						////
					////case TextFormatAlign.RIGHT:
						////
						////context.textAlign = "end";
						////context.fillText (line, offsetX + textEngine.width - 2, 2 + yOffset, textEngine.getTextWidth ());
						////
					////default:
						////
						////context.textAlign = "start";
						////context.fillText (line, 2 + offsetX, 2 + yOffset, textEngine.getTextWidth ());
						////
				////}
				////
				////yOffset += format.size + format.leading + 4;
				////offsetX = 0;
				////
			////}
			//
		//} else {
			
			for (i in 0...text.length) {
				
				if (text.charCodeAt (i) == 10) {
					
					lineBreaks.push (i);
					
				}
				
			}
			
		//}
		
		//var i = 0;
		
		//Utf8.iter (text, function (char:Int) {
			//
			//if (char == 10) {
				//
				//lineBreaks.push (i);
				//i++;
				//
			//}
			//
		//});
		
	}
	
	
	private function getLineMeasurements ():Void {
		
		lineAscents.splice (0, lineAscents.length);
		lineDescents.splice (0, lineDescents.length);
		lineLeadings.splice (0, lineLeadings.length);
		lineHeights.splice (0, lineHeights.length);
		lineWidths.splice (0, lineWidths.length);
		
		var currentLineAscent = 0;
		var currentLineDescent = 0;
		var currentLineLeading = 0;
		var currentLineHeight = 0;
		var currentLineWidth = 0;
		
		textWidth = 0;
		textHeight = 0;
		
		var lineIndex = 0;
		
		for (group in layoutGroups) {
			
			while (group.lineIndex > lineIndex) {
				
				lineAscents.push (currentLineAscent);
				lineDescents.push (currentLineDescent);
				lineLeadings.push (currentLineLeading);
				lineHeights.push (currentLineHeight);
				lineWidths.push (currentLineWidth);
				
				currentLineAscent = 0;
				currentLineDescent = 0;
				currentLineLeading = 0;
				currentLineHeight = 0;
				currentLineWidth = 0;
				
				lineIndex++;
				
			}
			
			lineIndex = group.lineIndex;
			
			currentLineAscent = Std.int (Math.max (currentLineAscent, group.ascent));
			currentLineDescent = Std.int (Math.max (currentLineDescent, group.descent));
			currentLineLeading = Std.int (Math.max (currentLineLeading, group.leading));
			currentLineHeight = Std.int (Math.max (currentLineHeight, group.height));
			currentLineWidth = Std.int (Math.max (currentLineLeading, group.width));
			
			if (currentLineWidth > textWidth) {
				
				textWidth = currentLineWidth;
				
			}
			
			textHeight = group.ascent + group.descent + group.offsetY;
			
		}
		
		lineAscents.push (currentLineAscent);
		lineDescents.push (currentLineDescent);
		lineLeadings.push (currentLineLeading);
		lineHeights.push (currentLineHeight);
		lineWidths.push (currentLineWidth);
		
	}
	
	
	private function getLayoutGroups ():Void {
		
		#if (cpp || neko || nodejs)
		if (__textLayout == null) {
			
			__textLayout = new TextLayout ();
			
		}
		#end
		
		layoutGroups.splice (0, layoutGroups.length);
		
		var rangeIndex = -1;
		var formatRange = null;
		
		var ascent, descent, leading, font = null, layoutGroup;
		
		var previousSpaceIndex = 0;
		var spaceIndex = text.indexOf (" ");
		var breakIndex = text.indexOf ("\n");
		var offsetX = 2;
		var offsetY = 2;
		var widthValue;
		var heightValue;
		
		var textIndex = 0;
		var lineIndex = 0;
		
		var nextFormatRange = function () {
			
			if (rangeIndex < textFormatRanges.length - 1) {
				
				rangeIndex++;
				formatRange = textFormatRanges[rangeIndex];
				
				#if (js && html5)
				
				__context.font = getFont (formatRange.format);
				
				ascent = Std.int (formatRange.format.size * 0.8);
				descent = Std.int (formatRange.format.size * 0.2);
				leading = Std.int (formatRange.format.leading + 4);
				heightValue = Std.int (ascent + descent + leading);
				
				#elseif (cpp || neko || nodejs)
				
				font = getFontInstance (formatRange.format);
				
				ascent = Std.int ((font.ascender / font.unitsPerEM) * formatRange.format.size);
				descent = Std.int (Math.abs ((font.descender / font.unitsPerEM) * formatRange.format.size));
				leading = Std.int (formatRange.format.leading);
				heightValue = Std.int (ascent + descent + leading) + 2;
				
				#end
				
			}
			
		}
		
		nextFormatRange ();
		
		var getTextWidth = function (text:String):Int {
			
			#if (js && html5)
			
			return Std.int (__context.measureText (text).width);
			
			#else
			
			var width = 0;
			
			__textLayout.text = null;
			__textLayout.font = font;
			__textLayout.size = formatRange.format.size;
			__textLayout.text = text;
			
			for (position in __textLayout.positions) {
				
				width += Std.int (position.advance.x);
				
			}
			
			return width;
			
			#end
			
		}
		
		var wrap;
		
		while (textIndex < text.length) {
			
			if ( (breakIndex > -1) && (spaceIndex == -1 || breakIndex < spaceIndex) && (formatRange.end >= breakIndex)) {
				
				layoutGroup = new TextLayoutGroup (formatRange.format, textIndex, breakIndex);
				layoutGroup.offsetX = offsetX;
				layoutGroup.ascent = ascent;
				layoutGroup.descent = descent;
				layoutGroup.leading = leading;
				layoutGroup.lineIndex = lineIndex;
				layoutGroup.offsetY = offsetY;
				layoutGroup.width = getTextWidth (text.substring (textIndex, breakIndex));
				layoutGroup.height = heightValue;
				layoutGroups.push (layoutGroup);
				
				offsetY += Std.int (ascent + descent + leading);
				#if (cpp || neko || nodejs)
					offsetY += 2;
				#end
				offsetX = 2;
				
				if (wordWrap && (layoutGroup.offsetX + layoutGroup.width > width - 4)) {
					
					layoutGroup.offsetY = offsetY;
					layoutGroup.offsetX = offsetX;
					
					offsetY += Std.int (ascent + descent + leading);
					#if (cpp || neko || nodejs)
						offsetY += 2;
					#end
					lineIndex++;
					
				}
				
				textIndex = breakIndex + 1;
				breakIndex = text.indexOf ("\n", textIndex);
				lineIndex++;
				
				if (formatRange.end == breakIndex) {
					
					nextFormatRange ();
					
				}
				
			} else if (formatRange.end >= spaceIndex) {
				
				layoutGroup = null;
				wrap = false;
				
				while (true) {
					
					if (spaceIndex == -1) spaceIndex = formatRange.end;
					
					widthValue = getTextWidth (text.substring (textIndex, spaceIndex + 1));
					
					if (wordWrap) {
						
						if (offsetX + widthValue > width - 4) {
							
							wrap = true;
							
						}
						
					}
					
					if (wrap) {
						
						offsetY += Std.int (ascent + descent + leading);
						#if (cpp || neko || nodejs)
							offsetY += 2;
						#end
						
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
						
						lineIndex++;
						
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
						
						layoutGroup = new TextLayoutGroup (formatRange.format, textIndex, spaceIndex + 1);
						layoutGroup.offsetX = offsetX;
						layoutGroup.ascent = ascent;
						layoutGroup.descent = descent;
						layoutGroup.leading = leading;
						layoutGroup.lineIndex = lineIndex;
						layoutGroup.offsetY = offsetY;
						layoutGroup.width = widthValue;
						layoutGroup.height = heightValue;
						layoutGroups.push (layoutGroup);
						
						offsetX += widthValue;
						
						wrap = false;
						
					} else {
						
						if (layoutGroup == null) {
							
							layoutGroup = new TextLayoutGroup (formatRange.format, textIndex, spaceIndex + 1);
							layoutGroup.offsetX = offsetX;
							layoutGroup.ascent = ascent;
							layoutGroup.descent = descent;
							layoutGroup.leading = leading;
							layoutGroup.lineIndex = lineIndex;
							layoutGroup.offsetY = offsetY;
							layoutGroup.width = widthValue;
							layoutGroup.height = heightValue;
							layoutGroups.push (layoutGroup);
							
						} else {
							
							layoutGroup.endIndex = spaceIndex + 1;
							layoutGroup.width += widthValue;
							
						}
						
						offsetX += widthValue;
						
					}
					
					textIndex = spaceIndex + 1;
					
					previousSpaceIndex = spaceIndex;
					spaceIndex = text.indexOf (" ", previousSpaceIndex + 1);
					
					if (formatRange.end <= previousSpaceIndex) {
						
						nextFormatRange ();
						
					}
					
					if ((spaceIndex > breakIndex && breakIndex > -1) || textIndex > text.length || spaceIndex > formatRange.end) {
						
						break;
						
					}
					
				}
				
			} else {
				
				layoutGroup = new TextLayoutGroup (formatRange.format, textIndex, formatRange.end);
				layoutGroup.offsetX = offsetX;
				layoutGroup.ascent = ascent;
				layoutGroup.descent = descent;
				layoutGroup.leading = leading;
				layoutGroup.lineIndex = lineIndex;
				layoutGroup.offsetY = offsetY;
				layoutGroup.width = getTextWidth (text.substring (textIndex, formatRange.end));
				layoutGroup.height = heightValue;
				layoutGroups.push (layoutGroup);
				
				offsetX += layoutGroup.width;
				
				textIndex = formatRange.end + 1;
				
				nextFormatRange ();
				
			}
			
		}
		
	}
	
	
	public function getSelectionBeginIndex ():Int {
		
		return Std.int (Math.min (__cursorPosition, __selectionStart));
		
	}
	
	
	public function getSelectionEndIndex ():Int {
		
		return Std.int (Math.max (__cursorPosition, __selectionStart));
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		openfl.Lib.notImplemented ("TextField.setSelection");
		
	}
	
	
	private function setTextAlignment ():Void {
		
		var lineIndex = -1;
		var offsetX = 0;
		
		for (group in layoutGroups) {
			
			if (group.lineIndex != lineIndex) {
				
				lineIndex = group.lineIndex;
				
				switch (group.format.align) {
					
					case CENTER:
						
						if (lineWidths[lineIndex] < width - 4) {
							
							offsetX = Math.round ((width - 4 - lineWidths[lineIndex]) / 2);
							
						} else {
							
							offsetX = 0;
							
						}
					
					case RIGHT:
						
						if (lineWidths[lineIndex] < width - 4) {
							
							offsetX = Std.int (width - 2 - lineWidths[lineIndex]);
							
						} else {
							
							offsetX = 0;
							
						}
						
					
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
		
		if (text == null || StringTools.trim (text) == "" || textFormatRanges.length == 0) {
			
			lineAscents.splice (0, lineAscents.length);
			lineBreaks.splice (0, lineBreaks.length);
			lineDescents.splice (0, lineDescents.length);
			lineLeadings.splice (0, lineLeadings.length);
			lineHeights.splice (0, lineHeights.length);
			lineWidths.splice (0, lineWidths.length);
			layoutGroups.splice (0, layoutGroups.length);
			
		} else {
			
			getLayoutGroups ();
			getLineMeasurements ();
			setTextAlignment ();
			
		}
		
		if (autoSize != TextFieldAutoSize.NONE) {
			
			bounds.width = (textWidth + 4) + (border ? 1 : 0);
			bounds.height = (textHeight + 4) + (border ? 1 : 0);
			
		} else {
			
			bounds.width = width;
			bounds.height = height;
			
		}
		
	}
	
	
	@:noCompletion private function __getPosition (x:Float, y:Float):Int {
		
		if (x <= 2 || x > width + 4 || y <= 0 || y > width + 4) return 0;
		
		var currentY = 0.0;
		var lineIndex = -1;
		
		for (i in 0...lineAscents.length) {
			
			currentY += lineAscents[i] + lineDescents[i] + lineLeadings[i];
			
			if (y < currentY) {
				
				lineIndex = i;
				break;
				
			}
			
		}
		
		if (lineIndex == -1) return 0;
		
		// TODO: handle word wrap
		
		var startIndex = 0;
		var endIndex = text.length;
		
		if (lineBreaks.length > 0) {
			
			endIndex = lineBreaks[lineIndex];
			
		}
		
		if (lineIndex > 0) {
			
			startIndex = lineBreaks[lineIndex - 1];
			
		}
		
		if (x >= lineWidths[lineIndex]) {
			
			return endIndex;
			
		}
		
		// TODO: keep track of actual positions
		
		var length = endIndex - startIndex;
		return Math.round ((x / lineWidths[lineIndex]) * length) + startIndex;
		
	}
	
	
	@:noCompletion private function __startCursorTimer ():Void {
		
		__cursorTimer = Timer.delay (__startCursorTimer, 500);
		__showCursor = !__showCursor;
		//__dirty = true;
		
	}
	
	
	@:noCompletion private function __stopCursorTimer ():Void {
		
		if (__cursorTimer != null) {
			
			__cursorTimer.stop ();
			
		}
		
	}
	
	
	
	// Event Handlers
	
	
	
	
	//#if (js && html5)
	//@:noCompletion private function input_onKeyUp (event:HTMLKeyboardEvent):Void {
		//
		//__isKeyDown = false;
		//if (event == null) event == untyped Browser.window.event;
		//
		//text = __hiddenInput.value;
		//__ranges = null;
		//__isHTML = false;
		//
		//if (__hiddenInput.selectionDirection == "backward") {
			//
			//__cursorPosition = __hiddenInput.selectionStart;
			//__selectionStart = __hiddenInput.selectionEnd;
			//
		//} else {
			//
			//__cursorPosition = __hiddenInput.selectionEnd;
			//__selectionStart = __hiddenInput.selectionStart;
			//
		//}
		//
		//__dirty = true;
		//
		//textField.dispatchEvent (new Event (Event.CHANGE, true));
		//
	//}
	//
	//
	//@:noCompletion private function input_onKeyDown (event:#if (js && html5) HTMLKeyboardEvent #else Dynamic #end):Void {
		//
		//__isKeyDown = true;
		//if (event == null) event == untyped Browser.window.event;
		//
		//var keyCode = event.which;
		//var isShift = event.shiftKey;
		//
		////if (keyCode == 65 && (event.ctrlKey || event.metaKey)) { // Command/Ctrl + A
			////
			////__hiddenInput.selectionStart = 0;
			////__hiddenInput.selectionEnd = text.length;
			////event.preventDefault ();
			////__dirty = true;
			////return;
			////
		////}
		////
		////if (keyCode == 17 || event.metaKey || event.ctrlKey) {
			////
			////return;
			////
		////}
		//
		//text = __hiddenInput.value;
		//__ranges = null;
		//__isHTML = false;
		//
		//if (__hiddenInput.selectionDirection == "backward") {
			//
			//__cursorPosition = __hiddenInput.selectionStart;
			//__selectionStart = __hiddenInput.selectionEnd;
			//
		//} else {
			//
			//__cursorPosition = __hiddenInput.selectionEnd;
			//__selectionStart = __hiddenInput.selectionStart;
			//
		//}
		//
		//__dirty = true;
		//
	//}
	//
	//
	//@:noCompletion private function stage_onMouseMove (event:MouseEvent) {
		//
		//if (__hasFocus && __selectionStart >= 0) {
			//
			//var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
			//__cursorPosition = __getPosition (localPoint.x, localPoint.y);
			//__dirty = true;
			//
		//}
		//
	//}
	//
	//
	//@:noCompletion private function stage_onMouseUp (event:MouseEvent):Void {
		//
		//Lib.current.stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		//Lib.current.stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		//
		//if (Lib.current.stage.focus == textField) {
			//
			//var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
			//var upPos:Int = __getPosition (localPoint.x, localPoint.y);
			//var leftPos:Int;
			//var rightPos:Int;
			//
			//leftPos = Std.int (Math.min (__selectionStart, upPos));
			//rightPos = Std.int (Math.max (__selectionStart, upPos));
			//
			//__selectionStart = leftPos;
			//__cursorPosition = rightPos;
			//
			//this_onFocusIn (null);
			//
		//}
		//
	//}
	//
	//
	//@:noCompletion private function this_onAddedToStage (event:Event):Void {
		//
		//textField.addEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
		//textField.addEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
		//
		//__hiddenInput.addEventListener ('keydown', input_onKeyDown, true);
		//__hiddenInput.addEventListener ('keyup', input_onKeyUp, true);
		//__hiddenInput.addEventListener ('input', input_onKeyUp, true);
		//
		//textField.addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		//
		//if (Lib.current.stage.focus == textField) {
			//
			//this_onFocusIn (null);
			//
		//}
		//
	//}
	//
	//
	//@:noCompletion private function this_onFocusIn (event:Event):Void {
		//
		//if (__cursorPosition < 0) {
			//
			//__cursorPosition = text.length;
			//__selectionStart = __cursorPosition;
			//
		//}
		//
		//__hiddenInput.focus ();
		//__hiddenInput.selectionStart = __selectionStart;
		//__hiddenInput.selectionEnd = __cursorPosition;
		//
		//__stopCursorTimer ();
		//__startCursorTimer ();
		//
		//__hasFocus = true;
		//__dirty = true;
		//
		//Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		//
	//}
	//
	//
	//@:noCompletion private function this_onFocusOut (event:Event):Void {
		//
		//__cursorPosition = -1;
		//__hasFocus = false;
		//__stopCursorTimer ();
		//if (__hiddenInput != null) __hiddenInput.blur ();
		//__dirty = true;
		//
	//}
	//
	//
	//@:noCompletion private function this_onMouseDown (event:MouseEvent):Void {
		//
		//if (!selectable) return;
		//
		//var localPoint = textField.globalToLocal (new Point (event.stageX, event.stageY));
		//__selectionStart = __getPosition (localPoint.x, localPoint.y);
		//__cursorPosition = __selectionStart;
		//
		//Lib.current.stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		//Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		//
	//}
	//
	//
	//@:noCompletion private function this_onRemovedFromStage (event:Event):Void {
		//
		//textField.removeEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
		//textField.removeEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
		//
		//this_onFocusOut (null);
		//
		//if (__hiddenInput != null) __hiddenInput.removeEventListener ('keydown', input_onKeyDown, true);
		//if (__hiddenInput != null) __hiddenInput.removeEventListener ('keyup', input_onKeyUp, true);
		//if (__hiddenInput != null) __hiddenInput.removeEventListener ('input', input_onKeyUp, true);
		//
		//textField.removeEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		//Lib.current.stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		//Lib.current.stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		//
	//}
	//#end
	
	
}