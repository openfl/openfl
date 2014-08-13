package openfl.display;


import haxe.io.Path;
import lime.app.Preloader in LimePreloader;
import lime.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.URLRequest;

#if js
import js.Browser;
#end


class Preloader extends LimePreloader {
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function load (urls:Array<String>, types:Array<AssetType>):Void {
		
		#if html5
		
		var sounds = [];
		var fonts = [];
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
				
				case FONT:
					
					if (!fonts.remove (url)) {
						
						total++;
						
					}
					
					fonts.push (url);
				
				default:
				
			}
			
		}
		
		for (soundName in sounds) {
			
			var sound = new Sound ();
			sound.addEventListener (Event.COMPLETE, sound_onComplete);
			sound.addEventListener (IOErrorEvent.IO_ERROR, sound_onIOError);
			sound.load (new URLRequest (soundName + ".ogg"));
			
		}
		
		for (font in fonts) {
			
			loadFont (font);
			
		}
		
		#end
		
		super.load (urls, types);
		
	}
	
	
	#if html5
	private function loadFont (font:String):Void {
		
		var node = Browser.document.createElement ("span");
		node.innerHTML = "giItT1WQy@!-/#";
		var style = node.style;
		style.position = "absolute";
		style.left = "-10000px";
		style.top = "-10000px";
		style.fontSize = "300px";
		style.fontFamily = "sans-serif";
		style.fontVariant = "normal";
		style.fontStyle = "normal";
		style.fontWeight = "normal";
		style.letterSpacing = "0";
		Browser.document.body.appendChild (node);
		
		var width = node.offsetWidth;
		style.fontFamily = "'" + font + "'";
		
		var interval:Null<Int> = null;
		var found = false;
		
		var checkFont = function () {
			
			if (node.offsetWidth != width) {
				
				// Test font was still not available yet, try waiting one more interval?
				if (!found) {
					
					found = true;
					return false;
					
				}
				
				loaded ++;
				
				if (interval != null) {
					
					Browser.window.clearInterval (interval);
					
				}
				
				node.parentNode.removeChild (node);
				node = null;
				
				update (loaded, total);
				
				if (loaded == total) {
					
					start ();
					
				}
				
				return true;
				
			}
			
			return false;
			
		}
		
		if (!checkFont ()) {
			
			interval = Browser.window.setInterval (checkFont, 50);
			
		}
		
	}
	#end
	
	
	
	
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