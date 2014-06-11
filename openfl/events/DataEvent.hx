package openfl.events;


class DataEvent extends TextEvent {
	
	
	public static var DATA:String = "data";
	public static var UPLOAD_COMPLETE_DATA:String = "uploadCompleteData";
	
	public var data:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.data = data;
		
	}
	
	
}