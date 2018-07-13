package openfl.profiler;

class Result {
	
	
	public var name:String;
	public var dt:Float;
	public var count:Int;
	
	public function new (name:String, dt:Float, count:Int) {
		
		this.name = name;
		this.dt = dt;
		this.count = count;
		
	}
	
	
}