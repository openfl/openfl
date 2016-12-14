package format;


import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import format.swf.SWFRoot;
import format.swf.SWFTimelineContainer;
import format.swf.tags.TagDefineBits;
import format.swf.tags.TagDefineBitsJPEG2;
import format.swf.tags.TagDefineBitsLossless;
import format.swf.tags.TagDefineButton2;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagSymbolClass;


class SWF extends EventDispatcher {
	
	
	public var data:SWFRoot;
	public static var instances = new Map<String, SWF> ();
	public static var parseABC:Bool = false;
	
	public var backgroundColor (default, null):Int;
	public var frameRate (default, null):Float;
	public var height (default, null):Int;
	public var symbols:Map <String, Int>;
	public var width (default, null):Int;
	
	private var complete:Bool;
	
	
	public function new (bytes:ByteArray) {
		
		super ();
		
		//SWFTimelineContainer.AUTOBUILD_LAYERS = true;
		data = new SWFRoot (bytes);
		
		backgroundColor = data.backgroundColor;
		frameRate = data.frameRate;
		width = Std.int (data.frameSize.rect.width);
		height = Std.int (data.frameSize.rect.height);
		
		symbols = data.symbols;
		
		
		#if flash
		
		var allTags = 0;
		var loadedTags = 0;
		
		var handler = function (_) {
			
			loadedTags++;
			
			if (loadedTags >= allTags) {
				
				dispatchCompleteTimer();
				
			}
			
		}
		
		for (tag in data.tags) {
			
			if (Std.is (tag, TagDefineBits)) {
				
				allTags++;
				
				var bits:TagDefineBits = cast tag;
				bits.exportBitmapData (handler);
				
			} /*else if (Std.is (tag, TagDefineBitsLossless)) {
				
				allTags++;
				
				var bits:TagDefineBitsLossless = cast tag;
				bits.exportBitmapData (handler);
				
			}*/
			
		}
		
		if (allTags == 0) {
			dispatchCompleteTimer();
		}
		
		#else
		
		dispatchCompleteTimer();
		
		#end
		
	}
	
	inline private function dispatchCompleteTimer():Void {
		var tmr = new flash.utils.Timer(1, 1);
		tmr.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, dispatchComplete);
		tmr.start();
	}
	
	private function dispatchComplete(e:flash.events.TimerEvent):Void 
	{
		complete = true;
		dispatchEvent (new Event (Event.COMPLETE));
	}
	
	
	public override function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		super.addEventListener (type, listener, useCapture, priority, useWeakReference);
		
		if (complete) {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	public function hasSymbol (className:String):Bool {
		
		return symbols.exists (className);
		//return streamPositions.exists (id);
		
	}	
	
	
}