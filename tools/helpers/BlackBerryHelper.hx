package;


import haxe.io.Eof;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;


class BlackBerryHelper {
	
	
	private static var binDirectory:String;
	private static var defines:Map <String, String>;
	private static var targetFlags:Map <String, String>;
	
	
	public static function createPackage (project:NMEProject, workingDirectory:String, descriptorFile:String, targetPath:String):Void {
		
		var args = [ "-package", targetPath, descriptorFile ];
		var password = null;
		
		if (project.certificate != null) {
			
			password = project.certificate.password;
			
			if (password == null) {
				
				password = prompt ("Keystore password", true);
				Sys.println ("");
				
			}
			
		}
		
		if (project.certificate != null) {
			
			args.push ("-keystore");
			args.push (PathHelper.tryFullPath (project.certificate.path));
			
			if (password != null) {
				
				args.push ("-storepass");
				args.push (password);
				
			}
			
		} else {
			
			args.push ("-devMode");
			
			if (!project.targetFlags.exists ("simulator")) {
				
				args.push ("-debugToken");
				args.push (PathHelper.tryFullPath (project.environment.get ("BLACKBERRY_DEBUG_TOKEN")));
				
			}
			
		}
		
		var exe = binDirectory + "blackberry-nativepackager";
			
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			exe += ".bat";
			
		}
		
		ProcessHelper.runCommand (workingDirectory, exe, args);
		
		if (project.certificate != null) {
			
			args = [ "-keystore", PathHelper.tryFullPath (project.certificate.path) ];
			
			if (password != null) {
				
				args.push ("-storepass");
				args.push (password);
				
			}
			
			args.push (targetPath);
			
			var exe = binDirectory + "blackberry-signer";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				exe += ".bat";
				
			}
			
			ProcessHelper.runCommand (workingDirectory, exe, args);
			
		}
		
	}
	
	
	public static function createWebWorksPackage (project:NMEProject, sourceDirectory:String, targetPath:String):Void {
		
		var zipPath = PathHelper.combine (targetPath, PathHelper.safeFileName (project.app.file) + ".zip");
		
		ZipHelper.compress (sourceDirectory, zipPath);
		
		var exe = "bbwp.bat";
		var args = [ zipPath ];
		var params = "";
		
		if (project.certificate != null) {
			
			var password = project.certificate.password;
			
			if (password == null) {
				
				password = prompt ("Keystore password", true);
				Sys.println ("");
				
			}
			
			args = args.concat ([ "--password", password, "--buildId", project.meta.buildNumber ]);
			
			//params = "{\n\t\"blackberry-nativepackager\": {\n\t\t\"-keystore\": \"" + PathHelper.tryFullPath (project.certificate.path) + "\"\n\t}\n}";
			
			try {
				
				FileHelper.copyFile (PathHelper.tryFullPath (project.certificate.path), PathHelper.combine (project.environment.get ("BLACKBERRY_WEBWORKS_SDK"), "author.p12"));
				
			} catch (e:Dynamic) {}
			
		} else {
			
			args.push ("--debug");
			
			//params = "{\n\t\"blackberry-nativepackager\": {\n\t\t\"-debugToken\": \"" + PathHelper.tryFullPath (project.environment.get ("BLACKBERRY_DEBUG_TOKEN")) + "\"\n\t}\n}";
			
			try {
				
				FileHelper.copyFile (PathHelper.tryFullPath (project.environment.get ("BLACKBERRY_DEBUG_TOKEN")), PathHelper.combine (project.environment.get ("BLACKBERRY_WEBWORKS_SDK"), "debugToken.bar"));
				
			} catch (e:Dynamic) {}
			
		}
		
		args = args.concat ([ "--output", targetPath ]);
		
		//if (!project.targetFlags.exists ("simulator")) {
				//
				//args.push ("-debugToken");
				//args.push (PathHelper.tryFullPath (project.environment.get ("BLACKBERRY_DEBUG_TOKEN")));
				//
			//}
		
		if (LogHelper.verbose) {
			
			args.push ("--verbose");
			
		}
		
		//var paramsFile = PathHelper.getTemporaryFile (".json");
		//File.saveContent (paramsFile, params);
		
		//args = args.concat ([ "--params", paramsFile ]);
		
		ProcessHelper.runCommand ("", PathHelper.combine (project.environment.get ("BLACKBERRY_WEBWORKS_SDK"), exe), args);
		
		//if (FileSystem.exists (paramsFile)) {
			
			//FileSystem.deleteFile (paramsFile);
			
		//}
		
	}
	
	
	public static function deploy (project:NMEProject, workingDirectory:String, targetPath:String, run:Bool = true):Void {
		
		var deviceIP = project.environment.get ("BLACKBERRY_DEVICE_IP");
		var devicePassword = project.environment.get ("BLACKBERRY_DEVICE_PASSWORD");
		
		if (project.targetFlags.exists ("simulator")) {
			
			deviceIP = project.environment.get ("BLACKBERRY_SIMULATOR_IP");
			devicePassword = "playbook";
			
		}
		
		var args = [ "-installApp" ];
		
		if (project.targetFlags.exists ("gdb")) {
			
			args.push ("-debugNative");
			
		}
		
		if (run) {
			
			args.push ("-launchApp");
			
		}
		
		args = args.concat ([ "-device", deviceIP, "-password", devicePassword, targetPath ]);
		
		var exe = binDirectory + "blackberry-deploy";
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			exe += ".bat";
			
		}
		
		ProcessHelper.runCommand (workingDirectory, exe, args);
		
	}
	
	
	public static function initialize (project:NMEProject):Void {
		
		if (project.environment.exists ("BLACKBERRY_NDK_ROOT") && (!project.environment.exists("QNX_HOST") || !project.environment.exists("QNX_TARGET"))) {
			
			var fileName = project.environment.get ("BLACKBERRY_NDK_ROOT");
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				fileName += "\\bbndk-env.bat";
				
			} else {
				
				fileName += "/bbndk-env.sh";
				
			}
			
			var fin = File.read (fileName, false);
			
			try {
				
				while (true) {
				
					var str = fin.readLine();
					var split = str.split ("=");
					var name = StringTools.trim (split[0].substr (split[0].indexOf (" ") + 1));
					
					switch (name) {
					
						case "QNX_HOST", "QNX_TARGET":
							
							var value = split[1];
							
							if (StringTools.startsWith (value, "\"")) {
							
								value = value.substr (1);
								
							}
							
							if (StringTools.endsWith (value, "\"")) {
							
								value = value.substr (0, value.length - 1);
								
							}
							
							project.environment.set(name,value);
							
					}
					
				}
				
			} catch (ex:Eof) {}
			
			fin.close();
			
		}
		
		binDirectory = PathHelper.combine (project.environment.get ("QNX_HOST"), "usr/bin/");
		
	}
	
	
	public static function processDebugToken (project:NMEProject, workingDirectory:String = ""):BlackBerryDebugToken {
		
		var data:BlackBerryDebugToken = { authorID: "", deviceIDs: new Array<String> () };
		
		if (project.environment.exists ("BLACKBERRY_DEBUG_TOKEN")) {
			
			PathHelper.mkdir (workingDirectory);
			
			var cacheCwd = Sys.getCwd ();
			
			if (workingDirectory != "") {
				
				Sys.setCwd (workingDirectory);
				
			}
			
			var exe = binDirectory + "blackberry-nativepackager";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				exe += ".bat";
				
			}
			
			var process = new Process (exe, [ "-listmanifest", PathHelper.escape (PathHelper.tryFullPath (project.environment.get ("BLACKBERRY_DEBUG_TOKEN"))) ]);
			var ret = process.stdout.readAll().toString();
			var ret2 = process.stderr.readAll().toString();
			process.exitCode(); //you need this to wait till the process is closed!
			process.close();
			
			Sys.setCwd (cacheCwd);
			
			if (ret != null) {
				
				var search = "Package-Author-Id: ";
				var index = ret.indexOf (search);
				
				if (index > -1) {
					
					var start = index + search.length;
					data.authorID = StringTools.trim (ret.substr (start, ret.indexOf ("\n", index) - start));
					
				}
				
				search = "Debug-Token-Device-Id: ";
				var index = ret.indexOf (search);
				
				while (index > -1) {
					
					var start = index + search.length;
					var deviceIDs = StringTools.trim (ret.substr (start, ret.indexOf ("\n", index) - start)).split (",");
					
					for (i in 0...deviceIDs.length) {
						
						deviceIDs[i] = StringTools.hex (Std.parseInt (deviceIDs[i]));
						
					}
					
					data.deviceIDs = data.deviceIDs.concat (deviceIDs);
					index = ret.indexOf (search, index + search.length);
					
				}
				
			}
			
		}
		
		if (data.authorID == "" && project.targetFlags.exists ("simulator")) {
			
			data.authorID = "gYAAgF-DMYiFsOQ3U6QvuW1fQDY";
			
		}
		
		return data;
		
	}
	
	
	private static function prompt (name:String, ?passwd:Bool):String {
		
		Sys.print (name + ": ");
		
		if (passwd) {
			var s = new StringBuf ();
			var c;
			while ((c = Sys.getChar(false)) != 13)
				s.addChar (c);
			return s.toString ();
		}
		
		try {
			
			return Sys.stdin ().readLine ();
			
		} catch (e:Eof) {
			
			return "";
			
		}
		
	}
	
	
	public static function trace (project:NMEProject, workingDirectory:String, targetPath:String):Void {
		
		var deviceIP = project.environment.get ("BLACKBERRY_DEVICE_IP");
		var devicePassword = project.environment.get ("BLACKBERRY_DEVICE_PASSWORD");
		
		if (project.targetFlags.exists ("simulator")) {
			
			deviceIP = project.environment.get ("BLACKBERRY_SIMULATOR_IP");
			devicePassword = "playbook";
			
		}
		
		var exe = binDirectory + "blackberry-deploy";
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			exe += ".bat";
			
		}
		
		ProcessHelper.runCommand (workingDirectory, exe, [ "-getFile", "logs/log", "-", "-device", deviceIP, "-password", devicePassword, targetPath ] );
		
	}
		

}


typedef BlackBerryDebugToken = {
	
	var authorID:String;
	var deviceIDs:Array<String>;
	
}