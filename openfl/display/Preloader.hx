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
	
	
	public override function load (urls:Array<String>, types:Array<AssetType>):Void {
		
		#if (js && html5)
		
		var sounds = [];
		var url = null;
		
		for (i in 0...urls.length) {
			
			url = urls[i];
			
			switch (types[i]) {
				
				case MUSIC, SOUND:
					
					var sound = Path.withoutExtension (url);
					
					if (!sounds.remove (sound)) {
						
						total++;
						
					}
					
					sounds.push (sound);
				
				default:
				
			}
			
		}
		
		for (soundName in sounds) {
			
			var sound = new Sound ();
			sound.addEventListener (Event.COMPLETE, sound_onComplete);
			sound.addEventListener (IOErrorEvent.IO_ERROR, sound_onIOError);
			sound.load (new URLRequest (soundName + ".ogg"));
			
		}
		
		#end
		
		super.load (urls, types);
		
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
	
	
	#if (js && html5)
	@:noCompletion private function sound_onComplete (event:Event):Void {
		
		loaded++;
		
		update (loaded, total);
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	
	
	@:noCompletion private function sound_onIOError (event:IOErrorEvent):Void {
		
		// if it is actually valid, it will load later when requested
		
		loaded++;
		
		update (loaded, total);
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	#end
	
	
}


#if tools
typedef OpenFLPreloader = NMEPreloader
#else
private class OpenFLPreloader extends Sprite {
	
	public function new () { super (); }
	public function onInit ():Void {};
	public function onUpdate (loaded:Int, total:Int):Void {};
	public function onLoaded ():Void {};
	
}
#end