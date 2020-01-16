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
	private var parent:PrintJob;

	public function new(parent:PrintJob)
	{
		this.parent = parent;
	}

	public function send():Void
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
			var canvas;

			for (i in 0...parent.__bitmapData.length)
			{
				bitmapData = parent.__bitmapData[i];
				canvas = bitmapData.__getCanvas();

				if (canvas != null)
				{
					if (i > 0)
					{
						div = cast window.document.createElement("div");
						div.className = "page-break";
						window.document.body.appendChild(div);
					}

					image = new Image();
					image.src = canvas.toDataURL("image/png");
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
