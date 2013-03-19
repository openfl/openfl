package;


import data.Asset;
import data.Icons;
import haxe.io.Eof;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;


class CordovaHelper {
	
	
	public static var contentPath = "www/";
	
	private static var defines:Hash <String>;
	private static var NME:String;
	private static var target:String;
	private static var targetFlags:Hash <String>;
	
	
	public static function build (workingDirectory:String, debug:Bool):Void {
		
		switch (target) {
			
			case "ios":
				
				var directoryName = "Release";
				
				if (debug) {
					
					directoryName = "Debug";
					
				}
				
				if (targetFlags.exists ("simulator")) {
					
					directoryName += "-iphonesimulator";
					
				} else {
					
					directoryName += "-iphoneos";
					
				}
				
				IOSHelper.build (workingDirectory, debug, [ "CONFIGURATION_BUILD_DIR=" + FileSystem.fullPath (workingDirectory) + "/build/" + directoryName ]);
				
				if (!targetFlags.exists ("simulator")) {
		            
		            //var entitlements = buildDirectory + "/ios/" + defines.get("APP_FILE") + "/" + defines.get("APP_FILE") + "-Entitlements.plist";
		            IOSHelper.sign (workingDirectory, null, debug);
		            
		        }
			
		    case "blackberry":
		    	
		    	if (targetFlags.exists ("bbos")) {
		    		
		    		AntHelper.run (workingDirectory, [ "blackberry", "build", "-Dcode.sign=false" ]);
		    		
		    	} else {
		    		
					//AntHelper.run (workingDirectory, [ "playbook", "build" ]);
					
					var args = [ "qnx", "build" ];
					
					if (!defines.exists ("KEY_STORE")) {
						
						var debugTokenPath = PathHelper.tryFullPath (defines.get ("BLACKBERRY_DEBUG_TOKEN"));
						var targetPath = defines.get ("WEBWORKS_SDK") + "/debugToken.bar";
						
						if (FileSystem.exists (debugTokenPath)) {
							
							try {
								
								if (FileSystem.exists (targetPath)) {
									
									FileSystem.deleteFile (targetPath);
									
								}
								
								File.copy (debugTokenPath, targetPath);
								
							} catch (e:Dynamic) {}
							
						}
						
					} else {
						
						var keyStorePath = PathHelper.tryFullPath (defines.get ("KEY_STORE"));
						var targetPath = "";
						
						if (InstallTool.isWindows) {
							
							targetPath = Sys.getEnv ("HOMEPATH") + "\\AppData\\Local\\Research In Motion";
							
						} else if (InstallTool.isMac) {
						
							targetPath = PathHelper.expand ("~/Library/Research In Motion");
							
						} else {
							
							targetPath = PathHelper.expand ("~/.rim");
							
						}
						
						targetPath += "/author.p12";
						
						if (FileSystem.exists (keyStorePath)) {
							
							try {
								
								PathHelper.mkdir (Path.directory (targetPath));
								
								if (FileSystem.exists (targetPath)) {
									
									FileSystem.deleteFile (targetPath);
									
								}
								
								File.copy (keyStorePath, targetPath);
								
							} catch (e:Dynamic) {}
							
						}
						
						if (defines.exists ("KEY_STORE") && !defines.exists ("KEY_STORE_PASSWORD")) {
							
							defines.set ("KEY_STORE_PASSWORD", prompt ("Keystore password", true));
							Sys.println ("");
							
						}
						
						args.push ("-Dproperties.qnx.sigtool.password=" + defines.get ("KEY_STORE_PASSWORD"));
						args.push ("-Dbuild.number=" + defines.get ("APP_BUILD_NUMBER"));
						args.push ("-Dcode.sign=true");
						
					}
					
					AntHelper.run (workingDirectory, args);
					
				}
			
			case "android":
				
				AndroidHelper.build (workingDirectory);
			
		}
		
	}
	
	
	public static function create (workingDirectory:String, targetPath:String, context:Dynamic):Void {
		
		//if (!FileSystem.exists (targetPath)) {
		
			if (target == "android") {
				
				Sys.putEnv ("ANDROID_BIN", defines.get ("ANDROID_SDK") + "/tools/android");
				
			}
			
			PathHelper.removeDirectory (targetPath);
			ProcessHelper.runCommand (workingDirectory, defines.get ("CORDOVA_PATH") + "/lib/" + target + "/bin/create", [ targetPath, defines.get ("APP_PACKAGE"), defines.get ("APP_FILE") ]);
			
		//}
		
		switch (target) {
			
			case "ios":
				
				FileHelper.copyFile (NME + "/templates/cordova/ios/template/PROJ/PROJ-Info.plist", targetPath + "/" + defines.get ("APP_FILE") + "/" + defines.get ("APP_FILE") + "-Info.plist", context);
			
			case "blackberry":
				
				context.BLACKBERRY_AUTHOR_ID = BlackBerryHelper.processDebugToken (targetPath).authorID;
				FileHelper.recursiveCopy (NME + "/templates/cordova/blackberry/template", targetPath, context);
			
		}
		
	}
	
	
	public static function initialize (defines:Hash <String>, targetFlags:Hash <String>, target:String, NME:String):Void {
		
		CordovaHelper.defines = defines;
		CordovaHelper.NME = NME;
		CordovaHelper.target = target;
		CordovaHelper.targetFlags = targetFlags;
		
		switch (target) {
			
			case "ios":
				
				IOSHelper.initialize (defines, targetFlags, NME);
			
			case "blackberry":
				
				AntHelper.initialize (defines);
				BlackBerryHelper.initialize (defines, targetFlags);
			
			case "android":
				
				AndroidHelper.initialize (defines);
			
		}
		
	}
	
	
	public static function launch (workingDirectory:String, debug:Bool):Void {
		
		switch (target) {
		
			case "ios":
				
				IOSHelper.launch (workingDirectory, debug);
			
			case "blackberry":
				
				if (targetFlags.exists ("bbos")) {
		    		
		    		if (targetFlags.exists ("simulator")) {
		    			
		    			AntHelper.run (workingDirectory, [ "blackberry", "load-simulator" ]);
		    			
		    		} else {
		    			
		    			//AntHelper.run (workingDirectory, [ "blackberry", "clean-device" ]);
		    			AntHelper.run (workingDirectory, [ "blackberry", "load-device" ]);
		    			
		    		}
		    		
		    	} else {
					
					var safePackageName = StringTools.replace (defines.get ("APP_TITLE"), " ", "");
					//BlackBerryHelper.deploy (workingDirectory, "build/" + safePackageName + ".bar");
					
					if (targetFlags.exists ("simulator")) {
						
						BlackBerryHelper.deploy (workingDirectory, "build/simulator/" + safePackageName + ".bar");
						
					} else {
						
						BlackBerryHelper.deploy (workingDirectory, "build/device/" + safePackageName + ".bar");
						
					}
				
				}
			
			case "android":
				
				var build:String = "debug";
				
				if (defines.exists ("KEY_STORE")) {
					
					build = "release";
					
				}
				
				AndroidHelper.install (FileSystem.fullPath (workingDirectory) + "/bin/" + defines.get ("APP_FILE") + "-" + build + ".apk");
				AndroidHelper.run (defines.get ("APP_PACKAGE") + "/" + defines.get ("APP_PACKAGE") + "." + defines.get ("APP_FILE"));
			
		}
		
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
	
	
	public static function updateIcon (buildDirectory:String, icons:Icons, assets:Array <Asset>, context:Dynamic):Void {
		
		var iconCount = 0;
		var sizes = [];
		var targetPaths = [];
		
		switch (target) {
			
			case "blackberry":
				
				// 80 for BBOS?
				
				sizes = [ 86, 150 ];
				targetPaths = [ "res/icon/icon-86.png", "res/icon/icon-150.png" ];
			
			case "ios":
				
				sizes = [ 57, 114 , 72, 144 ];
				targetPaths = [ "../" + defines.get ("APP_FILE") + "/Resources/icons/icon.png", "../" + defines.get ("APP_FILE") + "/Resources/icons/icon@2x.png", "../" + defines.get ("APP_FILE") + "/Resources/icons/icon-72.png", "../" + defines.get ("APP_FILE") + "/Resources/icons/icon-72@2x.png" ];
			
			case "android":
				
				sizes = [ 36, 48, 72, 96 ];
				targetPaths = [ "res/drawable-ldpi/icon.png", "res/drawable-mdpi/icon.png", "res/drawable-hdpi/icon.png", "res/drawable-xhdpi/icon.png" ];
				
		}
		
		context.ICONS = [];
		for (i in 0...sizes.length) {
			
			var icon_name = icons.findIcon (sizes[i], sizes[i]);
			
			if (icon_name == "") {
				
				var tmpDir = buildDirectory + "/haxe";
				PathHelper.mkdir (tmpDir);
				var tmp_name = tmpDir + "/icon-" + sizes[i] + ".png";
				
				Sys.println (sizes[i]);
				
				if (icons.updateIcon (sizes[i], sizes[i], tmp_name)) {
					
					icon_name = tmp_name;
					
				}
				
			}
			
			if (icon_name != "") {
				
				assets.push (new Asset (icon_name, targetPaths[i], Asset.TYPE_IMAGE, Path.withoutDirectory (icon_name), "1"));
				context.APP_ICON = targetPaths[i];
				context.ICONS.push (targetPaths[i]);
				context.HAS_ICON = true;
				
			}
			
		}
		
	}
	

}
