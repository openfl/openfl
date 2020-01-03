package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.utils.Endian;

@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
@:access(openfl._internal.backend.lime_standalone.RGBA)
class ImageDataUtil
{
	public static function displaceMap(target:Image, source:Image, map:Image, mapPoint:Point, componentX:Vector3D, componentY:Vector3D, smooth:Bool):Void
	{
		var targetData:UInt8Array = target.buffer.data;
		var sourceData:UInt8Array = source.buffer.data;
		var mapData:UInt8Array = map.buffer.data;

		var targetFormat:PixelFormat = target.buffer.format;
		var sourceFormat:PixelFormat = source.buffer.format;
		var mapFormat:PixelFormat = map.buffer.format;

		var targetPremultiplied:Bool = target.premultiplied;
		var sourcePremultiplied:Bool = source.premultiplied;
		var mapPremultiplied:Bool = map.premultiplied;

		var sourceView:ImageDataView = new ImageDataView(source);
		var mapView:ImageDataView = new ImageDataView(map);

		var row:Int;

		var sourceOffset:Int;

		var sourcePixel:RGBA;
		var mapPixel:RGBA;
		var targetPixel:RGBA;

		var mapPixelX:Float;
		var mapPixelY:Float;
		var mapPixelA:Float;

		// for bilinear smoothing
		var s1:RGBA;
		var s2:RGBA;
		var s3:RGBA;
		var s4:RGBA;

		var mPointXFloor:Int;
		var mPointYFloor:Int;

		var disOffsetXFloor:Int;
		var disOffsetYFloor:Int;

		var disX:Float;
		var disY:Float;

		for (y in 0...sourceView.height)
		{
			row = sourceView.row(y);

			for (x in 0...sourceView.width)
			{
				sourceOffset = row + (x * 4);

				mPointXFloor = Std.int(mapPoint.x);
				mPointYFloor = Std.int(mapPoint.y);

				if (smooth)
				{
					s1.readUInt8(mapData, sourceView.row(y - mPointYFloor + 1) + (x - mPointXFloor) * 4, mapFormat, mapPremultiplied);
					s2.readUInt8(mapData, sourceView.row(y - mPointYFloor) + (x - mPointXFloor + 1) * 4, mapFormat, mapPremultiplied);
					s3.readUInt8(mapData, sourceView.row(y - mPointYFloor + 1) + (x - mPointXFloor + 1) * 4, mapFormat, mapPremultiplied);
					s4.readUInt8(mapData, sourceView.row(y - mPointYFloor) + (x - mPointXFloor) * 4, mapFormat, mapPremultiplied);

					mapPixel = bilinear(s1, s2, s3, s4, mapPoint.x - mPointXFloor, mapPoint.y - mPointYFloor);
				}
				else
				{
					mapPixel.readUInt8(mapData, mapView.row(y - mPointYFloor) + (x - mPointXFloor) * 4, mapFormat, mapPremultiplied);
				}

				mapPixelA = mapPixel.a / 255.0;
				mapPixelX = (((mapPixel.r - 128) / 255.0)) * mapPixelA;
				mapPixelY = (((mapPixel.g - 128) / 255.0)) * mapPixelA;

				disX = mapPixelX * componentX.x + mapPixelY * componentY.x;
				disY = mapPixelX * componentX.y + mapPixelY * componentY.y;

				disOffsetXFloor = Math.floor(disX * sourceView.width);
				disOffsetYFloor = Math.floor(disY * sourceView.height);

				if (smooth)
				{
					s1.readUInt8(sourceData, sourceView.row(y + disOffsetYFloor + 1) + (x + disOffsetXFloor) * 4, sourceFormat, sourcePremultiplied);
					s2.readUInt8(sourceData, sourceView.row(y + disOffsetYFloor) + (x + disOffsetXFloor + 1) * 4, sourceFormat, sourcePremultiplied);
					s3.readUInt8(sourceData, sourceView.row(y + disOffsetYFloor + 1) + (x + disOffsetXFloor + 1) * 4, sourceFormat, sourcePremultiplied);
					s4.readUInt8(sourceData, sourceView.row(y + disOffsetYFloor) + (x + disOffsetXFloor) * 4, sourceFormat, sourcePremultiplied);

					sourcePixel = bilinear(s1, s2, s3, s4, disX * sourceView.width - disOffsetXFloor, disY * sourceView.height - disOffsetYFloor);
				}
				else
				{
					sourcePixel.readUInt8(sourceData, sourceView.row(y + disOffsetYFloor) + (x + disOffsetXFloor) * 4, sourceFormat, sourcePremultiplied);
				}

				sourcePixel.writeUInt8(targetData, sourceOffset, targetFormat, targetPremultiplied);
			}
		}

		target.dirty = true;
		target.version++;
	}

	// s1 = (x, y+1)
	// s2 = (x + 1, y);
	// s3 = (x + 1, y + 1);
	// s4 = (x, y)
	private static function bilinear(s1:RGBA, s2:RGBA, s3:RGBA, s4:RGBA, su:Float, sv:Float):RGBA
	{
		return lerpRGBA(lerpRGBA(s4, s2, su), lerpRGBA(s1, s3, su), sv);
	}

	private static function lerpRGBA(v0:RGBA, v1:RGBA, x:Float):RGBA
	{
		var result:RGBA = new RGBA();
		result.r = Math.floor(lerp(v0.r, v1.r, x));
		result.g = Math.floor(lerp(v0.g, v1.g, x));
		result.b = Math.floor(lerp(v0.b, v1.b, x));
		result.a = Math.floor(lerp(v0.a, v1.a, x));

		return result;
	}

	private static function lerp4f(v0:Vector3D, v1:Vector3D, x:Float):Vector3D
	{
		return new Vector3D(lerp(v0.x, v1.x, x), lerp(v0.y, v1.y, x), lerp(v0.z, v1.z, x), lerp(v0.w, v1.w, x));
	}

	private static function lerp(v0:Float, v1:Float, x:Float):Float
	{
		return (1.0 - x) * v0 + x * v1;
	}

	public static function colorTransform(image:Image, rect:Rectangle, colorMatrix:ColorMatrix):Void
	{
		var data = image.buffer.data;
		if (data == null) return;

		{
			var format = image.buffer.format;
			var premultiplied = image.buffer.premultiplied;

			var dataView = new ImageDataView(image, rect);

			var alphaTable = colorMatrix.getAlphaTable();
			var redTable = colorMatrix.getRedTable();
			var greenTable = colorMatrix.getGreenTable();
			var blueTable = colorMatrix.getBlueTable();

			var row, offset, pixel:RGBA;

			for (y in 0...dataView.height)
			{
				row = dataView.row(y);

				for (x in 0...dataView.width)
				{
					offset = row + (x * 4);

					pixel.readUInt8(data, offset, format, premultiplied);
					pixel.set(redTable[pixel.r], greenTable[pixel.g], blueTable[pixel.b], alphaTable[pixel.a]);
					pixel.writeUInt8(data, offset, format, premultiplied);
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function copyChannel(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel,
			destChannel:BitmapDataChannel):Void
	{
		var destIdx = switch (destChannel)
		{
			case RED: 0;
			case GREEN: 1;
			case BLUE: 2;
			case ALPHA: 3;
		}

		var srcIdx = switch (sourceChannel)
		{
			case RED: 0;
			case GREEN: 1;
			case BLUE: 2;
			case ALPHA: 3;
		}

		var srcData = sourceImage.buffer.data;
		var destData = image.buffer.data;

		if (srcData == null || destData == null) return;

		{
			var srcView = new ImageDataView(sourceImage, sourceRect);
			var destView = new ImageDataView(image, new Rectangle(destPoint.x, destPoint.y, srcView.width, srcView.height));

			var srcFormat = sourceImage.buffer.format;
			var destFormat = image.buffer.format;
			var srcPremultiplied = sourceImage.buffer.premultiplied;
			var destPremultiplied = image.buffer.premultiplied;

			var srcPosition,
				destPosition,
				srcPixel:RGBA,
				destPixel:RGBA,
				value = 0;

			for (y in 0...destView.height)
			{
				srcPosition = srcView.row(y);
				destPosition = destView.row(y);

				for (x in 0...destView.width)
				{
					srcPixel.readUInt8(srcData, srcPosition, srcFormat, srcPremultiplied);
					destPixel.readUInt8(destData, destPosition, destFormat, destPremultiplied);

					switch (srcIdx)
					{
						case 0:
							value = srcPixel.r;
						case 1:
							value = srcPixel.g;
						case 2:
							value = srcPixel.b;
						case 3:
							value = srcPixel.a;
					}

					switch (destIdx)
					{
						case 0:
							destPixel.r = value;
						case 1:
							destPixel.g = value;
						case 2:
							destPixel.b = value;
						case 3:
							destPixel.a = value;
					}

					destPixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);

					srcPosition += 4;
					destPosition += 4;
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function copyPixels(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Point, alphaImage:Image = null,
			alphaPoint:Point = null, mergeAlpha:Bool = false):Void
	{
		if (image.width == sourceImage.width
			&& image.height == sourceImage.height
			&& sourceRect.width == sourceImage.width
			&& sourceRect.height == sourceImage.height
			&& sourceRect.x == 0
			&& sourceRect.y == 0
			&& destPoint.x == 0
			&& destPoint.y == 0
			&& alphaImage == null
			&& alphaPoint == null
			&& mergeAlpha == false
			&& image.format == sourceImage.format)
		{
			image.buffer.data.set(sourceImage.buffer.data);
		}
		else
		{
			{
				var sourceData = sourceImage.buffer.data;
				var destData = image.buffer.data;

				if (sourceData == null || destData == null) return;

				var sourceView = new ImageDataView(sourceImage, sourceRect);
				var destRect = new Rectangle(destPoint.x, destPoint.y, sourceView.width, sourceView.height);
				var destView = new ImageDataView(image, destRect);

				var sourceFormat = sourceImage.buffer.format;
				var destFormat = image.buffer.format;

				var sourcePosition, destPosition;
				var sourceAlpha, destAlpha, oneMinusSourceAlpha, blendAlpha;
				var sourcePixel:RGBA, destPixel:RGBA;

				var sourcePremultiplied = sourceImage.buffer.premultiplied;
				var destPremultiplied = image.buffer.premultiplied;
				var sourceBytesPerPixel = Std.int(sourceImage.buffer.bitsPerPixel / 8);
				var destBytesPerPixel = Std.int(image.buffer.bitsPerPixel / 8);

				var useAlphaImage = (alphaImage != null && alphaImage.transparent);
				var blend = (mergeAlpha || (useAlphaImage && !image.transparent))
					|| (!mergeAlpha && !image.transparent && sourceImage.transparent);

				if (!useAlphaImage)
				{
					if (blend)
					{
						for (y in 0...destView.height)
						{
							sourcePosition = sourceView.row(y);
							destPosition = destView.row(y);

							for (x in 0...destView.width)
							{
								sourcePixel.readUInt8(sourceData, sourcePosition, sourceFormat, sourcePremultiplied);
								destPixel.readUInt8(destData, destPosition, destFormat, destPremultiplied);

								sourceAlpha = sourcePixel.a / 255.0;
								destAlpha = destPixel.a / 255.0;
								oneMinusSourceAlpha = 1 - sourceAlpha;
								blendAlpha = sourceAlpha + (destAlpha * oneMinusSourceAlpha);

								if (blendAlpha == 0)
								{
									destPixel = 0;
								}
								else
								{
									destPixel.r = RGBA.__clamp[
										Math.round((sourcePixel.r * sourceAlpha + destPixel.r * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.g = RGBA.__clamp[
										Math.round((sourcePixel.g * sourceAlpha + destPixel.g * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.b = RGBA.__clamp[
										Math.round((sourcePixel.b * sourceAlpha + destPixel.b * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.a = RGBA.__clamp[Math.round(blendAlpha * 255.0)];
								}

								destPixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);

								sourcePosition += 4;
								destPosition += 4;
							}
						}
					}
					else if (sourceFormat == destFormat
						&& sourcePremultiplied == destPremultiplied
						&& sourceBytesPerPixel == destBytesPerPixel)
					{
						for (y in 0...destView.height)
						{
							sourcePosition = sourceView.row(y);
							destPosition = destView.row(y);

							#if js
							// TODO: Is this faster on HTML5 than the normal copy method?
							destData.set(sourceData.subarray(sourcePosition, sourcePosition + destView.width * destBytesPerPixel), destPosition);
							#else
							destData.buffer.blit(destPosition, sourceData.buffer, sourcePosition, destView.width * destBytesPerPixel);
							#end
						}
					}
					else
					{
						for (y in 0...destView.height)
						{
							sourcePosition = sourceView.row(y);
							destPosition = destView.row(y);

							for (x in 0...destView.width)
							{
								sourcePixel.readUInt8(sourceData, sourcePosition, sourceFormat, sourcePremultiplied);
								sourcePixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);

								sourcePosition += 4;
								destPosition += 4;
							}
						}
					}
				}
				else
				{
					var alphaData = alphaImage.buffer.data;
					var alphaFormat = alphaImage.buffer.format;
					var alphaPosition, alphaPixel:RGBA;

					var alphaView = new ImageDataView(alphaImage,
						new Rectangle(sourceView.x + (alphaPoint == null ? 0 : alphaPoint.x), sourceView.y + (alphaPoint == null ? 0 : alphaPoint.y),
							sourceView.width, sourceView.height));

					destView.clip(Std.int(destPoint.x), Std.int(destPoint.y), alphaView.width, alphaView.height);

					if (blend)
					{
						for (y in 0...destView.height)
						{
							sourcePosition = sourceView.row(y);
							destPosition = destView.row(y);
							alphaPosition = alphaView.row(y);

							for (x in 0...destView.width)
							{
								sourcePixel.readUInt8(sourceData, sourcePosition, sourceFormat, sourcePremultiplied);
								destPixel.readUInt8(destData, destPosition, destFormat, destPremultiplied);
								alphaPixel.readUInt8(alphaData, alphaPosition, alphaFormat, false);

								sourceAlpha = (alphaPixel.a / 255.0) * (sourcePixel.a / 255.0);

								if (sourceAlpha > 0)
								{
									destAlpha = destPixel.a / 255.0;
									oneMinusSourceAlpha = 1 - sourceAlpha;
									blendAlpha = sourceAlpha + (destAlpha * oneMinusSourceAlpha);

									destPixel.r = RGBA.__clamp[
										Math.round((sourcePixel.r * sourceAlpha + destPixel.r * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.g = RGBA.__clamp[
										Math.round((sourcePixel.g * sourceAlpha + destPixel.g * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.b = RGBA.__clamp[
										Math.round((sourcePixel.b * sourceAlpha + destPixel.b * destAlpha * oneMinusSourceAlpha) / blendAlpha)
									];
									destPixel.a = RGBA.__clamp[Math.round(blendAlpha * 255.0)];

									destPixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);
								}

								sourcePosition += 4;
								destPosition += 4;
								alphaPosition += 4;
							}
						}
					}
					else
					{
						for (y in 0...destView.height)
						{
							sourcePosition = sourceView.row(y);
							destPosition = destView.row(y);
							alphaPosition = alphaView.row(y);

							for (x in 0...destView.width)
							{
								sourcePixel.readUInt8(sourceData, sourcePosition, sourceFormat, sourcePremultiplied);
								alphaPixel.readUInt8(alphaData, alphaPosition, alphaFormat, false);

								sourcePixel.a = Math.round(sourcePixel.a * (alphaPixel.a / 0xFF));
								sourcePixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);

								sourcePosition += 4;
								destPosition += 4;
								alphaPosition += 4;
							}
						}
					}
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function fillRect(image:Image, rect:Rectangle, color:Int, format:PixelFormat):Void
	{
		var fillColor:RGBA;

		switch (format)
		{
			case ARGB32:
				fillColor = (color : ARGB);
			case BGRA32:
				fillColor = (color : BGRA);
			default:
				fillColor = color;
		}

		if (!image.transparent)
		{
			fillColor.a = 0xFF;
		}

		var data = image.buffer.data;
		if (data == null) return;

		{
			var format = image.buffer.format;
			var premultiplied = image.buffer.premultiplied;
			if (premultiplied) fillColor.multiplyAlpha();

			var dataView = new ImageDataView(image, rect);
			var row;

			for (y in 0...dataView.height)
			{
				row = dataView.row(y);

				for (x in 0...dataView.width)
				{
					fillColor.writeUInt8(data, row + (x * 4), format, false);
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function floodFill(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		var data = image.buffer.data;
		if (data == null) return;

		if (format == ARGB32) color = ((color & 0xFFFFFF) << 8) | ((color >> 24) & 0xFF);

		{
			var format = image.buffer.format;
			var premultiplied = image.buffer.premultiplied;

			var fillColor:RGBA = color;

			var hitColor:RGBA;
			hitColor.readUInt8(data, ((y + image.offsetY) * (image.buffer.width * 4)) + ((x + image.offsetX) * 4), format, premultiplied);

			if (!image.transparent)
			{
				fillColor.a = 0xFF;
				hitColor.a = 0xFF;
			}

			if (fillColor == hitColor) return;

			if (premultiplied) fillColor.multiplyAlpha();

			var dx = [0, -1, 1, 0];
			var dy = [-1, 0, 0, 1];

			var minX = -image.offsetX;
			var minY = -image.offsetY;
			var maxX = minX + image.width;
			var maxY = minY + image.height;

			var queue = new Array<Int>();
			queue.push(x);
			queue.push(y);

			var curPointX,
				curPointY,
				nextPointX,
				nextPointY,
				nextPointOffset,
				readColor:RGBA;

			while (queue.length > 0)
			{
				curPointY = queue.pop();
				curPointX = queue.pop();

				for (i in 0...4)
				{
					nextPointX = curPointX + dx[i];
					nextPointY = curPointY + dy[i];

					if (nextPointX < minX || nextPointY < minY || nextPointX >= maxX || nextPointY >= maxY)
					{
						continue;
					}

					nextPointOffset = (nextPointY * image.width + nextPointX) * 4;
					readColor.readUInt8(data, nextPointOffset, format, premultiplied);

					if (readColor == hitColor)
					{
						fillColor.writeUInt8(data, nextPointOffset, format, false);

						queue.push(nextPointX);
						queue.push(nextPointY);
					}
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function gaussianBlur(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Point, blurX:Float = 4, blurY:Float = 4,
			quality:Int = 1, strength:Float = 1, color:Null<Int> = null):Image
	{
		// TODO: Support sourceRect better, do not modify sourceImage, create C++ implementation for native

		// TODO: Faster approach
		var imagePremultiplied = image.premultiplied;
		if (imagePremultiplied) image.premultiplied = false;

		// TODO: Use ImageDataView

		// if (image.buffer.premultiplied || sourceImage.buffer.premultiplied) {
		// 	// TODO: Better handling of premultiplied alpha
		// 	throw "Pre-multiplied bitmaps are not supported";

		// }

		StackBlur.blur(image, sourceImage, sourceRect, destPoint, blurX, blurY, quality);

		image.dirty = true;
		image.version++;

		if (imagePremultiplied) image.premultiplied = true;

		return image;
	}

	public static function getColorBoundsRect(image:Image, mask:Int, color:Int, findColor:Bool, format:PixelFormat):Rectangle
	{
		var left = image.width + 1;
		var right = 0;
		var top = image.height + 1;
		var bottom = 0;

		var _color:RGBA, _mask:RGBA;

		switch (format)
		{
			case ARGB32:
				_color = (color : ARGB);
				_mask = (mask : ARGB);

			case BGRA32:
				_color = (color : BGRA);
				_mask = (mask : BGRA);

			default:
				_color = color;
				_mask = mask;
		}

		if (!image.transparent)
		{
			_color.a = 0xFF;
			_mask.a = 0xFF;
		}

		var pixel, hit;

		for (x in 0...image.width)
		{
			hit = false;

			for (y in 0...image.height)
			{
				pixel = image.getPixel32(x, y, RGBA32);
				hit = findColor ? (pixel & _mask) == _color : (pixel & _mask) != _color;

				if (hit)
				{
					if (x < left) left = x;
					break;
				}
			}

			if (hit)
			{
				break;
			}
		}

		var ix;

		for (x in 0...image.width)
		{
			ix = (image.width - 1) - x;
			hit = false;

			for (y in 0...image.height)
			{
				pixel = image.getPixel32(ix, y, RGBA32);
				hit = findColor ? (pixel & _mask) == _color : (pixel & _mask) != _color;

				if (hit)
				{
					if (ix > right) right = ix;
					break;
				}
			}

			if (hit)
			{
				break;
			}
		}

		for (y in 0...image.height)
		{
			hit = false;

			for (x in 0...image.width)
			{
				pixel = image.getPixel32(x, y, RGBA32);
				hit = findColor ? (pixel & _mask) == _color : (pixel & _mask) != _color;

				if (hit)
				{
					if (y < top) top = y;
					break;
				}
			}

			if (hit)
			{
				break;
			}
		}

		var iy;

		for (y in 0...image.height)
		{
			iy = (image.height - 1) - y;
			hit = false;

			for (x in 0...image.width)
			{
				pixel = image.getPixel32(x, iy, RGBA32);
				hit = findColor ? (pixel & _mask) == _color : (pixel & _mask) != _color;

				if (hit)
				{
					if (iy > bottom) bottom = iy;
					break;
				}
			}

			if (hit)
			{
				break;
			}
		}

		var w = right - left;
		var h = bottom - top;

		if (w > 0) w++;
		if (h > 0) h++;

		if (w < 0) w = 0;
		if (h < 0) h = 0;

		if (left == right) w = 1;
		if (top == bottom) h = 1;

		if (left > image.width) left = 0;
		if (top > image.height) top = 0;

		return new Rectangle(left, top, w, h);
	}

	public static function getPixel(image:Image, x:Int, y:Int, format:PixelFormat):Int
	{
		var pixel:RGBA;

		pixel.readUInt8(image.buffer.data, (4 * (y + image.offsetY) * image.buffer.width + (x + image.offsetX) * 4), image.buffer.format,
			image.buffer.premultiplied);
		pixel.a = 0;

		switch (format)
		{
			case ARGB32:
				return (pixel : ARGB);
			case BGRA32:
				return (pixel : BGRA);
			default:
				return pixel;
		}
	}

	public static function getPixel32(image:Image, x:Int, y:Int, format:PixelFormat):Int
	{
		var pixel:RGBA;

		pixel.readUInt8(image.buffer.data, (4 * (y + image.offsetY) * image.buffer.width + (x + image.offsetX) * 4), image.buffer.format,
			image.buffer.premultiplied);

		switch (format)
		{
			case ARGB32:
				return (pixel : ARGB);
			case BGRA32:
				return (pixel : BGRA);
			default:
				return pixel;
		}
	}

	public static function getPixels(image:Image, rect:Rectangle, format:PixelFormat):Bytes
	{
		if (image.buffer.data == null) return null;

		var length = Std.int(rect.width * rect.height);
		var bytes = Bytes.alloc(length * 4);

		{
			var data = image.buffer.data;
			var sourceFormat = image.buffer.format;
			var premultiplied = image.buffer.premultiplied;

			var dataView = new ImageDataView(image, rect);
			var position, argb:ARGB, bgra:BGRA, pixel:RGBA;
			var destPosition = 0;

			for (y in 0...dataView.height)
			{
				position = dataView.row(y);

				for (x in 0...dataView.width)
				{
					pixel.readUInt8(data, position, sourceFormat, premultiplied);

					switch (format)
					{
						case ARGB32:
							argb = pixel;
							pixel = cast argb;
						case BGRA32:
							bgra = pixel;
							pixel = cast bgra;
						default:
					}

					bytes.set(destPosition++, pixel.r);
					bytes.set(destPosition++, pixel.g);
					bytes.set(destPosition++, pixel.b);
					bytes.set(destPosition++, pixel.a);

					position += 4;
				}
			}
		}

		return bytes;
	}

	public static function merge(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Point, redMultiplier:Int, greenMultiplier:Int,
			blueMultiplier:Int, alphaMultiplier:Int):Void
	{
		if (image.buffer.data == null || sourceImage.buffer.data == null) return;

		{
			var sourceView = new ImageDataView(sourceImage, sourceRect);
			var destView = new ImageDataView(image, new Rectangle(destPoint.x, destPoint.y, sourceView.width, sourceView.height));

			var sourceData = sourceImage.buffer.data;
			var destData = image.buffer.data;
			var sourceFormat = sourceImage.buffer.format;
			var destFormat = image.buffer.format;
			var sourcePremultiplied = sourceImage.buffer.premultiplied;
			var destPremultiplied = image.buffer.premultiplied;

			var sourcePosition, destPosition, sourcePixel:RGBA, destPixel:RGBA;

			for (y in 0...destView.height)
			{
				sourcePosition = sourceView.row(y);
				destPosition = destView.row(y);

				for (x in 0...destView.width)
				{
					sourcePixel.readUInt8(sourceData, sourcePosition, sourceFormat, sourcePremultiplied);
					destPixel.readUInt8(destData, destPosition, destFormat, destPremultiplied);

					destPixel.r = Std.int(((sourcePixel.r * redMultiplier) + (destPixel.r * (256 - redMultiplier))) / 256);
					destPixel.g = Std.int(((sourcePixel.g * greenMultiplier) + (destPixel.g * (256 - greenMultiplier))) / 256);
					destPixel.b = Std.int(((sourcePixel.b * blueMultiplier) + (destPixel.b * (256 - blueMultiplier))) / 256);
					destPixel.a = Std.int(((sourcePixel.a * alphaMultiplier) + (destPixel.a * (256 - alphaMultiplier))) / 256);

					destPixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);

					sourcePosition += 4;
					destPosition += 4;
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function multiplyAlpha(image:Image):Void
	{
		var data = image.buffer.data;
		if (data == null || !image.buffer.transparent) return;

		{
			var format = image.buffer.format;
			var length = Std.int(data.length / 4);
			var pixel:RGBA;

			for (i in 0...length)
			{
				pixel.readUInt8(data, i * 4, format, false);
				pixel.writeUInt8(data, i * 4, format, true);
			}
		}

		image.buffer.premultiplied = true;
		image.dirty = true;
		image.version++;
	}

	public static function resize(image:Image, newWidth:Int, newHeight:Int):Void
	{
		var buffer = image.buffer;
		if (buffer.width == newWidth && buffer.height == newHeight) return;
		var newBuffer = new ImageBuffer(new UInt8Array(newWidth * newHeight * 4), newWidth, newHeight);

		{
			var imageWidth = image.width;
			var imageHeight = image.height;

			var data = image.data;
			var newData = newBuffer.data;
			var sourceIndex:Int,
				sourceIndexX:Int,
				sourceIndexY:Int,
				sourceIndexXY:Int,
				index:Int;
			var sourceX:Int, sourceY:Int;
			var u:Float,
				v:Float,
				uRatio:Float,
				vRatio:Float,
				uOpposite:Float,
				vOpposite:Float;

			for (y in 0...newHeight)
			{
				for (x in 0...newWidth)
				{
					// TODO: Handle more color formats

					u = ((x + 0.5) / newWidth) * imageWidth - 0.5;
					v = ((y + 0.5) / newHeight) * imageHeight - 0.5;

					sourceX = Std.int(u);
					sourceY = Std.int(v);

					sourceIndex = (sourceY * imageWidth + sourceX) * 4;
					sourceIndexX = (sourceX < imageWidth - 1) ? sourceIndex + 4 : sourceIndex;
					sourceIndexY = (sourceY < imageHeight - 1) ? sourceIndex + (imageWidth * 4) : sourceIndex;
					sourceIndexXY = (sourceIndexX != sourceIndex) ? sourceIndexY + 4 : sourceIndexY;

					index = (y * newWidth + x) * 4;

					uRatio = u - sourceX;
					vRatio = v - sourceY;
					uOpposite = 1 - uRatio;
					vOpposite = 1 - vRatio;

					newData[index] = Std.int((data[sourceIndex] * uOpposite + data[sourceIndexX] * uRatio) * vOpposite
						+ (data[sourceIndexY] * uOpposite + data[sourceIndexXY] * uRatio) * vRatio);
					newData[index + 1] = Std.int((data[sourceIndex + 1] * uOpposite + data[sourceIndexX + 1] * uRatio) * vOpposite
						+ (data[sourceIndexY + 1] * uOpposite + data[sourceIndexXY + 1] * uRatio) * vRatio);
					newData[index + 2] = Std.int((data[sourceIndex + 2] * uOpposite + data[sourceIndexX + 2] * uRatio) * vOpposite
						+ (data[sourceIndexY + 2] * uOpposite + data[sourceIndexXY + 2] * uRatio) * vRatio);

					// Maybe it would be better to not weigh colors with an alpha of zero, but the below should help prevent black fringes caused by transparent pixels made visible

					if (data[sourceIndexX + 3] == 0 || data[sourceIndexY + 3] == 0 || data[sourceIndexXY + 3] == 0)
					{
						newData[index + 3] = 0;
					}
					else
					{
						newData[index + 3] = data[sourceIndex + 3];
					}
				}
			}
		}

		buffer.data = newBuffer.data;
		buffer.width = newWidth;
		buffer.height = newHeight;

		buffer.__srcImage = null;
		buffer.__srcImageData = null;
		buffer.__srcCanvas = null;
		buffer.__srcContext = null;

		image.dirty = true;
		image.version++;
	}

	public static function resizeBuffer(image:Image, newWidth:Int, newHeight:Int):Void
	{
		var buffer = image.buffer;
		var data = image.data;
		var newData = new UInt8Array(newWidth * newHeight * 4);
		var sourceIndex:Int, index:Int;

		for (y in 0...buffer.height)
		{
			for (x in 0...buffer.width)
			{
				sourceIndex = (y * buffer.width + x) * 4;
				index = (y * newWidth + x) * 4;

				newData[index] = data[sourceIndex];
				newData[index + 1] = data[sourceIndex + 1];
				newData[index + 2] = data[sourceIndex + 2];
				newData[index + 3] = data[sourceIndex + 3];
			}
		}

		buffer.data = newData;
		buffer.width = newWidth;
		buffer.height = newHeight;

		buffer.__srcImage = null;
		buffer.__srcImageData = null;
		buffer.__srcCanvas = null;
		buffer.__srcContext = null;

		image.dirty = true;
		image.version++;
	}

	public static function setFormat(image:Image, format:PixelFormat):Void
	{
		var data = image.buffer.data;
		if (data == null) return;

		{
			var index, a16;
			var length = Std.int(data.length / 4);
			var r1, g1, b1, a1, r2, g2, b2, a2;
			var r, g, b, a;

			switch (image.format)
			{
				case RGBA32:
					r1 = 0;
					g1 = 1;
					b1 = 2;
					a1 = 3;

				case ARGB32:
					r1 = 1;
					g1 = 2;
					b1 = 3;
					a1 = 0;

				case BGRA32:
					r1 = 2;
					g1 = 1;
					b1 = 0;
					a1 = 3;
			}

			switch (format)
			{
				case RGBA32:
					r2 = 0;
					g2 = 1;
					b2 = 2;
					a2 = 3;

				case ARGB32:
					r2 = 1;
					g2 = 2;
					b2 = 3;
					a2 = 0;

				case BGRA32:
					r2 = 2;
					g2 = 1;
					b2 = 0;
					a2 = 3;
			}

			for (i in 0...length)
			{
				index = i * 4;

				r = data[index + r1];
				g = data[index + g1];
				b = data[index + b1];
				a = data[index + a1];

				data[index + r2] = r;
				data[index + g2] = g;
				data[index + b2] = b;
				data[index + a2] = a;
			}
		}

		image.buffer.format = format;
		image.dirty = true;
		image.version++;
	}

	public static function setPixel(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		var pixel:RGBA;

		switch (format)
		{
			case ARGB32:
				pixel = (color : ARGB);
			case BGRA32:
				pixel = (color : BGRA);
			default:
				pixel = color;
		}

		// TODO: Write only RGB instead?

		var source = new RGBA();
		source.readUInt8(image.buffer.data, (4 * (y + image.offsetY) * image.buffer.width + (x + image.offsetX) * 4), image.buffer.format,
			image.buffer.premultiplied);

		pixel.a = source.a;
		pixel.writeUInt8(image.buffer.data, (4 * (y + image.offsetY) * image.buffer.width + (x + image.offsetX) * 4), image.buffer.format,
			image.buffer.premultiplied);

		image.dirty = true;
		image.version++;
	}

	public static function setPixel32(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		var pixel:RGBA;

		switch (format)
		{
			case ARGB32:
				pixel = (color : ARGB);
			case BGRA32:
				pixel = (color : BGRA);
			default:
				pixel = color;
		}

		if (!image.transparent) pixel.a = 0xFF;
		pixel.writeUInt8(image.buffer.data, (4 * (y + image.offsetY) * image.buffer.width + (x + image.offsetX) * 4), image.buffer.format,
			image.buffer.premultiplied);

		image.dirty = true;
		image.version++;
	}

	public static function setPixels(image:Image, rect:Rectangle, bytePointer:BytePointer, format:PixelFormat, endian:Endian):Void
	{
		if (image.buffer.data == null) return;

		{
			var data = image.buffer.data;
			var sourceFormat = image.buffer.format;
			var premultiplied = image.buffer.premultiplied;
			var dataView = new ImageDataView(image, rect);
			var row, color, pixel:RGBA;
			var transparent = image.transparent;
			var bytes = bytePointer.bytes;
			var dataPosition = bytePointer.offset;
			var littleEndian = (endian != BIG_ENDIAN);

			for (y in 0...dataView.height)
			{
				row = dataView.row(y);

				for (x in 0...dataView.width)
				{
					if (littleEndian)
					{
						color = bytes.getInt32(dataPosition); // can this be trusted on big endian systems?
					}
					else
					{
						color = bytes.get(dataPosition + 3) | (bytes.get(dataPosition + 2) << 8) | (bytes.get(dataPosition +
							1) << 16) | (bytes.get(dataPosition) << 24);
					}

					dataPosition += 4;

					switch (format)
					{
						case ARGB32:
							pixel = (color : ARGB);
						case BGRA32:
							pixel = (color : BGRA);
						default:
							pixel = color;
					}

					if (!transparent) pixel.a = 0xFF;
					pixel.writeUInt8(data, row + (x * 4), sourceFormat, premultiplied);
				}
			}
		}

		image.dirty = true;
		image.version++;
	}

	public static function threshold(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int,
			mask:Int, copySource:Bool, format:PixelFormat):Int
	{
		var _color:RGBA, _mask:RGBA, _threshold:RGBA;

		switch (format)
		{
			case ARGB32:
				_color = (color : ARGB);
				_mask = (mask : ARGB);
				_threshold = (threshold : ARGB);

			case BGRA32:
				_color = (color : BGRA);
				_mask = (mask : BGRA);
				_threshold = (threshold : BGRA);

			default:
				_color = color;
				_mask = mask;
				_threshold = threshold;
		}

		var _operation = switch (operation)
		{
			case "!=": NOT_EQUALS;
			case "==": EQUALS;
			case "<": LESS_THAN;
			case "<=": LESS_THAN_OR_EQUAL_TO;
			case ">": GREATER_THAN;
			case ">=": GREATER_THAN_OR_EQUAL_TO;
			default: -1;
		}

		if (_operation == -1) return 0;

		var srcData = sourceImage.buffer.data;
		var destData = image.buffer.data;

		if (srcData == null || destData == null) return 0;

		var hits = 0;

		{
			var srcView = new ImageDataView(sourceImage, sourceRect);
			var destView = new ImageDataView(image, new Rectangle(destPoint.x, destPoint.y, srcView.width, srcView.height));

			var srcFormat = sourceImage.buffer.format;
			var destFormat = image.buffer.format;
			var srcPremultiplied = sourceImage.buffer.premultiplied;
			var destPremultiplied = image.buffer.premultiplied;

			var srcPosition,
				destPosition,
				srcPixel:RGBA,
				destPixel:RGBA,
				pixelMask:UInt,
				test:Bool,
				value:Int;

			for (y in 0...destView.height)
			{
				srcPosition = srcView.row(y);
				destPosition = destView.row(y);

				for (x in 0...destView.width)
				{
					srcPixel.readUInt8(srcData, srcPosition, srcFormat, srcPremultiplied);

					pixelMask = srcPixel & _mask;

					value = __pixelCompare(pixelMask, _threshold);

					test = switch (_operation)
					{
						case NOT_EQUALS: (value != 0);
						case EQUALS: (value == 0);
						case LESS_THAN: (value == -1);
						case LESS_THAN_OR_EQUAL_TO: (value == 0 || value == -1);
						case GREATER_THAN: (value == 1);
						case GREATER_THAN_OR_EQUAL_TO: (value == 0 || value == 1);
						default: false;
					}

					if (test)
					{
						_color.writeUInt8(destData, destPosition, destFormat, destPremultiplied);
						hits++;
					}
					else if (copySource)
					{
						srcPixel.writeUInt8(destData, destPosition, destFormat, destPremultiplied);
					}

					srcPosition += 4;
					destPosition += 4;
				}
			}
		}

		if (hits > 0)
		{
			image.dirty = true;
			image.version++;
		}

		return hits;
	}

	public static function unmultiplyAlpha(image:Image):Void
	{
		var data = image.buffer.data;
		if (data == null) return;

		{
			var format = image.buffer.format;
			var length = Std.int(data.length / 4);
			var pixel:RGBA;

			for (i in 0...length)
			{
				pixel.readUInt8(data, i * 4, format, true);
				pixel.writeUInt8(data, i * 4, format, false);
			}
		}

		image.buffer.premultiplied = false;
		image.dirty = true;
		image.version++;
	}

	private static function __boxBlur(imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, bx:Float, by:Float):Void
	{
		// for(i in 0...imgA.length)
		// 	imgB[i] = imgA[i];
		imgB.set(imgA);

		var bx = Std.int(bx);
		var by = Std.int(by);

		__boxBlurH(imgB, imgA, w, h, bx, 0);
		__boxBlurH(imgB, imgA, w, h, bx, 1);
		__boxBlurH(imgB, imgA, w, h, bx, 2);
		__boxBlurH(imgB, imgA, w, h, bx, 3);

		__boxBlurT(imgA, imgB, w, h, by, 0);
		__boxBlurT(imgA, imgB, w, h, by, 1);
		__boxBlurT(imgA, imgB, w, h, by, 2);
		__boxBlurT(imgA, imgB, w, h, by, 3);
	}

	private static #if cpp inline #end function __boxBlurH(imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, r:Int, off:Int):Void
	{
		var iarr = 1 / (r + r + 1);
		var ti, li, ri, fv, lv, val;

		for (i in 0...h)
		{
			ti = i * w;
			li = ti;
			ri = ti + r;

			fv = imgA[ti * 4 + off];
			lv = imgA[(ti + w - 1) * 4 + off];
			val = (r + 1) * fv;

			for (j in 0...r)
			{
				val += imgA[(ti + j) * 4 + off];
			}

			for (j in 0...(r + 1))
			{
				val += imgA[ri * 4 + off] - fv;
				imgB[ti * 4 + off] = Math.round(val * iarr);
				ri++;
				ti++;
			}

			for (j in (r + 1)...(w - r))
			{
				val += imgA[ri * 4 + off] - imgA[li * 4 + off];
				imgB[ti * 4 + off] = Math.round(val * iarr);
				ri++;
				li++;
				ti++;
			}

			for (j in (w - r)...w)
			{
				val += lv - imgA[li * 4 + off];
				imgB[ti * 4 + off] = Math.round(val * iarr);
				li++;
				ti++;
			}
		}
	}

	private static inline function __boxBlurT(imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, r:Int, off:Int):Void
	{
		var iarr = 1 / (r + r + 1);
		var ws = w * 4;
		var ti, li, ri, fv, lv, val;

		for (i in 0...w)
		{
			ti = i * 4 + off;
			li = ti;
			ri = ti + (r * ws);

			fv = imgA[ti];
			lv = imgA[ti + (ws * (h - 1))];
			val = (r + 1) * fv;

			for (j in 0...r)
			{
				val += imgA[ti + (j * ws)];
			}

			for (j in 0...(r + 1))
			{
				val += imgA[ri] - fv;
				imgB[ti] = Math.round(val * iarr);
				ri += ws;
				ti += ws;
			}

			for (j in (r + 1)...(h - r))
			{
				val += imgA[ri] - imgA[li];
				imgB[ti] = Math.round(val * iarr);
				li += ws;
				ri += ws;
				ti += ws;
			}

			for (j in (h - r)...h)
			{
				val += lv - imgA[li];
				imgB[ti] = Math.round(val * iarr);
				li += ws;
				ti += ws;
			}
		}
	}

	/**
	 * Returns: the offset for translated coordinate in the source image or -1 if the source the coordinate out of the source or destination bounds
	 * Note: destX and destY should be valid coordinates
	**/
	private static #if cpp inline #end function __calculateSourceOffset(sourceRect:Rectangle, destPoint:Point, destX:Int, destY:Int):Int
	{
		var sourceX:Int = destX - Std.int(destPoint.x);
		var sourceY:Int = destY - Std.int(destPoint.y);

		var offset = 0;

		if (sourceX < 0 || sourceY < 0 || sourceX >= sourceRect.width || sourceY >= sourceRect.height)
		{
			offset = -1;
		}
		else
		{
			offset = 4 * (sourceY * Std.int(sourceRect.width) + sourceX);
		}

		return offset;
	}

	private static function __getBoxesForGaussianBlur(sigma:Float, n:Int):Array<Float>
	{
		var wIdeal = Math.sqrt((12 * sigma * sigma / n) + 1); // Ideal averaging filter width
		var wl = Math.floor(wIdeal);
		if (wl % 2 == 0) wl--;
		var wu = wl + 2;

		var mIdeal = ((12 * sigma * sigma) - (n * wl * wl) - (4 * n * wl) - (3 * n)) / ((-4 * wl) - 4);
		var m = Math.round(mIdeal);
		var sizes:Array<Float> = [];

		for (i in 0...n)
		{
			sizes.push(i < m ? wl : wu);
		}

		return sizes;
	}

	private static inline function __pixelCompare(n1:UInt, n2:UInt):Int
	{
		var tmp1:UInt;
		var tmp2:UInt;

		tmp1 = (n1 >> 24) & 0xFF;
		tmp2 = (n2 >> 24) & 0xFF;

		if (tmp1 != tmp2)
		{
			return (tmp1 > tmp2 ? 1 : -1);
		}
		else
		{
			tmp1 = (n1 >> 16) & 0xFF;
			tmp2 = (n2 >> 16) & 0xFF;

			if (tmp1 != tmp2)
			{
				return (tmp1 > tmp2 ? 1 : -1);
			}
			else
			{
				tmp1 = (n1 >> 8) & 0xFF;
				tmp2 = (n2 >> 8) & 0xFF;

				if (tmp1 != tmp2)
				{
					return (tmp1 > tmp2 ? 1 : -1);
				}
				else
				{
					tmp1 = n1 & 0xFF;
					tmp2 = n2 & 0xFF;

					if (tmp1 != tmp2)
					{
						return (tmp1 > tmp2 ? 1 : -1);
					}
					else
					{
						return 0;
					}
				}
			}
		}
	}

	private static #if cpp inline #end function __translatePixel(imgB:UInt8Array, sourceRect:Rectangle, destRect:Rectangle, destPoint:Point, destX:Int,
			destY:Int, strength:Float):Void
	{
		var d = 4 * (destY * Std.int(destRect.width) + destX);
		var s = __calculateSourceOffset(sourceRect, destPoint, destX, destY);

		if (s < 0)
		{
			imgB[d] = imgB[d + 1] = imgB[d + 2] = imgB[d + 3] = 0;
		}
		else
		{
			imgB[d] = imgB[s];
			imgB[d + 1] = imgB[s + 1];
			imgB[d + 2] = imgB[s + 2];

			var a = Std.int(imgB[s + 3] * strength);
			imgB[d + 3] = a < 0 ? 0 : (a > 255 ? 255 : a);
		}
	}
}

private class ImageDataView
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var height(default, null):Int;
	public var width(default, null):Int;

	private var byteOffset:Int;
	private var image:Image;
	private var rect:Rectangle;
	private var stride:Int;
	private var tempRect:Rectangle;

	public function new(image:Image, rect:Rectangle = null)
	{
		this.image = image;

		if (rect == null)
		{
			this.rect = image.rect;
		}
		else
		{
			if (rect.x < 0) rect.x = 0;
			if (rect.y < 0) rect.y = 0;
			if (rect.x + rect.width > image.width) rect.width = image.width - rect.x;
			if (rect.y + rect.height > image.height) rect.height = image.height - rect.y;
			if (rect.width < 0) rect.width = 0;
			if (rect.height < 0) rect.height = 0;
			this.rect = rect;
		}

		stride = image.buffer.stride;

		__update();
	}

	public function clip(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (tempRect == null) tempRect = new Rectangle();
		tempRect.setTo(x, y, width, height);

		// rect.intersection(tempRect, rect);
		var x0 = rect.x < tempRect.x ? tempRect.x : rect.x;
		var x1 = rect.right > tempRect.right ? tempRect.right : rect.right;

		if (x1 <= x0)
		{
			rect.setEmpty();
		}
		else
		{
			var y0 = rect.y < tempRect.y ? tempRect.y : rect.y;
			var y1 = rect.bottom > tempRect.bottom ? tempRect.bottom : rect.bottom;

			if (y1 <= y0)
			{
				rect.setEmpty();
			}
			else
			{
				rect.x = x0;
				rect.y = y0;
				rect.width = x1 - x0;
				rect.height = y1 - y0;
			}
		}

		__update();
	}

	public inline function hasRow(y:Int):Bool
	{
		return (y >= 0 && y < height);
	}

	public function offset(x:Int, y:Int):Void
	{
		if (x < 0)
		{
			rect.x += x;
			if (rect.x < 0) rect.x = 0;
		}
		else
		{
			rect.x += x;
			rect.width -= x;
		}

		if (y < 0)
		{
			rect.y += y;
			if (rect.y < 0) rect.y = 0;
		}
		else
		{
			rect.y += y;
			rect.height -= y;
		}

		__update();
	}

	public inline function row(y:Int):Int
	{
		return byteOffset + stride * y;
	}

	private function __update():Void
	{
		this.x = Math.ceil(rect.x);
		this.y = Math.ceil(rect.y);
		this.width = Math.floor(rect.width);
		this.height = Math.floor(rect.height);
		byteOffset = (stride * (this.y + image.offsetY)) + ((this.x + image.offsetX) * 4);
	}
}

@:noCompletion @:dox(hide) @:enum private abstract ThresholdOperation(Int) from Int to Int
{
	var NOT_EQUALS = 0;
	var EQUALS = 1;
	var LESS_THAN = 2;
	var LESS_THAN_OR_EQUAL_TO = 3;
	var GREATER_THAN = 4;
	var GREATER_THAN_OR_EQUAL_TO = 5;
}
#end
