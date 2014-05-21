/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.events;
#if display


extern class SampleDataEvent extends Event {
	var data : openfl.utils.ByteArray;
	var position : Float;
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, theposition : Float = 0, ?thedata : openfl.utils.ByteArray) : Void;
	static var SAMPLE_DATA : String;
}


#end
