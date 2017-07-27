package format.swf.instance;


import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import format.swf.exporters.ShapeCommandExporter;
import format.swf.tags.TagDefineEditText;
import format.swf.tags.TagDefineFont;
import format.swf.tags.TagDefineFont2;
import format.swf.SWFTimelineContainer;

import openfl.Assets;

#if ((cpp || neko) && openfl_legacy)
import openfl.text.AbstractFont;
#end


class DynamicText extends TextField {
	
	
	private static var registeredFonts = new Map <Int, Bool> ();
	
	public var offset:Matrix;
	
	private var data:SWFTimelineContainer;
	private var tag:TagDefineEditText;
	
	
	public function new (data:SWFTimelineContainer, tag:TagDefineEditText) {
		
		super ();
		
		var rect = tag.bounds.rect;
		
		offset = new Matrix (1, 0, 0, 1, rect.x, rect.y - 2);
		width = rect.width;
		height = rect.height;
		
		multiline = tag.multiline;
		wordWrap = tag.wordWrap;
		displayAsPassword = tag.password;
		border = tag.border;
		selectable = !tag.noSelect;
		
		var format = new TextFormat ();
		if (tag.hasTextColor) format.color = (tag.textColor & 0x00FFFFFF);
		format.size = Math.round (tag.fontHeight / 20);
		
		if (tag.hasFont) {
			
			var font = data.getCharacter (tag.fontId);
			
			if (Std.is (font, TagDefineFont2)) {
				
				#if ((cpp || neko) && openfl_legacy)
				
				var fontName =  cast (font, TagDefineFont2).fontName;
				
				if (fontName.charCodeAt (fontName.length - 1) == 0) {
					
					fontName = fontName.substr (0, fontName.length - 1).split (" ").join ("");
					
				}
				
				var fonts = Font.enumerateFonts (false);
				var foundFont = false;
				
				for (font in fonts) {
					
					if (font.fontName == fontName) {
						
						foundFont = true;
						format.font = fontName;
						break;
						
					}
					
				}
				
				if (!foundFont) {
					
					format.font = getFont (cast font);
					
				}
				
				#else
				
				format.font = cast (font, TagDefineFont2).fontName;
				
				#end
				
				embedFonts = true;
				
			}
			
		}
		
		if (tag.hasLayout) {
			
			switch (tag.align) {
				
				case 0: format.align = TextFormatAlign.LEFT;
				case 1: format.align = TextFormatAlign.RIGHT;
				case 2: format.align = TextFormatAlign.CENTER;
				case 3: format.align = TextFormatAlign.JUSTIFY;
				
			}
			
			format.leftMargin = Std.int (tag.leftMargin / 20);
			format.rightMargin = Std.int (tag.rightMargin / 20);
			format.indent = Std.int (tag.indent / 20);
			format.leading = Std.int (tag.leading / 20);
			
			if (embedFonts) format.leading += 4; // TODO: Why is this necessary?
			
		}
		
		defaultTextFormat = format;
		
		if (tag.hasText) {
			
			#if (cpp || neko)
			
			var plain = new EReg ("", "g").replace (tag.initialText, "\n");
			plain = new EReg ("<br>", "g").replace (plain, "\n");
			plain = new EReg ("<.*?>", "g").replace (plain, "");
			text = StringTools.htmlUnescape (plain);
			
			#else
			
			if (tag.html) {
				
				htmlText = tag.initialText;
				
			} else {
				
				text = tag.initialText;
				
			}
			
			#end
			
		}
		
		autoSize = (tag.autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		
	}
	
	
	#if ((cpp || neko) && openfl_legacy)
	
	private function getFont (font:TagDefineFont2):String {
		
		if (!registeredFonts.exists (font.characterId)) {
			
			AbstractFont.registerFont (font.fontName, function (definition) { return new SWFFont (font, definition); });
			registeredFonts.set (font.characterId, true);
			
		}
		
		return font.fontName;
		
	}
	
	#end
	
	
}


#if ((cpp || neko) && openfl_legacy)


class SWFFont extends AbstractFont {
	
	
	private var bitmapData:Map <Int, BitmapData>;
	private var font:TagDefineFont2;
	private var glyphInfo:Map <Int, GlyphInfo>;
	
	
	public function new (font:TagDefineFont2, definition:FontDefinition) {
		
		this.font = font;
		
		bitmapData = new Map <Int, BitmapData> ();
		glyphInfo = new Map <Int, GlyphInfo> ();
		
		var ascent = Math.round (font.ascent / (font.ascent + font.descent));
		var descent = Math.round (font.descent / (font.ascent + font.descent));
		
		super (definition.height, ascent, descent, false);
		
	}
	
	
	public override function getGlyphInfo (charCode:Int):GlyphInfo {
		
		if (!glyphInfo.exists (charCode)) {
			
			var index = -1;
			
			for (i in 0...font.codeTable.length) {
				
				if (font.codeTable[i] == charCode) {
					
					index = i;
					
				}
				
			}
			
			if (index > -1) {
				
				var scale = (height / 1024);
				var advance = Math.round (scale * font.fontAdvanceTable[index] * 0.05);
				
				glyphInfo.set (charCode, { width: height, height: height, advance: advance, offsetX: 0, offsetY: 2 });
			
			} else {
				
				glyphInfo.set (charCode, { width: 0, height: 0, advance: 0, offsetX: 0, offsetY: 0 });
				
			}
			
		}
		
		return glyphInfo.get (charCode);
		
	}
	
	
	public override function renderGlyph (charCode:Int):BitmapData {
		
		if (!bitmapData.exists (charCode)) {
			
			var index = -1;
			
			for (i in 0...font.codeTable.length) {
				
				if (font.codeTable[i] == charCode) {
					
					index = i;
					
				}
				
			}
			
			if (index > -1) {
				
				var shape = new flash.display.Shape ();
				var handler = new ShapeCommandExporter (null);
				font.export (handler, index);
				
				var scale = (height / 1024);
				var offsetX = 0;
				var offsetY = font.ascent * scale * 0.05;
				
				var graphics = shape.graphics;
				
				for (command in handler.commands) {
					
					switch (command) {
						
						case BeginFill (color, alpha): graphics.beginFill (color, alpha);
						case EndFill: shape.graphics.endFill ();
						case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
							
							if (thickness != null) {
								
								graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
								
							} else {
								
								graphics.lineStyle ();
								
							}
						
						case MoveTo (x, y): graphics.moveTo (x * scale + offsetX, y * scale + offsetY);
						case LineTo (x, y): graphics.lineTo (x * scale + offsetX, y * scale + offsetY);
						case CurveTo (controlX, controlY, anchorX, anchorY):
							
							//cacheAsBitmap = true;
							graphics.curveTo (controlX * scale + offsetX, controlY * scale + offsetY, anchorX * scale + offsetX, anchorY * scale + offsetY);
							
						default:
						
					}
					
					
				}
				
				//var bounds = shape.getBounds (shape);
				//var data = new BitmapData (Math.ceil (bounds.width + bounds.x), Math.ceil (bounds.height + bounds.y), true, 0x00000000);
				var data = new BitmapData (height, height, true, 0x00000000);
				data.draw (shape);
				
				var advance = Math.round (scale * font.fontAdvanceTable[index] * 0.05);
				
				bitmapData.set (charCode, data);
				
			} else {
				
				bitmapData.set (charCode, null);
				
			}
			
		}
		
		return bitmapData.get (charCode);
		
	}
	
	
}


#end