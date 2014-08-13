package openfl.display;


import haxe.io.Path;
import lime.app.Preloader in LimePreloader;
import lime.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.URLRequest;


class Preloader extends LimePreloader {
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function load (urls:Array<String>, types:Array<AssetType>):Void {
		
		#if html5
		
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
	
	
	
	
	// Event Handlers
	
	
	
	
	#if html5
	private function sound_onComplete (event:Event):Void {
		
		loaded++;
		
		update (loaded, total);
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	
	
	private function sound_onIOError (event:IOErrorEvent):Void {
		
		// if it is actually valid, it will load later when requested
		
		loaded++;
		
		update (loaded, total);
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	#end
	
	
}