declare namespace openfl.filters {
	
	/**
	 * The BitmapFilterType class contains values to set the type of a
	 * BitmapFilter.
	 */
	export enum BitmapFilterType {
		
		/**
		 * Defines the setting that applies a filter to the entire area of an object.
		 */
		FULL = "full",
		
		/**
		 * Defines the setting that applies a filter to the inner area of an object.
		 */
		INNER = "inner",
		
		/**
		 * Defines the setting that applies a filter to the outer area of an object.
		 */
		OUTER = "outer"
		
	}
	
}


export default openfl.filters.BitmapFilterType;