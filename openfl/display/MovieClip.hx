package openfl.display; #if !flash #if !lime_legacy


/**
 * The MovieClip class inherits from the following classes: Sprite,
 * DisplayObjectContainer, InteractiveObject, DisplayObject, and
 * EventDispatcher.
 *
 * <p>Unlike the Sprite object, a MovieClip object has a timeline.</p>
 *
 * <p>>In Flash Professional, the methods for the MovieClip class provide the
 * same functionality as actions that target movie clips. Some additional
 * methods do not have equivalent actions in the Actions toolbox in the
 * Actions panel in the Flash authoring tool. </p>
 *
 * <p>Children instances placed on the Stage in Flash Professional cannot be
 * accessed by code from within the constructor of a parent instance since
 * they have not been created at that point in code execution. Before
 * accessing the child, the parent must instead either create the child
 * instance by code or delay access to a callback function that listens for
 * the child to dispatch its <code>Event.ADDED_TO_STAGE</code> event.</p>
 *
 * <p>If you modify any of the following properties of a MovieClip object that
 * contains a motion tween, the playhead is stopped in that MovieClip object:
 * <code>alpha</code>, <code>blendMode</code>, <code>filters</code>,
 * <code>height</code>, <code>opaqueBackground</code>, <code>rotation</code>,
 * <code>scaleX</code>, <code>scaleY</code>, <code>scale9Grid</code>,
 * <code>scrollRect</code>, <code>transform</code>, <code>visible</code>,
 * <code>width</code>, <code>x</code>, or <code>y</code>. However, it does not
 * stop the playhead in any child MovieClip objects of that MovieClip
 * object.</p>
 *
 * <p><b>Note:</b>Flash Lite 4 supports the MovieClip.opaqueBackground
 * property only if FEATURE_BITMAPCACHE is defined. The default configuration
 * of Flash Lite 4 does not define FEATURE_BITMAPCACHE. To enable the
 * MovieClip.opaqueBackground property for a suitable device, define
 * FEATURE_BITMAPCACHE in your project.</p>
 */
class MovieClip extends Sprite {
	
	
	/**
	 * Specifies the number of the frame in which the playhead is located in the
	 * timeline of the MovieClip instance. If the movie clip has multiple scenes,
	 * this value is the frame number in the current scene.
	 */
	public var currentFrame (get, null):Int;
	
	/**
	 * The label at the current frame in the timeline of the MovieClip instance.
	 * If the current frame has no label, <code>currentLabel</code> is
	 * <code>null</code>.
	 */
	public var currentFrameLabel (get, null):String;
	
	/**
	 * The current label in which the playhead is located in the timeline of the
	 * MovieClip instance. If the current frame has no label,
	 * <code>currentLabel</code> is set to the name of the previous frame that
	 * includes a label. If the current frame and previous frames do not include
	 * a label, <code>currentLabel</code> returns <code>null</code>.
	 */
	public var currentLabel (get, null):String;
	
	/**
	 * Returns an array of FrameLabel objects from the current scene. If the
	 * MovieClip instance does not use scenes, the array includes all frame
	 * labels from the entire MovieClip instance.
	 */
	public var currentLabels (get, null):Array<FrameLabel>;
	
	/**
	 * A Boolean value that indicates whether a movie clip is enabled. The
	 * default value of <code>enabled</code> is <code>true</code>. If
	 * <code>enabled</code> is set to <code>false</code>, the movie clip's Over,
	 * Down, and Up frames are disabled. The movie clip continues to receive
	 * events(for example, <code>mouseDown</code>, <code>mouseUp</code>,
	 * <code>keyDown</code>, and <code>keyUp</code>).
	 *
	 * <p>The <code>enabled</code> property governs only the button-like
	 * properties of a movie clip. You can change the <code>enabled</code>
	 * property at any time; the modified movie clip is immediately enabled or
	 * disabled. If <code>enabled</code> is set to <code>false</code>, the object
	 * is not included in automatic tab ordering.</p>
	 */
	public var enabled:Bool;
	
	/**
	 * The number of frames that are loaded from a streaming SWF file. You can
	 * use the <code>framesLoaded</code> property to determine whether the
	 * contents of a specific frame and all the frames before it loaded and are
	 * available locally in the browser. You can also use it to monitor the
	 * downloading of large SWF files. For example, you might want to display a
	 * message to users indicating that the SWF file is loading until a specified
	 * frame in the SWF file finishes loading.
	 *
	 * <p>If the movie clip contains multiple scenes, the
	 * <code>framesLoaded</code> property returns the number of frames loaded for
	 * <i>all</i> scenes in the movie clip.</p>
	 */
	public var framesLoaded (get, null):Int;
	
	/**
	 * The total number of frames in the MovieClip instance.
	 *
	 * <p>If the movie clip contains multiple frames, the
	 * <code>totalFrames</code> property returns the total number of frames in
	 * <i>all</i> scenes in the movie clip.</p>
	 */
	public var totalFrames (get, null):Int;
	
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	@:noCompletion private var __totalFrames:Int;
	
	
	/**
	 * Creates a new MovieClip instance. After creating the MovieClip, call the
	 * <code>addChild()</code> or <code>addChildAt()</code> method of a display
	 * object container that is onstage.
	 */
	public function new () {
		
		super ();
		
		__currentFrame = 0;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;
		
	}
	
	
	/**
	 * Starts playing the SWF file at the specified frame. This happens after all
	 * remaining actions in the frame have finished executing. To specify a scene
	 * as well as a frame, specify a value for the <code>scene</code> parameter.
	 * 
	 * @param frame A number representing the frame number, or a string
	 *              representing the label of the frame, to which the playhead is
	 *              sent. If you specify a number, it is relative to the scene
	 *              you specify. If you do not specify a scene, the current scene
	 *              determines the global frame number to play. If you do specify
	 *              a scene, the playhead jumps to the frame number in the
	 *              specified scene.
	 * @param scene The name of the scene to play. This parameter is optional.
	 */
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	/**
	 * Brings the playhead to the specified frame of the movie clip and stops it
	 * there. This happens after all remaining actions in the frame have finished
	 * executing. If you want to specify a scene in addition to a frame, specify
	 * a <code>scene</code> parameter.
	 * 
	 * @param frame A number representing the frame number, or a string
	 *              representing the label of the frame, to which the playhead is
	 *              sent. If you specify a number, it is relative to the scene
	 *              you specify. If you do not specify a scene, the current scene
	 *              determines the global frame number at which to go to and
	 *              stop. If you do specify a scene, the playhead goes to the
	 *              frame number in the specified scene and stops.
	 * @param scene The name of the scene. This parameter is optional.
	 * @throws ArgumentError If the <code>scene</code> or <code>frame</code>
	 *                       specified are not found in this movie clip.
	 */
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	/**
	 * Sends the playhead to the next frame and stops it. This happens after all
	 * remaining actions in the frame have finished executing.
	 * 
	 */
	public function nextFrame ():Void {
		
		
		
	}
	
	
	/**
	 * Moves the playhead in the timeline of the movie clip.
	 * 
	 */
	public function play ():Void {
		
		
		
	}
	
	
	/**
	 * Sends the playhead to the previous frame and stops it. This happens after
	 * all remaining actions in the frame have finished executing.
	 * 
	 */
	public function prevFrame ():Void {
		
		
		
	}
	
	
	/**
	 * Stops the playhead in the movie clip.
	 * 
	 */
	public function stop ():Void {
		
		
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_currentFrame ():Int { return __currentFrame; }
	@:noCompletion private function get_currentFrameLabel ():String { return __currentFrameLabel; }
	@:noCompletion private function get_currentLabel ():String { return __currentLabel; }
	@:noCompletion private function get_currentLabels ():Array<FrameLabel> { return __currentLabels; }
	@:noCompletion private function get_framesLoaded ():Int { return __totalFrames; }
	@:noCompletion private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


#else
typedef MovieClip = openfl._v2.display.MovieClip;
#end
#else
typedef MovieClip = flash.display.MovieClip;
#end