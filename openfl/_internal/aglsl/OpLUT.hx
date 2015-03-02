package openfl._internal.aglsl;


class OpLUT {
	
	
	public var a:Bool;
	public var b:Bool;
	public var dest:Bool;
	public var dm:Bool;
	public var flags:Int;
	public var lod:Bool;
	public var matrixwidth:Int;
	public var matrixheight:Int;
	public var ndwm:Bool;
	public var s:String;
	public var scalar:Bool;
	
	
	public function new (?s:Null<String>, ?flags:Int = 0, ?dest:Bool = false, ?a:Bool = false, ?b:Bool = false, ?matrixwidth:Int = 0, ?matrixheight:Int = 0, ?ndwm:Bool = false, ?scaler:Bool = false, ?dm:Bool = false, ?lod:Bool = false) {
		
		this.s = s;
		this.flags = flags;
		this.dest = dest;
		this.a = a;
		this.b = b;
		this.matrixwidth = matrixwidth;
		this.matrixheight = matrixheight;
		this.ndwm = ndwm;
		this.scalar = scaler;
		this.dm = dm;
		this.lod = lod;
		
	}
	
	
}