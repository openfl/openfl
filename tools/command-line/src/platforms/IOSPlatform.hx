package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;
import PlatformConfig;


class IOSPlatform implements IPlatformTool {
	
	
	public function build (project:NMEProject):Void {
		
		var targetDirectory = PathHelper.combine (project.app.path, "ios");
		
		IOSHelper.build (project, project.app.path + "/ios");
		
        if (!project.targetFlags.exists ("simulator")) {
            
            var entitlements = targetDirectory + "/" + project.app.file + "/" + project.app.file + "-Entitlements.plist";
            
            IOSHelper.sign (project, targetDirectory + "/bin", entitlements);
            
        }
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		var targetPath = project.app.path + "/ios";
		
		if (FileSystem.exists (targetPath)) {
			
			PathHelper.removeDirectory (targetPath);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		var hxml = PathHelper.findTemplate (project.templatePaths, "iphone/PROJ/haxe/Build.hxml");
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (generateContext (project)));
		
	}
	
	
	private function generateContext (project:NMEProject):Dynamic {
		
		project = project.clone ();
		project.sources = PathHelper.relocatePaths (project.sources, PathHelper.combine (project.app.path, "ios/" + project.app.file + "/haxe"));
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + project.app.path + "/ios/types.xml");
			
		}
		
		var context = project.templateContext;
		
		context.HAS_ICON = false;
		context.HAS_LAUNCH_IMAGE = false;
		context.OBJC_ARC = false;
		
		context.linkedLibraries = [];
		
		for (dependency in project.dependencies) {
			
			if (!StringTools.endsWith (dependency, ".framework")) {
				
				context.linkedLibraries.push (dependency);
				
			}
			
		}
		
		/*var deployment = Std.parseFloat (iosDeployment);
		var binaries = iosBinaries;
		var devices = iosDevices;

		if (binaries != "fat" && binaries != "armv7" && binaries != "armv6") {
			
			InstallerBase.error ("iOS binaries must be one of: \"fat\", \"armv6\", \"armv7\"");
			
		}
		
		if (devices != "iphone" && devices != "ipad" && devices != "universal") {
			
			InstallerBase.error ("iOS devices must be one of: \"universal\", \"iphone\", \"ipad\"");
			
		}
		
		var iphone = (devices == "universal" || devices == "iphone");
		var ipad = (devices == "universal" || devices == "ipad");
		
		armv6 = ((iphone && deployment < 5.0 && Std.parseInt (defines.get ("IPHONE_VER")) < 6) || binaries == "armv7");
		armv7 = (binaries != "armv6" || !armv6 || ipad);
		
		var valid_archs = new Array <String> ();
		
		if (armv6) {
			
			valid_archs.push("armv6");
			
		}
		
		if (armv7) {
			
			valid_archs.push("armv7");
			
		}

		if (iosCompiler == "llvm" || iosCompiler == "clang") {
			
			context.OBJC_ARC = true;
			
		}*/
		
		var valid_archs = new Array <String> ();
		var armv6 = false;
		var armv7 = false;
		var architectures = project.architectures;
		
		if (architectures == null || architectures.length == 0) {
			
			architectures = [ Architecture.ARMV7 ];
			
		}
		
		if (project.config.ios.device == IOSConfigDevice.UNIVERSAL || project.config.ios.device == IOSConfigDevice.IPHONE) {
			
			if (project.config.ios.deployment < 5) {
				
				ArrayHelper.addUnique (architectures, Architecture.ARMV6);
				
			}
			
		}
		
		for (architecture in project.architectures) {
			
			switch (architecture) {
				
				case ARMV6: valid_archs.push ("armv6"); armv6 = true;
				case ARMV7: valid_archs.push ("armv7"); armv7 = true;
				default:
				
			}
			
		}
		
		context.CURRENT_ARCHS = "( " + valid_archs.join(",") + ") ";
		
		valid_archs.push ("i386");
		
		context.VALID_ARCHS = valid_archs.join(" ");
		context.THUMB_SUPPORT = armv6 ? "GCC_THUMB_SUPPORT = NO;" : "";
		
		var requiredCapabilities = [];
		
		if (armv7 && !armv6) {
			
			requiredCapabilities.push( { name: "armv7", value: true } );
			
		}
		
		context.REQUIRED_CAPABILITY = requiredCapabilities;
		context.ARMV6 = armv6;
		context.ARMV7 = armv7;
		context.TARGET_DEVICES = switch(project.config.ios.device) { case UNIVERSAL: "1,2"; case IPHONE : "1"; case IPAD : "2"; }
		context.DEPLOYMENT = project.config.ios.deployment;
		
		if (project.config.ios.compiler == "llvm" || project.config.ios.compiler == "clang") {
			
			context.OBJC_ARC = true;
			
		}
		
		context.IOS_COMPILER = project.config.ios.compiler;
		context.IOS_LINKER_FLAGS = project.config.ios.linkerFlags.split (" ").join (", ");
		
		switch (project.window.orientation) {
			
			case PORTRAIT:
				context.IOS_APP_ORIENTATION = "<array><string>UIInterfaceOrientationPortrait</string><string>UIInterfaceOrientationPortraitUpsideDown</string></array>";
			case LANDSCAPE:
				context.IOS_APP_ORIENTATION = "<array><string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string></array>";
			case ALL:
				context.IOS_APP_ORIENTATION = "<array><string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string><string>UIInterfaceOrientationPortrait</string><string>UIInterfaceOrientationPortraitUpsideDown</string></array>";
			//case "allButUpsideDown":
				//context.IOS_APP_ORIENTATION = "<array><string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string><string>UIInterfaceOrientationPortrait</string></array>";
			default:
				context.IOS_APP_ORIENTATION = "<array><string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string><string>UIInterfaceOrientationPortrait</string><string>UIInterfaceOrientationPortraitUpsideDown</string></array>";
			
		}
		
		context.ADDL_PBX_BUILD_FILE = "";
		context.ADDL_PBX_FILE_REFERENCE = "";
		context.ADDL_PBX_FRAMEWORKS_BUILD_PHASE = "";
		context.ADDL_PBX_FRAMEWORK_GROUP = "";
		
		for (dependency in project.dependencies) {
			
			if (Path.extension (dependency) == "framework") {
				
				var frameworkID = "11C0000000000018" + StringHelper.getUniqueID ();
				var fileID = "11C0000000000018" + StringHelper.getUniqueID ();
				
				context.ADDL_PBX_BUILD_FILE += "		" + frameworkID + " /* " + dependency + " in Frameworks */ = {isa = PBXBuildFile; fileRef = " + fileID + " /* " + dependency + " */; };\n";
				context.ADDL_PBX_FILE_REFERENCE += "		" + fileID + " /* " + dependency + " */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = " + dependency + "; path = System/Library/Frameworks/" + dependency + "; sourceTree = SDKROOT; };\n";
				context.ADDL_PBX_FRAMEWORKS_BUILD_PHASE += "				" + frameworkID + " /* " + dependency + " in Frameworks */,\n";
				context.ADDL_PBX_FRAMEWORK_GROUP += "				" + fileID + " /* " + dependency + " */,\n";
				
			}
			
		}
		
		context.HXML_PATH = PathHelper.findTemplate (project.templatePaths, "iphone/PROJ/haxe/Build.hxml");
		context.PRERENDERED_ICON = project.config.ios.prerenderedIcon;
		
		/*var assets = new Array <Asset> ();
		
		for (asset in project.assets) {
			
			var newAsset = asset.clone ();
			
			assets.push ();
			
		}*/
		
		//updateIcon ();
		//updateLaunchImage ();
		
		return context;
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		IOSHelper.launch (project, PathHelper.combine (project.app.path, "ios"));
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		project = project.clone ();
		
		var nmeLib = new Haxelib ("nme");
		
		project.ndlls.push (new NDLL ("curl_ssl", nmeLib, false));
		project.ndlls.push (new NDLL ("png", nmeLib, false));
		project.ndlls.push (new NDLL ("jpeg", nmeLib, false));
		
		for (asset in project.assets) {
			
			asset.resourceName = asset.flatName;
			
		}
		
		var context = generateContext (project);
		
		var targetDirectory = PathHelper.combine (project.app.path, "ios");
		var projectDirectory = targetDirectory + "/" + project.app.file + "/";
		
		PathHelper.mkdir (targetDirectory);
		PathHelper.mkdir (projectDirectory);
		PathHelper.mkdir (projectDirectory + "/haxe");
		PathHelper.mkdir (projectDirectory + "/haxe/nme/installer");
		
		var iconNames = [ "Icon.png", "Icon@2x.png", "Icon-72.png", "Icon-72@2x.png" ];
		var iconSizes = [ 57, 114, 72, 144 ];
		
		context.HAS_ICON = true;
		
		for (i in 0...iconNames.length) {
			
			if (!IconHelper.createIcon (project.icons, iconSizes[i], iconSizes[i], PathHelper.combine (projectDirectory, iconNames[i]))) {
				
				context.HAS_ICON = false;
				
			}
			
		}
		
		for (splashScreen in project.splashScreens) {
			
			FileHelper.copyFile (splashScreen.path, PathHelper.combine (projectDirectory, Path.withoutDirectory (splashScreen.path)));
			context.HAS_LAUNCH_IMAGE = true;
			
		}
		
		FileHelper.copyFileTemplate (project.templatePaths, "haxe/nme/AssetData.hx", projectDirectory + "/haxe/nme/AssetData.hx", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "iphone/PROJ/haxe", projectDirectory + "/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "iphone/PROJ/Classes", projectDirectory + "/Classes", context);
        FileHelper.copyFileTemplate (project.templatePaths, "iphone/PROJ/PROJ-Entitlements.plist", projectDirectory + "/" + project.app.file + "-Entitlements.plist", context);
		FileHelper.copyFileTemplate (project.templatePaths, "iphone/PROJ/PROJ-Info.plist", projectDirectory + "/" + project.app.file + "-Info.plist", context);
		FileHelper.copyFileTemplate (project.templatePaths, "iphone/PROJ/PROJ-Prefix.pch", projectDirectory + "/" + project.app.file + "-Prefix.pch", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "iphone/PROJ.xcodeproj", targetDirectory + "/" + project.app.file + ".xcodeproj", context);
		
		//SWFHelper.generateSWFClasses (project, projectDirectory + "/haxe");
		
		PathHelper.mkdir (projectDirectory + "/lib");
		
		for (archID in 0...3) {
			
			var arch = [ "armv6", "armv7", "i386" ][archID];
			
			if (arch == "armv6" && !context.ARMV6)
				continue;
			
			if (arch == "armv7" && !context.ARMV7)
				continue;
			
			var libExt = [ ".iphoneos.a", ".iphoneos-v7.a", ".iphonesim.a" ][archID];
			
			PathHelper.mkdir (projectDirectory + "/lib/" + arch);
			PathHelper.mkdir (projectDirectory + "/lib/" + arch + "-debug");
			
			for (ndll in project.ndlls) {
				
				if (ndll.haxelib != null) {
					
					var releaseLib = PathHelper.getLibraryPath (ndll, "iPhone", "lib", libExt);
					var debugLib = PathHelper.getLibraryPath (ndll, "iPhone", "lib", libExt);
					var releaseDest = projectDirectory + "/lib/" + arch + "/lib" + ndll.name + ".a";
					var debugDest = projectDirectory + "/lib/" + arch + "-debug/lib" + ndll.name + ".a";
					
					FileHelper.copyIfNewer (releaseLib, releaseDest);
					
					if (FileSystem.exists (debugLib)) {
						
						FileHelper.copyIfNewer (debugLib, debugDest);
						
					} else if (FileSystem.exists (debugDest)) {
						
						FileSystem.deleteFile (debugDest);
						
					}
					
				}
				
			}
			
		}
		
		PathHelper.mkdir (projectDirectory + "/assets");
		
		for (asset in project.assets) {
			
			if (asset.type != AssetType.TEMPLATE) {
				
				PathHelper.mkdir (Path.directory (projectDirectory + "/assets/" + asset.flatName));
				FileHelper.copyIfNewer (asset.sourcePath, projectDirectory + "/assets/" + asset.flatName);
				FileHelper.copyIfNewer (asset.sourcePath, projectDirectory + "haxe/" + asset.sourcePath);
				
			} else {
				
				PathHelper.mkdir (Path.directory (projectDirectory + "/" + asset.targetPath));
				FileHelper.copyAsset (asset, projectDirectory + "/" + asset.targetPath, context);
				
			}
			
		}
        
        if (project.command == "update" && PlatformHelper.hostPlatform == Platform.MAC) {
            
            ProcessHelper.runCommand ("", "open", [ targetDirectory + "/" + project.app.file + ".xcodeproj" ] );
            
        }
		
	}
	
	
	/*private function updateLaunchImage () {
		
		var destination = buildDirectory + "/ios";
		PathHelper.mkdir (destination);
		
		var has_launch_image = false;
		if (launchImages.length > 0) has_launch_image = true;

		for (launchImage in launchImages) {
			
			var splitPath = launchImage.name.split ("/");
			var path = destination + "/" + splitPath[splitPath.length - 1];
			FileHelper.copyFile (launchImage.name, path, context, false);
			
		}

		context.HAS_LAUNCH_IMAGE = has_launch_image;
		
	}*/
	
	
	public function new () {}
	@ignore public function install (project:NMEProject):Void {}
	@ignore public function trace (project:NMEProject):Void {}
	@ignore public function uninstall (project:NMEProject):Void {}
	
	
}