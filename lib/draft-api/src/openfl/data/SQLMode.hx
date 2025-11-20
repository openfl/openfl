package openfl.data;

/**
 * ...
 * @author Christopher Speciale
 */
enum abstract SQLMode(String) from String to SQLMode
{
	var CREATE:String = "create";
	var READ:String = "read";
	var UPDATE:String = "update";
}