package openfl.media; #if (display || !flash)

import openfl.events.EventDispatcher;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

/**
 * ...
 * @author P.J.Shand
 */
class StageVideo extends EventDispatcher
{
	private var _colorSpaces:Array<String>;
	public var colorSpaces(get, null):Array<String>;
	public var depth:Int;
	public var pan = new Point();
	public var videoWidth:Int;
	public var videoHeight:Int;
	public var viewPort:Rectangle;
	public var zoom = new Point(1, 1);
	
	public function new() 
	{
		super(null);
	}
	
	private function get_colorSpaces():Array<String>
	{
		return _colorSpaces;
	}
	
	/*public function attachCamera(theCamera:Camera):Void
	{
		
	}*/
	
	public function attachNetStream(netStream:NetStream):Void
	{
		
	}
}

#else
typedef StageVideo = flash.media.StageVideo;
#end