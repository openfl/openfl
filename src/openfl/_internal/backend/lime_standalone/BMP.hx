package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import openfl.geom.Rectangle;

class BMP
{
	public static function encode(image:Image, type:BMPType = null):Bytes
	{
		if (image.premultiplied || image.format != RGBA32)
		{
			// TODO: Handle encode from different formats

			image = image.clone();
			image.premultiplied = false;
			image.format = RGBA32;
		}

		if (type == null)
		{
			type = RGB;
		}

		var fileHeaderLength = 14;
		var infoHeaderLength = 40;
		var pixelValuesLength = (image.width * image.height * 4);

		switch (type)
		{
			case BITFIELD:
				infoHeaderLength = 108;

			case ICO:
				fileHeaderLength = 0;
				pixelValuesLength += image.width * image.height;

			case RGB:
				pixelValuesLength = ((image.width * 3) + ((image.width * 3) % 4)) * image.height;

			default:
		}

		var data = Bytes.alloc(fileHeaderLength + infoHeaderLength + pixelValuesLength);
		var position = 0;

		if (fileHeaderLength > 0)
		{
			data.set(position++, 0x42);
			data.set(position++, 0x4D);
			data.setInt32(position, data.length);
			position += 4;
			data.setUInt16(position, 0);
			position += 2;
			data.setUInt16(position, 0);
			position += 2;
			data.setInt32(position, fileHeaderLength + infoHeaderLength);
			position += 4;
		}

		data.setInt32(position, infoHeaderLength);
		position += 4;
		data.setInt32(position, image.width);
		position += 4;
		data.setInt32(position, type == ICO ? image.height * 2 : image.height);
		position += 4;
		data.setUInt16(position, 1);
		position += 2;
		data.setUInt16(position, type == RGB ? 24 : 32);
		position += 2;
		data.setInt32(position, type == BITFIELD ? 3 : 0);
		position += 4;
		data.setInt32(position, pixelValuesLength);
		position += 4;
		data.setInt32(position, 0x2e30);
		position += 4;
		data.setInt32(position, 0x2e30);
		position += 4;
		data.setInt32(position, 0);
		position += 4;
		data.setInt32(position, 0);
		position += 4;

		if (type == BITFIELD)
		{
			data.setInt32(position, 0x00FF0000);
			position += 4;
			data.setInt32(position, 0x0000FF00);
			position += 4;
			data.setInt32(position, 0x000000FF);
			position += 4;
			data.setInt32(position, 0xFF000000);
			position += 4;

			data.set(position++, 0x20);
			data.set(position++, 0x6E);
			data.set(position++, 0x69);
			data.set(position++, 0x57);

			for (i in 0...48)
			{
				data.set(position++, 0);
			}
		}

		var pixels = image.getPixels(new Rectangle(0, 0, image.width, image.height), ARGB32);
		var readPosition = 0;
		var a, r, g, b;

		switch (type)
		{
			case BITFIELD:
				for (y in 0...image.height)
				{
					readPosition = (image.height - 1 - y) * 4 * image.width;

					for (x in 0...image.width)
					{
						a = pixels.get(readPosition++);
						r = pixels.get(readPosition++);
						g = pixels.get(readPosition++);
						b = pixels.get(readPosition++);

						data.set(position++, b);
						data.set(position++, g);
						data.set(position++, r);
						data.set(position++, a);
					}
				}

			case ICO:
				var andMask = Bytes.alloc(image.width * image.height);
				var maskPosition = 0;

				for (y in 0...image.height)
				{
					readPosition = (image.height - 1 - y) * 4 * image.width;

					for (x in 0...image.width)
					{
						a = pixels.get(readPosition++);
						r = pixels.get(readPosition++);
						g = pixels.get(readPosition++);
						b = pixels.get(readPosition++);

						data.set(position++, b);
						data.set(position++, g);
						data.set(position++, r);
						data.set(position++, a);

						// if (a < 128) {

						// andMask.writeByte (1);

						// } else {

						andMask.set(maskPosition++, 0);

						// }
					}
				}

				data.blit(position, andMask, 0, image.width * image.height);

			case RGB:
				for (y in 0...image.height)
				{
					readPosition = (image.height - 1 - y) * 4 * image.width;

					for (x in 0...image.width)
					{
						a = pixels.get(readPosition++);
						r = pixels.get(readPosition++);
						g = pixels.get(readPosition++);
						b = pixels.get(readPosition++);

						data.set(position++, b);
						data.set(position++, g);
						data.set(position++, r);
					}

					for (i in 0...((image.width * 3) % 4))
					{
						data.set(position++, 0);
					}
				}

			default:
		}

		return data;
	}
}

enum BMPType
{
	RGB;
	BITFIELD;
	ICO;
}
#end
