package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import js.Browser;

@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
class PNG
{
	public static function decodeBytes(bytes:Bytes, decodeData:Bool = true):Image
	{
		return null;
	}

	public static function decodeFile(path:String, decodeData:Bool = true):Image
	{
		return null;
	}

	public static function encode(image:Image):Bytes
	{
		if (image.premultiplied || image.format != RGBA32)
		{
			// TODO: Handle encode from different formats

			image = image.clone();
			image.premultiplied = false;
			image.format = RGBA32;
		}

		ImageCanvasUtil.convertToCanvas(image, false);

		if (image.buffer.__srcCanvas != null)
		{
			var data = image.buffer.__srcCanvas.toDataURL("image/png");
			#if nodejs
			var buffer = new js.node.Buffer((data.split(";base64,")[1] : String), "base64").toString("binary");
			#else
			var buffer = Browser.window.atob(data.split(";base64,")[1]);
			#end
			var bytes = Bytes.alloc(buffer.length);

			for (i in 0...buffer.length)
			{
				bytes.set(i, buffer.charCodeAt(i));
			}

			return bytes;
		}

		return null;
	}
}
#end
