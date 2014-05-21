package openfl.errors;


class Error {
	
	
	public var errorID:Int;
	public var message:Dynamic;
	public var name:Dynamic;
	
	
	public function new (message:Dynamic = null, id:Dynamic = 0) {
		
		this.message = message;
		errorID = id;
		
	}
	
	
	private function getStackTrace ():String {
		
		return "";
		
	}
	
	
	public function toString ():String {
		
		return message;
		
	}
	
	
}