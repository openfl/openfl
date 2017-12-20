package openfl.desktop; #if (display || !flash)


@:enum abstract ClipboardTransferMode(Null<Int>) {
	
	public var CLONE_ONLY = 0;
	public var CLONE_PREFERRED = 1;
	public var ORIGINAL_ONLY = 2;
	public var ORIGINAL_PREFERRED = 3;
	
	@:from private static function fromString (value:String):ClipboardTransferMode {
		
		return switch (value) {
			
			case "cloneOnly": CLONE_ONLY;
			case "clonePreferred": CLONE_PREFERRED;
			case "originalOnly": ORIGINAL_ONLY;
			case "originalPreferred": ORIGINAL_PREFERRED;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case ClipboardTransferMode.CLONE_ONLY: "cloneOnly";
			case ClipboardTransferMode.CLONE_PREFERRED: "clonePreferred";
			case ClipboardTransferMode.ORIGINAL_ONLY: "originalOnly";
			case ClipboardTransferMode.ORIGINAL_PREFERRED: "originalPreferred";
			default: null;
			
		}
		
	}
	
}


#else
typedef ClipboardTransferMode = flash.desktop.ClipboardTransferMode;
#end