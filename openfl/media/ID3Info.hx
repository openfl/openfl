/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.media;
#if display


@:final extern class ID3Info implements Dynamic {
	var album : String;
	var artist : String;
	var comment : String;
	var genre : String;
	var songName : String;
	var track : String;
	var year : String;
	function new() : Void;
}


#end
