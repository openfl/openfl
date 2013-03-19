package utils;


import haxe.Http;
import haxe.io.Eof;
import haxe.io.Path;
import haxe.zip.Reader;
import neko.Lib;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;


class PlatformSetup {
	
	
	private static var airMacPath = "http://airdownload.adobe.com/air/mac/download/latest/AdobeAIRSDK.tbz2";
	private static var airWindowsPath = "http://airdownload.adobe.com/air/win/download/latest/AdobeAIRSDK.zip";
	private static var androidLinuxNDKPath = "http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2";
	private static var androidLinuxSDKPath = "http://dl.google.com/android/android-sdk_r20.0.3-linux.tgz";
	private static var androidMacNDKPath = "http://dl.google.com/android/ndk/android-ndk-r8b-darwin-x86.tar.bz2";
	private static var androidMacSDKPath = "http://dl.google.com/android/android-sdk_r20.0.3-macosx.zip";
	private static var androidWindowsNDKPath = "http://dl.google.com/android/ndk/android-ndk-r8b-windows.zip";
	private static var androidWindowsSDKPath = "http://dl.google.com/android/android-sdk_r20.0.3-windows.zip";
	private static var apacheAntUnixPath = "http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz";
	private static var apacheAntWindowsPath = "http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.zip";
	private static var apacheCordovaPath = "http://www.apache.org/dist/incubator/cordova/cordova-2.1.0-incubating-src.zip";
	private static var appleXcodeURL = "http://developer.apple.com/xcode/";
	private static var blackBerryCodeSigningURL = "https://www.blackberry.com/SignedKeys/";
	private static var blackBerryLinuxNativeSDKPath = "http://developer.blackberry.com/native/downloads/fetch/installer-bbndk-2.1.0-linux-1032-201209271809-201209280007.bin";
	private static var blackBerryMacNativeSDKPath = "http://developer.blackberry.com/native/downloads/fetch/installer-bbndk-2.1.0-macosx-1032-201209271809-201209280007.dmg";
	private static var blackBerryMacWebWorksSDKPath = "https://developer.blackberry.com/html5/downloads/fetch/BB10-WebWorks-SDK_1.0.4.7.zip";
	private static var blackBerryWindowsNativeSDKPath = "http://developer.blackberry.com/native/downloads/fetch/installer-bbndk-2.1.0-win32-1032-201209271809-201209280007.exe";
	private static var blackBerryWindowsWebWorksSDKPath = "https://developer.blackberry.com/html5/downloads/fetch/BB10-WebWorks-SDK_1.0.4.7.exe";
	private static var codeSourceryWindowsPath = "http://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-2009q1-203-arm-none-linux-gnueabi.exe";
	private static var javaJDKURL = "http://www.oracle.com/technetwork/java/javase/downloads/jdk6u37-downloads-1859587.html";
	private static var linuxX64Packages = "ia32-libs-multiarch gcc-multilib g++-multilib";
	private static var webOSLinuxX64NovacomPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.4.669/sdkBinaries/palm-novacom_1.0.80_amd64.deb";
	private static var webOSLinuxX86NovacomPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.4.669/sdkBinaries/palm-novacom_1.0.80_i386.deb";
	private static var webOSLinuxSDKPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.5.676/sdkBinaries/palm-sdk_3.0.5-svn528736-pho676_i386.deb";
	private static var webOSMacSDKPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.5.676/sdkBinaries/Palm_webOS_SDK.3.0.5.676.dmg";
	private static var webOSWindowsX64SDKPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.5.676/sdkBinaries/HP_webOS_SDK-Win-3.0.5-676-x64.exe";
	private static var webOSWindowsX86SDKPath = "http://cdn.downloads.palm.com/sdkdownloads/3.0.5.676/sdkBinaries/HP_webOS_SDK-Win-3.0.5-676-x86.exe";
	private static var windowsVisualStudioCPPPath = "http://download.microsoft.com/download/1/D/9/1D9A6C0E-FC89-43EE-9658-B9F0E3A76983/vc_web.exe";

	private static var backedUpConfig:Bool = false;
	private static var nme:String;
	private static var triedSudo:Bool = false;
	
   static inline function readLine()
   {
		return Sys.stdin ().readLine ();
   }
	
	private static function ask (question:String):Answer {
		
		while (true) {
			
			Lib.print (question + " [y/n/a] ? ");
			
			switch (readLine ()) {
				case "n": return No;
				case "y": return Yes;
				case "a": return Always;
			}
			
		}
		
		return null;
		
	}
	
	
	private static function createPath (path:String, defaultPath:String = ""):String {
		
		try {
			
			if (path == "") {
				
				PathHelper.mkdir (defaultPath);
				return defaultPath;
				
			} else {
				
				PathHelper.mkdir (path);
				return path;
				
			}
			
		} catch (e:Dynamic) {
			
			throwPermissionsError ();
			return "";
			
		}
		
	}
	
	
	private static function downloadFile (remotePath:String, localPath:String = "", followingLocation:Bool = false):Void {
		
		if (localPath == "") {
			
			localPath = Path.withoutDirectory (remotePath);
			
		}
		
		if (!followingLocation && FileSystem.exists (localPath)) {
			
			var answer = ask ("File found. Install existing file?");
			
			if (answer != No) {
				
				return;
				
			}
			
		}
		
		var out = File.write (localPath, true);
		var progress = new Progress (out);
		var h = new Http (remotePath);
		
		h.onError = function (e) {
			progress.close();
			FileSystem.deleteFile (localPath);
			throw e;
		};
		
		if (!followingLocation) {
			
			Lib.println ("Downloading " + localPath + "...");
			
		}
		
		h.customRequest (false, progress);
		
		if (h.responseHeaders != null && h.responseHeaders.exists ("Location")) {
			
			var location = h.responseHeaders.get ("Location");
			
			if (location != remotePath) {
				
				downloadFile (location, localPath, true);
				
			}
			
		}
		
	}
	
	
	private static function extractFile (sourceZIP:String, targetPath:String, ignoreRootFolder:String = ""):Void {
		
		var extension = Path.extension (sourceZIP);
		
		if (extension != "zip") {
			
			var arguments = "xvzf";			
						
			if (extension == "bz2" || extension == "tbz2") {
				
				arguments = "xvjf";
				
			}	
			
			if (ignoreRootFolder != "") {
				
				if (ignoreRootFolder == "*") {
					
					for (file in FileSystem.readDirectory (targetPath)) {
						
						if (FileSystem.isDirectory (targetPath + "/" + file)) {
							
							ignoreRootFolder = file;
							
						}
						
					}
					
				}
				
				ProcessHelper.runCommand ("", "tar", [ arguments, sourceZIP ], false);
				ProcessHelper.runCommand ("", "cp", [ "-R", ignoreRootFolder + "/*", targetPath ], false);
				Sys.command ("rm", [ "-r", ignoreRootFolder ]);
				
			} else {
				
				ProcessHelper.runCommand ("", "tar", [ arguments, sourceZIP, "-C", targetPath ], false);
				
				//InstallTool.runCommand (targetPath, "tar", [ arguments, FileSystem.fullPath (sourceZIP) ]);
				
			}
			
			Sys.command ("chmod", [ "-R", "755", targetPath ]);
			
		} else {
			
			var file = File.read (sourceZIP, true);
			var entries = Reader.readZip (file);
			file.close ();
		
			for (entry in entries) {
			
				var fileName = entry.fileName;
			
				if (fileName.charAt (0) != "/" && fileName.charAt (0) != "\\" && fileName.split ("..").length <= 1) {
				
					var dirs = ~/[\/\\]/g.split(fileName);
				
					if ((ignoreRootFolder != "" && dirs.length > 1) || ignoreRootFolder == "") {
					
						if (ignoreRootFolder != "") {
						
							dirs.shift ();
						
						}
					
						var path = "";
						var file = dirs.pop();
						for( d in dirs ) {
							path += d;
							PathHelper.mkdir (targetPath + "/" + path);
							path += "/";
						}
					
						if( file == "" ) {
							if( path != "" ) Lib.println("  Created "+path);
							continue; // was just a directory
						}
						path += file;
						Lib.println ("  Install " + path);
					
						var data = Reader.unzip (entry);
						var f = File.write (targetPath + "/" + path, true);
						f.write (data);
						f.close ();
					
					}
				
				}
			
			}
			
		}
		
		Lib.println ("Done");
		
	}
	
	
	private static function getDefines (names:Array <String> = null, descriptions:Array <String> = null, ignored:Array <String> = null):Map <String, String> {
		
		var config = CommandLineTools.getHXCPPConfig ();
		
		var defines = config.environment;
		var env = Sys.environment ();
		var path = "";
		
		if (!defines.exists ("HXCPP_CONFIG")) {
			
			var home = "";
			
			if (env.exists ("HOME")) {
				
				home = env.get ("HOME");
				
			} else if (env.exists ("USERPROFILE")) {
				
				home = env.get ("USERPROFILE");
				
			} else {
				
				Lib.println ("Warning : No 'HOME' variable set - .hxcpp_config.xml might be missing.");
				
				return null;
				
			}
			
			defines.set ("HXCPP_CONFIG", home + "/.hxcpp_config.xml");
			
		}
		
		if (names == null) {
			
			return defines;
			
		}
		
		var values = new Array <String> ();
		
		for (i in 0...names.length) {
			
			var name = names[i];
			var description = descriptions[i];
			
			var ignore = "";
			
			if (ignored != null && ignored.length > i) {
				
				ignore = ignored[i];
				
			}
			
			var value = "";
			
			if (defines.exists (name) && defines.get (name) != ignore) {
				
				value = defines.get (name);
				
			} else if (env.exists (name)) {
				
				value = Sys.getEnv (name);
				
			}
			
			value = unescapePath (param (description + " [" + value + "]"));
			
			if (value != "") {
				
				defines.set (name, value);
				
			} else if (value == Sys.getEnv (name)) {
				
				defines.remove (name);
				
			}
			
		}
		
		return defines;
		
	}
	
	
	public static function installNME ():Void {
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			var haxePath = Sys.getEnv ("HAXEPATH");
			
			if (haxePath == null || haxePath == "") {
				
				haxePath = "C:\\Motion-Twin\\haxe\\";
				
			}
			
			File.copy (CommandLineTools.nme + "\\tools\\command-line\\bin\\nme.bat", haxePath + "\\nme.bat");
			
		} else {
			
			File.copy (CommandLineTools.nme + "/tools/command-line/bin/nme.sh", "/usr/lib/haxe/nme");
			Sys.command ("chmod", [ "755", "/usr/lib/haxe/nme" ]);
			link ("haxe", "nme", "/usr/bin");
			
		}
		
		if (PlatformHelper.hostPlatform == Platform.MAC) {
			
			var defines = getDefines ();
			defines.set ("MAC_USE_CURRENT_SDK", "1");
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			
		}
		
	}
	
	
	private static function link (dir:String, file:String, dest:String):Void {
		
		Sys.command("rm -rf " + dest + "/" + file);
		Sys.command("ln -s " + "/usr/lib" +"/" + dir + "/" + file + " " + dest + "/" + file);
		
	}
	
	
	inline static function getChar () {
		
	   return Sys.getChar(false);
	   
	}
   
   
	private static function openURL (url:String):Void {
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			Sys.command ("explorer", [ url ]);
			
		} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
			
			ProcessHelper.runCommand ("", "xdg-open", [ url ], false);
			
		} else {
			
			ProcessHelper.runCommand ("", "open", [ url ], false);
			
		}
		
   }
	
	
	private static function param (name:String, ?passwd:Bool):String {
		
		Lib.print (name + ": ");
		
		if (passwd) {
			var s = new StringBuf ();
			var c;
			while ((c = getChar ()) != 13)
				s.addChar (c);
			Lib.print ("");
			Sys.println ("");
			
			return s.toString ();
		}
		
		try {
			
			return readLine ();
			
		} catch (e:Eof) {
			
			return "";
			
		}
		
	}
	
	
	public static function run (target:String = "") {
		
		try {
			
			switch (target) {
				
				//case "air":
					
					//setupAIR ();
				
				case "android":
					
					setupAndroid ();
				
				case "blackberry":
					
					setupBlackBerry ();
				
				//case "html5":
					
					//setupHTML5 ();
				
				case "ios":
					
					if (PlatformHelper.hostPlatform == Platform.MAC) {
						
						setupMac ();
						
					}
				
				case "linux":
					
					if (PlatformHelper.hostPlatform == Platform.LINUX) {
						
						setupLinux ();
						
					}
				
				case "mac":
					
					if (PlatformHelper.hostPlatform == Platform.MAC) {
						
						setupMac ();
						
					}
				
				case "webos":
					
					setupWebOS ();
				
				case "windows":
					
					if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
						
						setupWindows ();
						
					}
				
				case "":
					
					installNME ();
				
				default:
					
					Lib.println ("No setup is required for " + target + ", or it is not a valid target");
					return;
				
			}
			
		} catch (e:Eof) {
			
			
			
		}
		
	}
	
	
	private static function runInstaller (path:String, message:String = "Waiting for process to complete..."):Void {
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			try {
				
				Lib.println (message);
				ProcessHelper.runCommand ("", "call", [ path ], false);
				Lib.println ("Done");
				
			} catch (e:Dynamic) {}
			
		} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
			
			if (Path.extension (path) == "deb") {
				
				ProcessHelper.runCommand ("", "sudo", [ "dpkg", "-i", "--force-architecture", path ], false);
				
			} else {
				
				Lib.println (message);
				Sys.command ("chmod", [ "755", path ]);
				ProcessHelper.runCommand ("", path, [], false);
				Lib.println ("Done");
				
			}
			
		} else {
			
			if (Path.extension (path) == "") {
				
				Lib.println (message);
				Sys.command ("chmod", [ "755", path ]);
				ProcessHelper.runCommand ("", path, [], false);
				Lib.println ("Done");
				
			} else if (Path.extension (path) == "dmg") {
				
				var process = new Process("hdiutil", [ "mount", path ]);
				var ret = process.stdout.readAll().toString();
				process.exitCode(); //you need this to wait till the process is closed!
				process.close();
				
				var volumePath = "";
				
				if (ret != null && ret != "") {
					
					volumePath = StringTools.trim (ret.substr (ret.indexOf ("/Volumes")));
					
				}
				
				if (volumePath != "" && FileSystem.exists (volumePath)) {
					
					var apps = [];
					var packages = [];
					var executables = [];
					
					var files:Array <String> = FileSystem.readDirectory (volumePath);
					
					for (file in files) {
						
						switch (Path.extension (file)) {
							
							case "app":
								
								apps.push (file);
								
							case "pkg", "mpkg":
								
								packages.push (file);
							
							case "bin":
								
								executables.push (file);
							
						}
						
					}
					
					var file = "";
					
					if (apps.length == 1) {
						
						file = apps[0];
						
					} else if (packages.length == 1) {
						
						file = packages[0];
						
					} else if (executables.length == 1) {
						
						file = executables[0];
						
					}
					
					if (file != "") {
						
						Lib.println (message);
						ProcessHelper.runCommand ("", "open", [ "-W", volumePath + "/" + file ], false);
						Lib.println ("Done");
						
					}
					
					try {
						
						var process = new Process("hdiutil", [ "unmount", path ]);
						process.exitCode(); //you need this to wait till the process is closed!
						process.close();
						
					} catch (e:Dynamic) {
					
					}
					
					if (file == "") {
						
						ProcessHelper.runCommand ("", "open", [ path ], false);
						
					}
					
				} else {
					
					ProcessHelper.runCommand ("", "open", [ path ], false);
					
				}
				
			} else {
				
				ProcessHelper.runCommand ("", "open", [ path ], false);
				
			}
			
		}
		
	}
	
	
	public static function setupAIR ():Void {
		
		var setAIRSDK = false;
		var defines = getDefines ();
		var answer = ask ("Download and install the Adobe AIR SDK?");
		
		if (answer == Yes || answer == Always) {
			
			var downloadPath = "";
			var defaultInstallPath = "";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				downloadPath = airWindowsPath;
				defaultInstallPath = "C:\\Development\\Android SDK";
				
			} else if (PlatformHelper.hostPlatform == Platform.MAC) {
				
				downloadPath = airMacPath;
				defaultInstallPath = "/opt/air-sdk";
				
			}

			downloadFile (downloadPath);
			
			var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
			path = createPath (path, defaultInstallPath);
			
			extractFile (Path.withoutDirectory (downloadPath), path, "");
			
			setAIRSDK = true;
			defines.set ("AIR_SDK", path);
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			Lib.println ("");
			
		}
		
		var requiredVariables = new Array <String> ();
		var requiredVariableDescriptions = new Array <String> ();
		
		if (!setAIRSDK) {
			
			requiredVariables.push ("AIR_SDK");
			requiredVariableDescriptions.push ("Path to AIR SDK");
			
		}
		
		if (!setAIRSDK) {
			
			Lib.println ("");
			
		}
		
		var defines = getDefines (requiredVariables, requiredVariableDescriptions, null);
		
		if (defines != null) {
			
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			
		}
		
		ProcessHelper.runCommand ("", "haxelib", [ "install", "air3" ], true, true);
		
	}
	
	
	public static function setupAndroid ():Void {
		
		var setAndroidSDK = false;
		var setAndroidNDK = false;
		var setApacheAnt = false;
		var setJavaJDK = false;
		
		var defines = getDefines ();
		var answer = ask ("Download and install the Android SDK?");
		
		if (answer == Yes || answer == Always) {
			
			var downloadPath = "";
			var defaultInstallPath = "";
			var ignoreRootFolder = "android-sdk";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				downloadPath = androidWindowsSDKPath;
				defaultInstallPath = "C:\\Development\\Android SDK";
			
			} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
				
				downloadPath = androidLinuxSDKPath;
				defaultInstallPath = "/opt/android-sdk";
				ignoreRootFolder = "android-sdk-linux";
				
			} else if (PlatformHelper.hostPlatform == Platform.MAC) {
				
				downloadPath = androidMacSDKPath;
				defaultInstallPath = "/opt/android-sdk";
				ignoreRootFolder = "android-sdk-mac";
				
			}

			downloadFile (downloadPath);
			
			var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
			path = createPath (path, defaultInstallPath);
			
			extractFile (Path.withoutDirectory (downloadPath), path, ignoreRootFolder);
			
			if (PlatformHelper.hostPlatform != Platform.WINDOWS) {
				
				ProcessHelper.runCommand ("", "chmod", [ "-R", "777", path ], false);
				
			}
			
			Lib.println ("Launching the Android SDK Manager to install packages");
			Lib.println ("Please install Android API 8 and SDK Platform-tools");
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				runInstaller (path + "/SDK Manager.exe");
				
			} else {
				
				runInstaller (path + "/tools/android");
				
			}
			
			if (PlatformHelper.hostPlatform != Platform.WINDOWS && FileSystem.exists (Sys.getEnv ("HOME") + "/.android")) {
				
				ProcessHelper.runCommand ("", "chmod", [ "-R", "777", "~/.android" ], false);
				ProcessHelper.runCommand ("", "cp", [ CommandLineTools.nme + "/tools/command-line/bin/debug.keystore", "~/.android/debug.keystore" ], false);
				
			}
			
			setAndroidSDK = true;
			defines.set ("ANDROID_SDK", path);
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			Lib.println ("");
			
		}
		
		if (answer == Always) {
			
			Lib.println ("Download and install the Android NDK? [y/n/a] a");
			
		} else {
			
			answer = ask ("Download and install the Android NDK?");
			
		}
		
		if (answer == Yes || answer == Always) {
			
			var downloadPath = "";
			var defaultInstallPath = "";
			var ignoreRootFolder = "android-ndk-r8b";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				downloadPath = androidWindowsNDKPath;
				defaultInstallPath = "C:\\Development\\Android NDK";
				
			} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
				
				downloadPath = androidLinuxNDKPath;
				defaultInstallPath = "/opt/android-ndk";
				
			} else {
				
				downloadPath = androidMacNDKPath;
				defaultInstallPath = "/opt/android-ndk";
				
			}
			
			downloadFile (downloadPath);
			
			var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
			path = createPath (path, defaultInstallPath);
			
			extractFile (Path.withoutDirectory (downloadPath), path, ignoreRootFolder);
			
			setAndroidNDK = true;
			defines.set ("ANDROID_NDK_ROOT", path);
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			Lib.println ("");
			
		}
		
		if (PlatformHelper.hostPlatform != Platform.MAC) {
			
			if (answer == Always) {
				
				Lib.println ("Download and install Apache Ant? [y/n/a] a");
			
			} else {
				
				answer = ask ("Download and install Apache Ant?");
			
			}
			
			if (answer == Yes || answer == Always) {
				
				var downloadPath = "";
				var defaultInstallPath = "";
				var ignoreRootFolder = "apache-ant-1.8.4";
			
				if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
					
					downloadPath = apacheAntWindowsPath;
					defaultInstallPath = "C:\\Development\\Apache Ant";
				
				} else {
					
					downloadPath = apacheAntUnixPath;
					defaultInstallPath = "/opt/apache-ant";
					
				}
				
				downloadFile (downloadPath);
				
				var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
				path = createPath (path, defaultInstallPath);
				
				extractFile (Path.withoutDirectory (downloadPath), path, ignoreRootFolder);
				
				setApacheAnt = true;
				defines.set ("ANT_HOME", path);
				writeConfig (defines.get ("HXCPP_CONFIG"), defines);
				
			}
			
			if (answer == Always) {
			
				Lib.println ("Download and install the Java JDK? [y/n/a] a");
			
			} else {
			
				answer = ask ("Download and install the Java JDK?");
			
			}
		
			if (answer == Yes || answer == Always) {
			
				Lib.println ("You must visit the Oracle website to download the Java 6 JDK for your platform");
				var secondAnswer = ask ("Would you like to go there now?");
			
				if (secondAnswer != No) {
					
					openURL (javaJDKURL);
					
				}
				
				Lib.println ("");
			
			}
			
		}
			
		var requiredVariables = new Array <String> ();
		var requiredVariableDescriptions = new Array <String> ();
		var ignoreValues = new Array <String> ();
		
		if (!setAndroidSDK) {
			
			requiredVariables.push ("ANDROID_SDK");
			requiredVariableDescriptions.push ("Path to Android SDK");
			ignoreValues.push ("/SDKs//android-sdk");
			
		}
		
		if (!setAndroidNDK) {
			
			requiredVariables.push ("ANDROID_NDK_ROOT");
			requiredVariableDescriptions.push ("Path to Android NDK");
			ignoreValues.push ("/SDKs//android-ndk-r6");
			
		}
		
		if (PlatformHelper.hostPlatform != Platform.MAC && !setApacheAnt) {
			
			requiredVariables.push ("ANT_HOME");
			requiredVariableDescriptions.push ("Path to Apache Ant");
			ignoreValues.push ("/SDKs//ant");
			
		}
		
		if (PlatformHelper.hostPlatform != Platform.MAC && !setJavaJDK) {
			
			requiredVariables.push ("JAVA_HOME");
			requiredVariableDescriptions.push ("Path to Java JDK");
			ignoreValues.push ("/SDKs//java_jdk");
			
		}
		
		if (!setAndroidSDK && !setAndroidNDK && !setApacheAnt) {
			
			Lib.println ("");
			
		}
		
		var defines = getDefines (requiredVariables, requiredVariableDescriptions, ignoreValues);
		
		if (defines != null) {
			
			defines.set ("ANDROID_SETUP", "true");
			
			if (PlatformHelper.hostPlatform == Platform.MAC) {
				
				defines.remove ("ANT_HOME");
				defines.remove ("JAVA_HOME");
				
			}
			
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			
		}
		
	}
	
	
	public static function setupBlackBerry ():Void {
		
		var answer = ask ("Download and install the BlackBerry Native SDK?");
		
		if (answer == Yes || answer == Always) {
			
			var downloadPath = "";
			var defaultInstallPath = "";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				downloadPath = blackBerryWindowsNativeSDKPath;
				//defaultInstallPath = "C:\\Development\\Android NDK";
				
			} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
				
				downloadPath = blackBerryLinuxNativeSDKPath;
				//defaultInstallPath = "/opt/Android NDK";
				
			} else {
				
				downloadPath = blackBerryMacNativeSDKPath;
				//defaultInstallPath = "/opt/Android NDK";
				
			}
			
			downloadFile (downloadPath);
			runInstaller (Path.withoutDirectory (downloadPath));
			Lib.println ("");
			
			/*var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
			path = createPath (path, defaultInstallPath);
			
			extractFile (Path.withoutDirectory (downloadPath), path, ignoreRootFolder);
			
			setAndroidNDK = true;
			defines.set ("ANDROID_NDK_ROOT", path);
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			Lib.println ("");*/
			
		}
		
		var defines = getDefines ([ "BLACKBERRY_NDK_ROOT" ], [ "Path to BlackBerry Native SDK" ]);
		
		if (defines != null) {
			
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			
		}
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			if (answer == Always) {
				
				Lib.println ("Download and install the BlackBerry WebWorks SDK? [y/n/a] a");
			
			} else {
				
				answer = ask ("Download and install the BlackBerry WebWorks SDK?");
			
			}
			
			if (answer == Always || answer == Yes) {
				
				var downloadPath = "";
				var defaultInstallPath = "";
				
				if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
					
					downloadPath = blackBerryWindowsWebWorksSDKPath;
					//defaultInstallPath = "C:\\Development\\Android NDK";
					
				} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
					
					//downloadPath = blackBerryLinuxWebWorksSDKPath;
					//defaultInstallPath = "/opt/Android NDK";
					
				} else {
					
					downloadPath = blackBerryMacWebWorksSDKPath;
					//defaultInstallPath = "/opt/Android NDK";
					
				}
				
				downloadFile (downloadPath);
				runInstaller (Path.withoutDirectory (downloadPath));
				Lib.println ("");
				
				/*var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
				path = createPath (path, defaultInstallPath);
				
				extractFile (Path.withoutDirectory (downloadPath), path, ignoreRootFolder);
				
				setAndroidNDK = true;
				defines.set ("ANDROID_NDK_ROOT", path);
				writeConfig (defines.get ("HXCPP_CONFIG"), defines);
				Lib.println ("");*/
				
			}
			
			var defines = getDefines ([ "BLACKBERRY_WEBWORKS_SDK" ], [ "Path to BlackBerry WebWorks SDK" ]);
			
			if (defines != null) {
				
				writeConfig (defines.get ("HXCPP_CONFIG"), defines);
				
			}
			
		}
		
		var binDirectory = "";
		
		try {
			
			if (defines.exists ("BLACKBERRY_NDK_ROOT") && (!defines.exists("QNX_HOST") || !defines.exists("QNX_TARGET"))) {
				
				var fileName = defines.get ("BLACKBERRY_NDK_ROOT");
				
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
								
								defines.set(name,value);
								
						}
						
					}
					
				} catch (ex:Eof) {}
				
				fin.close();
				
			}
			
		} catch (e:Dynamic) {
			
			Lib.println ("Error: Path to BlackBerry Native SDK appears to be invalid");
			
		}
		
		binDirectory = defines.get ("QNX_HOST") + "/usr/bin/";
		
		if (answer == Always) {
			
			Lib.println ("Configure a BlackBerry device? [y/n/a] a");
			
		} else {
			
			answer = ask ("Configure a BlackBerry device?");
			
		}
		
		var debugTokenPath:String = null;
		
		if (answer == Yes || answer == Always) {

			var secondAnswer = ask ("Do you have a valid debug token?");
			
			if (secondAnswer == No) {
				
				secondAnswer = ask ("Have you requested code signing keys?");
				
				if (secondAnswer == No) {
					
					secondAnswer = ask ("Would you like to request them now?");
					
					if (secondAnswer != No) {
						
						openURL (blackBerryCodeSigningURL);
						
					}
					
					Lib.println ("");
					Lib.println ("It can take up to two hours for code signing keys to arrive");
					Lib.println ("Please run \"nme setup blackberry\" again at that time");
					Sys.exit (0);
					
				} else {
					
					secondAnswer = ask ("Have you created a keystore file?");
					
					var cskPassword:String = null;
					var keystorePath:String = null;
					var keystorePassword:String = null;
					var outputPath:String = null;
					
					if (secondAnswer == No) {
						
						var pbdtFile = unescapePath (param ("Path to client-PBDT-*.csj file"));
						var rdkFile = unescapePath (param ("Path to client-RDK-*.csj file"));
						var cskPIN = param ("Code signing key PIN");
						cskPassword = param ("Code signing key password", true);
						
						Lib.println ("Registering code signing keys...");
						
						try {
							
							ProcessHelper.runCommand ("", binDirectory + "blackberry-signer", [ "-csksetup", "-cskpass", cskPassword ], false);
							
						} catch (e:Dynamic) { }
						
						try {
							
							ProcessHelper.runCommand ("", binDirectory + "blackberry-signer", [ "-register", "-cskpass", cskPassword, "-csjpin", cskPIN, pbdtFile ], false);
							ProcessHelper.runCommand ("", binDirectory + "blackberry-signer", [ "-register", "-cskpass", cskPassword, "-csjpin", cskPIN, rdkFile ], false);
							
							Lib.println ("Done.");
							
						} catch (e:Dynamic) {}
						
						keystorePassword = param ("Keystore password", true);
						var companyName = param ("Company name");
						outputPath = unescapePath (param ("Output directory"));
						keystorePath = outputPath + "/author.p12";
						
						Lib.println ("Creating keystore...");
						
						try {
							
							ProcessHelper.runCommand ("", binDirectory + "blackberry-keytool", [ "-genkeypair", "-keystore", keystorePath, "-storepass", keystorePassword, "-dname", "cn=(" + companyName + ")", "-alias", "author" ], false);
							
							Lib.println ("Done.");
							
						} catch (e:Dynamic) {
							
							Sys.exit (1);
							
						}
						
					}
					
					var names:Array<String> = [];
					var descriptions:Array<String> = [];
					
					if (cskPassword == null) {
						
						cskPassword = param ("Code signing key password", true);
						
					}
					
					if (keystorePath == null) {
						
						keystorePath = unescapePath (param ("Path to keystore (*.p12) file"));
						
					}
					
					if (keystorePassword == null) {
						
						keystorePassword = param ("Keystore password", true);
						
					}
					
					var deviceIDs = [];
					var defines = getDefines ();
					
					var config = CommandLineTools.getHXCPPConfig ();
					
					BlackBerryHelper.initialize (config);
					var token = BlackBerryHelper.processDebugToken (config);
					
					if (token != null) {
						
						for (deviceID in token.deviceIDs) {
							
							if (ask ("Would you like to add existing device PIN \"" + deviceID + "\"?") != No) {
								
								deviceIDs.push ("0x" + deviceID);
								
							}
							
						}
						
					}
					
					if (deviceIDs.length == 0) {
						
						deviceIDs.push ("0x" + param ("Device PIN"));
						
					}
					
					while (ask ("Would you like to add another device PIN?") != No) {
						
						var pin = param ("Device PIN");
						
						if (pin != null && pin != "") {
							
							deviceIDs.push ("0x" + pin);
							
						}
						
					}
					
					if (outputPath == null) {
						
						outputPath = unescapePath (param ("Output directory"));
						
					}
					
					debugTokenPath = outputPath + "/debugToken.bar";
					
					Lib.println ("Requesting debug token...");
					
					try {
						
						var params = [ "-cskpass", cskPassword, "-keystore", keystorePath, "-storepass", keystorePassword ];
						
						for (id in deviceIDs) {
							
							params.push ("-deviceId");
							params.push (id);
							
						}
						
						params.push (debugTokenPath);
						
						ProcessHelper.runCommand ("", binDirectory + "blackberry-debugtokenrequest", params, false);
						
						Lib.println ("Done.");
						
					} catch (e:Dynamic) {
						
						Sys.exit (1);
						
					}
					
					var defines = getDefines ();
					defines.set ("BLACKBERRY_DEBUG_TOKEN", debugTokenPath);
					writeConfig (defines.get ("HXCPP_CONFIG"), defines);
					
				}
				
			}
			
			if (answer == Yes || answer == Always) {
				
				var names:Array<String> = [];
				var descriptions:Array<String> = [];
				
				if (debugTokenPath == null) {
					
					names.push ("BLACKBERRY_DEBUG_TOKEN");
					descriptions.push ("Path to debug token");
					
				}
				
				names = names.concat ([ "BLACKBERRY_DEVICE_IP", "BLACKBERRY_DEVICE_PASSWORD" ]);
				descriptions = descriptions.concat ([ "Device IP address", "Device password" ]);
				
				var defines = getDefines (names, descriptions);
				
				if (defines != null) {
					
					defines.set ("BLACKBERRY_SETUP", "true");
					writeConfig (defines.get ("HXCPP_CONFIG"), defines);
					
				}
				
				var secondAnswer = ask ("Install debug token on device?");
				
				if (secondAnswer != No) {
					
					Lib.println ("Installing debug token...");
					var done = false;
					
					while (!done) {
						
						try {
							
							ProcessHelper.runCommand ("", binDirectory + "blackberry-deploy", [ "-installDebugToken", defines.get ("BLACKBERRY_DEBUG_TOKEN"), "-device", defines.get ("BLACKBERRY_DEVICE_IP"), "-password", defines.get ("BLACKBERRY_DEVICE_PASSWORD") ], false);
							
							Lib.println ("Done.");
							done = true;
							
						} catch (e:Dynamic) {
							
							if (ask ("Would you like to try again?") == No) {
								
								Sys.exit (1);
								
							}
							
						}
						
					}
					
				}
				
			}
			
		}
		
		if (answer == Always) {
			
			Lib.println ("Configure the BlackBerry simulator? [y/n/a] a");
			
		} else {
			
			answer = ask ("Configure the BlackBerry simulator?");
			
		}
		
		if (answer == Yes || answer == Always) {
			
			var defines = getDefines ([ "BLACKBERRY_SIMULATOR_IP" ], [ "Simulator IP address" ]);
			
			if (defines != null) {
				
				writeConfig (defines.get ("HXCPP_CONFIG"), defines);
				
			}
			
		}
		
		var defines = getDefines ();
		defines.set ("BLACKBERRY_SETUP", "true");
		writeConfig (defines.get ("HXCPP_CONFIG"), defines);
		
	}
	
	
	public static function setupHTML5 ():Void {
		
		var setApacheCordova = false;
		
		var defines = getDefines ();
		var answer = ask ("Download and install Apache Cordova?");
		
		if (answer == Yes || answer == Always) {
			
			var downloadPath = "";
			var defaultInstallPath = "";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				defaultInstallPath = "C:\\Development\\Apache Cordova";
			
			} else {
				
				defaultInstallPath = "/opt/cordova";
				
			}
			
			var path = unescapePath (param ("Output directory [" + defaultInstallPath + "]"));
			path = createPath (path, defaultInstallPath);
			
			downloadFile (apacheCordovaPath);
			extractFile (Path.withoutDirectory (apacheCordovaPath), path, "*");
			
			var childArchives = [];
			
			for (file in FileSystem.readDirectory (path)) {
				
				if (Path.extension (file) == "zip") {
					
					childArchives.push (file);
					
				}
				
			}
			
			createPath (path + "/lib");
			var libs = [ "android", "bada-wac", "bada", "blackberry", "ios", "mac", "qt", "tizen", "webos", "wp7" ];
			
			for (archive in childArchives) {
				
				var name = Path.withoutExtension (archive);
				name = StringTools.replace (name, "incubator-", "");
				name = StringTools.replace (name, "cordova-", "");
				
				if (name == "blackberry-webworks") {
					
					name = "blackberry";
					
				}
				
				var basePath = path + "/";
				
				for (lib in libs) {
					
					if (name == lib) {
						
						basePath += "lib/";
						
					}
					
				}
				
				createPath (basePath + name);
				extractFile (path + "/" + archive, basePath + name);
				
			}
			
			if (PlatformHelper.hostPlatform != Platform.WINDOWS) {
				
				ProcessHelper.runCommand ("", "chmod", [ "-R", "777", path ], false);
				
			}
			
			setApacheCordova = true;
			defines.set ("CORDOVA_PATH", path);
			writeConfig (defines.get ("HXCPP_CONFIG"), defines);
			Lib.println ("");
			
		}
		
		var requiredVariables = [];
		var requiredVariableDescriptions = [];
		
		if (!setApacheCordova) {
			
			requiredVariables.push ("CORDOVA_PATH");
			requiredVariableDescriptions.push ("Path to Apache Cordova");
			
		}
		
		requiredVariables = requiredVariables.concat ([ "WEBWORKS_SDK", "WEBWORKS_SDK_BBOS", "WEBWORKS_SDK_PLAYBOOK" ]);
		requiredVariableDescriptions = requiredVariableDescriptions.concat ([ "Path to WebWorks SDK for BlackBerry 10", "Path to WebWorks SDK for BBOS", "Path to WebWorks SDK for PlayBook" ]);
		
		defines = getDefines (requiredVariables, requiredVariableDescriptions);
		
		defines.set ("CORDOVA_PATH", unescapePath (defines.get ("CORDOVA_PATH")));
		defines.set ("WEBWORKS_SDK_BBOS", unescapePath (defines.get ("WEBWORKS_SDK_BBOS")));
		defines.set ("WEBWORKS_SDK_PLAYBOOK", unescapePath (defines.get ("WEBWORKS_SDK_PLAYBOOK")));
		
		// temporary hack
		
		/*Sys.println ("");
		Sys.println ("Setting Apache Cordova install path...");
		ProcessHelper.runCommand (defines.get ("CORDOVA_PATH") + "/lib/ios", "make", [ "install" ], true, true);
		Sys.println ("Done.");*/
		
		writeConfig (defines.get ("HXCPP_CONFIG"), defines);
		
		ProcessHelper.runCommand ("", "haxelib", [ "install", "cordova" ], true, true);
		
	}


	public static function setupLinux ():Void {
		
		var parameters = [ "apt-get", "install" ].concat (linuxX64Packages.split (" "));
		ProcessHelper.runCommand ("", "sudo", parameters, false);
		
	}
	
	
	public static function setupMac ():Void {
		
		var answer = ask ("Download and install Apple Xcode?");
		
		if (answer == Yes || answer == Always) {
			
			Lib.println ("You must purchase Xcode from the Mac App Store or download using a paid");
			Lib.println ("member account with Apple.");
			var secondAnswer = ask ("Would you like to open the download page?");
			
			if (secondAnswer != No) {
				
				ProcessHelper.runCommand ("", "open", [ appleXcodeURL ], false);
				
			}
			
		}
		
	}	
	
	
	public static function setupWebOS ():Void {
		
		var answer = ask ("Download and install the HP webOS SDK?");
		
		if (answer == Yes || answer == Always) {
			
			var sdkPath = "";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				if (Sys.environment ().exists ("PROCESSOR_ARCHITEW6432") && Sys.getEnv ("PROCESSOR_ARCHITEW6432").indexOf ("64") > -1) {
					
					sdkPath = webOSWindowsX64SDKPath;
					
				} else {
					
					sdkPath = webOSWindowsX86SDKPath;
					
				}
				
			} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
				
				sdkPath = webOSLinuxSDKPath;
				
			} else {
				
				sdkPath = webOSMacSDKPath;
				
			}

			downloadFile (sdkPath);
			runInstaller (Path.withoutDirectory (sdkPath));
			Lib.println ("");
			
		}
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			if (answer == Always) {
				
				Lib.println ("Download and install the CodeSourcery C++ toolchain? [y/n/a] a");
				
			} else {
				
				answer = ask ("Download and install the CodeSourcery C++ toolchain?");
				
			}

			if (answer != No) {
				
				downloadFile (codeSourceryWindowsPath);
				runInstaller (Path.withoutDirectory (codeSourceryWindowsPath));
				
			}
			
		} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
			
			if (answer == Always) {
				
				Lib.println ("Download and install Novacom? [y/n/a] a");
				
			} else {
				
				answer = ask ("Download and install Novacom?");
				
			}

			if (answer != No) {

				var process = new Process("uname", ["-m"]);
				var ret = process.stdout.readAll().toString();
				var ret2 = process.stderr.readAll().toString();
				process.exitCode(); //you need this to wait till the process is closed!
				process.close();
			
				var novacomPath = webOSLinuxX86NovacomPath;

				if (ret.indexOf ("64") > -1) {
				
					novacomPath = webOSLinuxX64NovacomPath;
				
				}
				
				downloadFile (novacomPath);
				runInstaller (Path.withoutDirectory (novacomPath));
			
			}
		
		}
		
	}
	
	
	public static function setupWindows ():Void {
		
		var answer = ask ("Download and install Visual Studio C++ Express?");
		
		if (answer == Yes || answer == Always) {
			
			downloadFile (windowsVisualStudioCPPPath);
			runInstaller (Path.withoutDirectory (windowsVisualStudioCPPPath));
			
		}
		
	}
	
	
	private static function stripQuotes (path:String):String {
		
		if (path != null) {
			
			return path.split ("\"").join ("");
			
		}
		
		return path;
		
	}
	
	
	private static function throwPermissionsError () {
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			Lib.println ("Unable to access directory. Perhaps you need to run \"setup\" with administrative privileges?");
			
		} else {
			
			Lib.println ("Unable to access directory. Perhaps you should run \"setup\" again using \"sudo\"");
			
		}
		
		Sys.exit (1);
		
	}
	
	
	private static function unescapePath (path:String):String {
		
		if (path == null) {
			
			path = "";
			
		}
			
		path = StringTools.replace (path, "\\ ", " ");
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS && StringTools.startsWith (path, "~/")) {
			
			path = Sys.getEnv ("HOME") + "/" + path.substr (2);
			
		}
		
		return path;
		
	}
	
	
	private static function writeConfig (path:String, defines:Map <String, String>):Void {
		
		var newContent = "";
		var definesText = "";
		
		for (key in defines.keys ()) {
			
			if (key != "HXCPP_CONFIG") {
				
				definesText += "		<set name=\"" + key + "\" value=\"" + stripQuotes (defines.get (key)) + "\" />\n";
				
			}
			
		}
		
		if (FileSystem.exists (path)) {
			
			var input = File.read (path, false);
			var bytes = input.readAll ();
			input.close ();
			
			if (!backedUpConfig) {
				
				try {
					
					var backup = File.write (path + ".bak", false);
					backup.writeBytes (bytes, 0, bytes.length);
					backup.close ();
					
				} catch (e:Dynamic) { }
				
				backedUpConfig = true;
			
			}
			
			var content = bytes.readString (0, bytes.length);
			
			var startIndex = content.indexOf ("<section id=\"vars\">");
			var endIndex = content.indexOf ("</section>", startIndex);
			
			newContent += content.substr (0, startIndex) + "<section id=\"vars\">\n		\n";
			newContent += definesText;
			newContent += "		\n	" + content.substr (endIndex);
			
		} else {
			
			newContent += "<xml>\n\n";
			newContent += "	<section id=\"vars\">\n\n";
			newContent += definesText;
			newContent += "	</section>\n\n</xml>";
			
		}
		
		var output = File.write (path, false);
		output.writeString (newContent);
		output.close ();
		
	}
	
	
}


class Progress extends haxe.io.Output {

	var o : haxe.io.Output;
	var cur : Int;
	var max : Int;
	var start : Float;

	public function new(o) {
		this.o = o;
		cur = 0;
		start = haxe.Timer.stamp();
	}

	function bytes(n) {
		cur += n;
		if( max == null )
			Lib.print(cur+" bytes\r");
		else
			Lib.print(cur+"/"+max+" ("+Std.int((cur*100.0)/max)+"%)\r");
	}

	public override function writeByte(c) {
		o.writeByte(c);
		bytes(1);
	}

	public override function writeBytes(s,p,l) {
		var r = o.writeBytes(s,p,l);
		bytes(r);
		return r;
	}

	public override function close() {
		super.close();
		o.close();
		var time = haxe.Timer.stamp() - start;
		var speed = (cur / time) / 1024;
		time = Std.int(time * 10) / 10;
		speed = Std.int(speed * 10) / 10;
		
		// When the path is a redirect, we don't want to display that the download completed
		
		if (cur > 400) {
			
			Lib.print("Download complete : " + cur + " bytes in " + time + "s (" + speed + "KB/s)\n");
			
		}
		
	}

	public override function prepare(m) {
		max = m;
	}

}


enum Answer {
	Yes;
	No;
	Always;
}
