package openfl._internal.backend.html5;

#if openfl_html5
import haxe.Timer;
import js.html.DivElement;
import js.html.StyleElement;
import js.Browser;
import openfl._internal.backend.lime_standalone.Image;
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import openfl.printing.PrintJob;

@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
@:access(openfl.printing.PrintJob)
class HTML5PrintJobBackend
{
	public function send(printJob:PrintJob):Void
	{
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
	}
}
#end
