package openfl.printing;


import haxe.Timer;
import lime.graphics.utils.ImageCanvasUtil;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.DivElement;
import js.html.Image;
import js.html.StyleElement;
import js.Browser;
#end

@:access(lime.graphics.ImageBuffer)


class PrintJob {
	
	
	public static var isSupported (default, null) = #if (js && html5) true #else false #end;
	
	public var orientation:PrintJobOrientation;
	public var pageHeight (default, null):Int;
	public var pageWidth (default, null):Int;
	public var paperHeight (default, null):Int;
	public var paperWidth (default, null):Int;
	
	private var __bitmapData:Array<BitmapData>;
	private var __started:Bool;
	
	
	public function new () {
		
		
		
	}
	
	
	public function addPage (sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:Int = 0):Void {
		
		if (!__started) return;
		
		if (printArea == null) {
			
			printArea = sprite.getBounds (sprite);
			
		}
		
		var bitmapData = new BitmapData (Math.ceil (printArea.width), Math.ceil (printArea.height), true, 0);
		bitmapData.draw (sprite);
		
		__bitmapData.push (bitmapData);
		
	}
	
	
	public function send ():Void {
		
		if (!__started) return;
		
		#if (js && html5)
		
		var window = Browser.window.open ("", "", "width=500,height=500");
		
		if (window != null) {
			
			var style:StyleElement = cast window.document.createElement ("style");
			style.innerText = 
				
				"@media all {
					.page-break	{ display: none; }
				}
				
				@media print {
					.page-break	{ display: block; page-break-before: always; }
				}";
			
			window.document.head.appendChild (style);
			
			var div:DivElement;
			var image:Image;
			var bitmapData;
			
			for (i in 0...__bitmapData.length) {
				
				bitmapData = __bitmapData[i];
				ImageCanvasUtil.sync (bitmapData.image, false);
				
				if (bitmapData.image.buffer.__srcCanvas != null) {
					
					if (i > 0) {
						
						div = cast window.document.createElement ("div");
						div.className = "page-break";
						window.document.body.appendChild (div);
						
					}
					
					image = new Image ();
					image.src = bitmapData.image.buffer.__srcCanvas.toDataURL ("image/png");
					window.document.body.appendChild (image);
					
				}
				
			}
			
			Timer.delay (function () {
				
				window.focus ();
				window.print ();
				
			}, 500);
			
		}
		
		#end
		
	}
	
	
	public function start ():Bool {
		
		if (isSupported) {
			
			__started = true;
			__bitmapData = new Array ();
			
			return true;
			
		}
		
		return false;
		
	}
	
	
}