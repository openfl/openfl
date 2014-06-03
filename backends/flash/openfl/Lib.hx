package openfl;


class Lib {

	public static var current (get, set): flash.display.MovieClip;
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();

	public inline static function getTimer() : Int {
		return flash.Lib.getTimer();
	}

	public static function eval( path : String ) : Dynamic {
		return flash.Lib.eval(path);
	}

	public static function getURL( url : flash.net.URLRequest, ?target : String ) {
		return flash.Lib.getURL(url, target);
	}

	public static function fscommand( cmd : String, ?param : String ) {
		return flash.Lib.fscommand(cmd, param);
	}

	public static function trace( arg : Dynamic ) {
		return flash.Lib.trace(arg);
	}

	public static function attach( name : String ) : flash.display.MovieClip {
		return flash.Lib.attach(name);
	}

	public inline static function as<T>( v : Dynamic, c : Class<T> ) : Null<T> {
		return flash.Lib.as(v,c);
	}

	public static function redirectTraces() {
		return flash.Lib.redirectTraces();
	}

	public static function get_current() {
		return flash.Lib.current;
    }

	public static function set_current(current : flash.display.MovieClip) {
		flash.Lib.current = current;
        return current;
    }

    public static function notImplemented (api:String):Void {
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			trace ("Warning: " + api + " has not been implemented");
			
		}
		
	}
}
