package openfl.display;


import lime.app.Preloader in LimePreloader;
import lime.Assets;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.IEventDispatcher;


class Preloader extends LimePreloader {
	
	
	private var display:Dynamic;
	private var displayComplete:Bool;
	private var displayHasInit:Bool;
	private var displayHasLoaded:Bool;
	private var displayHasUpdate:Bool;
	
	
	public function new (display:Dynamic = null) {
		
		super ();
		
		this.display = display;
		
	}
	
	
	private function init ():Void {
		
		if (!complete && display != null) {
			
			var classType = Type.getClass (display);
			var fields = Type.getInstanceFields (classType);
			
			for (field in fields) {
				
				if (field == "onInit") displayHasInit = true;
				if (field == "onUpdate") displayHasUpdate = true;
				if (field == "onLoaded") displayHasLoaded = true;
				
			}
			
			if (Std.is (display, DisplayObject)) {
				
				Lib.current.addChild (display);
				
			}
			
			if (displayHasInit) {
				
				Reflect.callMethod (display, Reflect.field (display, "onInit"), []);
				
			}
			
		}
		
	}
	
	
	public override function load (urls:Array<String>, types:Array<AssetType>):Void {
		
		if (urls.length > 0) {
			
			init ();
			
		}
		
		super.load (urls, types);
		
	}
	
	
	private override function start ():Void {
		
		if (displayHasLoaded) {
			
			if (Std.is (display, IEventDispatcher)) {
				
				(display:IEventDispatcher).addEventListener (Event.COMPLETE, display_onComplete);
				
			}
			
			Reflect.callMethod (display, Reflect.field (display, "onLoaded"), []);
			
			if (display != null && !Std.is (display, IEventDispatcher)) {
				
				display_onComplete (null);
				
			}
			
		} else if (display != null) {
			
			display_onComplete (null);
			
		} else {
			
			super.start ();
			
		}
		
	}
	
	
	private override function update (loaded:Int, total:Int):Void {
		
		if (displayHasUpdate) {
			
			Reflect.callMethod (display, Reflect.field (display, "onUpdate"), [ loaded, total ]);
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function display_onComplete (event:Event):Void {
		
		if (display != null && Std.is (display, IEventDispatcher)) {
			
			(display:IEventDispatcher).removeEventListener (Event.COMPLETE, display_onComplete);
			
		}
		
		if (Std.is (display, DisplayObject)) {
			
			if (display.parent == Lib.current) {
				
				Lib.current.removeChild (display);
				
			}
			
		}
		
		Lib.current.stage.focus = null;
		display = null;
		
		super.start ();
		
	}
	
	
}


@:dox(hide) class DefaultPreloader extends Sprite implements IPreloader {
	
	
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
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	@:keep public function onUpdate (bytesLoaded:Int, bytesTotal:Int):Void {
		
		var percentLoaded = bytesLoaded / bytesTotal;
		
		if (percentLoaded > 1) {
			
			percentLoaded = 1;
			
		}
		
		progress.scaleX = percentLoaded;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		var elapsed = Lib.getTimer () - startAnimation;
		var total = endAnimation - startAnimation;
		
		var percent = elapsed / total;
		
		if (percent < 0) percent = 0;
		if (percent > 1) percent = 1;
		
		outline.alpha = percent;
		progress.alpha = percent;
		
	}
	
	
}