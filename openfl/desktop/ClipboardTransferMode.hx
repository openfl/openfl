package openfl.desktop; #if (!display && !flash) #if !openfl_legacy


enum ClipboardTransferMode {
	
	CLONE_ONLY;
	CLONE_PREFERRED;
	ORIGINAL_ONLY;
	ORIGINAL_PREFERRED;
	
}


#end
#else


#if flash
@:require(flash10)
@:native("flash.desktop.ClipboardTransferMode")
#end

@:fakeEnum(String) extern enum ClipboardTransferMode {
	
	CLONE_ONLY;
	CLONE_PREFERRED;
	ORIGINAL_ONLY;
	ORIGINAL_PREFERRED;
	
}


#end