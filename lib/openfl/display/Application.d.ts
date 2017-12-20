import Preloader from "./Preloader";
import Window from "./Window";

type Config = any;
type Event<T> = any;


declare namespace openfl.display {
	
	
	export class Application {
		
		
		/**
		 * The current Application instance that is executing
		**/
		static readonly current:Application;
		
		
		/**
		 * Configuration values for the application, such as window options or a package name
		**/
		readonly config:Config;
		
		/**
		 * The current frame rate (measured in frames-per-second) of the application.
		 *
		 * On some platforms, a frame rate of 60 or greater may imply vsync, which will
		 * perform more quickly on displays with a higher refresh rate
		**/
		frameRate:number;
		
		/**
		 * A list of currently attached Module instances
		**/
		// public var modules (default, null):Array<IModule>;
		
		/**
		 * The Preloader for the current Application
		**/
		readonly preloader:Preloader;
		
		/**
		 * Update events are dispatched each frame (usually just before rendering)
		 */
		onUpdate:Event<any>;
		
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
		readonly window:Window;
		
		/**
		 * A list of active Window instances associated with this Application
		**/
		readonly windows:Array<Window>;
		
		constructor ();
		
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
		create (config:Config):void;
		
		
		/**
		 * Adds a new Window to the Application. By default, this is
		 * called automatically by create()
		 * @param	window	A Window object to add
		 */
		createWindow (window:Window):void;
		
		
		/**
		 * Execute the Application. On native platforms, this method
		 * blocks until the application is finished running. On other 
		 * platforms, it will return immediately
		 * @return An exit code, 0 if there was no error
		 */
		exec ():number;
		
		
		/**
		 * Removes a module from the Application
		 * @param	module	A module to remove
		 */
		// public function removeModule (module:IModule):Void;
		
		
	}
	
	
}


export default openfl.display.Application;