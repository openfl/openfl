package openfl.events;


class IOErrorEvent extends Event {
	
	
	public static var IO_ERROR = "ioError";
	
	public var text:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		
	}
	
	
}