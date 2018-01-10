package openfl.display; #if (display || !flash)


@:jsRequire("openfl/display/MovieClip", "default")

/**
 * The MovieClip class inherits from the following classes: Sprite,
 * DisplayObjectContainer, InteractiveObject, DisplayObject, and
 * EventDispatcher.
 *
 * Unlike the Sprite object, a MovieClip object has a timeline.
 *
 * In Flash Professional, the methods for the MovieClip class provide the
 * same functionality as actions that target movie clips. Some additional
 * methods do not have equivalent actions in the Actions toolbox in the
 * Actions panel in the Flash authoring tool. 
 *
 * Children instances placed on the Stage in Flash Professional cannot be
 * accessed by code from within the constructor of a parent instance since
 * they have not been created at that point in code execution. Before
 * accessing the child, the parent must instead either create the child
 * instance by code or delay access to a callback function that listens for
 * the child to dispatch its `Event.ADDED_TO_STAGE` event.
 *
 * If you modify any of the following properties of a MovieClip object that
 * contains a motion tween, the playhead is stopped in that MovieClip object:
 * `alpha`, `blendMode`, `filters`,
 * `height`, `opaqueBackground`, `rotation`,
 * `scaleX`, `scaleY`, `scale9Grid`,
 * `scrollRect`, `transform`, `visible`,
 * `width`, `x`, or `y`. However, it does not
 * stop the playhead in any child MovieClip objects of that MovieClip
 * object.
 *
 * **Note:**Flash Lite 4 supports the MovieClip.opaqueBackground
 * property only if FEATURE_BITMAPCACHE is defined. The default configuration
 * of Flash Lite 4 does not define FEATURE_BITMAPCACHE. To enable the
 * MovieClip.opaqueBackground property for a suitable device, define
 * FEATURE_BITMAPCACHE in your project.
 */
extern class MovieClip extends Sprite implements Dynamic {
	
	
	/**
	 * Specifies the number of the frame in which the playhead is located in the
	 * timeline of the MovieClip instance. If the movie clip has multiple scenes,
	 * this value is the frame number in the current scene.
	 */
	public var currentFrame (default, never):Int;
	
	/**
	 * The label at the current frame in the timeline of the MovieClip instance.
	 * If the current frame has no label, `currentLabel` is
	 * `null`.
	 */
	public var currentFrameLabel (default, never):String;
	
	/**
	 * The current label in which the playhead is located in the timeline of the
	 * MovieClip instance. If the current frame has no label,
	 * `currentLabel` is set to the name of the previous frame that
	 * includes a label. If the current frame and previous frames do not include
	 * a label, `currentLabel` returns `null`.
	 */
	public var currentLabel (default, never):String;
	
	/**
	 * Returns an array of FrameLabel objects from the current scene. If the
	 * MovieClip instance does not use scenes, the array includes all frame
	 * labels from the entire MovieClip instance.
	 */
	public var currentLabels (default, never):Array<FrameLabel>;
	
	/**
	 * A Boolean value that indicates whether a movie clip is enabled. The
	 * default value of `enabled` is `true`. If
	 * `enabled` is set to `false`, the movie clip's Over,
	 * Down, and Up frames are disabled. The movie clip continues to receive
	 * events(for example, `mouseDown`, `mouseUp`,
	 * `keyDown`, and `keyUp`).
	 *
	 * The `enabled` property governs only the button-like
	 * properties of a movie clip. You can change the `enabled`
	 * property at any time; the modified movie clip is immediately enabled or
	 * disabled. If `enabled` is set to `false`, the object
	 * is not included in automatic tab ordering.
	 */
	public var enabled:Bool;
	
	/**
	 * The number of frames that are loaded from a streaming SWF file. You can
	 * use the `framesLoaded` property to determine whether the
	 * contents of a specific frame and all the frames before it loaded and are
	 * available locally in the browser. You can also use it to monitor the
	 * downloading of large SWF files. For example, you might want to display a
	 * message to users indicating that the SWF file is loading until a specified
	 * frame in the SWF file finishes loading.
	 *
	 * If the movie clip contains multiple scenes, the
	 * `framesLoaded` property returns the number of frames loaded for
	 * _all_ scenes in the movie clip.
	 */
	public var framesLoaded (default, never):Int;
	
	public var isPlaying (default, never):Bool;
	
	#if flash
	@:noCompletion @:dox(hide) public var scenes (default, null):Array<flash.display.Scene>;
	#end
	
	/**
	 * The total number of frames in the MovieClip instance.
	 *
	 * If the movie clip contains multiple frames, the
	 * `totalFrames` property returns the total number of frames in
	 * _all_ scenes in the movie clip.
	 */
	public var totalFrames (default, never):Int;
	
	#if flash
	@:noCompletion @:dox(hide) public var trackAsMenu:Bool;
	#end
	
	
	/**
	 * Creates a new MovieClip instance. After creating the MovieClip, call the
	 * `addChild()` or `addChildAt()` method of a display
	 * object container that is onstage.
	 */
	public function new ();
	
	
	public function addFrameScript (index:Int, method:Void->Void):Void;
	
	
	/**
	 * Starts playing the SWF file at the specified frame. This happens after all
	 * remaining actions in the frame have finished executing. To specify a scene
	 * as well as a frame, specify a value for the `scene` parameter.
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
	public function gotoAndPlay (frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void;
	
	
	/**
	 * Brings the playhead to the specified frame of the movie clip and stops it
	 * there. This happens after all remaining actions in the frame have finished
	 * executing. If you want to specify a scene in addition to a frame, specify
	 * a `scene` parameter.
	 * 
	 * @param frame A number representing the frame number, or a string
	 *              representing the label of the frame, to which the playhead is
	 *              sent. If you specify a number, it is relative to the scene
	 *              you specify. If you do not specify a scene, the current scene
	 *              determines the global frame number at which to go to and
	 *              stop. If you do specify a scene, the playhead goes to the
	 *              frame number in the specified scene and stops.
	 * @param scene The name of the scene. This parameter is optional.
	 * @throws ArgumentError If the `scene` or `frame`
	 *                       specified are not found in this movie clip.
	 */
	public function gotoAndStop (frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void;
	
	
	/**
	 * Sends the playhead to the next frame and stops it. This happens after all
	 * remaining actions in the frame have finished executing.
	 * 
	 */
	public function nextFrame ():Void;
	
	
	#if flash
	@:noCompletion @:dox(hide) public function nextScene ():Void;
	#end
	
	
	/**
	 * Moves the playhead in the timeline of the movie clip.
	 * 
	 */
	public function play ():Void;
	
	
	/**
	 * Sends the playhead to the previous frame and stops it. This happens after
	 * all remaining actions in the frame have finished executing.
	 * 
	 */
	public function prevFrame ():Void;
	
	
	#if flash
	@:noCompletion @:dox(hide) public function prevScene ():Void;
	#end
	
	
	/**
	 * Stops the playhead in the movie clip.
	 * 
	 */
	public function stop ():Void;
	
	
}


#else
typedef MovieClip = flash.display.MovieClip;
#end