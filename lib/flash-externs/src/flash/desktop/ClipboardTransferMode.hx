package flash.desktop;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ClipboardTransferMode(String) from String to String

{
	public var CLONE_ONLY = "cloneOnly";
	public var CLONE_PREFERRED = "clonePreferred";
	public var ORIGINAL_ONLY = "originalOnly";
	public var ORIGINAL_PREFERRED = "originalPreferred";
}
#else
typedef ClipboardTransferMode = openfl.desktop.ClipboardTransferMode;
#end
