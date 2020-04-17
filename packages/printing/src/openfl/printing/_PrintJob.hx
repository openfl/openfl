package openfl.printing;

#if lime
import haxe.Timer;
import openfl.printing.PrintJob;
#if openfl_html5
import js.html.DivElement;
import js.html.Image;
import js.html.StyleElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.printing.PrintJob)
@:noCompletion
class _PrintJob
{
	private var parent:PrintJob;

	public function new(parent:PrintJob)
	{
		this.parent = parent;
	}

	public function send():Void
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
		#end
	}
}
#end
