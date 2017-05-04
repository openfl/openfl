package openfl.display;


import lime.app.Config;
import lime.app.Preloader in LimePreloader;
import lime.utils.AssetType;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.LoaderInfo)


class Preloader extends LimePreloader {
	
	
	private var display:Sprite;
	private var ready:Bool;
	
	
	public function new (display:Sprite = null) {
		
		super ();
		
		this.display = display;
		
		if (display != null) {
			
			display.addEventListener (Event.UNLOAD, display_onUnload);
			Lib.current.addChild (display);
			
		}
		
	}
	
	
	private override function start ():Void {
		
		if (simulateProgress) return;
		
		ready = true;
		
		#if !flash
		Lib.current.loaderInfo.__complete ();
		#end
		
		if (display != null) {
			
			var complete = new Event (Event.COMPLETE, true, true);
			display.dispatchEvent (complete);
			
			if (!complete.isDefaultPrevented ()) {
				
				display.dispatchEvent (new Event (Event.UNLOAD));
				
			}
			
		} else {
			
			super.start ();
			
		}
		
	}
	
	
	private override function update (loaded:Int, total:Int):Void {
		
		#if !flash
		Lib.current.loaderInfo.__update (loaded, total);
		#end
		
		if (display != null) {
			
			display.dispatchEvent (new ProgressEvent (ProgressEvent.PROGRESS, true, true, loaded, total));
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function display_onUnload (event:Event):Void {
		
		if (display != null) {
			
			display.removeEventListener (Event.UNLOAD, display_onUnload);
			
			if (display.parent == Lib.current) {
				
				Lib.current.removeChild (display);
				
			}
			
			Lib.current.stage.focus = null;
			display = null;
			
		}
		
		if (ready && !simulateProgress) {
			
			super.start ();
			
		}
		
	}
	
	
}


@:dox(hide) class DefaultPreloader extends Sprite {
	
	
	private var endAnimation:Int;
	private var outline:Sprite;
	private var progress:Sprite;
	private var startAnimation:Int;
	
	
	public function new () {
		
		super ();
		
		var backgroundColor = getBackgroundColor ();
		var r = backgroundColor >> 16 & 0xFF;
		var g = backgroundColor >> 8  & 0xFF;
		var b = backgroundColor & 0xFF;
		var perceivedLuminosity = (0.299 * r + 0.587 * g + 0.114 * b);
		var color = 0x000000;
		
		if (perceivedLuminosity < 70) {
			
			color = 0xFFFFFF;
			
		}
		
		var x = 30;
		var height = 7;
		var y = getHeight () / 2 - height / 2;
		var width = getWidth () - x * 2;
		
		var padding = 2;
		
		outline = new Sprite ();
		outline.graphics.beginFill (color, 0.07);
		outline.graphics.drawRect (0, 0, width, height);
		outline.x = x;
		outline.y = y;
		outline.alpha = 0;
		addChild (outline);
		
		progress = new Sprite ();
		progress.graphics.beginFill (color, 0.35);
		progress.graphics.drawRect (0, 0, width - padding * 2, height - padding * 2);
		progress.x = x + padding;
		progress.y = y + padding;
		progress.scaleX = 0;
		progress.alpha = 0;
		addChild (progress);
		
		startAnimation = Lib.getTimer () + 100;
		endAnimation = startAnimation + 1000;
		
		addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
		
	}
	
	
	public function getBackgroundColor ():Int {
		
		return Lib.current.stage.window.config.background;
		
	}
	
	
	public function getHeight ():Float {
		
		var height = Lib.current.stage.window.config.height;
		
		if (height > 0) {
			
			return height;
			
		} else {
			
			return Lib.current.stage.stageHeight;
			
		}
		
	}
	
	
	public function getWidth ():Float {
		
		var width = Lib.current.stage.window.config.width;
		
		if (width > 0) {
			
			return width;
			
		} else {
			
			return Lib.current.stage.stageWidth;
			
		}
		
	}
	
	
	@:keep public function onInit ():Void {
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	@:keep public function onLoaded ():Void {
		
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		dispatchEvent (new Event (Event.UNLOAD));
		
	}
	
	
	@:keep public function onUpdate (bytesLoaded:Int, bytesTotal:Int):Void {
		
		var percentLoaded = 0.0;
		
		if (bytesTotal > 0) {
			
			percentLoaded = bytesLoaded / bytesTotal;
			
			if (percentLoaded > 1) {
				
				percentLoaded = 1;
				
			}
			
		}
		
		progress.scaleX = percentLoaded;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onAddedToStage (event:Event):Void {
		
		removeEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
		
		onInit ();
		onUpdate (loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
		
		addEventListener (ProgressEvent.PROGRESS, this_onProgress);
		addEventListener (Event.COMPLETE, this_onComplete);
		
	}
	
	
	private function this_onComplete (event:Event):Void {
		
		event.preventDefault ();
		
		removeEventListener (ProgressEvent.PROGRESS, this_onProgress);
		removeEventListener (Event.COMPLETE, this_onComplete);
		
		onLoaded ();
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		var elapsed = Lib.getTimer () - startAnimation;
		var total = endAnimation - startAnimation;
		
		var percent = elapsed / total;
		
		if (percent < 0) percent = 0;
		if (percent > 1) percent = 1;
		
		outline.alpha = percent;
		progress.alpha = percent;
		
	}
	
	
	private function this_onProgress (event:ProgressEvent):Void {
		
		onUpdate (Std.int (event.bytesLoaded), Std.int (event.bytesTotal));
		
	}
	
	
}