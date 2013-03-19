package;


import haxe.io.Path;
import sys.io.Process;
import sys.FileSystem;


class IOSHelper {
	
	
	private static var initialized = false;
	
	
	public static function build (project:NMEProject, workingDirectory:String, additionalArguments:Array <String> = null):Void {
		
		initialize (project);
		
		var platformName = "iphoneos";
        
        if (project.targetFlags.exists ("simulator")) {
        	
            platformName = "iphonesimulator";
            
        }
        
        var configuration = "Release";
        
        if (project.debug) {
        	
            configuration = "Debug";
            
        }
			
        var iphoneVersion = project.environment.get ("IPHONE_VER");
        var commands = [ "-configuration", configuration, "PLATFORM_NAME=" + platformName, "SDKROOT=" + platformName + iphoneVersion ];
			
        if (project.targetFlags.exists("simulator")) {
        	
            commands.push ("-arch");
            commands.push ("i386");
            
        }
        
        if (additionalArguments != null) {
        	
        	commands = commands.concat (additionalArguments);
        	
        }
			
        ProcessHelper.runCommand (workingDirectory, "xcodebuild", commands);
		
	}
	
	
	public static function getSDKDirectory (project:NMEProject):String {
		
		initialize (project);
		
		var platformName = "iPhoneOS";
		
		if (project.targetFlags.exists ("simulator")) {
			
			platformName = "iPhoneSimulator";
			
		}
		
		var process = new Process ("xcode-select", [ "--print-path" ]);
		var directory = process.stdout.readLine ();
		process.close ();
		
		if (directory == "" || directory.indexOf ("Run xcode-select") > -1) {
			
			directory = "/Applications/Xcode.app/Contents/Developer";
			
		}
		
		directory += "/Platforms/" + platformName + ".platform/Developer/SDKs/" + platformName + project.environment.get ("IPHONE_VER") + ".sdk";
		return directory;
		
	}
	
	
	private static function getIOSVersion (project:NMEProject):Void {
		
		if (!project.environment.exists("IPHONE_VER")) {
			if (!project.environment.exists("DEVELOPER_DIR")) {
		        var proc = new Process("xcode-select", ["--print-path"]);
		        var developer_dir = proc.stdout.readLine();
		        proc.close();
		        project.environment.set("DEVELOPER_DIR", developer_dir);
		    }
			var dev_path = project.environment.get("DEVELOPER_DIR") + "/Platforms/iPhoneOS.platform/Developer/SDKs";
         	
			if (FileSystem.exists (dev_path)) {
				var best = "";
            	var files = FileSystem.readDirectory (dev_path);
            	var extract_version = ~/^iPhoneOS(.*).sdk$/;
				
            	for (file in files) {
					if (extract_version.match (file)) {
						var ver = extract_version.matched (1);
                  		if (ver > best)
                     		best = ver;
               		}
            	}
				
            	if (best != "")
               		project.environment.set ("IPHONE_VER", best);
			}
      	}
		
	}
	
	
	public static function getProvisioningFile ():String {
		
		var path = PathHelper.expand ("~/Library/MobileDevice/Provisioning Profiles");
		var files = FileSystem.readDirectory (path);
		
		for (file in files) {
			
			if (Path.extension (file) == "mobileprovision") {
				
				return path + "/" + file;
				
			}
			
		}
		
		return "";
		
	}
	
	
	private static function initialize (project:NMEProject):Void {
		
		if (!initialized) {
			
			getIOSVersion (project);
			
			initialized = true;
			
		}
		
	}
	
	
	public static function launch (project:NMEProject, workingDirectory:String):Void {
		
		initialize (project);
		
		var configuration = "Release";
			
        if (project.debug) {
        	
            configuration = "Debug";
            
        }
        
		if (project.targetFlags.exists ("simulator")) {
			
			var applicationPath = "";
			
			if (Path.extension (workingDirectory) == "app" || Path.extension (workingDirectory) == "ipa") {
				
				applicationPath = workingDirectory;
				
			} else {
				
				applicationPath = workingDirectory + "/build/" + configuration + "-iphonesimulator/" + project.app.file + ".app";
				
			}
			
			var family = "iphone";
			
			if (project.targetFlags.exists ("ipad")) {
				
				family = "ipad";
				
			}
			
			var launcher = PathHelper.findTemplate (project.templatePaths, "bin/ios-sim");
			Sys.command ("chmod", [ "+x", launcher ]);
			
			ProcessHelper.runCommand ("", launcher, [ "launch", FileSystem.fullPath (applicationPath), "--sdk", project.environment.get ("IPHONE_VER"), "--family", family ] );
			
		} else {
			
			var applicationPath = "";
			
			if (Path.extension (workingDirectory) == "app" || Path.extension (workingDirectory) == "ipa") {
				
				applicationPath = workingDirectory;
				
			} else {
				
				applicationPath = workingDirectory + "/build/" + configuration + "-iphoneos/" + project.app.file + ".app";
				
			}
			
            var launcher = PathHelper.findTemplate (project.templatePaths, "bin/fruitstrap");
	        Sys.command ("chmod", [ "+x", launcher ]);
	        
	        if (project.debug) {
	            
	            ProcessHelper.runCommand ("", launcher, [ "install", "--debug", "--timeout", "5", "--bundle", FileSystem.fullPath (applicationPath) ]);
	            
	        } else {
	            
	            ProcessHelper.runCommand ("", launcher, [ "install", "--debug", "--timeout", "5", "--bundle", FileSystem.fullPath (applicationPath) ]);
	            
	        }
            
		}
		
	}
	
	
	public static function sign (project:NMEProject, workingDirectory:String, entitlementsPath:String):Void {
		
		initialize (project);
		
        var configuration = "Release";
		
        if (project.debug) {
        	
            configuration = "Debug";
            
        }
        
        var commands = [ "-s", "iPhone Developer" ];
        
        if (entitlementsPath != null) {
        	
        	commands.push ("--entitlements");
        	commands.push (entitlementsPath);
        	
        }
        
        var applicationPath = "build/" + configuration + "-iphoneos/" + project.app.file + ".app";
        commands.push (applicationPath);
        
        ProcessHelper.runCommand (workingDirectory, "codesign", commands, true, true);
		
	}
	

}
