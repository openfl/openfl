package openfl._internal.aglsl;


class Token {
	
	
	public var a:Destination;
	public var b:Destination;
	public var dest:Destination;
	public var opcode:Int;
	
	
	public function new () {
		
		dest = new Destination ();
		opcode = 0;
		a = new Destination ();
		b = new Destination ();
		
	}
	
	
}