package;


import sys.FileSystem;


class NDLL {
	
	
	public var extensionPath:String;
	public var haxelib:Haxelib;
	public var name:String;
	public var path:String;
	public var registerStatics:Bool;
	
	
	public function new (name:String, haxelib:Haxelib = null, registerStatics:Bool = true) {
		
		this.name = name;
		this.haxelib = haxelib;
		this.registerStatics = registerStatics;
		
	}
	
	
	public function clone ():NDLL {
		
		var ndll = new NDLL (name, haxelib, registerStatics);
		ndll.path = path;
		ndll.extensionPath = extensionPath;
		return ndll;
		
	}
	
	
}