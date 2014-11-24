package openfl._v2.system; #if (!flash && !html5 && !openfl_next)

class ScreenMode {
	public var format:PixelFormat;
	public var width:Int;
	public var height:Int;
	public var refreshRate:Int;

	public function new() {
		this.width = -1;
		this.height = -1;
		this.format = null;
		this.refreshRate = -1;
	}
}


#end