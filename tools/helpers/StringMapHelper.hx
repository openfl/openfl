package;


import haxe.ds.StringMap;


class StringMapHelper {
	
	
	public static function copy <T> (source:StringMap <T>):StringMap <T> {
		
		var target = new StringMap <T> ();
		
		for (key in source.keys ()) {
			
			target.set (key, source.get (key));
			
		}
		
		return target;
		
	}
	
	
	public static function copyKeys <T> (source:StringMap <T>, target:StringMap <T>):Void {
		
		for (key in source.keys ()) {
			
			target.set (key, source.get (key));
			
		}
		
	}
	
	
	public static function copyUniqueKeys <T> (source:StringMap <T>, target:StringMap <T>):Void {
		
		for (key in source.keys ()) {
			
			if (!target.exists (key)) {
				
				target.set (key, source.get (key));
				
			}
			
		}
		
	}
	
	
}