package;


class ArrayHelper {
	
	
	public static function addUnique<T> (array:Array<T>, value:T):T {
		
		var exists = false;
		
		for (arrayValue in array) {
			
			if (arrayValue == value) {
				
				exists = true;
				
			}
			
		}
		
		if (!exists) {
			
			array.push (value);
			
		}
		
		return value;
		
	}
	
	
	public static function concatUnique<T> (a:Array<T>, b:Array<T>):Array<T> {
		
		var concat = a.copy ();
		
		for (bValue in b) {
			
			var hasValue = false;
			
			for (aValue in a) {
				
				if (aValue == bValue) {
					
					hasValue = true;
					
				}
				
			}
			
			if (!hasValue) {
				
				concat.push (bValue);
				
			}
			
		}
		
		return concat;
		
	}
	
	
	public static function containsValue<T> (array:Array < T > , value:T):Bool {
		
		for (arrayValue in array) {
			
			if (arrayValue == value) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
}