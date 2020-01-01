package openfl._internal.backend.lime;

#if lime
import haxe.Timer;
import lime._internal.graphics.ImageCanvasUtil;
import lime.graphics.Image;
import openfl.printing.PrintJob;
#if openfl_html5
import js.html.DivElement;
import js.html.StyleElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl.printing.PrintJob)
class LimePrintJobBackend
{
	public function send(printJob:PrintJob):Void
	{
		#if openfl_html5
		var window = Browser.window.open("", "", "width=500,height=500");

		if (window != null)
		{
			var style:StyleElement = cast window.document.createElement("style");
			style.innerText = "@media all {
					.page-break	{ display: none; }
				}

				@media print {
					.page-break	{ display: block; page-break-before: always; }
				}";

			window.document.head.appendChild(style);

			var div:DivElement;
			var image:Image;
			var bitmapData;

			for (i in 0...printJob.__bitmapData.length)
			{
				bitmapData = printJob.__bitmapData[i];
				ImageCanvasUtil.sync(bitmapData.image, false);

				if (bitmapData.image.buffer.__srcCanvas != null)
				{
					if (i > 0)
					{
						div = cast window.document.createElement("div");
						div.className = "page-break";
						window.document.body.appendChild(div);
					}

					image = new Image();
					image.src = bitmapData.image.buffer.__srcCanvas.toDataURL("image/png");
					window.document.body.appendChild(image);
				}
			}

			Timer.delay(function()
			{
				window.focus();
				window.print();
			}, 500);
		}
		#end
	}
}
#end
