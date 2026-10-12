package openfl.media;

import haxe.ds.Either;
import haxe.extern.EitherType;
import haxe.Timer;

import js.Promise;
import js.Browser;
import js.html.VideoElement;
import js.html.MediaStream;
import js.html.MediaStreamTrack;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;

import openfl.events.StatusEvent;
import openfl.events.EventDispatcher;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.net.NetStream;
import openfl.net.NetConnection;

import lime.graphics.Image;
import lime.graphics.ImageBuffer;

@:access(openfl.display.BitmapData)
@:access(openfl.net.NetStream)
class Camera extends EventDispatcher
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
    public var name(default, null) : String;
    public static var names(default, null) : Array<String> = [];
    public static var permissionStatus(default, never) : String;
    public var position(default, never) : String;
    public var quality(default, never) : Int;
    public var width(default, never) : Int;

    static var mediaDevices:MediaDevices;
    static var devices = new Map<String, MediaDeviceInfo>();
    var stream:MediaStream;
    @:noCompletion var __video (default, null):VideoElement;

    var netStream:NetStream;

    var idealWidth:Null<Int>;
    var idealHeight:Null<Int>;
    var idealFps:Null<Float>;
    var idealFavorArea:Bool = true;

    static function __init__()
    {
        mediaDevices = Reflect.getProperty(Browser.navigator, 'mediaDevices');
        findAvailableDevices(true);
    }

    private function new(name:String = null)
    {
        super();
        this.name = name;
        
        mediaDevices.ondevicechange = ondevicechange;


        netStream = new NetStream(new NetConnection(), null);
        netStream.__video.onloadedmetadata = function(e:Dynamic) {
            netStream.__video.play();
        };
        
        findAvailableDevices(findDevice);
    }

    static function findAvailableDevices(callback:Void -> Void = null, updateNames:Bool=false)
    {
        var names:Array<String> = [];
        devices = new Map<String, MediaDeviceInfo>();

        mediaDevices.enumerateDevices().then(function(_devices:Array<MediaDeviceInfo>){
            for (device in _devices){
                if (device.kind == MediaDeviceKind.VIDEO_INPUT){
                    names.push(device.label);
                    devices.set(device.label, device);
                }
            }
            if (updateNames) Camera.names = names;
            if (callback != null) callback();
        });
    }

    function ondevicechange(e:Dynamic)
    {
        clearActive();
        Timer.delay(() -> {
            findAvailableDevices(findDevice);
        }, 100);
    }

    function clearActive()
    {   
        if (this.stream != null){
            var tracks:Array<MediaStreamTrack> = this.stream.getTracks();
            for (track in tracks){
                track.stop();
                this.stream.removeTrack(track);
            }
            dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, StatusEventCode.INACTIVE));
        }
        this.stream = null;
        netStream.__video.srcObject = null;
    }

    function findDevice()
    {
        var deviceInfo:MediaDeviceInfo = null;
        if (name != null){
            deviceInfo = devices.get(name);
        }
        
        var constraints:MediaConstraints = { audio: false, video: true };
        if (deviceInfo != null){
            var trackConstraints:MediaTrackConstraints = {
                deviceId: { exact: deviceInfo.deviceId },
            };
            if (idealWidth != null) trackConstraints.width = { ideal: idealWidth };
            if (idealHeight != null) trackConstraints.height = { ideal: idealHeight };
            if (idealFps != null) trackConstraints.frameRate = { ideal: idealFps };
            constraints.video = trackConstraints;
        } else if (name != null) {
            trace("not device with name " + name + " found");
            return;
        }
        
        mediaDevices.getUserMedia(constraints).then(function(stream:MediaStream) {
            this.stream = stream;
            netStream.__video.srcObject = stream;
            dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, StatusEventCode.ACTIVE));
        }).catchError(function(error:Dynamic) {
            trace(error);
        });
    }

    public function copyToByteArray(rect:Rectangle, destination:ByteArray):Void
    {
        var canvas = toCanvas(0, 0, Math.floor(rect.width), Math.floor(rect.height));
        var bmd:BitmapData = BitmapData.fromCanvas(canvas, true);
        var b = bmd.getPixels(rect);
        destination.readBytes(b, 0, b.length);
    }

    public function copyToVector(rect:Rectangle, destination:Vector<UInt>):Void
    {
        var canvas = toCanvas(0, 0, Math.floor(rect.width), Math.floor(rect.height));
        var bmd:BitmapData = BitmapData.fromCanvas(canvas, true);
        var v = bmd.getVector(rect);
        for (i in 0...v.length){
            destination.push(v[i]);
        }
    }
    
    public function drawToBitmapData(destination:BitmapData):Void
    {
        var canvas = toCanvas(0, 0, destination.width, destination.height);
        var bmd:BitmapData = BitmapData.fromCanvas(canvas, destination.transparent);
        destination.draw(bmd);
    }

    function toCanvas(x:Int, y:Int, width:Int, height:Int)
    {
        var canvas:CanvasElement = Browser.document.createCanvasElement();
        var ctx:CanvasRenderingContext2D = canvas.getContext('2d');
        canvas.width = width;
        canvas.height = height;
        ctx.drawImage(netStream.__video, 0, 0);
        return canvas;
    }

    
    public static function getCamera(name:String = null):Camera
    {
        var cam = new Camera(name);
        return cam;
    }
    
    public function requestPermission():Void
    {
        throw "neess to be implemented";
    }
    
    public function setKeyFrameInterval(keyFrameInterval:Int):Void
    {
        throw "neess to be implemented";
    }
    
    public function setLoopback(compress:Bool = false):Void
    {
        throw "neess to be implemented";
    }
    
    public function setMode(width:Int, height:Int, fps:Float, favorArea:Bool = true):Void
    {
        idealWidth = width; 
        idealHeight = height;
        idealFps = fps;
        idealFavorArea = favorArea;
    }
    
    public function setMotionLevel(motionLevel:Int, timeout:Int = 2000):Void
    {
        throw "neess to be implemented";
    }
    
    public function setQuality(bandwidth:Int, quality:Int):Void
    {
        throw "neess to be implemented";
    }
}

typedef MediaDevices =
{
    dynamic function ondevicechange(event:Dynamic):Void;
    function getUserMedia(constraints:Dynamic):Promise<MediaStream>;
    function enumerateDevices():Promise<Array<MediaDeviceInfo>>;
    function getSupportedConstraints():Array<Dynamic>;
}

typedef MediaDeviceInfo =
{
    var deviceId(default, never):String;
    var groupId(default, never):String;
    var kind(default, never):MediaDeviceKind;
    var label(default, never):String;
}

typedef MediaConstraints =
{
    audio:EitherType<Bool, MediaTrackConstraints>,
    video:EitherType<Bool, MediaTrackConstraints>
}

typedef MediaTrackConstraints =
{
    ?aspectRatio : Int, 
	?brightness : Int, 
	?channelCount : Int, 
	?colorTemperature : Int, 
	?contrast : Int, 
	?deviceId : EitherType<Dynamic, String>, 
	?echoCancellation : Bool, 
	?exposureCompensation : Int, 
	?exposureMode : String, 
	?facingMode : String, 
	?focusMode : String, 
	?frameRate : EitherType<Dynamic, Int>, 
	?groupId : EitherType<Dynamic, String>, 
	?height : EitherType<Dynamic, Float>, 
	?iso : Int, 
	?latency : Float, 
	?pointsOfInterest : Int, 
	?sampleRate : Int, 
	?sampleSize : Int, 
	?saturation : Int, 
	?sharpness : Int, 
	?torch : Bool, 
	?volume : Float, 
	?whiteBalanceMode : String, 
	?width : EitherType<Dynamic, Float>, 
	?zoom : Int
}

@:enum abstract MediaDeviceKind(String) from String to String {
	
	public var AUDIO_INPUT = 'audioinput';
	public var VIDEO_INPUT = 'videoinput';
}