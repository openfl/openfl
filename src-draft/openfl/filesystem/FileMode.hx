package openfl.filesystem;

@:enum
abstract FileMode(String) from String to String
{
	var APPEND = "append";
	var READ = "read";
	var UPDATE = "update";
	var WRITE = "write";
}
