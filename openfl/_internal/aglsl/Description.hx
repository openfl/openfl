package openfl._internal.aglsl;


class Description {
	
	
	public var hasindirect:Bool;
	public var hasmatrix:Bool;
	public var header:Header;
	public var regread:Array<Dynamic>;
	public var regwrite:Array<Dynamic>;
	public var samplers:Array<Dynamic>;
	public var tokens:Array<Dynamic>; // added due to dynamic assignment 3*0xFFFFFFuuuu
	public var writedepth:Bool;
	
	
	public function new () {
		
		regread = [[], [], [], [], [], [], []];
		regwrite = [[], [], [], [], [], [], []];
		hasindirect = false;
		writedepth = false;
		hasmatrix = false;
		samplers = [];
		
		//
		// added due to dynamic assignment 3*0xFFFFFFuuuu
		tokens = [];
		header = new Header ();
		
	}
	
	
}