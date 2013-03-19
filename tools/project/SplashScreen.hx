class SplashScreen {
	
	
	public var height:Int;
	public var path:String;
	public var width:Int;
	
	
	public function new (path:String, width:Int = 0, height:Int = 0) {
		
		this.path = path;
		this.width = width;
		this.height = height;
		
	}
	
	
	public function clone ():SplashScreen {
		
		var splashScreen = new SplashScreen (path);
		splashScreen.width = width;
		splashScreen.height = height;
		
		return splashScreen;
		
	}
	
	
}