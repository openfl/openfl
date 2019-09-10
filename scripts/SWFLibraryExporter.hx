package;

import format.abc.Data;
import format.abc.Data.ABCData;
import format.abc.Data.Name;
import format.png.Data;
import format.png.Writer as PNGWriter;
import format.swf.exporters.ShapeBitmapExporter;
import format.swf.exporters.ShapeCommandExporter;
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
import format.swf.tags.TagDefineScalingGrid;
import format.swf.tags.TagDefineShape;
import format.swf.tags.TagDefineSound;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagDefineText;
import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagSymbolClass;
import format.swf.data.consts.BitmapFormat;
import format.swf.data.consts.BlendMode;
import format.swf.data.SWFButtonRecord;
import format.swf.SWFRoot;
import format.swf.SWFTimelineContainer;
import haxe.Template;
import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.StringTools;
import lime.graphics.Image;
import lime.tools.Asset;
import openfl._internal.formats.swf.FilterType;
import openfl._internal.formats.swf.ShapeCommand;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;
import openfl.utils.AssetManifest;
import openfl.utils.AssetType;
import openfl.utils.ByteArray;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.zip.Entry;
import haxe.zip.Writer as ZipWriter;
import haxe.Json;
import sys.io.File;
import sys.io.FileOutput;

using SWFLibraryExporter.AVM2;

class SWFLibraryExporter
{
	private var libraryData:SWFDocument;
	private var manifestData:AssetManifest;
	private var outputList:List<Entry>;
	private var swfData:SWFRoot;
	private var targetPath:String;

	public function new(swfData:SWFRoot, targetPath:String)
	{
		this.swfData = swfData;
		this.targetPath = targetPath;

		manifestData = new AssetManifest();
		libraryData = new SWFDocument();
		outputList = new List();

		var uuid = StringTools.generateUUID(20);

		manifestData.libraryType = "openfl._internal.formats.animate.AnimateLibrary";
		manifestData.libraryArgs = ["data.json", uuid];
		manifestData.version = 3;
		manifestData.assets = [];

		libraryData.uuid = uuid;
		libraryData.frameRate = swfData.frameRate;
		addSprite(swfData, true);

		for (tag in swfData.tags)
		{
			if (Std.is(tag, TagSymbolClass))
			{
				for (symbol in cast(tag, TagSymbolClass).symbols)
				{
					processSymbol(symbol);
				}
			}
		}

		// TODO: Compressed

		var libraryJSON = libraryData.serialize();
		var bytes = new ByteArray();
		bytes.writeUTFBytes(libraryJSON);
		var crc32 = Crc32.make(bytes);
		// var size = bytes.length;
		// bytes.deflate();
		var size = 0;

		var entry:Entry = {
			fileName: "data.json",
			fileSize: bytes.length,
			fileTime: Date.now(),
			compressed: false,
			dataSize: size,
			data: bytes,
			crc32: crc32
		};
		outputList.add(entry);
		manifestData.assets.push({
			path: "data.json",
			type: AssetType.TEXT
		});

		// var manifestJSON = manifestData.serialize();
		var manifestJSON = Json.stringify(manifestData);
		var bytes = new ByteArray();
		bytes.writeUTFBytes(manifestJSON);
		var crc32 = Crc32.make(bytes);
		// var size = bytes.length;
		// bytes.deflate();
		var size = 0;

		var entry:Entry = {
			fileName: "library.json",
			fileSize: bytes.length,
			fileTime: Date.now(),
			compressed: false,
			dataSize: size,
			data: bytes,
			crc32: crc32
		};
		outputList.add(entry);

		// TODO: Generated class names
		// generateSWFLiteClasses(srcPath, exportedClasses, swfLite, uuid, prefix);

		// 		var includeXML = '<?xml version="1.0" encoding="utf-8"?>
		// <library>

		// 	<source path="src" />

		// </library>';
		// 		var bytes = new ByteArray();
		// 		bytes.writeUTFString(includeXML, includeXML.length);
		// 		bytes.compress();

		// 		var entry:Entry = {
		// 			fileName: "include.xml",
		// 			fileSize: bytes.length,
		// 			fileTime: Date.now(),
		// 			compressed: true,
		// 			dataSize: 0,
		// 			data: bytes,
		// 			crc32: Crc32.make(bytes)
		// 		};
		// 		outputList.add(entry);

		var outputFile = File.write(targetPath, true);
		var writer = new ZipWriter(outputFile);
		writer.write(outputList);
	}

	private function addButton(tag:IDefinitionTag):Dynamic
	{
		var symbol:Dynamic = {};
		symbol.type = SWFSymbolType.BUTTON;

		if (Std.is(tag, IDefinitionTag))
		{
			symbol.id = untyped tag.characterId;
		}

		var processRecords = function(records:Array<SWFButtonRecord>)
		{
			if (records.length > 0)
			{
				var sprite:Dynamic = {};
				sprite.type = SWFSymbolType.SPRITE;
				sprite.frames = [];

				var frame:Dynamic = {};
				frame.objects = [];

				for (i in 0...records.length)
				{
					var object = records[i];

					var frameObject:Dynamic = {};
					frameObject.type = SWFFrameObjectType.CREATE;
					frameObject.symbol = object.characterId;
					frameObject.id = i;

					processTag(cast swfData.getCharacter(object.characterId));

					if (object.placeMatrix != null)
					{
						var matrix = object.placeMatrix.matrix;
						matrix.tx *= (1 / 20);
						matrix.ty *= (1 / 20);

						frameObject.matrix = serializeMatrix(matrix);
					}

					if (object.colorTransform != null)
					{
						frameObject.colorTransform = serializeColorTransform(object.colorTransform.colorTransform);
					}

					if (object.hasBlendMode)
					{
						var blendMode = BlendMode.toString(object.blendMode);
						frameObject.blendMode = blendMode;
					}

					if (object.hasFilterList)
					{
						var filters:Array<FilterType> = [];

						for (filter in object.filterList)
						{
							var type = filter.type;

							if (type != null)
							{
								filters.push(filter.type);
								// filterClasses.set (Type.getClassName (Type.getClass (surfaceFilter.filter)), true);
							}
						}

						frameObject.filters = filters;
					}

					frameObject.depth = i;
					frameObject.clipDepth = 0;
					frameObject.visible = true;

					frame.objects.push(frameObject);
				}

				sprite.frames.push(frame);

				return sprite;
			}

			return null;
		}

		if (Std.is(tag, TagDefineButton))
		{
			var defineButton:TagDefineButton = cast tag;

			symbol.downState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_DOWN));
			symbol.hitState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_HIT));
			symbol.overState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_OVER));
			symbol.upState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_UP));
		}
		else
		{
			var defineButton:TagDefineButton2 = cast tag;

			symbol.downState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_DOWN));
			symbol.hitState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_HIT));
			symbol.overState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_OVER));
			symbol.upState = processRecords(defineButton.getRecordsByState(TagDefineButton.STATE_UP));
		}

		libraryData.symbols.set(symbol.id, symbol);

		return symbol;
	}

	private function addBitmap(tag:IDefinitionTag):Dynamic
	{
		var alphaByteArray = null;
		var byteArray = null;
		var type = null;

		if (Std.is(tag, TagDefineBitsLossless))
		{
			var data:TagDefineBitsLossless = cast tag;

			var transparent = (data.level > 1);
			var buffer = data.zlibBitmapData;
			buffer.uncompress();
			buffer.position = 0;

			if (data.bitmapFormat == BitmapFormat.BIT_8)
			{
				var palette = Bytes.alloc(data.bitmapColorTableSize * 3);
				var alpha = null;

				if (transparent) alpha = Bytes.alloc(data.bitmapColorTableSize);
				var index = 0;

				for (i in 0...data.bitmapColorTableSize)
				{
					palette.set(index++, buffer.readUnsignedByte());
					palette.set(index++, buffer.readUnsignedByte());
					palette.set(index++, buffer.readUnsignedByte());
					if (transparent) alpha.set(i, buffer.readUnsignedByte());
				}

				var paddedWidth:Int = Math.ceil(data.bitmapWidth / 4) * 4;
				var values = Bytes.alloc(data.bitmapWidth * data.bitmapHeight + data.bitmapHeight);
				index = 0;

				for (y in 0...data.bitmapHeight)
				{
					values.set(index++, 0);
					values.blit(index, buffer, buffer.position, data.bitmapWidth);
					index += data.bitmapWidth;
					buffer.position += paddedWidth;
				}

				var png = new List();
				png.add(CHeader({
					width: data.bitmapWidth,
					height: data.bitmapHeight,
					colbits: 8,
					color: ColIndexed,
					interlaced: false
				}));
				png.add(CPalette(palette));
				if (transparent) png.add(CUnknown("tRNS", alpha));
				var valuesBA:ByteArray = values;
				valuesBA.compress();
				png.add(CData(valuesBA));
				png.add(CEnd);

				var output = new BytesOutput();
				var writer = new PNGWriter(output);
				writer.write(png);

				byteArray = ByteArray.fromBytes(output.getBytes());
				type = BitmapType.PNG;
			}
			else
			{
				var bitmapData = new BitmapData(data.bitmapWidth, data.bitmapHeight, transparent);

				bitmapData.image.buffer.premultiplied = false;
				bitmapData.setPixels(bitmapData.rect, buffer);
				bitmapData.image.buffer.premultiplied = true;
				bitmapData.image.premultiplied = false;

				byteArray = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions());
				type = BitmapType.PNG;
			}
		}
		else if (Std.is(tag, TagDefineBitsJPEG2))
		{
			var data:TagDefineBitsJPEG2 = cast tag;

			if (Std.is(tag, TagDefineBitsJPEG3))
			{
				var alpha = cast(tag, TagDefineBitsJPEG3).bitmapAlphaData;
				alpha.uncompress();
				alpha.position = 0;

				#if !nodejs
				var image = Image.fromBytes(data.bitmapData);
				#else
				var jpeg = js.Lib.require("jpeg-js");
				var bytes:Bytes = data.bitmapData;
				var image = jpeg.decode(bytes.getData());
				#end

				var values = Bytes.alloc(image.width * image.height + image.height);
				var index = 0;

				for (y in 0...image.height)
				{
					values.set(index++, 0);
					values.blit(index, alpha, alpha.position, image.width);
					index += image.width;
					alpha.position += image.width;
				}

				var png = new List();
				png.add(CHeader({
					width: image.width,
					height: image.height,
					colbits: 8,
					color: ColGrey(false),
					interlaced: false
				}));
				var valuesBA:ByteArray = values;
				valuesBA.compress();
				png.add(CData(valuesBA));
				png.add(CEnd);

				var output = new BytesOutput();
				var writer = new PNGWriter(output);
				writer.write(png);

				alphaByteArray = ByteArray.fromBytes(output.getBytes());
				byteArray = data.bitmapData;
				type = BitmapType.JPEG_ALPHA;
			}
			else
			{
				byteArray = data.bitmapData;
				type = BitmapType.JPEG;
			}
		}
		else if (Std.is(tag, TagDefineBits))
		{
			var data:TagDefineBits = cast tag;

			byteArray = data.bitmapData;
			type = BitmapType.JPEG;
		}

		if (byteArray != null)
		{
			var symbol:Dynamic = {};
			symbol.type = SWFSymbolType.BITMAP;
			symbol.id = tag.characterId;
			symbol.path = "symbols/" + symbol.id + "." + (type == PNG ? "png" : "jpg");

			var entry:Entry = {
				fileName: symbol.path,
				fileSize: byteArray.length,
				fileTime: Date.now(),
				compressed: false,
				dataSize: 0,
				data: byteArray,
				crc32: Crc32.make(byteArray)
			};
			outputList.add(entry);

			manifestData.assets.push({
				path: symbol.path,
				type: AssetType.IMAGE
			});

			if (type == JPEG_ALPHA)
			{
				symbol.alpha = "symbols/" + symbol.id + "a.png";

				var entry:Entry = {
					fileName: symbol.alpha,
					fileSize: alphaByteArray.length,
					fileTime: Date.now(),
					compressed: false,
					dataSize: 0,
					data: alphaByteArray,
					crc32: Crc32.make(alphaByteArray)
				};
				outputList.add(entry);

				manifestData.assets.push({
					path: symbol.alpha,
					type: AssetType.IMAGE
				});
			}

			libraryData.symbols.set(symbol.id, symbol);

			return symbol;
		}

		return null;
	}

	private function addFont(tag:IDefinitionTag):Dynamic
	{
		if (Std.is(tag, TagDefineFont2))
		{
			var defineFont:TagDefineFont2 = cast tag;
			var symbol:Dynamic = {};
			symbol.type = SWFSymbolType.FONT;
			symbol.id = defineFont.characterId;
			symbol.glyphs = new Array<Array<Dynamic>>();

			// for (i in 0...defineFont.glyphShapeTable.length) {
			//
			// var handler = new ShapeCommandExporter (data);
			// defineFont.export (handler, i);
			// symbol.glyphs.push (handler.commands);
			//
			// }

			symbol.advances = new Array<Int>();
			// symbol.advances = cast defineFont.fontAdvanceTable.copy ();
			symbol.ascent = defineFont.ascent;
			symbol.bold = defineFont.bold;
			symbol.codes = defineFont.codeTable.copy();
			symbol.descent = defineFont.descent;
			symbol.italic = defineFont.italic;
			symbol.leading = defineFont.leading;
			symbol.name = defineFont.fontName;

			libraryData.symbols.set(symbol.id, symbol);

			return symbol;
		}

		return null;
	}

	private function addShape(tag:TagDefineShape):Dynamic
	{
		var handler = new ShapeCommandExporter(swfData);
		tag.export(handler);

		// TODO: Remove need for this optimization

		#if !disable_bitmap_optimization
		var bitmaps = ShapeBitmapExporter.process(handler);
		#else
		var bitmaps:Array<Dynamic> = null;
		#end

		if (bitmaps != null)
		{
			var symbol:Dynamic = {};
			symbol.type = SWFSymbolType.SPRITE;
			symbol.frames = [];

			var frame:Dynamic = {};
			frame.objects = [];
			var bitmap, frameObject:Dynamic;

			for (i in 0...bitmaps.length)
			{
				bitmap = bitmaps[i];

				processTag(cast swfData.getCharacter(bitmap.id));

				var bitmapSymbol:Dynamic = cast libraryData.symbols.get(bitmap.id);

				if (bitmapSymbol != null)
				{
					// Use smoothing if a shape requests it

					if (bitmapSymbol.smooth == null && !bitmap.smooth)
					{
						bitmapSymbol.smooth = false;
					}
					else if (bitmapSymbol.smooth == false && bitmap.smooth)
					{
						bitmapSymbol.smooth = true;
					}
				}

				frameObject = {};
				frameObject.symbol = bitmap.id;
				frameObject.type = SWFFrameObjectType.CREATE;
				frameObject.id = i;
				frameObject.depth = i;
				frameObject.clipDepth = 0;
				frameObject.matrix = serializeMatrix(bitmap.transform);
				frameObject.visible = true;

				frame.objects.push(frameObject);
			}

			symbol.frames.push(frame);
			symbol.id = tag.characterId;

			libraryData.symbols.set(symbol.id, symbol);
			return symbol;
		}
		else
		{
			var symbol:Dynamic = {};
			symbol.type = SWFSymbolType.SHAPE;
			symbol.id = tag.characterId;

			var commands:Array<Dynamic> = [];

			for (command in handler.commands)
			{
				switch (command)
				{
					case LineStyle(thickness, color, alpha, pixelHinting, scaleMode, startCaps, joints, miterLimit):
						if (thickness == null && color == null && alpha == null)
						{
							commands.push(SWFShapeCommandType.CLEAR_LINE_STYLE);
						}
						else
						{
							commands = commands.concat([
								SWFShapeCommandType.LINE_STYLE,
								thickness,
								color,
								alpha,
								pixelHinting,
								scaleMode,
								startCaps,
								joints,
								miterLimit
							]);
						}

					case BeginFill(color, alpha):
						commands = commands.concat([SWFShapeCommandType.BEGIN_FILL, color, alpha]);

					case BeginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
						commands = commands.concat([
							SWFShapeCommandType.BEGIN_GRADIENT_FILL,
							type,
							colors,
							alphas,
							ratios,
							serializeMatrix(matrix),
							spreadMethod,
							interpolationMethod,
							focalPointRatio
						]);

					case BeginBitmapFill(bitmapID, matrix, repeat, smooth):
						commands = commands.concat([
							SWFShapeCommandType.BEGIN_BITMAP_FILL,
							bitmapID,
							serializeMatrix(matrix),
							repeat,
							smooth
						]);
						processTag(cast swfData.getCharacter(bitmapID));

					case EndFill:
						commands.push(SWFShapeCommandType.END_FILL);

					case MoveTo(x, y):
						commands = commands.concat([SWFShapeCommandType.MOVE_TO, twip(x), twip(y)]);

					case LineTo(x, y):
						commands = commands.concat([SWFShapeCommandType.LINE_TO, twip(x), twip(y)]);

					case CurveTo(controlX, controlY, anchorX, anchorY):
						commands = commands.concat([
							SWFShapeCommandType.CURVE_TO,
							twip(controlX),
							twip(controlY),
							twip(anchorX),
							twip(anchorY)
						]);

					default:
				}
			}

			symbol.commands = commands;
			libraryData.symbols.set(symbol.id, symbol);
			return symbol;
		}
	}

	private function addSprite(tag:SWFTimelineContainer, root:Bool = false):Dynamic
	{
		var symbol:Dynamic = {};
		symbol.type = SWFSymbolType.SPRITE;
		symbol.frames = [];

		if (Std.is(tag, IDefinitionTag))
		{
			symbol.id = untyped tag.characterId;
		}

		var instances = new Array<Int>();
		var lastModified = new Map<Int, Int>();
		var zeroCharacter = -1;

		var frame:Dynamic,
			frameObject:Dynamic,
			frameData,
			placeTag:TagPlaceObject;

		for (frameData in tag.frames)
		{
			frame = {};

			if (frameData.label != null)
			{
				frame.label = frameData.label;
			}

			instances.splice(0, instances.length);

			for (object in frameData.getObjectsSortedByDepth())
			{
				instances.push(object.placedAtIndex);

				if (object.placedAtIndex == 0 && object.characterId != zeroCharacter)
				{
					lastModified.remove(0);
					zeroCharacter = object.characterId;
				}

				if (!lastModified.exists(object.placedAtIndex))
				{
					processTag(cast swfData.getCharacter(object.characterId));

					placeTag = cast tag.tags[object.placedAtIndex];
				}
				else if (object.lastModifiedAtIndex > lastModified.get(object.placedAtIndex))
				{
					placeTag = cast tag.tags[object.lastModifiedAtIndex];
				}
				else
				{
					continue;
				}

				frameObject = {};
				frameObject.symbol = object.characterId;
				frameObject.id = object.placedAtIndex;
				frameObject.name = placeTag.instanceName;

				if (!lastModified.exists(object.placedAtIndex))
				{
					frameObject.type = SWFFrameObjectType.CREATE;
				}
				else
				{
					frameObject.type = SWFFrameObjectType.UPDATE;
				}

				if (placeTag.matrix != null)
				{
					var matrix = placeTag.matrix.matrix;
					matrix.tx *= (1 / 20);
					matrix.ty *= (1 / 20);

					frameObject.matrix = serializeMatrix(matrix);
				}

				if (placeTag.colorTransform != null)
				{
					frameObject.colorTransform = serializeColorTransform(placeTag.colorTransform.colorTransform);
				}

				if (placeTag.hasFilterList)
				{
					var filters:Array<FilterType> = [];

					for (surfaceFilter in placeTag.surfaceFilterList)
					{
						var type = surfaceFilter.type;

						if (type != null)
						{
							filters.push(surfaceFilter.type);
							// filterClasses.set (Type.getClassName (Type.getClass (surfaceFilter.filter)), true);
						}
					}

					frameObject.filters = filters;
				}

				frameObject.depth = placeTag.depth;
				frameObject.clipDepth = (placeTag.hasClipDepth ? placeTag.clipDepth : 0);

				if (placeTag.hasVisible)
				{
					frameObject.visible = placeTag.visible != 0;
				}

				if (placeTag.hasBlendMode)
				{
					var blendMode = BlendMode.toString(placeTag.blendMode);
					frameObject.blendMode = blendMode;
				}

				if (placeTag.hasCacheAsBitmap)
				{
					frameObject.cacheAsBitmap = placeTag.bitmapCache != 0;
				}

				lastModified.set(object.placedAtIndex, object.lastModifiedAtIndex);

				if (frame.objects == null)
				{
					frame.objects = [];
				}

				frame.objects.push(frameObject);
			}

			for (id in lastModified.keys())
			{
				if (instances.indexOf(id) == -1)
				{
					lastModified.remove(id);

					frameObject = {};
					frameObject.id = id;
					frameObject.type = SWFFrameObjectType.DESTROY;

					if (frame.objects == null)
					{
						frame.objects = [];
					}

					frame.objects.push(frameObject);
				}
			}

			symbol.frames.push(frame);
		}

		var scalingGrid = swfData.getScalingGrid(symbol.id);
		if (scalingGrid != null && scalingGrid.splitter != null)
		{
			symbol.scale9Grid = serializeRect(scalingGrid.splitter.rect);
		}

		if (root)
		{
			libraryData.root = symbol;
		}
		else
		{
			libraryData.symbols.set(symbol.id, symbol);
		}

		return symbol;
	}

	private function addDynamicText(tag:TagDefineEditText):Dynamic
	{
		var symbol:Dynamic = {};
		symbol.type = SWFSymbolType.DYNAMIC_TEXT;

		symbol.id = tag.characterId;
		symbol.border = tag.border;

		if (tag.hasTextColor)
		{
			symbol.color = tag.textColor;
		}

		symbol.fontHeight = tag.fontHeight;
		symbol.multiline = tag.multiline;
		symbol.selectable = !tag.noSelect;

		if (tag.hasText)
		{
			symbol.html = tag.html;
			symbol.text = tag.initialText;
		}

		if (tag.hasLayout)
		{
			switch (tag.align)
			{
				case 0:
					symbol.align = "left";
				case 1:
					symbol.align = "right";
				case 2:
					symbol.align = "center";
				case 3:
					symbol.align = "justify";
			}

			symbol.leftMargin = tag.leftMargin;
			symbol.rightMargin = tag.rightMargin;
			symbol.indent = tag.indent;
			symbol.leading = tag.leading;
		}

		symbol.wordWrap = tag.wordWrap;
		symbol.input = !tag.readOnly;
		symbol.password = tag.password;

		// embedded fonts
		if (tag.hasFont)
		{
			var font:IDefinitionTag = cast swfData.getCharacter(tag.fontId);

			if (font != null)
			{
				// processTag (font);
			}

			symbol.fontID = tag.fontId;
			symbol.fontName = cast(font, TagDefineFont2).fontName;
		}

		// shared fonts
		if (tag.hasFontClass)
		{
			symbol.fontName = tag.fontClass;
		}

		symbol.rect = serializeRect(tag.bounds.rect);

		libraryData.symbols.set(symbol.id, symbol);

		return symbol;
	}

	private function addStaticText(tag:TagDefineText):Dynamic
	{
		var symbol:Dynamic = {};
		symbol.type = SWFSymbolType.STATIC_TEXT;
		symbol.id = tag.characterId;

		var records = [];

		var font:Dynamic = null;
		var defineFont:TagDefineFont2 = null;

		for (record in tag.records)
		{
			var textRecord:Dynamic = {};

			if (record.hasFont)
			{
				textRecord.fontID = record.fontId;

				defineFont = cast swfData.getCharacter(record.fontId);
				processTag(defineFont);
				font = cast libraryData.symbols.get(record.fontId);
			}

			if (record.hasColor) textRecord.color = record.textColor;
			if (record.hasXOffset || record.hasYOffset)
			{
				textRecord.offset = [record.hasXOffset ? record.xOffset : 0, record.hasYOffset ? record.yOffset : 0];
			}
			textRecord.fontHeight = record.textHeight;

			var advances = [];
			var glyphs = [];

			if (font != null)
			{
				var handler = new ShapeCommandExporter(swfData);

				for (glyphEntry in record.glyphEntries)
				{
					var index = glyphEntry.index;

					advances.push(glyphEntry.advance);
					glyphs.push(index);

					if (font.glyphs[index] == null)
					{
						handler.beginShape();
						defineFont.export(handler, index);

						var commands:Array<Dynamic> = [];
						for (command in handler.commands)
						{
							switch (command)
							{
								case LineStyle(thickness, color, alpha, pixelHinting, scaleMode, startCaps, joints, miterLimit):
									if (thickness == null && color == null && alpha == null)
									{
										commands.push(SWFShapeCommandType.CLEAR_LINE_STYLE);
									}
									else
									{
										commands = commands.concat([
											SWFShapeCommandType.LINE_STYLE,
											thickness,
											color,
											alpha,
											pixelHinting,
											scaleMode,
											startCaps,
											joints,
											miterLimit
										]);
									}

								case BeginFill(color, alpha):
									commands = commands.concat([SWFShapeCommandType.BEGIN_FILL, color, alpha]);

								case BeginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
									commands = commands.concat([
										SWFShapeCommandType.BEGIN_GRADIENT_FILL,
										type,
										colors,
										alphas,
										ratios,
										serializeMatrix(matrix),
										spreadMethod,
										interpolationMethod,
										focalPointRatio
									]);

								case BeginBitmapFill(bitmapID, matrix, repeat, smooth):
									commands = commands.concat([
										SWFShapeCommandType.BEGIN_BITMAP_FILL,
										bitmapID,
										serializeMatrix(matrix),
										repeat,
										smooth
									]);
									processTag(cast swfData.getCharacter(bitmapID));

								case EndFill:
									commands.push(SWFShapeCommandType.END_FILL);

								case MoveTo(x, y):
									commands = commands.concat([SWFShapeCommandType.MOVE_TO, twip(x), twip(y)]);

								case LineTo(x, y):
									commands = commands.concat([SWFShapeCommandType.LINE_TO, twip(x), twip(y)]);

								case CurveTo(controlX, controlY, anchorX, anchorY):
									commands = commands.concat([
										SWFShapeCommandType.CURVE_TO,
										twip(controlX),
										twip(controlY),
										twip(anchorX),
										twip(anchorY)
									]);

								default:
							}
						}
						font.glyphs[index] = commands;
						font.advances[index] = defineFont.fontAdvanceTable[index];
					}
				}
			}

			textRecord.advances = advances;
			textRecord.glyphs = glyphs;
			records.push(textRecord);
		}

		symbol.records = records;

		var matrix = tag.textMatrix.matrix;
		matrix.tx *= (1 / 20);
		matrix.ty *= (1 / 20);

		symbol.matrix = serializeMatrix(matrix);

		libraryData.symbols.set(symbol.id, symbol);

		return symbol;
	}

	private function addSound(tag:IDefinitionTag):Void
	{
		if (Std.is(tag, TagDefineSound))
		{
			var defineSound:TagDefineSound = cast tag;

			var byteArray = defineSound.soundData;
			var type:SoundType = switch (defineSound.soundFormat)
			{
				case 0: SoundType.UNCOMPRESSED_NATIVE_ENDIAN;
				case 1: SoundType.ADPCM;
				case 2: SoundType.MP3;
				case 3: SoundType.UNCOMPRESSED_LITTLE_ENDIAN;
				case 4: SoundType.NELLYMOSER_16_KHZ;
				case 5: SoundType.NELLYMOSER_8_KHZ;
				case 6: SoundType.NELLYMOSER;
				case 7: SoundType.SPEEX;
				case _: throw("invalid sound type!");
			}

			// TODO

			// 			var entry:Entry = {
			// 				fileName: symbol.path,
			// 				fileSize: byteArray.length,
			// 				fileTime: Date.now(),
			// 				compressed: false,
			// 				dataSize: 0,
			// 				data: byteArray,
			// 				crc32: Crc32.make(byteArray)
			// 			};
			// 			outputList.add(entry);

			// createdDirectory = false;
			// 		for (id in exporter.sounds.keys())
			// 		{
			// 			if (!createdDirectory)
			// 			{
			// 				System.mkdir(Path.combine(targetPath, "sounds"));
			// 				createdDirectory = true;
			// 			}

			// 			var symbolClassName = exporter.soundSymbolClassNames.get(id);
			// 			var typeId = exporter.soundTypes.get(id);

			// 			Log.info("", " - \x1b[1mExporting sound:\x1b[0m [id=" + id + ", type=" + typeId + ", symbolClassName=" + symbolClassName + "]");

			// 			var type;
			// 			switch (typeId)
			// 			{
			// 				case SoundType.MP3:
			// 					type = "mp3";
			// 				case SoundType.ADPCM:
			// 					type = "adpcm";
			// 				case _:
			// 					throw "unsupported sound type " + id + ", type " + typeId + ", symbol class name " + symbolClassName;
			// 			};
			// 			var path = "sounds/" + symbolClassName + "." + type;
			// 			var assetData = exporter.sounds.get(id);

			// 			File.saveBytes(Path.combine(targetPath, path), assetData);

			// 			// NOTICE: everything must be .mp3 in its final form, even though we write out various formats to disk
			// 			var soundAsset = new Asset("", "sounds/" + symbolClassName + ".mp3", AssetType.SOUND);
			// 			project.assets.push(soundAsset);
		}

		return;
	}

	private function formatClassName(className:String, prefix:String = null):String
	{
		if (className == null) return null;
		if (prefix == null) prefix = "";

		var lastIndexOfPeriod = className.lastIndexOf(".");

		var packageName = "";
		var name = "";

		if (lastIndexOfPeriod == -1)
		{
			name = prefix + className;
		}
		else
		{
			packageName = className.substr(0, lastIndexOfPeriod);
			name = prefix + className.substr(lastIndexOfPeriod + 1);
		}

		packageName = packageName.charAt(0).toLowerCase() + packageName.substr(1);
		name = name.substr(0, 1).toUpperCase() + name.substr(1);

		if (packageName != "")
		{
			return StringTools.trim(packageName + "." + name);
		}
		else
		{
			return StringTools.trim(name);
		}
	}

	public function generateClasses(targetPath:String, output:Array<Asset>, prefix:String = ""):Array<String>
	{
		#if commonjs
		var bitmapDataTemplate = File.getContent(Path.combine(js.Node.__dirname, "../assets/templates/animate/BitmapData.mtt"));
		var movieClipTemplate = File.getContent(Path.combine(js.Node.__dirname, "../assets/templates/animate/MovieClip.mtt"));
		var simpleButtonTemplate = File.getContent(Path.combine(js.Node.__dirname, "../assets/templates/animate/SimpleButton.mtt"));
		#else
		var bitmapDataTemplate = File.getContent(Haxelib.getPath(new Haxelib("openfl"), true) + "/assets/templates/animate/BitmapData.mtt");
		var movieClipTemplate = File.getContent(Haxelib.getPath(new Haxelib("openfl"), true) + "/assets/templates/animate/MovieClip.mtt");
		var simpleButtonTemplate = File.getContent(Haxelib.getPath(new Haxelib("openfl"), true) + "/assets/templates/animate/SimpleButton.mtt");
		#end

		var generatedClasses = [];

		for (symbolID in libraryData.symbols.keys())
		{
			var symbol = libraryData.symbols.get(symbolID);
			var templateData = null;
			var baseClassName = null;

			var type:SWFSymbolType = symbol.type;

			if (type == BITMAP)
			{
				templateData = bitmapDataTemplate;
			}
			else if (type == SPRITE)
			{
				templateData = movieClipTemplate;
				if (Reflect.hasField(symbol, "baseClassName"))
				{
					baseClassName = symbol.baseClassName;
				}
			}
			else if (type == BUTTON)
			{
				templateData = simpleButtonTemplate;
			}
			else
			{
				continue;
			}

			if (templateData != null && Reflect.hasField(symbol, "className") && symbol.className != null)
			{
				var className:String = symbol.className;

				var name = className;
				var packageName = "";

				if (name.toLowerCase().indexOf("shipguide") > -1)
				{
					trace(name);
				}

				var lastIndexOfPeriod = className.lastIndexOf(".");

				if (lastIndexOfPeriod > -1)
				{
					packageName = className.substr(0, lastIndexOfPeriod);
					if (packageName.length > 0)
					{
						packageName = packageName.charAt(0).toLowerCase() + packageName.substr(1);
					}
					if (name.toLowerCase().indexOf("shipguide") > -1)
					{
						trace(name);
						trace(packageName);
					}
					name = className.substr(lastIndexOfPeriod + 1);

					if (name.toLowerCase().indexOf("shipguide") > -1)
					{
						trace(name);
					}
				}

				name = formatClassName(name, prefix);

				if (name.toLowerCase().indexOf("shipguide") > -1)
				{
					trace(prefix);
					trace(name);
				}

				var classProperties = [];
				var objectReferences = new Map<String, Bool>();

				if (type == SPRITE)
				{
					var spriteSymbol:Dynamic = cast symbol;
					var frames:Array<Dynamic> = cast spriteSymbol.frames;

					if (frames.length > 0 && Reflect.hasField(frames[0], "objects"))
					{
						for (frame in frames)
						{
							var objects:Array<Dynamic> = cast frame.objects;
							if (objects != null)
							{
								for (object in objects)
								{
									if (Reflect.hasField(object, "name") && object.name != null && !objectReferences.exists(object.name))
									{
										if (libraryData.symbols.exists(object.symbol))
										{
											var childSymbol = libraryData.symbols.get(object.symbol);
											var className = Reflect.hasField(childSymbol, "className") ? childSymbol.className : null;

											if (className == null)
											{
												var childType:SWFSymbolType = cast childSymbol.type;
												if (childType == SPRITE)
												{
													className = "openfl.display.MovieClip";
												}
												else if (childType == BITMAP)
												{
													className = "openfl.display.BitmapData";
												}
												else if (childType == SHAPE)
												{
													className = "openfl.display.Shape";
												}
													// else if (childType == BITMAP)
													// {
													// 	className = "openfl.display.Bitmap";
												// }
												else if (childType == DYNAMIC_TEXT)
												{
													className = "openfl.text.TextField";
												}
												else if (childType == BUTTON)
												{
													className = "openfl.display.SimpleButton";
												}
												else
												{
													className = "Dynamic";
												}
											}
											else
											{
												className = formatClassName(className, prefix);
											}

											if (className != null)
											{
												objectReferences[object.name] = true;
												classProperties.push({name: object.name, type: className});
											}
										}
									}
								}
							}
						}
					}
				}

				var context:Dynamic = {
					UUID: libraryData.uuid,
					PACKAGE_NAME: packageName,
					NATIVE_CLASS_NAME: className,
					CLASS_NAME: name,
					SYMBOL_ID: symbolID,
					PREFIX: "",
					CLASS_PROPERTIES: classProperties
				};
				if (baseClassName != null) context.BASE_CLASS_NAME = baseClassName;
				var template = new Template(templateData);

				var templateFile = new Asset("", Path.combine(targetPath, Path.directory(symbol.className.split(".").join("/"))) + "/" + name + ".hx",
					cast AssetType.TEMPLATE);
				templateFile.embed = false;
				templateFile.data = template.execute(context);
				output.push(templateFile);

				generatedClasses.push((packageName.length > 0 ? packageName + "." : "") + name);
			}
		}

		return generatedClasses;
	}

	private function processSymbol(symbol:format.swf.data.SWFSymbol):Void
	{
		// Log.info("", "processing symbol " + symbol.name);

		var data2 = processTag(cast swfData.getCharacter(symbol.tagId));

		if (data2 != null && symbol.name != null)
		{
			data2.className = symbol.name;
		}

		// TODO: Move to separate FrameScriptExporter class

		// #if enable_framescript
		// // TODO: guard the rest of this code with appropriate macro
		// //       cuz not everyone wants to do it this way

		// // apply names to sounds
		// // if (null != sounds.get(symbol.tagId))
		// // {
		// // 	soundSymbolClassNames.set(symbol.tagId, symbol.name);
		// // }

		// // root symbol is a special case
		// if (data2 == null && ~/_fla\.MainTimeline$/.match(symbol.name))
		// {
		// 	data2 = libraryData.root;
		// }

		// // we only want to operate on DefineSprite tags from here
		// if (!Std.is(data2, SpriteSymbol))
		// {
		// 	return;
		// }
		// var spriteSymbol:SpriteSymbol = cast data2;

		// // find the as3 class definition
		// var cls = swfData.abcData.findClassByName(symbol.name);

		// if (cls != null)
		// {
		// 	// get base class
		// 	if (cls.superclass != null)
		// 	{
		// 		var superClsName = swfData.abcData.resolveMultiNameByIndex(cls.superclass);
		// 		switch (superClsName.nameSpace)
		// 		{
		// 			case NPublic(_) if (!~/^flash\./.match(superClsName.nameSpaceName)):
		// 				// store on SWFLite object for serialized .dat export
		// 				spriteSymbol.baseClassName = ("" == superClsName.nameSpaceName ? "" : superClsName.nameSpaceName + ".") + superClsName.name;
		// 				Log.info("", "swfData.className: " + symbol.name + ", baseClass: " + spriteSymbol.baseClassName);
		// 			case _:
		// 		}
		// 	}

		// 	// get frame scripts
		// 	if (cls.fields.length > 0)
		// 	{
		// 		for (field in cls.fields)
		// 		{
		// 			switch (field.kind)
		// 			{
		// 				case FMethod(var idx, _, _, _):
		// 					var methodName = swfData.abcData.resolveMultiNameByIndex(field.name);
		// 					if (AVM2.FRAME_SCRIPT_METHOD_NAME.match(methodName.name))
		// 					{
		// 						var frameNumOneIndexed = Std.parseInt(AVM2.FRAME_SCRIPT_METHOD_NAME.matched(1));
		// 						Log.info("", "frame script #" + frameNumOneIndexed);
		// 						var pcodes:Array<OpCode> = swfData.pcode[idx.getIndex()];
		// 						var js = "";
		// 						var prop:MultiName = null;
		// 						var stack:Array<Dynamic> = new Array();
		// 						for (pcode in pcodes)
		// 						{
		// 							switch (pcode)
		// 							{
		// 								case OThis:
		// 									stack.push("this");
		// 								case OScope:
		// 									stack.pop();
		// 								case OFindPropStrict(nameIndex):
		// 								//										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);
		// 								case OGetLex(nameIndex):
		// 									prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

		// 									var fullname = "";

		// 									if (prop != null)
		// 									{
		// 										fullname += AVM2.getFullName(swfData.abcData, prop, cls);
		// 										stack.push(fullname);
		// 									}
		// 								case OGetProp(nameIndex):
		// 									var fullname = "";

		// 									prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

		// 									if (prop != null)
		// 									{
		// 										fullname += stack.pop() + "." + AVM2.getFullName(swfData.abcData, prop, cls);
		// 									}

		// 									Log.info("", "OGetProp fullname: " + fullname);

		// 									stack.push(fullname);
		// 								case OSetProp(nameIndex):
		// 									prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);
		// 									Log.info("", "OSetProp stack: " + prop + ", " + stack);

		// 									var result = stack.pop();

		// 									var name = null;

		// 									if (prop != null)
		// 									{
		// 										if (prop.name != null)
		// 										{
		// 											name = "." + prop.name;
		// 										}
		// 										else
		// 										{
		// 											name = "[" + stack.pop() + "]";
		// 										}
		// 									}
		// 									else
		// 									{
		// 										Log.info("", "OSetProp stack prop is null");
		// 										break;
		// 									}

		// 									var instance = stack.pop();

		// 									if (instance != "this")
		// 									{
		// 										instance = "this" + "." + instance;
		// 									}

		// 									js += instance + name + " = " + result + ";\n";
		// 								case OString(strIndex):
		// 									var str = swfData.abcData.getStringByIndex(strIndex);
		// 									stack.push("\"" + str + "\"");
		// 								case OInt(i):
		// 									stack.push(i);
		// 									Log.info("", "int: " + i);
		// 								case OSmallInt(i):
		// 									stack.push(i);
		// 									Log.info("", "smallint: " + i);
		// 								case OCallPropVoid(nameIndex, argCount):
		// 									var temp = AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack);

		// 									if (stack.length > 0)
		// 									{
		// 										js += stack.pop() + ".";
		// 									}
		// 									else
		// 									{
		// 										js += "this" + ".";
		// 									}

		// 									js += temp;
		// 									js += ";\n";
		// 								case OCallProperty(nameIndex, argCount):
		// 									Log.info("", "OCallProperty stack: " + stack);

		// 									stack.pop();
		// 									if (prop != null)
		// 									{
		// 										stack.push(AVM2.getFullName(swfData.abcData, prop, cls)
		// 											+ "."
		// 											+ AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack));
		// 									}
		// 								case OConstructProperty(nameIndex, argCount):
		// 									Log.info("", "OConstructProperty stack: " + stack);

		// 									var temp = "new ";
		// 									temp += AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack);
		// 									stack.push(temp);

		// 									Log.info("", "OConstructProperty value: " + temp);
		// 								case OInitProp(nameIndex):
		// 									Log.info("", "OInitProp stack: " + stack);

		// 									prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

		// 									var temp = stack.pop();

		// 									js += stack.pop() + "." + prop.name + " = " + Std.string(temp) + ";\n";
		// 								case ODup:
		// 									stack.push(stack[stack.length - 1]);
		// 								case OArray(argCount):
		// 									Log.info("", "before array: " + stack);

		// 									var str = "";
		// 									var temp = [];
		// 									for (i in 0...argCount)
		// 									{
		// 										temp.push(stack.pop());
		// 									}
		// 									temp.reverse();
		// 									stack.push(temp);

		// 									Log.info("", "after array: " + stack);
		// 								case ORetVoid:
		// 								case ONull:
		// 									stack.push(null);
		// 								case OOp(op):
		// 									var _operator = null;
		// 									switch (op)
		// 									{
		// 										case OpMul:
		// 											_operator = "*";
		// 										case OpAdd:
		// 											_operator = "+";
		// 										case _:
		// 											Log.info("", "OOp");
		// 									}

		// 									if (op == OpAs)
		// 									{
		// 										Log.info("", "cast to " + stack.pop() + " is discarded");
		// 									}

		// 									if (_operator != null)
		// 									{
		// 										var temp = stack.pop();
		// 										stack.push(Std.string(stack.pop()) + " " + _operator + " " + Std.string(temp));
		// 									}
		// 								case OJump(j, delta):
		// 									switch (j)
		// 									{
		// 										case JNeq:
		// 											// Log.info("", stack[0]);
		// 											var temp = stack.pop();
		// 											js += "if (" + Std.string(stack.pop()) + " == " + Std.string(temp) + ")\n";
		// 										case JAlways:
		// 											js += "else\n";
		// 											Log.info("", Std.string(delta));
		// 										case JFalse:
		// 											js += "if (" + Std.string(stack.pop()) + ")\n";
		// 										case _:
		// 											Log.info("", "OJump");
		// 									}
		// 								case OTrue:
		// 									stack.push(true);
		// 								case OFalse:
		// 									stack.push(false);
		// 								case _:
		// 									// TODO: throw() on unsupported pcodes
		// 									Log.info("", "pcode " + pcode);
		// 							}
		// 						}
		// 						Log.info("", "javascript:\n" + js);

		// 						if (js != null && js.indexOf("null.") > -1)
		// 						{
		// 							Log.info("", "Script appears to have been parsed improperly, discarding");
		// 							js = null;
		// 						}
		// 						else
		// 						{
		// 							// store on SWFLite object for serialized .dat export
		// 							spriteSymbol.frames[frameNumOneIndexed - 1].scriptSource = js;
		// 						}
		// 					}
		// 				case _:
		// 			}
		// 		}
		// 	}
		// }
		// #end
	}

	private function processTag(tag:IDefinitionTag):Dynamic
	{
		if (tag == null) return null;

		if (!libraryData.symbols.exists(tag.characterId))
		{
			if (Std.is(tag, TagDefineSprite))
			{
				return addSprite(cast tag);
			}
			else if (Std.is(tag, TagDefineBits) || Std.is(tag, TagDefineBitsJPEG2) || Std.is(tag, TagDefineBitsLossless))
			{
				return addBitmap(tag);
			}
			else if (Std.is(tag, TagDefineButton) || Std.is(tag, TagDefineButton2))
			{
				return addButton(cast tag);
			}
			else if (Std.is(tag, TagDefineEditText))
			{
				return addDynamicText(cast tag);
			}
			else if (Std.is(tag, TagDefineText))
			{
				return addStaticText(cast tag);
			}
			else if (Std.is(tag, TagDefineShape))
			{
				return addShape(cast tag);
			}
			else if (Std.is(tag, TagDefineFont) || Std.is(tag, TagDefineFont4))
			{
				return addFont(tag);
			}
			else if (Std.is(tag, TagDefineSound))
			{
				addSound(tag);
			}

			return null;
		}
		else
		{
			return libraryData.symbols.get(tag.characterId);
		}
	}

	private function serializeColorTransform(colorTransform:ColorTransform):Array<Int>
	{
		return [
			twip(colorTransform.redMultiplier),
			twip(colorTransform.greenMultiplier),
			twip(colorTransform.blueMultiplier),
			twip(colorTransform.alphaMultiplier),
			twip(colorTransform.redOffset),
			twip(colorTransform.greenOffset),
			twip(colorTransform.blueOffset),
			twip(colorTransform.alphaOffset)
		];
	}

	private function serializeMatrix(matrix:Matrix):Array<Float>
	{
		return [matrix.a, matrix.b, matrix.c, matrix.d, twip(matrix.tx), twip(matrix.ty)];
	}

	private function serializeRect(rect:Rectangle):Array<Int>
	{
		return [twip(rect.x), twip(rect.y), twip(rect.width), twip(rect.height)];
	}

	private inline function twip(value:Float):Int
	{
		return Math.round(value * 20);
	}
}

enum BitmapType
{
	PNG;
	JPEG_ALPHA;
	JPEG;
}

enum SoundType
{
	UNCOMPRESSED_NATIVE_ENDIAN;
	ADPCM;
	MP3;
	UNCOMPRESSED_LITTLE_ENDIAN;
	NELLYMOSER_16_KHZ;
	NELLYMOSER_8_KHZ;
	NELLYMOSER;
	SPEEX;
}

/**
 * AVM2 ActionScript3 Byte Code (ABC) Instruction Traversal
 */
typedef MultiName =
{
	var name:String;
	var nameIndex:Index<Name>;
	var nameSpace:Namespace;
	var nameSpaceName:String;
}

class AVM2
{
	public static var FRAME_SCRIPT_METHOD_NAME = ~/frame(\d+)/;

	public static function getIndex<T>(idx:Index<T>):Int
	{
		#if (haxe4 || (format > "3.4.2"))
		return idx.asInt();
		#else
		return switch (idx)
		{
			case Idx(i): i;
		};
		#end
	}

	public static function getMultiNameByIndex(abcData:ABCData, i:Index<Name>):Name
	{
		return abcData.names[i.getIndex() - 1];
	}

	public static function getStringByIndex(abcData:ABCData, i:Index<String>):String
	{
		return abcData.strings[i.getIndex() - 1];
	}

	public static function getNameSpaceByIndex(abcData:ABCData, i:Index<Namespace>):Namespace
	{
		return abcData.namespaces[i.getIndex() - 1];
	}

	public static function getFunctionByIndex(abcData:ABCData, i:Index<MethodType>):Function
	{
		return abcData.functions[i.getIndex()];
	}

	public static function resolveMultiNameByIndex(abcData:ABCData, i:Index<Name>):MultiName
	{
		var multiName = abcData.getMultiNameByIndex(i);
		switch (multiName)
		{
			case NName(nameIndex, nsIndex): // a.k.a. QName
				var nameSpace = abcData.getNameSpaceByIndex(nsIndex);
				switch (nameSpace)
				{
					case NPublic(nsNameIndex) | NInternal(nsNameIndex) | NPrivate(nsNameIndex): // a.k.a. PackageNamespace, PackageInternalNS
						return {
							name: abcData.getStringByIndex(nameIndex),
							nameIndex: i,
							nameSpace: nameSpace,
							nameSpaceName: abcData.getStringByIndex(nsNameIndex)
						}
					case _:
						Log.info("", "other type of namespace");
				}
			case NMulti(nameIndex, nsIndexSet):
				return {
					name: abcData.getStringByIndex(nameIndex),
					nameIndex: i,
					nameSpace: null,
					nameSpaceName: null
				}
			case NMultiLate(nset):
				return {
					name: null,
					nameIndex: i,
					nameSpace: null,
					nameSpaceName: null
				}
			case _:
				Log.info("", "other type of name");
		}
		return null;
	}

	public static function findClassByName(abcData:ABCData, s:String):ClassDef
	{
		var x = s.lastIndexOf(".");
		var pkgName = "";
		var clsName = s;
		if (-1 != x)
		{
			pkgName = s.substr(0, x);
			clsName = s.substr(x + 1);
		}
		for (cls in abcData.classes)
		{
			if (cls.isInterface) continue;

			var multiName = abcData.resolveMultiNameByIndex(cls.name);

			if (multiName != null)
			{
				if (clsName == multiName.name && pkgName == multiName.nameSpaceName)
				{
					return cls;
				}
			}
			else
			{
				Log.info("", "multiname: " + multiName);
			}
		}

		return null;
	}

	public static function classHasField(abcData:ABCData, cls:ClassDef, name:String):Bool
	{
		var classHasField = false;

		for (field in cls.fields)
		{
			switch (field.kind)
			{
				case FMethod(var idx, _, _, _):
					var methodName = abcData.resolveMultiNameByIndex(field.name);
					if (methodName.name == name)
					{
						classHasField = true;
						break;
					}
				case FVar(_, _, _):
					var methodName = abcData.resolveMultiNameByIndex(field.name);
					if (methodName.name == name)
					{
						classHasField = true;
						break;
					}
				case _:
			}
		}

		return classHasField;
	}

	public static function getFullName(abcData:ABCData, prop:MultiName, cls:ClassDef):String
	{
		var js = null;

		if (prop == null)
		{
			Log.info("", "unable to get full name of property, prop = null");
			return "";
		}

		if (prop.nameSpace == null)
		{
			Log.info("", "namespace is null");
			js = prop.name;
		}
		else
		{
			switch (prop.nameSpace)
			{
				case NPublic(_) if ("" != prop.nameSpaceName):
					js = prop.nameSpaceName + "_" + prop.name;
				case NInternal(_) if (cls.name == prop.nameIndex):
					js = "this." + prop.name;
				case NPublic(_):
					switch (prop.name)
					{
						case "trace":
							js = "console.log";
						case _:
							//						var classHasField = classHasField(abcData, cls, prop.name);
							//
							//						if (classHasField)
							//						{
							//							js = "this." + prop.name;
							//						}
							//						else
							//						{
							js = prop.name;
							//						}
					}
				case _:
					// TODO: throw() on unsupported namespaces
					Log.info("", "unsupported namespace " + prop.nameSpace);
			}
		}

		return js;
	}

	public static function parseFunctionCall(abcData:ABCData, cls:ClassDef, nameIndex:IName, argCount:Int, stack:Array<Dynamic>):String
	{
		var prop = abcData.resolveMultiNameByIndex(nameIndex);

		if (prop == null)
		{
			Log.info("", "parseFunctionCall is stopped, prop = null");
			return "";
		}

		var js = getFullName(abcData, prop, cls);
		// invoke function
		js += "(";

		var temp = [];
		for (i in 0...argCount)
		{
			//			if (i > 0) js += ", ";
			var arg = stack.pop();
			if (Std.is(arg, String))
			{
				//				js += arg;
				temp.push(arg);
			}
			else
			{
				//				js += haxe.Json.stringify(arg);
				temp.push(haxe.Json.stringify(arg));
			}
		}
		temp.reverse();
		js += temp.join(", ") + ")";

		return js;
	}
}

class SWFDocument
{
	public var frameRate:Float;
	public var uuid:String;
	public var root:Dynamic;
	public var symbols:Map<Int, Dynamic>;

	// public var version:Int;

	public function new()
	{
		symbols = new Map();
	}

	public function serialize():Dynamic
	{
		var output:Dynamic = {};
		output.frameRate = frameRate;
		output.uuid = uuid;
		output.root = 0;
		output.version = 0.1;

		var symbolArray = new Array<Dynamic>();
		symbolArray.push(root);

		for (key in symbols.keys())
		{
			symbolArray.push(symbols.get(key));
		}

		output.symbols = symbolArray;

		return Json.stringify(output);
	}
}

@:enum abstract SWFFrameObjectType(Int) from Int to Int
{
	public var CREATE = 0;
	public var UPDATE = 1;
	public var DESTROY = 2;
}

@:enum abstract SWFShapeCommandType(Int) from Int to Int
{
	public var BEGIN_BITMAP_FILL = 0;
	public var BEGIN_FILL = 1;
	public var BEGIN_GRADIENT_FILL = 2;
	public var CLEAR_LINE_STYLE = 3;
	public var CURVE_TO = 4;
	public var END_FILL = 5;
	public var LINE_STYLE = 6;
	public var LINE_TO = 7;
	public var MOVE_TO = 8;
}

@:enum abstract SWFSymbolType(Int) from Int to Int
{
	public var BITMAP = 0;
	public var BUTTON = 1;
	public var DYNAMIC_TEXT = 2;
	public var FONT = 3;
	public var SHAPE = 4;
	public var SPRITE = 5;
	public var STATIC_TEXT = 6;
}
