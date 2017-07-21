package format.swf.timeline;

import format.swf.utils.StringUtils;

class Layer
{
	public var depth:Int = 0;
	public var frameCount:Int = 0;
	
	public var frameStripMap:Array<Int>;
	public var strips:Array<LayerStrip>;
	
	public function new(depth:Int, frameCount:Int)
	{
		this.depth = depth;
		this.frameCount = frameCount;
		frameStripMap = [];
		strips = [];
	}
	
	public function appendStrip(type:Int, start:Int, end:Int):Void {
		if(type != LayerStrip.TYPE_EMPTY) {
			var i:Int;
			var stripIndex:Int = strips.length;
			if(stripIndex == 0 && start > 0) {
				for(i in 0...start) {
					frameStripMap[i] = stripIndex;
				}
				strips[stripIndex++] = new LayerStrip(LayerStrip.TYPE_SPACER, 0, start - 1);
			} else if(stripIndex > 0) {
				var prevStrip:LayerStrip = strips[stripIndex - 1];
				if(prevStrip.endFrameIndex + 1 < start) {
					for(i in prevStrip.endFrameIndex + 1...start) {
						frameStripMap[i] = stripIndex;
					}
					strips[stripIndex++] = new LayerStrip(LayerStrip.TYPE_SPACER, prevStrip.endFrameIndex + 1, start - 1);
				}
			}
			for(i in start...(end + 1)) {
				frameStripMap[i] = stripIndex;
			}
			strips[stripIndex] = new LayerStrip(type, start, end);
		}
	}
	
	public function getStripsForFrameRegion(start:Int, end:Int):Array<LayerStrip> {
		if(start >= frameStripMap.length || end < start) {
			return [];
		}
		var startStripIndex:Int = frameStripMap[start];
		var endStripIndex:Int = (end >= frameStripMap.length) ? strips.length - 1 : frameStripMap[end];
		return strips.slice(startStripIndex, endStripIndex + 1);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = "Depth: " + depth + ", Frames: " + frameCount;
		if(strips.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Strips:";
			for(i in 0...strips.length) {
				var strip:LayerStrip = strips[i];
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + strip.toString();
			}
		}
		return str;
	}
}