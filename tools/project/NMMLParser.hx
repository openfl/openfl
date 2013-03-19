package;


import format.XFL;
import haxe.io.Path;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import NMEProject;
import PlatformConfig;


class NMMLParser extends NMEProject {
	
	
	public var localDefines:Map <String, Dynamic>;
	public var includePaths:Array <String>;
	
	private static var varMatch = new EReg("\\${(.*?)}", "");
	
	
	public function new (path:String = "", defines:Map <String, Dynamic> = null, includePaths:Array <String> = null, useExtensionPath:Bool = false) {
		
		super ();
		
		if (defines != null) {
			
			localDefines = StringMapHelper.copy (defines);
			
		} else {
			
			localDefines = new Map <String, Dynamic> ();
			
		}
		
		if (includePaths != null) {
			
			this.includePaths = includePaths;
			
		} else {
			
			this.includePaths = new Array <String> ();
			
		}
		
		initialize ();
		
		if (path != "") {
			
			process (path, useExtensionPath);
			
		}
		
	}
	
	
	private function initialize ():Void {
		
		switch (platformType) {
			
			case MOBILE:
				
				localDefines.set ("mobile", "1");
			
			case DESKTOP:
				
				localDefines.set ("desktop", "1");
			
			case WEB:
				
				localDefines.set ("web", "1");
			
		}
		
		if (targetFlags.exists ("cpp")) {
			
			localDefines.set ("cpp", "1");
			
		} else if (targetFlags.exists ("neko")) {
			
			localDefines.set ("neko", "1");
			
		}
		
		localDefines.set ("haxe3", "1");
		
		if (command != null) {
			
			localDefines.set (command.toLowerCase (), "1");
			
		}
		
		if (localDefines.exists ("SWF_PLAYER")) {
			
			environment.set ("SWF_PLAYER", localDefines.get ("SWF_PLAYER"));
			
		} else if (localDefines.exists ("FLASH_PLAYER_EXE")) {
			
			environment.set ("FLASH_PLAYER_EXE", localDefines.get ("SWF_PLAYER"));
			
		}
		
		localDefines.set (Type.enumConstructor (target).toLowerCase (), "1");
		
	}
	
	
	private function isValidElement (element:Fast, section:String):Bool {
		
		if (element.x.get ("if") != null) {
			
			var value = element.x.get ("if");
			var optionalDefines = value.split ("||");
			var isValid = true;
			
			for (optional in optionalDefines) {
				
				var requiredDefines = optional.split (" ");
				
				for (required in requiredDefines) {
					
					var check = StringTools.trim (required);
					
					if (check != "" && !localDefines.exists (check)) {
						
						isValid = false;
						
					}
					
				}
				
			}
			
			return isValid;
			
		}
		
		if (element.has.unless) {
			
			var value = element.att.unless;
			var optionalDefines = value.split ("||");
			var isValid = true;
			
			for (optional in optionalDefines) {
				
				var requiredDefines = optional.split (" ");
				
				for (required in requiredDefines) {
					
					var check = StringTools.trim (required);
					
					if (check != "" && localDefines.exists (check)) {
						
						isValid = false;
						
					}
					
				}
				
			}
			
			return isValid;
			
		}
		
		if (section != "") {
			
			if (element.name != "section") {
				
				return false;
				
			}
			
			if (!element.has.id) {
				
				return false;
				
			}
			
			if (element.att.id != section) {
				
				return false;
				
			}
			
		}
		
		return true;
		
	}
	
	
	private function findIncludeFile (base:String):String {
		
		if (base == "") {
			
			return "";
			
		}
		
		if (base.substr (0, 1) != "/" && base.substr (0, 1) != "\\") {
			
			if (base.substr (1, 1) != ":") {
				
				for (path in includePaths) {
					
					var includePath = path + "/" + base;
					
					if (FileSystem.exists (includePath)) {
						
						if (FileSystem.exists (includePath + "/include.nmml")) {
							
							return includePath + "/include.nmml";
							
						} else {
							
							return includePath;
							
						}
						
					}
					
				}
				
			}
			
		}
		
		if (FileSystem.exists (base)) {
			
			if (FileSystem.exists (base + "/include.nmml")) {
				
				return base + "/include.nmml";
				
			} else {
				
				return base;
				
			}
			
		}
		
		return "";
		
	}
	
	
	private function formatAttributeName (name:String):String {
		
		var segments = name.toLowerCase ().split ("-");
		
		for (i in 1...segments.length) {
			
			segments[i] = segments[i].substr (0, 1).toUpperCase () + segments[i].substr (1);
			
		}
		
		return segments.join ("");
		
	}
	
	
	private function parseAppElement (element:Fast):Void {
		
		for (attribute in element.x.attributes ()) {

			switch (attribute) {
				
				case "path":
					
					app.path = substitute (element.att.path);
				
				case "min-swf-version":
					
					var version = Std.parseFloat (substitute (element.att.resolve ("min-swf-version")));
					
					if (version > app.swfVersion) {
						
						app.swfVersion = version;
						
					}
				
				case "swf-version":
					
					app.swfVersion = Std.parseFloat (substitute (element.att.resolve ("swf-version")));
				
				case "preloader":
					
					app.preloader = substitute (element.att.preloader);
				
				default:
					
					// if we are happy with this spec, we can tighten up this parsing a bit, later
					
					var name = formatAttributeName (attribute);
					var value = substitute (element.att.resolve (attribute));
					
					if (attribute == "package") {
						
						name = "packageName";
						
					}
					
					if (Reflect.hasField (app, name)) {
						
						Reflect.setField (app, name, value);
						
					} else if (Reflect.hasField (meta, name)) {
						
						Reflect.setField (meta, name, value);
						
					}
				
			}
			
		}
		
	}
	
	
	private function parseAssetsElement (element:Fast, basePath:String = "", isTemplate:Bool = false):Void {
		
		var path = "";
		var embed = "";
		var targetPath = "";
		var glyphs = null;
		var type = null;
		
		if (element.has.path) {
			
			path = basePath + substitute (element.att.path);
			
		}
		
		if (element.has.embed) {
			
			embed = substitute (element.att.embed);
			
		}
		
		if (element.has.rename) {
			
			targetPath = substitute (element.att.rename);
			
		} else {
			
			targetPath = path;
			
		}
		
		if (element.has.glyphs) {
			
			glyphs = substitute (element.att.glyphs);
			
		}
		
		if (isTemplate) {
			
			type = AssetType.TEMPLATE;
			
		} else if (element.has.type) {
			
			type = Reflect.field (AssetType, substitute (element.att.type).toUpperCase ());
			
		}
		
		if (path == "" && (element.has.include || element.has.exclude || type != null )) {
			
			LogHelper.error ("In order to use 'include' or 'exclude' on <asset /> nodes, you must specify also specify a 'path' attribute");
			return;
			
		} else if (!element.elements.hasNext ()) {
			
			// Empty element
			
			if (path == "") {
				
				return;
				
			}
			
			if (!FileSystem.exists (path)) {
				
				LogHelper.error ("Could not find asset path \"" + path + "\"");
				return;
				
			}
			
			if (!FileSystem.isDirectory (path)) {
				
				var id = "";
				
				if (element.has.id) {
					
					id = substitute (element.att.id);
					
				}
				
				var asset = new Asset (path, targetPath, type);
				asset.id = id;
				
				if (glyphs != null) {
					
					asset.glyphs = glyphs;
					
				}
				
				assets.push (asset);
				
			} else {
				
				var exclude = ".*|cvs|thumbs.db|desktop.ini|*.hash";
				var include = "";
				
				if (element.has.exclude) {
					
					exclude += "|" + element.att.exclude;
					
				}
				
				if (element.has.include) {
					
					include = element.att.include;
					
				} else {
					
					if (type == null) {
						
						include = "*";
						
					} else {
						
						switch (type) {
							
							case IMAGE:
								
								include = "*.jpg|*.jpeg|*.png|*.gif";
							
							case SOUND:
								
								include = "*.wav|*.ogg";
							
							case MUSIC:
								
								include = "*.mp2|*.mp3";
							
							case FONT:
								
								include = "*.otf|*.ttf";
							
							case TEMPLATE:
								
								include = "*";
							
							default:
								
								include = "*";
							
						}
						
					}
					
				}
				
				parseAssetsElementDirectory (path, targetPath, include, exclude, type, embed, glyphs, true);
				
			}
			
		} else {
			
			if (path != "") {
				
				path += "/";
				
			}
			
			if (targetPath != "") {
				
				targetPath += "/";
				
			}
			
			for (childElement in element.elements) {
				
				var isValid = isValidElement (childElement, "");

				if (isValid) {
					
					var childPath = substitute (childElement.has.name ? childElement.att.name : childElement.att.path);
					var childTargetPath = childPath;
					var childEmbed = embed;
					var childType = type;
					var childGlyphs = glyphs;
					
					if (childElement.has.rename) {
						
						childTargetPath = childElement.att.rename;
						
					}
					
					if (childElement.has.embed) {
						
						childEmbed = substitute (childElement.att.embed);
						
					}
					
					if (childElement.has.glyphs) {
						
						childGlyphs = substitute (childElement.att.glyphs);
						
					}
					
					switch (childElement.name) {
						
						case "image", "sound", "music", "font", "template":
							
							childType = Reflect.field (AssetType, childElement.name.toUpperCase ());
						
						default:
							
							if (childElement.has.type) {
								
								childType = Reflect.field (AssetType, childElement.att.type.toUpperCase ());
								
							}
						
					}
					
					var id = "";
					
					if (childElement.has.id) {
						
						id = substitute (childElement.att.id);
						
					}
					else if (childElement.has.name) {
						
						id = substitute (childElement.att.name);
						
					}
					
					var asset = new Asset (path + childPath, targetPath + childTargetPath, childType);
					asset.id = id;
					
					if (childGlyphs != null) {
						
						asset.glyphs = childGlyphs;
						
					}
					
					assets.push (asset);
					
				}
				
			}
			
		}
		
	}
	
	
	private function parseAssetsElementDirectory (path:String, targetPath:String, include:String, exclude:String, type:AssetType, embed:String, glyphs:String, recursive:Bool):Void {
		
		var files = FileSystem.readDirectory (path);
		
		if (targetPath != "") {
			
			targetPath += "/";
			
		}
		
		for (file in files) {
			
			if (FileSystem.isDirectory (path + "/" + file) && recursive) {
				
				if (filter (file, [ "*" ], exclude.split ("|"))) {
					
					parseAssetsElementDirectory (path + "/" + file, targetPath + file, include, exclude, type, embed, glyphs, true);
					
				}
				
			} else {
				
				if (filter (file, include.split ("|"), exclude.split ("|"))) {
					
					var asset = new Asset (path + "/" + file, targetPath + file, type);
					
					if (glyphs != null) {
						
						asset.glyphs = glyphs;
						
					}
					
					assets.push (asset);
					
				}
				
			}
			
		}
		
	}
	
	
	private function parseMetaElement (element:Fast):Void {
		
		for (attribute in element.x.attributes ()) {
			
			switch (attribute) {
				
				case "title", "description", "package", "version", "company", "company-id", "build-number":
					
					var value = substitute (element.att.resolve (attribute));
					
					localDefines.set ("APP_" + StringTools.replace (attribute, "-", "_").toUpperCase (), value);
					
					var name = formatAttributeName (attribute);
					
					if (attribute == "package") {
						
						name = "packageName";
						
					}
					
					if (Reflect.hasField (meta, name)) {
						
						Reflect.setField (meta, name, value);
						
					}
				
			}
			
		}
		
	}
	
	
	private function parseOutputElement (element:Fast):Void {
		
		if (element.has.name) {
			
			app.file = substitute (element.att.name);
			
		}
		
		if (element.has.path) {
			
			app.path = substitute (element.att.path);
			
		}
		
		if (element.has.resolve ("swf-version")) {
			
			app.swfVersion = Std.parseFloat (substitute (element.att.resolve ("swf-version")));
			
		}
		
	}
	
	
	private function parseXML (xml:Fast, section:String, extensionPath:String = ""):Void {
		
		for (element in xml.elements) {
			
			var isValid = isValidElement (element, section);
			if (isValid) {
				
				switch (element.name) {
					
					case "set":
						
						var name = element.att.name;
						var value = "";
						
						if (element.has.value) {
							
							value = substitute (element.att.value);
							
						}
						
						switch (name) {
							
							case "BUILD_DIR": app.path = value;
							case "SWF_VERSION": app.swfVersion = Std.parseFloat (value);
							case "PRERENDERED_ICON": config.ios.prerenderedIcon = (value == "true");
							case "ANDROID_INSTALL_LOCATION": config.android.installLocation = value;
							
						}
						
						localDefines.set (name, value);
						environment.set (name, value);
					
					case "unset":
						
						localDefines.remove (element.att.name);
						environment.remove (element.att.name);
					
					case "setenv":
						
						var value = "";
						
						if (element.has.value) {
							
							value = substitute (element.att.value);
							
						} else {
							
							value = "1";
							
						}
						
						var name = element.att.name;
						
						localDefines.set (name, value);
						environment.set (name, value);
						setenv (name, value);
					
					case "error":
						
						LogHelper.error (substitute (element.att.value));
	
					case "echo":
						
						Sys.println (substitute (element.att.value));
					
					case "path":
						
						var value = "";
						
						if (element.has.value) {
							
							value = substitute (element.att.value);
							
						} else {
							
							value = substitute (element.att.name);
							
						}
						
						/*if (defines.get ("HOST") == "windows") {
							
							Sys.putEnv ("PATH", value + ";" + Sys.getEnv ("PATH"));
							
						} else {
							
							Sys.putEnv ("PATH", value + ":" + Sys.getEnv ("PATH"));
							
						}*/
						
						path (value);
					
					case "include":
						
						var path = "";
						
						if (element.has.path) {
							
							var subPath = substitute (element.att.path);
							if (subPath == "") subPath = element.att.path;
							path = findIncludeFile (PathHelper.combine (extensionPath, subPath));
							
						} else {
							
							path = findIncludeFile (PathHelper.combine (extensionPath, substitute (element.att.name)));
							
						}
						
						if (path != null && path != "" && FileSystem.exists (path)) {
							
							var includeProject = new NMMLParser (path);
							
							var dir = Path.directory (path);
							if (dir != "")
								includeProject.sources.push (dir);
							
							merge (includeProject);
							
						} else if (!element.has.noerror) {
							
							LogHelper.error ("Could not find include file \"" + path + "\"");
							
						}
					
					case "meta":
						
						parseMetaElement (element);
					
					case "app":
						
						parseAppElement (element);
					
					case "java":
						
						javaPaths.push (PathHelper.combine (extensionPath, substitute (element.att.path)));
					
					case "haxelib":
						
						/*var name:String = substitute (element.att.name);
						compilerFlags.push ("-lib " + name);
						
						var path = Utils.getHaxelib (name);
						
						if (FileSystem.exists (path + "/include.nmml")) {
							
							var xml:Fast = new Fast (Xml.parse (File.getContent (path + "/include.nmml")).firstElement ());
							parseXML (xml, "", path + "/");
							
						}*/
						
						var name = substitute (element.att.name);
						var version = "";
						
						if (element.has.version) {
							
							version = substitute (element.att.version);
							
						}
						
						var haxelib = new Haxelib (name, version);
						var path = PathHelper.getHaxelib (haxelib);
						
						if (FileSystem.exists (path + "/include.nmml")) {
							
							var includeProject = new NMMLParser (path + "/include.nmml");
							
							for (ndll in includeProject.ndlls) {
								
								if (ndll.haxelib == null) {
									
									ndll.haxelib = haxelib;
									
								}
								
							}
							
							includeProject.sources.push (path);
							merge (includeProject);
							
						}
						
						haxelibs.push (haxelib);
					
					case "ndll":
						
						/*var name:String = substitute (element.att.name);
						var haxelib:String = "";
						
						if (element.has.haxelib) {
							
							haxelib = substitute (element.att.haxelib);
							
						}
						
						if (extensionPath != "" && haxelib == "") {
							
							var ndll = new NDLL (name, "nme-extension");
							ndll.extension = extensionPath;
							ndlls.push (ndll);
							
						} else {
							
							ndlls.push (new NDLL (name, haxelib));
							
						}*/
						
						var name = substitute (element.att.name);
						var haxelib = null;
						
						if (element.has.haxelib) {
							
							haxelib = new Haxelib (substitute (element.att.haxelib));
							
						}
						
						if (haxelib == null && (name == "std" || name == "regexp" || name == "zlib")) {
							
							haxelib = new Haxelib ("hxcpp");
							
						}
						
						var ndll = new NDLL (name, haxelib);
						ndll.extensionPath = extensionPath;
						ndlls.push (ndll);
					
					case "launchImage":
						
						/*var name:String = "";
						
						if (element.has.path) {
							
							name = substitute(element.att.path);
							
						} else {
							
							name = substitute(element.att.name);
							
						}
						
						var width:String = "";
						var height:String = "";
						
						if (element.has.width) {
							
							width = substitute (element.att.width);
							
						}
						
						if (element.has.height) {
							
							height = substitute (element.att.height);
							
						}
						
						launchImages.push (new LaunchImage(name, width, height));*/
						
						
						var name:String = "";
						
						if (element.has.path) {
							
							name = substitute(element.att.path);
							
						} else {
							
							name = substitute(element.att.name);
							
						}
						
						var splashScreen = new SplashScreen (name);
						
						if (element.has.width) {
							
							splashScreen.width = Std.parseInt (substitute (element.att.width));
							
						}
						
						if (element.has.height) {
							
							splashScreen.height = Std.parseInt (substitute (element.att.height));
							
						}
						
						splashScreens.push (splashScreen);
					
					case "icon":
						
						/*var name:String = "";
						
						if (element.has.path) {
							
							name = substitute(element.att.path);
							
						} else {
							
							name = substitute(element.att.name);
							
						}
						
						var width:String = "";
						var height:String = "";
						
						if (element.has.size) {
							
							width = height = substitute (element.att.size);
							
						}
						
						if (element.has.width) {
							
							width = substitute (element.att.width);
							
						}
						
						if (element.has.height) {
							
							height = substitute (element.att.height);
							
						}
						
						icons.add (new Icon (name, width, height));*/
						
						var name = "";
						
						if (element.has.path) {
							
							name = substitute(element.att.path);
							
						} else {
							
							name = substitute(element.att.name);
							
						}
						
						var icon = new Icon (name);
						
						if (element.has.size) {
							
							icon.size = icon.width = icon.height = Std.parseInt (substitute (element.att.size));
							
						}
						
						if (element.has.width) {
							
							icon.width = Std.parseInt (substitute (element.att.width));
							
						}
						
						if (element.has.height) {
							
							icon.height = Std.parseInt (substitute (element.att.height));
							
						}
						
						icons.push (icon);
					
					case "source", "classpath":
						
						var path = "";
						
						if (element.has.path) {
							
							path = PathHelper.combine (extensionPath, substitute (element.att.path));
							
						} else {
							
							path = PathHelper.combine (extensionPath, substitute (element.att.name));
							
						}
						
						sources.push (path);
					
					case "extension":
						
						// deprecated
					
					case "haxedef":
						
						var name = substitute (element.att.name);
						var value = "";
						
						if (element.has.value) {
							
							value = substitute (element.att.value);
							
						}
						
						haxedefs.set (name, value);
					
					case "haxeflag", "compilerflag":
						
						var flag = substitute (element.att.name);
						
						if (element.has.value) {
							
							flag += " " + substitute (element.att.value);
							
						}
						
						haxeflags.push (substitute (flag));
					
					case "window":
						
						parseWindowElement (element);
					
					case "assets":
						
						parseAssetsElement (element, extensionPath);
					
					case "library", "swf":
						
						var path = PathHelper.combine (extensionPath, substitute (element.att.path));
						var name = "";
						
						if (element.has.name) {
							
							name = element.att.name;
							
						}
						
						if (element.has.id) {
							
							name = element.att.id;
							
						}
						
						libraries.push (new Library (path, name));
					
					case "ssl":
						
						//if (wantSslCertificate())
						   //parseSsl (element);
					
					case "template":
						
						if (element.has.path) {
							
							var path = PathHelper.combine (extensionPath, substitute (element.att.path));
							
							if (FileSystem.exists (path) && !FileSystem.isDirectory (path)) {
								
								parseAssetsElement (element, extensionPath, true);
								
							} else {
								
								templatePaths.push (path);
								
							}
							
						} else {
							
							parseAssetsElement (element, extensionPath, true);
							
						}
					
					case "templatePath":
						
						templatePaths.push (PathHelper.combine (extensionPath, substitute (element.att.name)));
					
					case "preloader":
						
						// deprecated
						
						app.preloader = substitute (element.att.name);
					
					case "output":
						
						parseOutputElement (element);
					
					case "section":
						
						parseXML (element, "");
					
					case "certificate":
						
						certificate = new Keystore (substitute (element.att.path));
						
						if (element.has.type) {
							
							certificate.type = substitute (element.att.type);
							
						}
						
						if (element.has.password) {
							
							certificate.password = substitute (element.att.password);
							
						}
						
						if (element.has.alias) {
							
							certificate.alias = substitute (element.att.alias);
							
						}
						
						if (element.has.resolve ("alias-password")) {
							
							certificate.aliasPassword = substitute (element.att.resolve ("alias-password"));
							
						} else if (element.has.alias_password) {
							
							certificate.aliasPassword = substitute (element.att.alias_password);
							
						}
					
					case "dependency":
						
						dependencies.push (substitute (element.att.name));
					
					case "ios":
						
						if (target == Platform.IOS) {
							
							if (element.has.deployment) {
								
								var deployment = Std.parseFloat (substitute (element.att.deployment));
								
								// If it is specified, assume the dev knows what he is doing!
								config.ios.deployment = deployment;
							}
							
							if (element.has.binaries) {
								
								var binaries = substitute (element.att.binaries);
								
								switch (binaries) {
									
									case "fat":
										
										ArrayHelper.addUnique (architectures, Architecture.ARMV6);
										ArrayHelper.addUnique (architectures, Architecture.ARMV7);
									
									case "armv6":
										
										ArrayHelper.addUnique (architectures, Architecture.ARMV6);
										architectures.remove (Architecture.ARMV7);
									
									case "armv7":
										
										ArrayHelper.addUnique (architectures, Architecture.ARMV7);
										architectures.remove (Architecture.ARMV6);
									
								}
								
							}
							
							if (element.has.devices) {
								
								config.ios.device = Reflect.field (IOSConfigDevice, substitute (element.att.devices).toUpperCase ());
								
							}
							
							if (element.has.compiler) {
								
								config.ios.compiler = substitute (element.att.compiler);
								
							}
							
							if (element.has.resolve ("prerendered-icon")) {
								
								config.ios.prerenderedIcon = (substitute (element.att.resolve ("prerendered-icon")) == "true");
								
							}
							
							if (element.has.resolve ("linker-flags")) {
								
								config.ios.linkerFlags = substitute (element.att.resolve ("linker-flags"));
								
							}
							
						}
					
				}
				
			}
			
		}
		
	}
	
	
	private function parseWindowElement (element:Fast):Void {
		
		for (attribute in element.x.attributes ()) {
			
			var name = formatAttributeName (attribute);
			var value = substitute (element.att.resolve (attribute));
			
			switch (name) {
				
				case "background":
					
					value = StringTools.replace (value, "#", "");
					
					if (value.indexOf ("0x") == -1) {
						
						value = "0x" + value;
						
					}
					
					window.background = Std.parseInt (value);
				
				case "orientation":
					
					var orientation = Reflect.field (Orientation, Std.string (value).toUpperCase ());
					
					if (orientation != null) {
						
						window.orientation = orientation;
						
					}
				
				case "height", "width", "fps", "antialiasing":
					
					if (Reflect.hasField (window, name)) {
						
						Reflect.setField (window, name, Std.parseInt (value));
						
					}
				
				case "parameters":
					
					if (Reflect.hasField (window, name)) {
						
						Reflect.setField (window, name, Std.string (value));
						
					}
				
				default:
					
					if (Reflect.hasField (window, name)) {
						
						Reflect.setField (window, name, value == "true");
						
					}
				
			}
			
		}
		
	}
	
	
	public function process (projectFile:String, useExtensionPath:Bool):Void {
		
		var xml = null;
		var extensionPath = "";
		
		try {
			
			xml = new Fast (Xml.parse (File.getContent (projectFile)).firstElement ());
			extensionPath = Path.directory (projectFile);
			
		} catch (e:Dynamic) {
			
			LogHelper.error ("\"" + projectFile + "\" contains invalid XML data", e);
			
		}
		
		parseXML (xml, "", extensionPath);
		
	}
	
	
	private function substitute (string:String):String {
		
		var newString = string;
		
		while (varMatch.match (newString)) {
			
			newString = localDefines.get (varMatch.matched (1));
			
			if (newString == null) {
				
				newString = "";
				
			}
			
			newString = varMatch.matchedLeft () + newString + varMatch.matchedRight ();
			
		}
		
		return newString;
		
	}
	
	
	
}
