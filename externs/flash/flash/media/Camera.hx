package flash.media; #if flash

import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.display.BitmapData;

extern class Camera extends EventDispatcher
{	
    public var activityLevel(default, never) : Float;
    public var bandwidth(default, never) : Int;
    public var currentFPS(default, never) : Float;
    public var fps(default, never) : Float;
    public var height(default, never) : Int;
    public var index(default, never) : Int;
    public var isSupported(default, never) : Bool;
    public var keyFrameInterval(default, never) : Int;
    public var loopback(default, never) : Bool;
    public var motionLevel(default, never) : Int;
    public var motionTimeout(default, never) : Int;
    public var muted(default, never) : Bool;
    public var name(default, never) : String;
    public static var names(default, never) : Array<String>;
    public static var permissionStatus(default, never) : String;
    public var position(default, never) : String;
    public var quality(default, never) : Int;
    public var width(default, never) : Int;

    public function copyToByteArray(rect:Rectangle, destination:ByteArray):Void;
    public function copyToVector(rect:Rectangle, destination:Vector<UInt>):Void;
    public function drawToBitmapData(destination:BitmapData):Void;
    public function getCamera(name:String = null):Camera;
    public function requestPermission():Void;
    public function setKeyFrameInterval(keyFrameInterval:Int):Void;
    public function setLoopback(compress:Bool = false):Void;
    public function setMode(width:Int, height:Int, fps:Number, favorArea:Bool = true):Void;
    public function setMotionLevel(motionLevel:Int, timeout:Int = 2000):Void;
    public function setQuality(bandwidth:Int, quality:Int):Void;
}


#else
typedef Camera = openfl.media.Camera;
#end