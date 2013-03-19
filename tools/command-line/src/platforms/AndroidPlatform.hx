package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;


class AndroidPlatform implements IPlatformTool {
	
	
	public function build (project:NMEProject):Void {
		
		initialize (project);
		
		var destination = project.app.path + "/android/bin";
		var hxml = project.app.path + "/android/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
		
		var arm5 = project.app.path + "/android/bin/libs/armeabi/libApplicationMain.so";
		var arm7 = project.app.path + "/android/bin/libs/armeabi-v7a/libApplicationMain.so";
		
		if (ArrayHelper.containsValue (project.architectures, Architecture.ARMV6)) {
			
			ProcessHelper.runCommand ("", "haxe", [ hxml ] );
			FileHelper.copyIfNewer (project.app.path + "/android/obj/libApplicationMain" + (project.debug ? "-debug" : "") + ".so", arm5);
			
		} else {
			
			if (FileSystem.exists (arm5)) {
				
				FileSystem.deleteFile (arm5);
				
			}
			
		}
		
		if (ArrayHelper.containsValue (project.architectures, Architecture.ARMV7)) {
			
			ProcessHelper.runCommand ("", "haxe", [ hxml, "-D", "HXCPP_ARMV7" ] );
			FileHelper.copyIfNewer (project.app.path + "/android/obj/libApplicationMain-7" + (project.debug ? "-debug" : "") + ".so", arm7);
			
		} else {
			
			if (FileSystem.exists (arm7)) {
				
				FileSystem.deleteFile (arm7);
				
			}
			
		}
		
		AndroidHelper.build (project, destination);
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		var targetPath = project.app.path + "/android";
		
		if (FileSystem.exists (targetPath)) {
			
			PathHelper.removeDirectory (targetPath);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		var hxml = PathHelper.findTemplate (project.templatePaths, "android/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
		
		var context = project.templateContext;
		context.CPP_DIR = project.app.path + "/android/obj";
		
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (context));
		
	}
	
	
	public function install (project:NMEProject):Void {
		
		initialize (project);
		
		var build = "debug";
		
		if (project.certificate != null) {
			
			build = "release";
			
		}
		
		AndroidHelper.install (FileSystem.fullPath (project.app.path) + "/android/bin/bin/" + project.app.file + "-" + build + ".apk");
		
   }
	
	
	private function initialize (project:NMEProject):Void {
		
		if (!project.environment.exists ("ANDROID_SETUP")) {
			
			LogHelper.error ("You need to run \"nme setup android\" before you can use the Android target");
			
		}
		
		AndroidHelper.initialize (project);
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		initialize (project);
		
		AndroidHelper.run (project.meta.packageName + "/" + project.meta.packageName + ".MainActivity");
		
	}
	
	
	public function trace (project:NMEProject):Void {
		
		initialize (project);
		
		AndroidHelper.trace (project, project.debug);
		
	}
	
	
	public function uninstall (project:NMEProject):Void {
		
		initialize (project);
		
		AndroidHelper.uninstall (project.meta.packageName);
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		project = project.clone ();
		
		initialize (project);
		
		var destination = project.app.path + "/android/bin/";
		PathHelper.mkdir (destination);
		PathHelper.mkdir (destination + "/res/drawable-ldpi/");
		PathHelper.mkdir (destination + "/res/drawable-mdpi/");
		PathHelper.mkdir (destination + "/res/drawable-hdpi/");
		PathHelper.mkdir (destination + "/res/drawable-xhdpi/");
		
		for (asset in project.assets) {
			
			if (asset.type != AssetType.TEMPLATE) {
				
				var targetPath = "";
				
				switch (asset.type) {
					
					case SOUND, MUSIC:
						
						asset.resourceName = asset.id;
						targetPath = destination + "/res/raw/" + asset.flatName + "." + Path.extension (asset.targetPath);
					
					default:
						
						asset.resourceName = asset.flatName;
						targetPath = destination + "/assets/" + asset.resourceName;
					
				}
				
				FileHelper.copyAssetIfNewer (asset, targetPath);
				
			}
			
		}
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + project.app.path + "/android/types.xml");
			
		}
		
		var context = project.templateContext;
		
		context.CPP_DIR = project.app.path + "/android/obj";
		context.ANDROID_INSTALL_LOCATION = project.config.android.installLocation;
		
		var iconTypes = [ "ldpi", "mdpi", "hdpi", "xhdpi" ];
		var iconSizes = [ 36, 48, 72, 96 ];
		
		for (i in 0...iconTypes.length) {
			
			if (IconHelper.createIcon (project.icons, iconSizes[i], iconSizes[i], destination + "/res/drawable-" + iconTypes[i] + "/icon.png")) {
				
				context.HAS_ICON = true;
				
			}
			
		}
		
		IconHelper.createIcon (project.icons, 732, 412, destination + "/res/drawable-xhdpi/ouya_icon.png");
		
		var packageDirectory = project.meta.packageName;
		packageDirectory = destination + "/src/" + packageDirectory.split (".").join ("/");
		PathHelper.mkdir (packageDirectory);
		
		//SWFHelper.generateSWFClasses (project, project.app.path + "/android/haxe");
		
		for (ndll in project.ndlls) {
			
			FileHelper.copyLibrary (ndll, "Android", "lib", ".so", destination + "/libs/armeabi", project.debug);
			
		}
		
		for (javaPath in project.javaPaths) {
			
			try {
				
				if (FileSystem.isDirectory (javaPath)) {
					
					FileHelper.recursiveCopy (javaPath, destination + "/src", context, true);
					
				} else {
					
					if (Path.extension (javaPath) == "jar") {
						
						FileHelper.copyIfNewer (javaPath, destination + "/libs/" + Path.withoutDirectory (javaPath));
						
					} else {
						
						FileHelper.copyIfNewer (javaPath, destination + "/src/" + Path.withoutDirectory (javaPath));
						
					}
					
				}
				
			} catch (e:Dynamic) {}
				
			//	throw"Could not find javaPath " + javaPath +" required by extension."; 
				
			//}
			
		}
		
		FileHelper.recursiveCopyTemplate (project.templatePaths, "android/template", destination, context);
		FileHelper.copyFileTemplate (project.templatePaths, "android/MainActivity.java", packageDirectory + "/MainActivity.java", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", project.app.path + "/android/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "android/hxml", project.app.path + "/android/haxe", context);
		
		for (asset in project.assets) {
			
			if (asset.type == AssetType.TEMPLATE) {
				
				PathHelper.mkdir (Path.directory (destination + asset.targetPath));
				FileHelper.copyAsset (asset, destination + asset.targetPath, context);
				
			}
			
		}
		
	}
	
	
	public function new () {}
	
	
}
