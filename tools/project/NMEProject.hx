package;


import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import sys.FileSystem;


class NMEProject {
	
	
	public var app:ApplicationData;
	public var architectures:Array <Architecture>;
	public var assets:Array <Asset>;
	public var certificate:Keystore;
	public var command:String;
	public var config:PlatformConfig;
	public var debug:Bool;
	public var dependencies:Array <String>;
	public var environment:Map <String, String>;
	public var haxedefs:Map <String, Dynamic>;
	public var haxeflags:Array <String>;
	public var haxelibs:Array <Haxelib>;
	public var host (get_host, null):Platform;
	public var icons:Array <Icon>;
	public var javaPaths:Array <String>;
	public var libraries:Array <Library>;
	public var meta:MetaData;
	public var ndlls:Array <NDLL>;
	public var platformType:PlatformType;
	public var sources:Array <String>;
	public var splashScreens:Array <SplashScreen>;
	public var target:Platform;
	public var targetFlags:Map <String, String>;
	public var templateContext (get_templateContext, null):Dynamic;
	public var templatePaths:Array <String>;
	public var window:Window;
	
	private var defaultApp:ApplicationData;
	private var defaultMeta:MetaData;
	private var defaultWindow:Window;
	
	public static var _command:String;
	public static var _debug:Bool;
	public static var _target:Platform;
	public static var _targetFlags:Map <String, String>;
	public static var _templatePaths:Array <String>;
	
	private static var initialized:Bool;
	
	
	public static function main () {
		
		var args = Sys.args ();
		
		if (args.length > 1) {
			
			NMEProject._command = args[1];
			NMEProject._debug = (args[2] == "true");
			NMEProject._target = Type.createEnum (Platform, args[3]);
			NMEProject._targetFlags = Unserializer.run (args[4]);
			NMEProject._templatePaths = Unserializer.run (args[5]);
			
		}
		
		initialize ();
		
		var classRef = Type.resolveClass (args[0]);
		var instance = Type.createInstance (classRef, []);
		
		Sys.print (Serializer.run (instance));
		
	}
	
	
	public function new () {
		
		initialize ();
		
		command = _command;
		config = new PlatformConfig ();
		debug = _debug;
		target = _target;
		targetFlags = StringMapHelper.copy (_targetFlags);
		templatePaths = _templatePaths.copy ();
		
		defaultMeta = { title: "MyApplication", description: "", packageName: "com.example.myapp", version: "1.0.0", company: "Example, Inc.", buildNumber: "1", companyID: "" }
		defaultApp = { main: "Main", file: "MyApplication", path: "bin", preloader: "NMEPreloader", swfVersion: 11, url: "" }
		defaultWindow = { width: 800, height: 600, parameters: "{}", background: 0xFFFFFF, fps: 30, hardware: true, resizable: true, borderless: false, orientation: Orientation.AUTO, vsync: false, fullscreen: false, antialiasing: 0, allowShaders: true, requireShaders: false, depthBuffer: false, stencilBuffer: false }
		
		switch (target) {
			
			case FLASH:
				
				platformType = PlatformType.WEB;
				architectures = [];
				
			case HTML5:
				
				platformType = PlatformType.WEB;
				architectures = [];
				
				defaultWindow.fps = 0;
				
			case ANDROID, BLACKBERRY, IOS, WEBOS:
				
				platformType = PlatformType.MOBILE;
				
				if (target == Platform.IOS) {
					
					architectures = [ Architecture.ARMV7 ];
					
				} else {
					
					architectures = [ Architecture.ARMV6 ];
					
				}
				
				defaultWindow.width = 0;
				defaultWindow.height = 0;
				defaultWindow.fullscreen = true;
				
			case WINDOWS, MAC, LINUX:
				
				platformType = PlatformType.DESKTOP;
				
				if (target == Platform.LINUX) {
					
					architectures = [ PlatformHelper.hostArchitecture ];
					
				} else {
					
					architectures = [ Architecture.X86 ];
					
				}
			
		}
		
		meta = {};
		app = {};
		window = {};
		
		ObjectHelper.copyFields (defaultMeta, meta);
		ObjectHelper.copyFields (defaultApp, app);
		ObjectHelper.copyFields (defaultWindow, window);
		
		assets = new Array <Asset> ();
		dependencies = new Array <String> ();
		environment = Sys.environment ();
		haxedefs = new Map <String, Dynamic> ();
		haxeflags = new Array <String> ();
		haxelibs = new Array <Haxelib> ();
		icons = new Array <Icon> ();
		javaPaths = new Array <String> ();
		libraries = new Array <Library> ();
		ndlls = new Array <NDLL> ();
		sources = new Array <String> ();
		splashScreens = new Array <SplashScreen> ();
		
	}
	
	
	public function clone ():NMEProject {
		
		var project = new NMEProject ();
		
		ObjectHelper.copyFields (app, project.app);
		project.architectures = architectures.copy ();
		
		for (asset in assets) {
			
			project.assets.push (asset.clone ());
			
		}
		
		if (certificate != null) {
			
			project.certificate = certificate.clone ();
			
		}
		
		project.command = command;
		project.config = config.clone ();
		project.debug = debug;
		project.dependencies = dependencies.copy ();
		
		for (key in environment.keys ()) {
			
			project.environment.set (key, environment.get (key));
			
		}
		
		for (key in haxedefs.keys ()) {
			
			project.haxedefs.set (key, haxedefs.get (key));
			
		}
		
		project.haxeflags = haxeflags.copy ();
		
		for (haxelib in haxelibs) {
			
			project.haxelibs.push (haxelib.clone ());
			
		}
		
		for (icon in icons) {
			
			project.icons.push (icon.clone ());
			
		}
		
		project.javaPaths = javaPaths.copy ();
		
		for (library in libraries) {
			
			project.libraries.push (library.clone ());
			
		}
		
		ObjectHelper.copyFields (meta, project.meta);
		
		for (ndll in ndlls) {
			
			project.ndlls.push (ndll.clone ());
			
		}
		
		project.platformType = platformType;
		project.sources = sources.copy ();
		
		for (splashScreen in splashScreens) {
			
			project.splashScreens.push (splashScreen.clone ());
			
		}
		
		project.target = target;
		
		for (key in targetFlags.keys ()) {
			
			project.targetFlags.set (key, targetFlags.get (key));
			
		}
		
		project.templatePaths = templatePaths.copy ();
		
		ObjectHelper.copyFields (window, project.window);
		
		return project;
		
	}
	
	
	private function filter (text:String, include:Array <String> = null, exclude:Array <String> = null):Bool {
		
		if (include == null) {
			
			include = [ "*" ];
			
		}
		
		if (exclude == null) {
			
			exclude = [];
			
		}
		
		for (filter in exclude) {
			
			if (filter != "") {
				
				filter = StringTools.replace (filter, ".", "\\.");
				filter = StringTools.replace (filter, "*", ".*");
				
				var regexp = new EReg ("^" + filter, "i");
				
				if (regexp.match (text)) {
					
					return false;
					
				}
				
			}
			
		}
		
		for (filter in include) {
			
			if (filter != "") {
				
				filter = StringTools.replace (filter, ".", "\\.");
				filter = StringTools.replace (filter, "*", ".*");
				
				var regexp = new EReg ("^" + filter, "i");
				
				if (regexp.match (text)) {
					
					return true;
					
				}
				
			}
			
		}
		
		return false;
		
	}
	
	
	public function include (path:String):Void {
		
		// extend project file somehow?
		
	}
	
	
	public function includeAssets (path:String, rename:String = null, include:Array <String> = null, exclude:Array <String> = null):Void {
		
		if (include == null) {
			
			include = [ "*" ];
			
		}
		
		if (exclude == null) {
			
			exclude = [];
			
		}
		
		exclude = exclude.concat ([ ".*", "cvs", "thumbs.db", "desktop.ini", "*.hash" ]);
			
		if (path == "") {
			
			return;
			
		}
		
		var targetPath = "";
		
		if (rename != null) {
			
			targetPath = rename;
			
		} else {
			
			targetPath = path;
			
		}
		
		if (!FileSystem.exists (path)) {
			
			LogHelper.error ("Could not find asset path \"" + path + "\"");
			return;
			
		}
		
		var files = FileSystem.readDirectory (path);
		
		if (targetPath != "") {
			
			targetPath += "/";
			
		}
		
		for (file in files) {
			
			if (FileSystem.isDirectory (path + "/" + file)) {
				
				if (filter (file, [ "*" ], exclude)) {
					
					includeAssets (path + "/" + file, targetPath + file, include, exclude);
					
				}
				
			} else {
				
				if (filter (file, include, exclude)) {
					
					assets.push (new Asset (path + "/" + file, targetPath + file));
					
				}
				
			}
			
		}
		
	}
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			if (_target == null) {
				
				_target = PlatformHelper.hostPlatform;
				
			}
			
			if (_targetFlags == null) {
				
				_targetFlags = new Map <String, String> ();
				
			}
			
			if (_templatePaths == null) {
				
				_templatePaths = new Array <String> ();
				
			}
			
			initialized = true;
			
		}
		
	}
	
	
	public function merge (project:NMEProject):Void {
		
		if (project != null) {
			
			ObjectHelper.copyUniqueFields (project.meta, meta, project.defaultMeta);
			ObjectHelper.copyUniqueFields (project.app, app, project.defaultApp);
			ObjectHelper.copyUniqueFields (project.window, window, project.defaultWindow);
			
			StringMapHelper.copyUniqueKeys (project.environment, environment);
			StringMapHelper.copyUniqueKeys (project.haxedefs, haxedefs);
			
			ObjectHelper.copyUniqueFields (project.certificate, certificate, null);
			config.merge (project.config);
			
			assets = ArrayHelper.concatUnique (assets, project.assets);
			dependencies = ArrayHelper.concatUnique (dependencies, project.dependencies);
			haxeflags = ArrayHelper.concatUnique (haxeflags, project.haxeflags);
			haxelibs = ArrayHelper.concatUnique (haxelibs, project.haxelibs);
			icons = ArrayHelper.concatUnique (icons, project.icons);
			javaPaths = ArrayHelper.concatUnique (javaPaths, project.javaPaths);
			libraries = ArrayHelper.concatUnique (libraries, project.libraries);
			ndlls = ArrayHelper.concatUnique (ndlls, project.ndlls);
			sources = ArrayHelper.concatUnique (sources, project.sources);
			splashScreens = ArrayHelper.concatUnique (splashScreens, project.splashScreens);
			templatePaths = ArrayHelper.concatUnique (templatePaths, project.templatePaths);
			
		}
		
	}
	
	
	public function path (value:String):Void {
		
		if (host == Platform.WINDOWS) {
			
			setenv ("PATH", value + ";" + Sys.getEnv ("PATH"));
			
		} else {
			
			setenv ("PATH", value + ":" + Sys.getEnv ("PATH"));
			
		}
		
	}
	
	
	public function setenv (name:String, value:String):Void {
		
		Sys.putEnv (name, value);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_host ():Platform {
		
		return PlatformHelper.hostPlatform;
		
	}
	
	
	private function get_templateContext ():Dynamic {
		
		var context:Dynamic = {};
		
		if (app == null) app = { };
		if (meta == null) meta = { };
		if (window == null) window = { };
		
		ObjectHelper.copyMissingFields (defaultApp, app);
		ObjectHelper.copyMissingFields (defaultMeta, meta);
		ObjectHelper.copyMissingFields (defaultWindow, window);
		
		config.populate ();
		
		for (field in Reflect.fields (app)) {
			
			Reflect.setField (context, "APP_" + StringHelper.formatUppercaseVariable (field), Reflect.field (app, field));
			
		}
		
		context.BUILD_DIR = app.path;
		
		for (field in Reflect.fields (meta)) {
			
			Reflect.setField (context, "APP_" + StringHelper.formatUppercaseVariable (field), Reflect.field (meta, field));
			Reflect.setField (context, "META_" + StringHelper.formatUppercaseVariable (field), Reflect.field (meta, field));
			
		}
		
		context.APP_PACKAGE = context.META_PACKAGE = meta.packageName;
		
		for (field in Reflect.fields (window)) {
			
			Reflect.setField (context, "WIN_" + StringHelper.formatUppercaseVariable (field), Reflect.field (window, field));
			
		}
		
		for (haxeflag in haxeflags) {
			
			if (StringTools.startsWith (haxeflag, "-lib")) {
				
				Reflect.setField (context, "LIB_" + haxeflag.substr (5).toUpperCase (), "true");
				
			}
			
		}
		
		context.assets = new Array <Dynamic> ();
		
		for (asset in assets) {
			
			if (asset.type != AssetType.TEMPLATE) {
				
				var embeddedAsset:Dynamic = { };
				ObjectHelper.copyFields (asset, embeddedAsset);
				embeddedAsset.type = Std.string (asset.type).toLowerCase ();
				context.assets.push (embeddedAsset);
				
			}
			
		}
		
		context.libraries = new Array <Dynamic> ();
		
		for (library in libraries) {
			
			var libraryData:Dynamic = { };
			ObjectHelper.copyFields (library, libraryData);
			libraryData.type = Std.string (library.type).toLowerCase ();
			context.libraries.push (libraryData);
			
		}
		
		Reflect.setField (context, "ndlls", ndlls);
		//Reflect.setField (context, "sslCaCert", sslCaCert);
		context.sslCaCert = "";
		
		var compilerFlags = [];
		
		for (haxelib in haxelibs) {
			
			var name = haxelib.name;
			
			if (haxelib.version != "") {
				
				name += ":" + haxelib.version;
				
			}
			
			compilerFlags.push ("-lib " + name);
			
			Reflect.setField (context, "LIB_" + haxelib.name.toUpperCase (), true);
			
		}
		
		for (source in sources) {
			
			compilerFlags.push ("-cp " + source);
			
		}
		
		for (key in haxedefs.keys ()) {
			
			var value = haxedefs.get (key);
			
			if (value == null || value == "") {
				
				compilerFlags.push ("-D " + key);
				
			} else {
				
				compilerFlags.push ("-D " + key + "=" + value);
				
			}
			
		}
		
		if (target != Platform.FLASH) {
			
			compilerFlags.push ("-D " + Std.string (target).toLowerCase ());
			
		}
		
		compilerFlags.push ("-D " + Std.string (platformType).toLowerCase ());
		compilerFlags = compilerFlags.concat (haxeflags);
		
		if (compilerFlags.length == 0) {
			
			context.HAXE_FLAGS = "";
			
		} else {
			
			context.HAXE_FLAGS = "\n" + compilerFlags.join ("\n");
			
		}
		
		var main = app.main;
		
		if (main == null) {
			
			main = defaultApp.main;
			
		}
		
		var indexOfPeriod = main.lastIndexOf (".");
        
		context.APP_MAIN_PACKAGE = main.substr (0, indexOfPeriod + 1);
		context.APP_MAIN_CLASS = main.substr (indexOfPeriod + 1);
		
		var hxml = Std.string (target).toLowerCase () + "/hxml/" + (debug ? "debug" : "release") + ".hxml";
		
		for (templatePath in templatePaths) {
			
			var path = PathHelper.combine (templatePath, hxml);
			
			if (FileSystem.exists (path)) {
				
				context.HXML_PATH = path;
				
			}
			
		}
		
		for (field in Reflect.fields (context)) {
			
			//Sys.println ("context." + field + " = " + Reflect.field (context, field));
		}
		
		context.DEBUG = debug;
		context.SWF_VERSION = app.swfVersion;
		context.PRELOADER_NAME = app.preloader;
		context.WIN_BACKGROUND = window.background;
		context.WIN_FULLSCREEN = window.fullscreen;
		context.WIN_ORIENTATION = "";
		
		if (window.orientation == Orientation.LANDSCAPE || window.orientation == Orientation.PORTRAIT) {
			
			context.WIN_ORIENTATION = Std.string (window.orientation).toLowerCase ();
			
		}
		
		context.WIN_ALLOW_SHADERS = window.allowShaders;
		context.WIN_REQUIRE_SHADERS = window.requireShaders;
		context.WIN_DEPTH_BUFFER = window.depthBuffer;
		context.WIN_STENCIL_BUFFER = window.stencilBuffer;
		
		if (certificate != null) {
			
			context.KEY_STORE = PathHelper.tryFullPath (certificate.path);
			
			if (certificate.password != null) {
				
				context.KEY_STORE_PASSWORD = certificate.password;
				
			}
			
			if (certificate.alias != null) {
				
				context.KEY_STORE_ALIAS = certificate.alias;
				
			} else if (certificate.path != null) {
				
				context.KEY_STORE_ALIAS = Path.withoutExtension (Path.withoutDirectory (certificate.path));
				
			}
			
			if (certificate.aliasPassword != null) {
				
				context.KEY_STORE_ALIAS_PASSWORD = certificate.aliasPassword;
				
			} else if (certificate.password != null) {
				
				context.KEY_STORE_ALIAS_PASSWORD = certificate.password;
				
			}
			
		}
		
		return context;
		
	}
	

}