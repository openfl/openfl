package format.swf.exporters;


import flash.display.BitmapData;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import format.png.Data;
import format.png.Writer;
import format.swf.data.consts.BitmapFormat;
import format.swf.data.SWFButtonRecord;
import openfl._internal.swf.FilterType;
import openfl._internal.swf.ShapeCommand;
import format.swf.instance.Bitmap;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.symbols.ButtonSymbol;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.symbols.ShapeSymbol;
import openfl._internal.symbols.SpriteSymbol;
import openfl._internal.symbols.StaticTextSymbol;
import openfl._internal.symbols.SWFSymbol;
import openfl._internal.timeline.Frame;
import openfl._internal.timeline.FrameObject;
import openfl._internal.timeline.FrameObjectType;
import openfl._internal.swf.SWFLite;
import format.swf.tags.IDefinitionTag;
import format.swf.tags.TagDefineBits;
import format.swf.tags.TagDefineBitsJPEG2;
import format.swf.tags.TagDefineBitsJPEG3;
import format.swf.tags.TagDefineBitsLossless;
import format.swf.tags.TagDefineButton;
import format.swf.tags.TagDefineButton2;
import format.swf.tags.TagDefineEditText;
import format.swf.tags.TagDefineFont;
import format.swf.tags.TagDefineFont2;
import format.swf.tags.TagDefineFont4;
import format.swf.tags.TagDefineShape;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagDefineText;
import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagSymbolClass;
import format.swf.SWFRoot;
import format.swf.SWFTimelineContainer;
import format.tools.Deflate;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import lime.graphics.format.JPEG;
import openfl.display.PNGEncoderOptions;


class SWFLiteExporter {
	
	
	public var bitmapAlpha:Map <Int, ByteArray>;
	public var bitmaps:Map <Int, ByteArray>;
	public var bitmapTypes:Map <Int, BitmapType>;
	public var filterClasses:Map <String, Bool>;
	public var swfLite:SWFLite;
	
	private var alphaPalette:Bytes;
	private var data:SWFRoot;
	
	
	public function new (data:SWFRoot) {
		
		this.data = data;
		
		bitmapAlpha = new Map <Int, ByteArray> ();
		bitmaps = new Map <Int, ByteArray> ();
		bitmapTypes = new Map <Int, BitmapType> ();
		filterClasses = new Map <String, Bool> ();
		
		swfLite = new SWFLite ();
		swfLite.frameRate = data.frameRate;
		
		addSprite (data, true);
		
		for (tag in data.tags) {
			
			if (Std.is (tag, TagSymbolClass)) {
				
				for (symbol in cast (tag, TagSymbolClass).symbols) {
					
					processSymbol (symbol);
					
				}
				
			}
			
		}
		
	}
	
	
	private function addButton (tag:IDefinitionTag):SWFSymbol {
		
		var symbol = new ButtonSymbol ();
		
		if (Std.is (tag, IDefinitionTag)) {
			
			symbol.id = untyped tag.characterId;
			
		}
		
		var processRecords = function (records:Array<SWFButtonRecord>) {
			
			if (records.length > 0) {
				
				var sprite = new SpriteSymbol ();
				var frame = new Frame ();
				
				for (i in 0...records.length) {
					
					var object = records[i];
					
					var frameObject = new FrameObject ();
					frameObject.symbol = object.characterId;
					frameObject.id = i;
					
					processTag (cast data.getCharacter (object.characterId));
					
					if (object.placeMatrix != null) {
						
						var matrix = object.placeMatrix.matrix;
						matrix.tx *= (1 / 20);
						matrix.ty *= (1 / 20);
						
						frameObject.matrix = matrix;
						
					}
					
					if (object.colorTransform != null) {
						
						frameObject.colorTransform = object.colorTransform.colorTransform;
						
					}
					
					if (object.hasFilterList) {
						
						var filters:Array<FilterType> = [];
						
						for (filter in object.filterList) {
							
							var type = filter.type;
							
							if (type != null) {
								
								filters.push (filter.type);
								//filterClasses.set (Type.getClassName (Type.getClass (surfaceFilter.filter)), true);
								
							}
							
						}
						
						frameObject.filters = filters;
						
					}
					
					frameObject.depth = i;
					frameObject.clipDepth = 0;
					frameObject.visible = true;
					
					frame.objects.push (frameObject);
					
				}
				
				sprite.frames.push (frame);
				
				return sprite;
				
			}
			
			return null;
			
		}
		
		if (Std.is (tag, TagDefineButton)) {
			
			var defineButton:TagDefineButton = cast tag;
			
			symbol.downState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_DOWN));
			symbol.hitState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_HIT));
			symbol.overState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_OVER));
			symbol.upState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_UP));
			
		} else {
			
			var defineButton:TagDefineButton2 = cast tag;
			
			symbol.downState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_DOWN));
			symbol.hitState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_HIT));
			symbol.overState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_OVER));
			symbol.upState = processRecords (defineButton.getRecordsByState (TagDefineButton.STATE_UP));
			
		}
		
		swfLite.symbols.set (symbol.id, symbol);
		
		return symbol;
		
	}
	
	
	private function addBitmap (tag:IDefinitionTag):BitmapSymbol {
		
		var alphaByteArray = null;
		var byteArray = null;
		var type = null;
		
		if (Std.is (tag, TagDefineBitsLossless)) {
			
			var data:TagDefineBitsLossless = cast tag;
			
			var transparent = (data.level > 1);
			var buffer = data.zlibBitmapData;
			buffer.uncompress ();
			buffer.position = 0;
			
			if (data.bitmapFormat == BitmapFormat.BIT_8) {
				
				var palette = Bytes.alloc (data.bitmapColorTableSize * 3);
				var alpha = null;
				
				if (transparent) alpha = Bytes.alloc (data.bitmapColorTableSize);
				var index = 0;
				
				for (i in 0...data.bitmapColorTableSize) {
					
					palette.set (index++, buffer.readUnsignedByte ());
					palette.set (index++, buffer.readUnsignedByte ());
					palette.set (index++, buffer.readUnsignedByte ());
					if (transparent) alpha.set (i, buffer.readUnsignedByte ());
					
				}
				
				var paddedWidth:Int = Math.ceil (data.bitmapWidth / 4) * 4;
				var values = Bytes.alloc ((data.bitmapWidth + 1) * data.bitmapHeight);
				index = 0;
				
				for (y in 0...data.bitmapHeight) {
					
					values.set (index++, 0);
					values.blit (index, buffer, buffer.position, data.bitmapWidth);
					index += data.bitmapWidth;
					buffer.position += paddedWidth;
					
				}
				
				var png = new List ();
				png.add (CHeader ( { width: data.bitmapWidth, height: data.bitmapHeight, colbits: 8, color: ColIndexed, interlaced: false } ));
				png.add (CPalette (palette));
				if (transparent) png.add(CUnknown("tRNS", alpha));
				png.add (CData (Deflate.run (values)));
				png.add (CEnd);
				
				var output = new BytesOutput ();
				var writer = new Writer (output);
				writer.write (png);
				
				byteArray = ByteArray.fromBytes (output.getBytes ());
				type = BitmapType.PNG;
				
			} else {
				
				var bitmapData = new BitmapData (data.bitmapWidth, data.bitmapHeight, transparent);
				
				bitmapData.image.buffer.premultiplied = false;
				bitmapData.setPixels (bitmapData.rect, buffer);
				bitmapData.image.buffer.premultiplied = true;
				bitmapData.image.premultiplied = false;
				
				byteArray = bitmapData.encode (bitmapData.rect, new PNGEncoderOptions ());
				type = BitmapType.PNG;
				
			}
			
		} else if (Std.is (tag, TagDefineBitsJPEG2)) {
			
			var data:TagDefineBitsJPEG2 = cast tag;
			
			if (Std.is (tag, TagDefineBitsJPEG3)) {
				
				var alpha = cast (tag, TagDefineBitsJPEG3).bitmapAlphaData;
				alpha.uncompress ();
				alpha.position = 0;
				
				if (alphaPalette == null) {
					
					alphaPalette = Bytes.alloc (256 * 3);
					var index = 0;
					
					for (i in 0...256) {
						
						alphaPalette.set (index++, i);
						alphaPalette.set (index++, i);
						alphaPalette.set (index++, i);
						
					}
					
				}
				
				var tempFile = lime.tools.helpers.PathHelper.getTemporaryFile ("jpg");
				sys.io.File.saveBytes (tempFile, data.bitmapData);
				var image = lime.graphics.format.JPEG.decodeFile (tempFile, false);
				try { sys.FileSystem.deleteFile (tempFile); } catch (e:Dynamic) {}
				
				var values = Bytes.alloc ((image.width + 1) * image.height);
				var index = 0;
				
				for (y in 0...image.height) {
					
					values.set (index++, 0);
					values.blit (index, alpha, alpha.position, image.width);
					index += image.width;
					alpha.position += image.width;
					
				}
				
				var png = new List ();
				png.add (CHeader ( { width: image.width, height: image.height, colbits: 8, color: ColIndexed, interlaced: false } ));
				png.add (CPalette (alphaPalette));
				png.add (CData (Deflate.run (values)));
				png.add (CEnd);
				
				var output = new BytesOutput ();
				var writer = new Writer (output);
				writer.write (png);
				
				alphaByteArray = ByteArray.fromBytes (output.getBytes ());
				byteArray = data.bitmapData;
				type = BitmapType.JPEG_ALPHA;
				
			} else {
				
				byteArray = data.bitmapData;
				type = BitmapType.JPEG;
				
			}
			
		} else if (Std.is (tag, TagDefineBits)) {
			
			var data:TagDefineBits = cast tag;
			
			byteArray = data.bitmapData;
			type = BitmapType.JPEG;
			
		}
		
		if (byteArray != null) {
			
			var symbol = new BitmapSymbol ();
			symbol.id = tag.characterId;
			
			bitmapAlpha.set (symbol.id, alphaByteArray);
			bitmaps.set (symbol.id, byteArray);
			bitmapTypes.set (symbol.id, type);
			
			symbol.path = "";
			swfLite.symbols.set (symbol.id, symbol);
			
			return symbol;
			
		}
		
		return null;
		
	}
	
	
	private function addFont (tag:IDefinitionTag):FontSymbol {
		
		if (Std.is (tag, TagDefineFont2)) {
			
			var defineFont:TagDefineFont2 = cast tag;
			var symbol = new FontSymbol ();
			symbol.id = defineFont.characterId;
			symbol.glyphs = new Array<Array<ShapeCommand>> ();
			
			//for (i in 0...defineFont.glyphShapeTable.length) {
				//
				//var handler = new ShapeCommandExporter (data);
				//defineFont.export (handler, i);
				//symbol.glyphs.push (handler.commands);
				//
			//}
			
			symbol.advances = new Array<Int> ();
			//symbol.advances = cast defineFont.fontAdvanceTable.copy ();
			symbol.bold = defineFont.bold;
			symbol.codes = defineFont.codeTable.copy ();
			symbol.italic = defineFont.italic;
			symbol.leading = defineFont.leading;
			symbol.name = defineFont.fontName;
			
			swfLite.symbols.set (symbol.id, symbol);
			
			return symbol;
			
		}
		
		return null;
		
	}
	
	
	private function addShape (tag:TagDefineShape):SWFSymbol {
		
		var handler = new ShapeCommandExporter (data);
		tag.export (handler);
		
		// TODO: Remove need for this optimization
		
		#if !disable_bitmap_optimization
		var bitmaps = ShapeBitmapExporter.process (handler);
		#else
		var bitmaps:Array<Dynamic> = null;
		#end
		
		if (bitmaps != null) {
			
			var symbol = new SpriteSymbol ();
			var frame = new Frame ();
			var bitmap, frameObject;
			
			for (i in 0...bitmaps.length) {
				
				bitmap = bitmaps[i];
				
				processTag (cast data.getCharacter (bitmap.id));
				
				var bitmapSymbol:BitmapSymbol = cast swfLite.symbols.get (bitmap.id);
				
				if (bitmapSymbol != null) {
					
					// Use smoothing if a shape requests it
					
					if (bitmapSymbol.smooth == null && !bitmap.smooth) {
						
						bitmapSymbol.smooth = false;
						
					} else if (bitmapSymbol.smooth == false && bitmap.smooth) {
						
						bitmapSymbol.smooth = true;
						
					}
					
				}
				
				frameObject = new FrameObject ();
				frameObject.symbol = bitmap.id;
				frameObject.type = FrameObjectType.CREATE;
				frameObject.id = i;
				frameObject.depth = i;
				frameObject.clipDepth = 0;
				frameObject.matrix = bitmap.transform;
				frameObject.visible = true;
				
				frame.objects.push (frameObject);
				
			}
			
			symbol.frames.push (frame);
			symbol.id = tag.characterId;
			
			swfLite.symbols.set (symbol.id, symbol);
			return symbol;
			
		} else {
			
			var symbol = new ShapeSymbol ();
			symbol.id = tag.characterId;
			
			symbol.commands = handler.commands;
			
			for (command in handler.commands) {
				
				switch (command) {
					
					case BeginBitmapFill (bitmapID, _, _, _):
						
						processTag (cast data.getCharacter (bitmapID));
					
					default:
					
				}
				
			}
			
			swfLite.symbols.set (symbol.id, symbol);
			return symbol;
			
		}
		
	}
	
	
	private function addSprite (tag:SWFTimelineContainer, root:Bool = false):SpriteSymbol {
		
		var symbol = new SpriteSymbol ();
		
		if (Std.is (tag, IDefinitionTag)) {
			
			symbol.id = untyped tag.characterId;
			
		}
		
		var instances = new Array<Int> ();
		var lastModified = new Map<Int, Int> ();
		var zeroCharacter = -1;
		
		var frame, frameObject, frameData, placeTag:TagPlaceObject;
		
		for (frameData in tag.frames) {
			
			frame = new Frame ();
			
			if (frameData.label != null) {
				
				frame.label = frameData.label;
				
			}
			
			instances.splice (0, instances.length);
			
			for (object in frameData.getObjectsSortedByDepth ()) {
				
				instances.push (object.placedAtIndex);
				
				if (object.placedAtIndex == 0 && object.characterId != zeroCharacter) {
					
					lastModified.remove (0);
					zeroCharacter = object.characterId;
					
				}
				
				if (!lastModified.exists (object.placedAtIndex)) {
					
					processTag (cast data.getCharacter (object.characterId));
					
					placeTag = cast tag.tags[object.placedAtIndex];
					
				} else if (object.lastModifiedAtIndex > lastModified.get (object.placedAtIndex)) {
					
					placeTag = cast tag.tags[object.lastModifiedAtIndex];
					
				} else {
					
					continue;
					
				}
				
				frameObject = new FrameObject ();
				frameObject.symbol = object.characterId;
				frameObject.id = object.placedAtIndex;
				
				frameObject.name = placeTag.instanceName;
				
				if (!lastModified.exists (object.placedAtIndex)) {
					
					frameObject.type = FrameObjectType.CREATE;
					
				} else {
					
					frameObject.type = FrameObjectType.UPDATE;
					
				}
				
				if (placeTag.matrix != null) {
					
					var matrix = placeTag.matrix.matrix;
					matrix.tx *= (1 / 20);
					matrix.ty *= (1 / 20);
					
					frameObject.matrix = matrix;
					
				}
				
				if (placeTag.colorTransform != null) {
					
					frameObject.colorTransform = placeTag.colorTransform.colorTransform;
					
				}
				
				if (placeTag.hasFilterList) {
					
					var filters:Array<FilterType> = [];
					
					for (surfaceFilter in placeTag.surfaceFilterList) {
						
						var type = surfaceFilter.type;
						
						if (type != null) {
							
							filters.push (surfaceFilter.type);
							//filterClasses.set (Type.getClassName (Type.getClass (surfaceFilter.filter)), true);
							
						}
						
					}
					
					frameObject.filters = filters;
					
				}
				
				frameObject.depth = placeTag.depth;
				frameObject.clipDepth = (placeTag.hasClipDepth ? placeTag.clipDepth : 0);
				frameObject.visible = (placeTag.hasVisible ? placeTag.visible != 0 : true);
				
				lastModified.set (object.placedAtIndex, object.lastModifiedAtIndex);
				
				frame.objects.push (frameObject);
				
			}
			
			for (id in lastModified.keys ()) {
				
				if (instances.indexOf (id) == -1) {
					
					lastModified.remove (id);
					
					frameObject = new FrameObject ();
					frameObject.id = id;
					frameObject.type = FrameObjectType.DESTROY;
					frame.objects.push (frameObject);
					
				}
				
			}
			
			symbol.frames.push (frame);
			
		}
		
		if (root) {
			
			swfLite.root = symbol;
			
		} else {
			
			swfLite.symbols.set (symbol.id, symbol);
			
		}
		
		return symbol;
		
	}
	
	
	private function addDynamicText (tag:TagDefineEditText):DynamicTextSymbol {
		
		var symbol = new DynamicTextSymbol ();
		
		symbol.id = tag.characterId;
		symbol.border = tag.border;
		
		if (tag.hasTextColor) {
			
			symbol.color = tag.textColor;
			
		}
		
		symbol.fontHeight = tag.fontHeight;
		symbol.multiline = tag.multiline;
		symbol.selectable = !tag.noSelect;
		
		if (tag.hasText) {
			
			symbol.html = tag.html;
			symbol.text = tag.initialText;
			
		}
		
		if (tag.hasLayout) {
			
			switch (tag.align) {
				
				case 0: symbol.align = "left";
				case 1: symbol.align = "right";
				case 2: symbol.align = "center";
				case 3: symbol.align = "justify";
				
			}
			
			symbol.leftMargin = tag.leftMargin;
			symbol.rightMargin = tag.rightMargin;
			symbol.indent = tag.indent;
			symbol.leading = tag.leading;
			
		}
		
		symbol.wordWrap = tag.wordWrap;
		symbol.input = !tag.readOnly;
		
		if (tag.hasFont) {
			
			var font:IDefinitionTag = cast data.getCharacter (tag.fontId);
			
			if (font != null) {
				
				//processTag (font);
				
			}
			
			symbol.fontID = tag.fontId;
			symbol.fontName = cast (font, TagDefineFont2).fontName;
			
		}
		
		var bounds = tag.bounds.rect;
		symbol.x = bounds.x;
		symbol.y = bounds.y;
		symbol.width = bounds.width;
		symbol.height = bounds.height;
		
		swfLite.symbols.set (symbol.id, symbol);
		
		return symbol;
		
	}
	
	
	private function addStaticText (tag:TagDefineText):StaticTextSymbol {
		
		var symbol = new StaticTextSymbol ();
		symbol.id = tag.characterId;
		
		var records = [];
		
		for (record in tag.records) {
			
			var textRecord = new StaticTextRecord ();
			var font:FontSymbol = null;
			var defineFont:TagDefineFont2 = null;
			
			if (record.hasFont) {
				
				textRecord.fontID = record.fontId;
				
				defineFont = cast data.getCharacter (record.fontId);
				processTag (defineFont);
				font = cast swfLite.symbols.get (record.fontId);
				
			}
			
			if (record.hasColor) textRecord.color = record.textColor;
			if (record.hasXOffset) textRecord.offsetX = record.xOffset;
			if (record.hasYOffset) textRecord.offsetY= record.yOffset;
			textRecord.fontHeight = record.textHeight;
			
			var advances = [];
			var glyphs = [];
			
			if (font != null) {
				
				var handler = new ShapeCommandExporter (data);
				
				for (glyphEntry in record.glyphEntries) {
					
					var index = glyphEntry.index;
					
					advances.push (glyphEntry.advance);
					glyphs.push (index);
					
					if (font.glyphs[index] == null) {
						
						handler.beginShape ();
						defineFont.export (handler, index);
						font.glyphs[index] = handler.commands.copy ();
						font.advances[index] = defineFont.fontAdvanceTable[index];
						
					}
					
				}
				
			}
			
			textRecord.advances = advances;
			textRecord.glyphs = glyphs;
			records.push (textRecord);
			
		}
		
		symbol.records = records;
		
		var matrix = tag.textMatrix.matrix;
		matrix.tx *= (1 / 20);
		matrix.ty *= (1 / 20);
		
		symbol.matrix = matrix;
		
		swfLite.symbols.set (symbol.id, symbol);
		
		return symbol;
		
	}
	
	
	private function processSymbol (symbol:format.swf.data.SWFSymbol):Void {
		
		var data = processTag (cast data.getCharacter (symbol.tagId));
		
		if (data != null) {
			
			data.className = symbol.name;
			
		}
		
	}
	
	
	private function processTag (tag:IDefinitionTag):SWFSymbol {
		
		if (tag == null) return null;
		
		if (!swfLite.symbols.exists (tag.characterId)) {
			
			if (Std.is (tag, TagDefineSprite)) {
				
				return addSprite (cast tag);
				
			} else if (Std.is (tag, TagDefineBits) || Std.is (tag, TagDefineBitsJPEG2) || Std.is (tag, TagDefineBitsLossless)) {
				
				return addBitmap (tag);
				
			} else if (Std.is (tag, TagDefineButton) || Std.is (tag, TagDefineButton2)) {
				
				return addButton (cast tag);
				
			} else if (Std.is (tag, TagDefineEditText)) {
				
				return addDynamicText (cast tag);
				
			} else if (Std.is (tag, TagDefineText)) {
				
				return addStaticText (cast tag);
				
			} else if (Std.is (tag, TagDefineShape)) {
				
				return addShape (cast tag);
				
			} else if (Std.is (tag, TagDefineFont) || Std.is (tag, TagDefineFont4)) {
				
				return addFont (tag);
				
			}
			
			return null;
			
		} else {
			
			return swfLite.symbols.get (tag.characterId);
			
		}
		
	}
	
	
}


enum BitmapType {
	
	PNG;
	JPEG_ALPHA;
	JPEG;
	
}