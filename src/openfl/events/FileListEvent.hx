package openfl.events;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
import openfl.events.Event;
import openfl.filesystem.File;

/**
	A File object dispatches a FileListEvent object when a call to the
	`getDirectoryListingAsync()` method of a File object successfully enumerates
	a set of files and directories or when a user selects files after a call to
	the `browseForOpenMultiple()` method.

	@see `openfl.filesystem.File.getDirectoryListingAsync()`
	@see `openfl.filesystem.File.browseForOpenMultiple()`
**/
class FileListEvent extends Event
{
	/**
		The `FileListEvent.DIRECTORY_LISTING` constant defines the value of the
		`type` property of the event object for a `directoryListing` event.
	**/
	public static inline var DIRECTORY_LISTING:EventType<FileListEvent> = "directoryListing";

	/**
		The `FileListEvent.SELECT_MULTIPLE` constant defines the value of the
		`type` property of the event object for a `selectMultiple` event.
	**/
	public static inline var SELECT_MULTIPLE:EventType<FileListEvent> = "selectMultiple";

	/**
		An array of File objects representing the files and directories found or
		selected.

		For the `File.getDirectoryListingAsync()` method, this is the list of
		files and directories found at the root level of the directory
		represented by the File object that called the method. For the
		`File.browseForOpenMultiple()` method, this is the list of files
		selected by the user.
	**/
	public var files:Array<File>;

	/**
		The constructor function for a FileListEvent object.

		OpenFL uses this class to create FileListEvent objects. You will not use
		this constructor directly in your code.
	**/
	public function new(type:String, files:Array<File>, bubbles:Bool = false, cancelable:Bool = false)
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
#if air
typedef FileListEvent = flash.events.FileListEvent
#end
#end
