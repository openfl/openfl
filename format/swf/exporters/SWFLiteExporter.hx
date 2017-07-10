package format.swf.exporters;


import flash.display.BitmapData;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import format.png.Data;
import format.png.Writer;
import format.swf.data.consts.BitmapFormat;
import format.swf.data.SWFButtonRecord;
import format.swf.exporters.core.FilterType;
import format.swf.exporters.core.ShapeCommand;
import format.swf.lite.symbols.BitmapSymbol;
import format.swf.lite.symbols.ButtonSymbol;
import format.swf.lite.symbols.DynamicTextSymbol;
import format.swf.lite.symbols.FontSymbol;
import format.swf.lite.symbols.MorphShapeSymbol;
import format.swf.lite.symbols.ShapeSymbol;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.StaticTextSymbol;
import format.swf.lite.symbols.SWFSymbol;
import format.swf.lite.symbols.SimpleSpriteSymbol;
import format.swf.lite.timeline.Frame;
import format.swf.lite.timeline.FrameObject;
import format.swf.lite.timeline.FrameObjectType;
import format.swf.lite.SWFLite;
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
import format.swf.tags.TagDefineFont3;
import format.swf.tags.TagDefineFont4;
import format.swf.tags.TagDefineMorphShape;
import format.swf.tags.TagDefineShape;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagDefineText;
import format.swf.tags.TagExportAssets;
import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagSymbolClass;
import format.swf.SWFRoot;
import format.swf.SWFTimelineContainer;
import format.tools.Deflate;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import lime.graphics.format.JPEG;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;
import lime.math.Vector2;
import lime.math.color.RGBA;

import openfl.display.PNGEncoderOptions;
import openfl.geom.Matrix;
import openfl.geom.Point;

class SWFLiteExporter {


	public var bitmapAlpha:Map <Int, ByteArray>;
	public var bitmaps:Map <Int, ByteArray>;
	public var bitmapExtents:Map <Int, Vector2>;
	public var bitmapTypes:Map <Int, BitmapType>;
	public var filterClasses:Map <String, Bool>;
	public var swfLite:SWFLite;

	private var alphaPalette:Bytes;
	private var data:SWFRoot;
	private var mergeAlphaChannel:Bool;
	private var excludes:Array<Dynamic>;


	public function new (data:SWFRoot, mergeAlphaChannel:Bool, excludes:Array<Dynamic> = null) {

		this.data = data;
		this.mergeAlphaChannel = mergeAlphaChannel;
		if ( excludes == null ) {
			excludes = new Array<Dynamic>();
		}
		this.excludes = excludes;

		bitmapAlpha = new Map <Int, ByteArray> ();
		bitmaps = new Map <Int, ByteArray> ();
		bitmapExtents = new Map <Int, Vector2> ();
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

			} else if (Std.is (tag, TagExportAssets)) {

				for (symbol in cast (tag, TagExportAssets).symbols) {

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
		var bitmapWidth:Int = 0;
		var bitmapHeight:Int = 0;

		if (Std.is (tag, TagDefineBitsLossless)) {

			var data:TagDefineBitsLossless = cast tag;

			var transparent = (data.level > 1);
			var buffer = data.zlibBitmapData;
			buffer.uncompress ();
			buffer.position = 0;
			bitmapWidth = data.bitmapWidth;
			bitmapHeight = data.bitmapHeight;

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

				var values = Bytes.alloc ((data.bitmapWidth + 1) * data.bitmapHeight);
				index = 0;

				for (y in 0...data.bitmapHeight) {

					values.set (index++, 0);
					values.blit (index, buffer, buffer.position, data.bitmapWidth);
					index += data.bitmapWidth;
					buffer.position += ( data.bitmapWidth + 3 ) & ~3;

				}

				var png = new List ();
				png.add (CHeader ( { width: data.bitmapWidth, height: data.bitmapHeight, colbits: 8, color: ColIndexed, interlaced: false } ));
				png.add (CPalette (palette));
				if( alpha != null ) {
					png.add (CUnknown("tRNS", alpha));
				}
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

				var bytes:haxe.io.Bytes = data.bitmapData;

				// :HACK: as per specification:
				// Before version 8 of the SWF file format, SWF files could contain an erroneous header of 0xFF, 0xD9, 0xFF, 0xD8  before the JPEG SOI marker.

				if (data.version < 8) {

					var byteArray = data.bitmapData;
					for( index in 0...byteArray.length - 3 ) {
						if (
							byteArray[index + 1] == 0xD9
							&& byteArray[index + 3] == 0xD8
							&& byteArray[index] == 0xFF
							&& byteArray[index + 2] == 0xFF
							) {
								bytes = bytes.sub(index + 2, byteArray.length - index - 2);
						}
					}

				}

				var image = lime.graphics.format.JPEG.decodeBytes (bytes, mergeAlphaChannel);
				bitmapWidth = image.width;
				bitmapHeight = image.height;

				if( mergeAlphaChannel ){
					var width = image.width;
					var height = image.height;

					/* If copy channel supported 8bit texture, does not
					var alphaBuffer = new ImageBuffer( UInt8Array.fromBytes(alpha), width, height, 8 );
					var alphaImage = new Image(alphaBuffer);

					image.transparent = true;
					image.copyChannel (alphaImage, alphaImage.rect, new Vector2 (), RED, ALPHA);
					*/

					var pixel : RGBA;
					var srcPosition = 0;
					var srcData = image.buffer.data;

					for( j in 0 ... height ){
						for( i in 0 ... width ){

							pixel.readUInt8(srcData, srcPosition * 4);
							pixel.a = alpha[srcPosition];

							if( pixel.a > 0 ){

								var a = pixel.a / 255.0;

								pixel.r = Std.int( Math.min( pixel.r / a, 255 ) );
								pixel.g = Std.int( Math.min( pixel.g / a, 255 ) );
								pixel.b = Std.int( Math.min( pixel.b / a, 255 ) );
							}
							pixel.writeUInt8(srcData, srcPosition * 4);
							srcPosition += 1;
						}
					}

					alphaByteArray = null;
					byteArray = lime.graphics.format.PNG.encode( image );

					type = BitmapType.PNG;

				} else {

					if (alphaPalette == null) {

						alphaPalette = Bytes.alloc (256 * 3);
						var index = 0;

						for (i in 0...256) {

							alphaPalette.set (index++, i);
							alphaPalette.set (index++, i);
							alphaPalette.set (index++, i);

						}
					}

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

				}

			} else {

				byteArray = data.bitmapData;
				type = BitmapType.JPEG;

				var image = lime.graphics.format.JPEG.decodeBytes (byteArray, false);
				bitmapWidth = image.width;
				bitmapHeight = image.height;

			}

		} else if (Std.is (tag, TagDefineBits)) {

			var data:TagDefineBits = cast tag;

			byteArray = data.bitmapData;
			type = BitmapType.JPEG;

			var image = lime.graphics.format.JPEG.decodeBytes (byteArray, false);
			bitmapWidth = image.width;
			bitmapHeight = image.height;

		}

		if (byteArray != null) {

			var symbol = new BitmapSymbol ();
			symbol.id = tag.characterId;

			bitmapAlpha.set (symbol.id, alphaByteArray);
			bitmaps.set (symbol.id, byteArray);
			bitmapTypes.set (symbol.id, type);
			bitmapExtents.set (symbol.id, new Vector2 (bitmapWidth, bitmapHeight));

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

	private function simplify (commands:Array<ShapeCommand>):Array<ShapeCommand> {

		var simplifiedCommands = new Array<ShapeCommand> ();

		var i = 0;
		while (i < commands.length) {

			var command = commands[i];

			function simplifyEmptyLineStyle ():Bool {

				switch (command) {

					case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
						if (thickness == null && color == null && alpha == null
							&& pixelHinting == null && scaleMode == null && caps == null && joints == null
							&& miterLimit == null) {

							for( j in i+1...commands.length ) {

								if (commands[j] == EndFill) {
									i = j;
									return true;
								}
							}
						}

					default:

				}

				return false;

			}

			function simplifyDrawImage ():Bool {

				switch (command) {
					case BeginBitmapFill (bitmapID, matrix, repeat, smooth):

						if (repeat) {
							return false;
						}

						if (i+6 >= commands.length) {
							return false;
						}

						var rectStartIndex:Int;
						var startPoint = new Point ();

						switch (commands[i+1]) {

							case MoveTo (x, y):
								rectStartIndex = i + 2;
								startPoint.x = x;
								startPoint.y = y;

							case LineTo (x, y):
								throw "should never happen (LineTo after BeginBitmapFill)";

							default:
								return false;

						}

						if (commands[rectStartIndex+4] == EndFill) {

							var pointTable = new Array<Point> ();
							var centerPoint = new Point ();

							for( j in 0...4 ) {

								switch (commands[rectStartIndex + j]) {
									case LineTo (x, y):

										pointTable.push (new Point (x, y));
										centerPoint.x += x;
										centerPoint.y += y;

									default:
										return false;

								}
							}

							if (pointTable[3].x != startPoint.x || pointTable[3].y != startPoint.y ) {

								return false;

							}

							centerPoint.x /= 4;
							centerPoint.y /= 4;

							var rightPoint = Point.interpolate (pointTable[0], pointTable[1], 0.5);
							var upPoint = Point.interpolate (pointTable[1], pointTable[2], 0.5);

							var shapeRectangle = new Parallellogram (centerPoint, rightPoint.subtract (centerPoint), upPoint.subtract (centerPoint));
							var bitmapExtent:Vector2 = bitmapExtents.get (bitmapID);

							var imageRectangle = new Parallellogram (new Point (0.5 * bitmapExtent.x, 0.5 * bitmapExtent.y), new Point (0.5 * bitmapExtent.x, 0.0), new Point (0.0, 0.5 * bitmapExtent.y));
							imageRectangle.transform (matrix);

							if (!shapeRectangle.equals (imageRectangle)) {

								return false;
							}

							var imageMatrix:Matrix = new Matrix (bitmapExtent.x, 0, 0, bitmapExtent.y, 0.0, 0.0);
							imageMatrix.concat (matrix);
							simplifiedCommands.push (DrawImage(bitmapID, imageMatrix, smooth));
							i = rectStartIndex+4;

							return true;

						}

					default:
				}

				return false;

			}

			if (!simplifyEmptyLineStyle() && !simplifyDrawImage()) {

				simplifiedCommands.push (command);

			}

			++i;
		}

		return simplifiedCommands;

	}

	private function addShape (tag:TagDefineShape):SWFSymbol {

		var foundBitmapID = null;
		var foundMatrix = null;

		var handler = new ShapeCommandExporter ();
		tag.export (handler);

		for (command in handler.commands) {

			switch (command) {

				case BeginBitmapFill (bitmapID, matrix, _, _):

					processTag (cast data.getCharacter (bitmapID));
					foundBitmapID = bitmapID;
					foundMatrix = matrix;

				default:

			}

		}

		try {
			handler.commands = simplify (handler.commands);
		} catch(e:Dynamic) {
			throw 'Error simplifying shape ${tag.characterId}: $e';
		}

		if (isSimpleSprite (handler.commands)) {
			var symbol = new SimpleSpriteSymbol ();
			symbol.id = tag.characterId;
			symbol.matrix = foundMatrix;
			symbol.bitmapID = foundBitmapID;
			symbol.bounds = tag.shapeBounds.rect;

			swfLite.symbols.set (symbol.id, symbol);

			return symbol;
		}

		var symbol = new ShapeSymbol ();
		symbol.id = tag.characterId;
		symbol.fillDrawCommandBuffer (handler.commands);
		symbol.bounds = tag.shapeBounds.rect;

		swfLite.symbols.set (symbol.id, symbol);

		return symbol;

	}


	private function addMorphShape (tag:TagDefineMorphShape):MorphShapeSymbol {

		var symbol = new MorphShapeSymbol ();
		symbol.id = tag.characterId;

		symbol.startEdges = tag.startEdges;
		symbol.endEdges = tag.endEdges;
		symbol.morphFillStyles = tag.morphFillStyles;
		symbol.morphLineStyles = tag.morphLineStyles;

		swfLite.symbols.set (symbol.id, symbol);

		return symbol;

	}


	private function addSprite (tag:SWFTimelineContainer, root:Bool = false):SpriteSymbol {

		var symbol = new SpriteSymbol ();

		if (Std.is (tag, IDefinitionTag)) {

			symbol.id = untyped tag.characterId;

			var grid = tag.getScalingGrid (symbol.id);
			if (grid != null) {
				symbol.scalingGridRect = grid.splitter.rect.clone ();

			}
		}


		var instances = new Array<Int> ();
		var lastModified = new Map<Int, Int> ();
		var zeroCharacter = -1;

		var hasShape = false;
		var hasSprite = false;

		var frame, frameObject, frameData, placeTag:TagPlaceObject;

		for (frameData in tag.frames) {

			frame = new Frame ();

			if (frameData.label != null) {

				frame.label = frameData.label;

			}

			instances.splice (0, instances.length);

			for (object in frameData.getObjectsSortedByDepth ()) {

				instances.push (object.placedAtIndex);

				var objectTag = data.getCharacter (object.characterId);

				if (!lastModified.exists (object.placedAtIndex)) {

					processTag (objectTag);
					placeTag = cast tag.tags[object.placedAtIndex];

				} else if ( object.isKeyframe ){

					processTag (objectTag);
					placeTag = cast tag.tags[object.lastModifiedAtIndex];

				}
				else if (object.lastModifiedAtIndex > lastModified.get (object.placedAtIndex) ) {

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

					if( object.isKeyframe ){
						frameObject.type = FrameObjectType.UPDATE_CHARACTER;
					} else {
						frameObject.type = FrameObjectType.UPDATE;
					}
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

				if( placeTag.hasBlendMode) {
					frameObject.blendMode = format.swf.data.consts.BlendMode.toString(placeTag.blendMode);
				}

				if( placeTag.hasRatio) {
					frameObject.ratio = placeTag.ratio / 65535;
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
				frameObject.cacheAsBitmap = placeTag.hasCacheAsBitmap;

				lastModified.set (object.placedAtIndex, object.lastModifiedAtIndex);

				frame.objects.push (frameObject);

				hasShape = hasShape || Std.is(objectTag, TagDefineShape);
				hasSprite = hasSprite || Std.is(objectTag, TagDefineSprite);

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

		// From 'scale9Grid' documentation:
		// When the scale9Grid property is set and a movie clip is scaled, all text and child movie clips scale normally, ...
		// :TODO: detect other tags (texts, ...)
		if (symbol.scalingGridRect != null && hasSprite) {
			if (hasShape) {
				throw ":TODO: support 9 slice on sprites containing both shapes and sprites (symbol " + symbol.id + ")";
			} else {
				symbol.scalingGridRect = null;
			}
		}
		return symbol;

	}


	private function addDynamicText (tag:TagDefineEditText):DynamicTextSymbol {

		var symbol = new DynamicTextSymbol ();

		symbol.id = tag.characterId;
		symbol.variableName = tag.variableName;
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

		if (tag.hasMaxLength) {
			symbol.maxLength = tag.maxLength;
		}

		symbol.wordWrap = tag.wordWrap;

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
		var fontIsScaled : Bool = false;
		var font:FontSymbol = null;
		var defineFont:TagDefineFont2 = null;

		for (record in tag.records) {

			var textRecord = new StaticTextRecord ();

			if (record.hasFont || font != null) {

				textRecord.fontID = record.fontId;

				defineFont = cast data.getCharacter (record.fontId);
				processTag (defineFont);
				font = cast swfLite.symbols.get (record.fontId);

				if (Std.is(defineFont, TagDefineFont3))
				{
					fontIsScaled = true;
				}
			}

			if (record.hasColor) textRecord.color = record.textColor;
			if (record.hasXOffset) textRecord.offsetX = record.xOffset;
			if (record.hasYOffset) textRecord.offsetY= record.yOffset;
			textRecord.fontHeight = record.textHeight;

			var advances = [];
			var glyphs = [];

			if (font != null) {

				var handler = new ShapeCommandExporter ();

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
		symbol.bounds = tag.textBounds.rect;
		symbol.shapeIsScaled = fontIsScaled;

		swfLite.symbols.set (symbol.id, symbol);

		return symbol;

	}


	private function processSymbol (symbol:format.swf.data.SWFSymbol):Void {

		var data = processTag (cast data.getCharacter (symbol.tagId), symbol.name);

		if (data != null) {

			data.className = symbol.name;

		}

	}


	private function processTag (tag:IDefinitionTag, name:String = ""):SWFSymbol {

		if (tag == null) return null;

		if (excludes.indexOf(tag.characterId) != -1 || excludes.indexOf(name) != -1) {
			var empty_symbol = new SWFSymbol();
			empty_symbol.id = tag.characterId;
			empty_symbol.className = name;
			swfLite.symbols.set(tag.characterId, empty_symbol);
		}

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

			} else if (Std.is (tag, TagDefineMorphShape)) {

				return addMorphShape (cast tag);

			} else if (Std.is (tag, TagDefineFont) || Std.is (tag, TagDefineFont4)) {

				return addFont (tag);

			}

			return null;

		} else {

			return swfLite.symbols.get (tag.characterId);

		}

	}

	private function isSimpleSprite(commands:Array<ShapeCommand>)
	{

		return commands.length == 1 && Type.enumConstructor(commands[0]) == "DrawImage";

	}
}


enum BitmapType {

	PNG;
	JPEG_ALPHA;
	JPEG;

}

class Parallellogram {

	public var center (default, null):Point;
	public var halfRight (default, null):Point;
	public var halfUp (default, null):Point;

	public function new (center:Point, halfRight:Point, halfUp:Point):Void {

		this.center = center;
		this.halfRight = halfRight;
		this.halfUp = halfUp;

		normalize ();

	}

	public function equals (other:Parallellogram, tolerance:Float = 0.01):Bool {

		return Point.squareDistance (center, other.center) <= tolerance
			&& Point.squareDistance (halfRight, other.halfRight) <= tolerance
			&& Point.squareDistance (halfUp, other.halfUp) <= tolerance;

	}

	public function transform (matrix:Matrix):Void {

		matrix.__transformPoint (center);
		halfRight = matrix.deltaTransformPoint (halfRight);
		halfUp = matrix.deltaTransformPoint (halfUp);

		normalize ();

	}

	public function normalize ():Void {

		var normalizedRight = halfRight.clone ();
		var normalizedUp = halfUp.clone ();

		normalizedRight.normalize (1.0);
		normalizedUp.normalize (1.0);

		if (Math.abs (normalizedRight.x) < Math.abs (normalizedUp.x) ) {

				var swap = halfRight;
				halfRight = halfUp;
				halfUp = swap;

		}

		if (halfRight.x < 0) {

			halfRight.x *= -1;
			halfRight.y *= -1;

		}

		if (halfUp.y < 0) {

			halfUp.x *= -1;
			halfUp.y *= -1;

		}

	}
}
