package;


import sys.FileSystem;


class AndroidHelper {
	
	
	private static var adbName:String;
	private static var adbPath:String;
	
	
	public static function build (project:NMEProject, projectDirectory:String):Void {
		
		if (project.environment.exists ("ANDROID_SDK")) {
			
			Sys.putEnv ("ANDROID_SDK", project.environment.get ("ANDROID_SDK"));
			
		}
		
		var ant = project.environment.get ("ANT_HOME");
		
		if (ant == null || ant == "") {
			
			ant = "ant";
			
		} else {
			
			ant += "/bin/ant";
			
		}
		
		var build = "debug";
		
		if (project.certificate != null) {
			
			build = "release";
			
		}
		
		// Fix bug in Android build system, force compile
		
		var buildProperties = projectDirectory + "/bin/build.prop";
		
		if (FileSystem.exists (buildProperties)) {
			
			FileSystem.deleteFile (buildProperties);
			
		}
		
		ProcessHelper.runCommand (projectDirectory, ant, [ build ]);
		
	}
	
	
	private static function getADB (project:NMEProject):Void {
		
		adbPath = project.environment.get ("ANDROID_SDK") + "/tools/";
		adbName = "adb";
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			adbName += ".exe";
			
		}
		
		if (!FileSystem.exists (adbPath + adbName)) {
			
			adbPath = project.environment.get ("ANDROID_SDK") + "/platform-tools/";
			
		}
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS) {
			
			adbName = "./" + adbName;
			
		}
		
	}
	
	
	public static function initialize (project:NMEProject):Void {
		
		getADB (project);
		
		if (project.environment.exists ("JAVA_HOME")) {
			
			Sys.putEnv ("JAVA_HOME", project.environment.get ("JAVA_HOME"));
			
		}
		
	}
	
	
	public static function install (targetPath:String):Void {
		
		ProcessHelper.runCommand (adbPath, adbName, [ "install", "-r", targetPath ]);
		
	}
	
	
	public static function run (activityName:String):Void {
		
		ProcessHelper.runCommand (adbPath, adbName, [ "shell", "am", "start", "-a", "android.intent.action.MAIN", "-n", activityName ]);
		
	}
	
	
	public static function trace (project:NMEProject, debug:Bool):Void {
		
		// Use -DFULL_LOGCAT or  <set name="FULL_LOGCAT" /> if you do not want to filter log messages
		
		if (project.environment.exists("FULL_LOGCAT") || LogHelper.verbose) {
			
			ProcessHelper.runCommand (adbPath, adbName, [ "logcat", "-c" ]);
			ProcessHelper.runCommand (adbPath, adbName, [ "logcat" ]);
			
		} else if (debug) {
			
			var filter = "*:E";
			var includeTags = [ "NME", "Main", "GameActivity", "GLThread", "trace" ];
			
			for (tag in includeTags) {
				
				filter += " " + tag + ":D";
				
			}
			
			Sys.println (filter);
			
			ProcessHelper.runCommand (adbPath, adbName, [ "logcat", filter ]);
			
		} else {
			
			ProcessHelper.runCommand (adbPath, adbName, [ "logcat", "*:S trace:I" ]);
			
		}
		
	}
	
	
	public static function uninstall (packageName:String):Void {
		
		ProcessHelper.runCommand (adbPath, adbName, [ "uninstall", packageName ]);
		
	}
	

}
