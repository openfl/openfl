declare namespace openfl.net {
	
	
	/*@:final*/ export class FileFilter {
		
		
		/**
		 * The description string for the filter.
		 */
		public description:string;
		
		/**
		 * A list of file extensions.
		 */
		public extension:string;
		
		/**
		 * A list of Macintosh file types.
		 */
		public macType:string;
		
		
		public constructor (description:string, extension:string, macType?:string);
		
		
	}
	
	
}


export default openfl.net.FileFilter;