package openfl.events;
#if !air
import openfl.events.Event;
import openfl.filesystem.File;

class FileListEvent extends Event 
{
	public static inline var DIRECTORY_LISTING:String = "directoryListing";
	public static inline var SELECT_MULTIPLE:String = "selectMultiple";
	
	public var files:Array<File>;
	
	public function new(type:String, files:Array<File>, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		this.files = files;
		
	}
	
	override public function clone():Event 
	{
		return new FileListEvent(type, files, bubbles, cancelable);
	}
	
}
#else
typedef FileListEvent = flash.events.FileListEvent
#end