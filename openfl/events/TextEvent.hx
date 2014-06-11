package openfl.events;


class TextEvent extends Event {
	
	
	public static var LINK:String = "link";
	public static var TEXT_INPUT:String = "textInput";
	
	public var text:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		
	}
	
	
}