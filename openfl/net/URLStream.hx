package openfl.net;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.ProgressEvent;

import openfl.utils.IDataInput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLLoader;

#if js
import lime.utils.UInt8Array;
#end

class URLStream extends EventDispatcher implements IDataInput {

    #if (flash && !display)
    public var bytesAvailable (default, null):UInt;
    #else
    @:isVar public var bytesAvailable(get, never):UInt;

    public function get_bytesAvailable():UInt {
        untyped {
            if (mData != null && mData.length != null && mData.position != null) {
                return mData.length - mData.position;
            }
        };
        return 0;

    }
    #end

    @:isVar public var connected(get, never):Bool;

    public function get_connected():Bool {
        return false;
    }

    #if (flash && !display)
    public var endian:Endian;
    #else
    @:isVar public var endian(get, set):Endian;

    public function get_endian():Endian {
        return mData.endian;
    }

    public function set_endian(e:Endian):Endian {
        mData.endian = e;
        return mData.endian;
    }
    #end


    public var objectEncoding:UInt;

    private var mLoader:URLLoader = new URLLoader();
    private var mData:ByteArrayData;

    public function new() {
        super();
        mLoader = new URLLoader();
        mLoader.dataFormat = URLLoaderDataFormat.BINARY;
    }


    public function close():Void {
        RemoveEventListeners();
        mData = null;
    }

    public function load(request:URLRequest):Void {
        RemoveEventListeners();
        AddEventListeners();
        mLoader.load(request);
    }

    public function readBoolean():Bool {
        return mData.readBoolean();
    }

    public function readByte():Int {
        return mData.readByte();
    }

    public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void {
        mData.readBytes(bytes, offset, length);
    }

    public function readDouble():Float {
        return mData.readDouble();
    }

    public function readFloat():Float {
        return mData.readFloat();
    }

    public function readInt():Int {
        return mData.readInt();
    }

    public function readMultiByte(length:UInt, charSet:String):String {
        return mData.readMultiByte(length, charSet);
    }

    public function readObject():Dynamic {
        #if flash
        return mData.readObject();
        #else
        // return ByteArrayObjects._readObject(mData);
        #end
    }

    public function readShort():Int {
        return mData.readShort();
    }

    public function readUnsignedByte():UInt {
        return mData.readUnsignedByte();
    }

    public function readUnsignedInt():UInt {
        return mData.readUnsignedInt();
    }

    public function readUnsignedShort():UInt {
        return mData.readUnsignedShort();
    }

    public function readUTF():String {
        return mData.readUTF();
    }

    public function readUTFBytes(length:UInt):String {
        return mData.readUTFBytes(length);
    }

    public function readmData():ByteArrayData {
        return mData;
    }

    private function OnComplete(evt:Event):Void {
        RemoveEventListeners();
        #if js
        untyped {
            this.mData = cast(ByteArray.fromBytes(cast(mLoader.data.b, UInt8Array).toBytes()), ByteArrayData);
        };
        #end
        this.mData = mLoader.data;

        var pe:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS, false, false, mLoader.bytesLoaded, mLoader.bytesTotal );
        this.dispatchEvent(pe);

        var de:Event = new Event(Event.COMPLETE);
        this.dispatchEvent(de);
    }

    private function OnIOError(evt:IOErrorEvent):Void {
        RemoveEventListeners();
        var de:IOErrorEvent = new IOErrorEvent(evt.type, evt.bubbles, evt.cancelable, evt.text, evt.errorID);
        this.dispatchEvent(de);
    }

    private function OnSecurityError(evt:SecurityErrorEvent):Void {
        RemoveEventListeners();
        var de:SecurityErrorEvent = new SecurityErrorEvent(evt.type, evt.bubbles, evt.cancelable);
        this.dispatchEvent(de);
    }

    private function OnProgressEvent(evt:ProgressEvent):Void {
        #if js
        if (mLoader != null) {
            untyped __js__('this.mData = this.mLoader.getData()');
        }
        #end
        this.dispatchEvent(evt);
    }

    private function AddEventListeners():Void {
        mLoader.addEventListener(Event.COMPLETE, OnComplete);
        mLoader.addEventListener(IOErrorEvent.IO_ERROR, OnIOError);
        mLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);
        mLoader.addEventListener(ProgressEvent.PROGRESS, OnProgressEvent);
    }

    private function RemoveEventListeners():Void {
        mLoader.removeEventListener(Event.COMPLETE, OnComplete);
        mLoader.removeEventListener(IOErrorEvent.IO_ERROR, OnIOError);
        mLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);
        mLoader.removeEventListener(ProgressEvent.PROGRESS, OnProgressEvent);
    }
}
