import FileFilter from "./FileFilter";
import FileReference from "./FileReference";
import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.net {
	
	
	export class FileReferenceList extends EventDispatcher {
		
		
		/**
		 * An array of FileReference objects.
		 */
		public readonly fileList:Array<FileReference>;
		
		
		public constructor ();
		
		
		public browse (typeFilter?:Array<FileFilter>):boolean;
		
		
	}
	
	
}


export default openfl.net.FileReferenceList;