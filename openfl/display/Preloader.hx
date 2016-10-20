package openfl.display;


import haxe.io.Path;
import lime.app.Preloader in LimePreloader;
import lime.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.Lib;


class Preloader extends LimePreloader {
	
	
	private var display:Sprite;
	private var displayComplete:Bool;
	
	
	public function new (display:Sprite = null) {
		
		super ();
		
		if (display != null) {
			
			this.display = display;
			Lib.current.addChild (display);
			
			if (Std.is (display, OpenFLPreloader)) {
				
				cast (display, OpenFLPreloader).onInit ();
				
			}
			
		}
		
	}
	
	
	private override function start ():Void {
		
		if (display != null && Std.is (display, OpenFLPreloader)) {
			
			display.addEventListener (Event.COMPLETE, display_onComplete);
			cast (display, OpenFLPreloader).onLoaded ();
			
		} else {
			
			super.start ();
			
		}
		
	}
	
	
	private override function update (loaded:Int, total:Int):Void {
		
		if (display != null && Std.is (display, OpenFLPreloader)) {
			
			cast (display, OpenFLPreloader).onUpdate (loaded, total);
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function display_onComplete (event:Event):Void {
		
		display.removeEventListener (Event.COMPLETE, display_onComplete);
		Lib.current.removeChild (display);
		Lib.current.stage.focus = null;
		display = null;
		
		super.start ();
		
	}
	
	
}


class OpenFLPreloader extends Sprite {
	
	public function onInit ():Void {};
	public function onUpdate (loaded:Int, total:Int):Void {};
	public function onLoaded ():Void {};
	
}