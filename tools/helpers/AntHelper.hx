package;


class AntHelper {
	
	
	private static var ant:String;
	
	
	public static function initialize (defines:Hash <String>):Void {
		
		if (defines.exists ("ANDROID_SDK")) {
			
			Sys.putEnv ("ANDROID_SDK", defines.get ("ANDROID_SDK"));
			
		}
		
		ant = defines.get ("ANT_HOME");
		
		if (ant == null || ant == "") {
			
			ant = "ant";
			
		} else {
			
			ant += "/bin/ant";
			
		}
		
	}
	
	
	public static function run (workingDirectory:String, commands:Array <String>):Void {
		
		if (commands == null) {
			
			commands = [];
			
		}
		
		ProcessHelper.runCommand (workingDirectory, ant, commands);
		
	}
		

}
