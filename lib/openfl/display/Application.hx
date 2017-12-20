package openfl.display;


// import lime.app.Application in LimeApplication;
typedef LimeApplication = Dynamic;
typedef Config = Dynamic;
typedef Event<T> = Dynamic;

@:jsRequire("openfl/display/Application", "default")


extern class Application implements Dynamic /*extends LimeApplication*/ {
	
	
	/**
	 * The current Application instance that is executing
	**/
	public static var current (default, null):Application;
	
	
	/**
	 * Configuration values for the application, such as window options or a package name
	**/
	public var config (default, null):Config;
	
	/**
	 * The current frame rate (measured in frames-per-second) of the application.
	 *
	 * On some platforms, a frame rate of 60 or greater may imply vsync, which will
	 * perform more quickly on displays with a higher refresh rate
	**/
	public var frameRate (get, set):Float;
	
	/**
	 * A list of currently attached Module instances
	**/
	// public var modules (default, null):Array<IModule>;
	
	/**
	 * The Preloader for the current Application
	**/
	public var preloader (get, null):Preloader;
	
	/**
	 * Update events are dispatched each frame (usually just before rendering)
	 */
	public var onUpdate:Event<Int->Void>;
	
	/**
	 * The Renderer associated with this Application, or the first Renderer
	 * if there are multiple Renderer instances
	**/
	// public var renderer (get, null):Renderer;
	
	/**
	 * A list of Renderer instances associated with this Application
	**/
	// public var renderers (get, null):Array<Renderer>;
	
	/**
	 * The Window associated with this Application, or the first Window
	 * if there are multiple Windows active
	**/
	public var window (default, null):Window;
	
	/**
	 * A list of active Window instances associated with this Application
	**/
	public var windows (default, null):Array<Window>;
	
	public function new ();
	
	/**
	 * Adds a new module to the Application
	 * @param	module	A module to add
	 */
	// public function addModule (module:IModule):Void;
	
	
	/**
	 * Adds a new Renderer to the Application. By default, this is
	 * called automatically by create()
	 * @param	renderer	A Renderer object to add
	 */
	// public override function addRenderer (renderer:Renderer):Void;
	
	
	/**
	 * Initializes the Application, using the settings defined in
	 * the config instance. By default, this is called automatically
	 * when building the project using Lime's command-line tools
	 * @param	config	A Config object
	 */
	public function create (config:Config):Void;
	
	
	/**
	 * Adds a new Window to the Application. By default, this is
	 * called automatically by create()
	 * @param	window	A Window object to add
	 */
	public function createWindow (window:Window):Void;
	
	
	/**
	 * Execute the Application. On native platforms, this method
	 * blocks until the application is finished running. On other 
	 * platforms, it will return immediately
	 * @return An exit code, 0 if there was no error
	 */
	public function exec ():Int;
	
	
	/**
	 * Removes a module from the Application
	 * @param	module	A module to remove
	 */
	// public function removeModule (module:IModule):Void;
	
	
}