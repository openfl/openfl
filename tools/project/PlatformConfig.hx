package;


class PlatformConfig {
	
	
	public var android:AndroidConfig;
	public var ios:IOSConfig;
	
	private static var defaultAndroid:AndroidConfig = { installLocation: "preferExternal" };
	private static var defaultIOS:IOSConfig = { compiler: "clang", deployment: /*3.2*/ 5, device: IOSConfigDevice.UNIVERSAL, linkerFlags: "", prerenderedIcon: false };
	
	
	public function new () {
		
		android = { };
		ios = { };
		
		ObjectHelper.copyFields (defaultAndroid, android);
		ObjectHelper.copyFields (defaultIOS, ios);
		
	}
	
	
	public function clone ():PlatformConfig {
		
		var copy = new PlatformConfig ();
		
		ObjectHelper.copyFields (android, copy.android);
		ObjectHelper.copyFields (ios, copy.ios);
		
		return copy;
		
	}
	
	
	public function merge (config:PlatformConfig):Void {
		
		ObjectHelper.copyUniqueFields (config.android, android, defaultAndroid);
		ObjectHelper.copyUniqueFields (config.ios, ios, defaultIOS);
		
	}
	
	
	public function populate ():Void {
		
		ObjectHelper.copyMissingFields (android, defaultAndroid);
		ObjectHelper.copyMissingFields (ios, defaultIOS);
		
	}
	
	
}


typedef AndroidConfig = {
	
	@:optional var installLocation:String;
	
}


typedef IOSConfig = {
	
	@:optional var compiler:String;
	@:optional var deployment:Float;
	@:optional var device:IOSConfigDevice;
	@:optional var linkerFlags:String;
	@:optional var prerenderedIcon:Bool;
	
}


enum IOSConfigDevice {
	
	UNIVERSAL;
	IPHONE;
	IPAD;
	
}