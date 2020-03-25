import MouseEvent from "openfl/events/MouseEvent";

namespace openfl.display
{
	/**
		The MovieClip class inherits from the following classes: Sprite,
		DisplayObjectContainer, InteractiveObject, DisplayObject, and
		EventDispatcher.

		Unlike the Sprite object, a MovieClip object has a timeline.

		In Flash Professional, the methods for the MovieClip class provide the
		same functionality as actions that target movie clips. Some additional
		methods do not have equivalent actions in the Actions toolbox in the
		Actions panel in the Flash authoring tool.

		Children instances placed on the Stage in Flash Professional cannot be
		accessed by code from within the constructor of a parent instance since
		they have not been created at that point in code execution. Before
		accessing the child, the parent must instead either create the child
		instance by code or delay access to a callback that listens for
		the child to dispatch its `Event.ADDED_TO_STAGE` event.

		If you modify any of the following properties of a MovieClip object that
		contains a motion tween, the playhead is stopped in that MovieClip object:
		`alpha`, `blendMode`, `filters`,
		`height`, `opaqueBackground`, `rotation`,
		`scaleX`, `scaleY`, `scale9Grid`,
		`scrollRect`, `transform`, `visible`,
		`width`, `x`, or `y`. However, it does not
		stop the playhead in any child MovieClip objects of that MovieClip
		object.

		**Note:**Flash Lite 4 supports the MovieClip.opaqueBackground
		property only if FEATURE_BITMAPCACHE is defined. The default configuration
		of Flash Lite 4 does not define FEATURE_BITMAPCACHE. To enable the
		MovieClip.opaqueBackground property for a suitable device, define
		FEATURE_BITMAPCACHE in your project.
	**/
	export class MovieClip extends Sprite
	{
		/**
			Specifies the number of the frame in which the playhead is located in the
			timeline of the MovieClip instance. If the movie clip has multiple scenes,
			this value is the frame number in the current scene.
		**/
		public currentFrame(get, never): number;

		/**
			The label at the current frame in the timeline of the MovieClip instance.
			If the current frame has no label, `currentLabel` is
			`null`.
		**/
		public currentFrameLabel(get, never): string;

		/**
			The current label in which the playhead is located in the timeline of the
			MovieClip instance. If the current frame has no label,
			`currentLabel` is set to the name of the previous frame that
			includes a label. If the current frame and previous frames do not include
			a label, `currentLabel` returns `null`.
		**/
		public currentLabel(get, never): string;

		/**
			Returns an array of FrameLabel objects from the current scene. If the
			MovieClip instance does not use scenes, the array includes all frame
			labels from the entire MovieClip instance.
		**/
		public currentLabels(get, never): Array<FrameLabel>;

		/**
			The current scene in which the playhead is located in the timeline of
			the MovieClip instance.
		**/
		public currentScene(get, never): Scene;

		/**
			A Boolean value that indicates whether a movie clip is enabled. The
			default value of `enabled` is `true`. If
			`enabled` is set to `false`, the movie clip's Over,
			Down, and Up frames are disabled. The movie clip continues to receive
			events(for example, `mouseDown`, `mouseUp`,
			`keyDown`, and `keyUp`).

			The `enabled` property governs only the button-like
			properties of a movie clip. You can change the `enabled`
			property at any time; the modified movie clip is immediately enabled or
			disabled. If `enabled` is set to `false`, the object
			is not included in automatic tab ordering.
		**/
		public enabled(get, set): boolean;

		/**
			The number of frames that are loaded from a streaming SWF file. You can
			use the `framesLoaded` property to determine whether the
			contents of a specific frame and all the frames before it loaded and are
			available locally in the browser. You can also use it to monitor the
			downloading of large SWF files. For example, you might want to display a
			message to users indicating that the SWF file is loading until a specified
			frame in the SWF file finishes loading.

			If the movie clip contains multiple scenes, the
			`framesLoaded` property returns the number of frames loaded for
			_all_ scenes in the movie clip.
		**/
		public framesLoaded(get, never): number;

		/**
			A Boolean value that indicates whether a movie clip is curently playing.
		**/
		public isPlaying(get, never): boolean;

		/**
			An array of Scene objects, each listing the name, the number of frames, and
			the frame labels for a scene in the MovieClip instance.
		**/
		public scenes(get, never): Array<Scene>;

		/**
			The total number of frames in the MovieClip instance.

			If the movie clip contains multiple frames, the
			`totalFrames` property returns the total number of frames in
			_all_ scenes in the movie clip.
		**/
		public totalFrames(get, never): number;

		protected static __constructor: MovieClip -> Void;

	// /** @hidden */ @:dox(hide) public trackAsMenu:Bool;
	protected __enabled: boolean;
	protected __hasDown: boolean;
	protected __hasOver: boolean;
	protected __hasUp: boolean;
	protected __mouseIsDown: boolean;
	protected __scene: Scene;
	protected __timeline: Timeline;

	/**
		Creates a new MovieClip instance. After creating the MovieClip, call the
		`addChild()` or `addChildAt()` method of a display
		object container that is onstage.
	**/
	public constructor()
	{
		super();

		__enabled = true;
		__type = MOVIE_CLIP;

		if (__constructor != null)
		{
			var method = __constructor;
			__constructor = null;

			method(this);
		}
	}

	public addFrameScript(index : number, method: void -> Void): void
		{
			if(__timeline != null)
	{
		__timeline.__addFrameScript(index, method);
	}
}

	/**
		Attaches a Timeline object to the current movie clip.

		A movie clip with a timeline will support additional movie clip features
		such as `play()`, `gotoAndPlay()`, `stop()` and `prevFrame()`.

		@param	timeline	The Timeline to attach to this MovieClip
	**/
	public attachTimeline(timeline: Timeline): void
	{
		__timeline = timeline;
		if(timeline != null)
{
	timeline.__attachMovieClip(this);
	play();
}
}

	/**
		Creates a new MovieClip instance from a Timeline.

		@param	timeline	A Timeline instance
		@returns	A MovieClip attached to the Timeline
	**/
	public static fromTimeline(timeline: Timeline): MovieClip
{
	var movieClip = new MovieClip();
	movieClip.attachTimeline(timeline);
	return movieClip;
}

	/**
		Starts playing the SWF file at the specified frame. This happens after all
		remaining actions in the frame have finished executing. To specify a scene
		as well as a frame, specify a value for the `scene` parameter.

		@param frame A number representing the frame number, or a string
					 representing the label of the frame, to which the playhead is
					 sent. If you specify a number, it is relative to the scene
					 you specify. If you do not specify a scene, the current scene
					 determines the global frame number to play. If you do specify
					 a scene, the playhead jumps to the frame number in the
					 specified scene.
		@param scene The name of the scene to play. This parameter is optional.
	**/
	public gotoAndPlay(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end, scene: string = null): void
	{
		if(__timeline != null)
{
	__timeline.__gotoAndPlay(frame, scene);
}
	}

	/**
		Brings the playhead to the specified frame of the movie clip and stops it
		there. This happens after all remaining actions in the frame have finished
		executing. If you want to specify a scene in addition to a frame, specify
		a `scene` parameter.

		@param frame A number representing the frame number, or a string
					 representing the label of the frame, to which the playhead is
					 sent. If you specify a number, it is relative to the scene
					 you specify. If you do not specify a scene, the current scene
					 determines the global frame number at which to go to and
					 stop. If you do specify a scene, the playhead goes to the
					 frame number in the specified scene and stops.
		@param scene The name of the scene. This parameter is optional.
		@throws ArgumentError If the `scene` or `frame`
							  specified are not found in this movie clip.
	**/
	public gotoAndStop(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end, scene: string = null): void
	{
		if(__timeline != null)
{
	__timeline.__gotoAndStop(frame, scene);
}
	}

	/**
		Sends the playhead to the next frame and stops it. This happens after all
		remaining actions in the frame have finished executing.

	**/
	public nextFrame(): void
	{
		if(__timeline != null)
{
	__timeline.__nextFrame();
}
	}

	/**
		Moves the playhead to the next scene of the MovieClip instance. This happens
		after all remaining actions in the frame have finished executing.
	**/
	public nextScene(): void
	{
		if(__timeline != null)
{
	__timeline.__nextScene();
}
	}

	/**
		Moves the playhead in the timeline of the movie clip.

	**/
	public play(): void
	{
		if(__timeline != null)
{
	__timeline.__play();
}
	}

	/**
		Sends the playhead to the previous frame and stops it. This happens after
		all remaining actions in the frame have finished executing.

	**/
	public prevFrame(): void
	{
		if(__timeline != null)
{
	__timeline.__prevFrame();
}
	}

	/**
		Moves the playhead to the previous scene of the MovieClip instance. This
		happens after all remaining actions in the frame have finished executing.
	**/
	public prevScene(): void
	{
		if(__timeline != null)
{
	__timeline.__prevScene();
}
	}

	/**
		Stops the playhead in the movie clip.

	**/
	public stop(): void
	{
		if(__timeline != null)
{
	__timeline.__stop();
}
	}

protected__stopAllMovieClips(): void
	{
		super.__stopAllMovieClips();
		stop();
	}

protected__tabTest(stack: Array<InteractiveObject>): void
	{
		if(!__enabled) return;
		super.__tabTest(stack);
	}

	// Event Handlers
	protected __onMouseDown(event: MouseEvent): void
{
	if(__enabled && __hasDown)
{
	gotoAndStop("_down");
}

__mouseIsDown = true;
stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp, true);
}

	protected __onMouseUp(event: MouseEvent): void
	{
		__mouseIsDown = false;

		if(stage != null)
{
	stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
}

if (!__buttonMode)
{
	return;
}

if (event.target == this && __enabled && __hasOver)
{
	gotoAndStop("_over");
}
else if (__enabled && __hasUp)
{
	gotoAndStop("_up");
}
}

	protected __onRollOut(event: MouseEvent): void
	{
		if(!__enabled) return;

		if(__mouseIsDown && __hasOver)
{
	gotoAndStop("_over");
}
	else if (__hasUp)
{
	gotoAndStop("_up");
}
}

	protected __onRollOver(event: MouseEvent): void
	{
		if(__enabled && __hasOver)
{
	gotoAndStop("_over");
}
}

// Getters & Setters
protectedset_buttonMode(value : boolean) : boolean
{
	if (__buttonMode != value)
	{
		if (value)
		{
			__hasDown = false;
			__hasOver = false;
			__hasUp = false;

			for (frameLabel in currentLabels)
			{
				switch (frameLabel.name)
				{
					case "_up":
						__hasUp = true;
					case "_over":
						__hasOver = true;
					case "_down":
						__hasDown = true;
					default:
				}
			}

			if (__hasDown || __hasOver || __hasUp)
			{
				addEventListener(MouseEvent.ROLL_OVER, __onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, __onRollOut);
				addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			}
		}
		else
		{
			removeEventListener(MouseEvent.ROLL_OVER, __onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, __onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}

		__buttonMode = value;
	}

	return value;
}

	protected get_currentFrame() : number
{
	if (__timeline != null)
	{
		return __timeline.__currentFrame;
	}
	else
	{
		return 1;
	}
}

	protected get_currentFrameLabel(): string
{
	if (__timeline != null)
	{
		return __timeline.__currentFrameLabel;
	}
	else
	{
		return null;
	}
}

	protected get_currentLabel(): string
{
	if (__timeline != null)
	{
		return __timeline.__currentLabel;
	}
	else
	{
		return null;
	}
}

	protected get_currentLabels(): Array < FrameLabel >
{
	if(__timeline != null)
{
	return __timeline.__currentLabels.copy();
}
		else
{
	return [];
}
	}

	protected get_currentScene(): Scene
{
	if (__timeline != null)
	{
		return __timeline.__currentScene;
	}
	else
	{
		if (__scene == null)
		{
			__scene = new Scene("", [], 1);
		}
		return __scene;
	}
}

	protected get_enabled() : boolean
{
	return __enabled;
}

	protected set_enabled(value : boolean) : boolean
{
	return __enabled = value;
}

	protected get_framesLoaded() : number
{
	if (__timeline != null)
	{
		return __timeline.__framesLoaded;
	}
	else
	{
		return 1;
	}
}

	protected get_isPlaying() : boolean
{
	if (__timeline != null)
	{
		return __timeline.__isPlaying;
	}
	else
	{
		return false;
	}
}

	protected get_scenes(): Array < Scene >
{
	if(__timeline != null)
{
	return __timeline.scenes.copy();
}
		else
{
	return [currentScene];
}
	}

	protected get_totalFrames() : number
{
	if (__timeline != null)
	{
		return __timeline.__totalFrames;
	}
	else
	{
		return 1;
	}
}
}
}

export default openfl.display.MovieClip;
