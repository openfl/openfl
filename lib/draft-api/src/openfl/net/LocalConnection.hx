package openfl.net;

import openfl.Lib;

class LocalConnection {
    
    public function new() {
        Lib.notImplemented("LocalConnection.new");
    }

    public function allowDomain(?domains:Array<String>):Void {
        Lib.notImplemented("LocalConnection.allowDomain");
    }

    public function allowInsecureDomain(?domains:Array<String>):Void {
        Lib.notImplemented("LocalConnection.allowInsecureDomain");
    }

    public function close():Void {
        Lib.notImplemented("LocalConnection.close");
    }

    public function connect(connectionName:String):Void {
        Lib.notImplemented("LocalConnection.connect");
    }

    public function send(connectionName:String, methodName:String, ?args:Rest<Dynamic>):Void {
        Lib.notImplemented("LocalConnection.send");
    }

    public static function get isSupported():Bool {
        Lib.notImplemented("LocalConnection.isSupported");
        return false;
    }

    public var client:Dynamic;

    public var domain(get, never):String;

    public var isPerUser:Bool;

    private function get_domain():String {
        Lib.notImplemented("LocalConnection.domain");
        return "";
    }
}
