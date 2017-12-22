import FileFilter from "./FileFilter";
import EventDispatcher from "./../events/EventDispatcher";
import URLRequest from "./../net/URLRequest";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.net {
	
	
	export class FileReference extends EventDispatcher {
		
		
		/**
		 * The creation date of the file on the local disk.
		 */
		public readonly creationDate:Date;
		
		/**
		 * The Macintosh creator type of the file, which is only used in Mac OS versions prior to Mac OS X.
		 */
		public readonly creator:string;
		
		/**
		 * The ByteArray object representing the data from the loaded file after a successful call to the load() method.
		 */
		public readonly data:ByteArray;
		
		/**
		 * The date that the file on the local disk was last modified.
		 */
		public readonly modificationDate:Date;
		
		/**
		 * The name of the file on the local disk.
		 */
		public readonly name:string;
		
		/**
		 * The size of the file on the local disk in bytes.
		 */
		public readonly size:number;
		
		/**
		 * The file type.
		 */
		public readonly type:string;
		
		
		public constructor ();
		
		
		public browse (typeFilter?:Array<FileFilter>):boolean;
		
		
		public cancel ():void;
		
		
		public download (request:URLRequest, defaultFileName?:string):void;
		
		
		public load ():void;
		
		
		public save (data:any, defaultFileName?:string):void;
		
		
		public upload (request:URLRequest, uploadDataFieldName?:string, testUpload?:boolean):void;
		
		
	}
	
	
}


export default openfl.net.FileReference;