package openfl.desktop; #if !flash #if !openfl_legacy


enum ClipboardTransferMode {
	
	CLONE_ONLY;
	CLONE_PREFERRED;
	ORIGINAL_ONLY;
	ORIGINAL_PREFERRED;
	
}


#end
#else
typedef ClipboardTransferMode = flash.desktop.ClipboardTransferMode;
#end