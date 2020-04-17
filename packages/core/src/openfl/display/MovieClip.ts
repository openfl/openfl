import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import * as internal from "../_internal/utils/InternalAccess";
import FrameLabel from "../display/FrameLabel";
import InteractiveObject from "../display/InteractiveObject";
import Scene from "../display/Scene";
import Sprite from "../display/Sprite";
import Timeline from "../display/Timeline";
import MouseEvent from "../events/MouseEvent";

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
export default class MovieClip extends Sprite
{
	protected static __constructor: (scope: MovieClip) => void;

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

		this.__enabled = true;
		this.__type = DisplayObjectType.MOVIE_CLIP;

		if (MovieClip.__constructor != null)
		{
			var method = MovieClip.__constructor;
			MovieClip.__constructor = null;

			method(this);
		}
	}

	public addFrameScript(index: number, method: () => void): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__addFrameScript(index, method);
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
		this.__timeline = timeline;
		if (timeline != null)
		{
			(<internal.Timeline><any>timeline).__attachMovieClip(this);
			this.play();
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
	public gotoAndPlay(frame: number | string, scene: string = null): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__gotoAndPlay(frame, scene);
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
	public gotoAndStop(frame: number | string, scene: string = null): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__gotoAndStop(frame, scene);
		}
	}

	/**
		Sends the playhead to the next frame and stops it. This happens after all
		remaining actions in the frame have finished executing.

	**/
	public nextFrame(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__nextFrame();
		}
	}

	/**
		Moves the playhead to the next scene of the MovieClip instance. This happens
		after all remaining actions in the frame have finished executing.
	**/
	public nextScene(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__nextScene();
		}
	}

	/**
		Moves the playhead in the timeline of the movie clip.

	**/
	public play(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__play();
		}
	}

	/**
		Sends the playhead to the previous frame and stops it. This happens after
		all remaining actions in the frame have finished executing.

	**/
	public prevFrame(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__prevFrame();
		}
	}

	/**
		Moves the playhead to the previous scene of the MovieClip instance. This
		happens after all remaining actions in the frame have finished executing.
	**/
	public prevScene(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__prevScene();
		}
	}

	/**
		Stops the playhead in the movie clip.

	**/
	public stop(): void
	{
		if (this.__timeline != null)
		{
			(<internal.Timeline><any>this.__timeline).__stop();
		}
	}

	protected __stopAllMovieClips(): void
	{
		super.__stopAllMovieClips();
		stop();
	}

	protected __tabTest(stack: Array<InteractiveObject>): void
	{
		if (!this.__enabled) return;
		super.__tabTest(stack);
	}

	// Event Handlers

	protected __onMouseDown(event: MouseEvent): void
	{
		if (this.__enabled && this.__hasDown)
		{
			this.gotoAndStop("_down");
		}

		this.__mouseIsDown = true;
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onMouseUp, true);
	}

	protected __onMouseUp(event: MouseEvent): void
	{
		this.__mouseIsDown = false;

		if (this.stage != null)
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onMouseUp);
		}

		if (!this.__buttonMode)
		{
			return;
		}

		if (event.target == this && this.__enabled && this.__hasOver)
		{
			this.gotoAndStop("_over");
		}
		else if (this.__enabled && this.__hasUp)
		{
			this.gotoAndStop("_up");
		}
	}

	protected __onRollOut(event: MouseEvent): void
	{
		if (!this.__enabled) return;

		if (this.__mouseIsDown && this.__hasOver)
		{
			this.gotoAndStop("_over");
		}
		else if (this.__hasUp)
		{
			this.gotoAndStop("_up");
		}
	}

	protected __onRollOver(event: MouseEvent): void
	{
		if (this.__enabled && this.__hasOver)
		{
			this.gotoAndStop("_over");
		}
	}

	// Getters & Setters

	public set buttonMode(value: boolean)
	{
		if (this.__buttonMode != value)
		{
			if (value)
			{
				this.__hasDown = false;
				this.__hasOver = false;
				this.__hasUp = false;

				for (let frameLabel of this.currentLabels)
				{
					switch (frameLabel.name)
					{
						case "_up":
							this.__hasUp = true;
							break;
						case "_over":
							this.__hasOver = true;
							break;
						case "_down":
							this.__hasDown = true;
							break;
						default:
					}
				}

				if (this.__hasDown || this.__hasOver || this.__hasUp)
				{
					this.addEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
					this.addEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
					this.addEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseDown);
				}
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseDown);
			}

			this.__buttonMode = value;
		}
	}

	/**
		Specifies the number of the frame in which the playhead is located in the
		timeline of the MovieClip instance. If the movie clip has multiple scenes,
		this value is the frame number in the current scene.
	**/
	public get currentFrame(): number
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__currentFrame;
		}
		else
		{
			return 1;
		}
	}

	/**
		The label at the current frame in the timeline of the MovieClip instance.
		If the current frame has no label, `currentLabel` is
		`null`.
	**/
	public get currentFrameLabel(): string
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__currentFrameLabel;
		}
		else
		{
			return null;
		}
	}

	/**
		The current label in which the playhead is located in the timeline of the
		MovieClip instance. If the current frame has no label,
		`currentLabel` is set to the name of the previous frame that
		includes a label. If the current frame and previous frames do not include
		a label, `currentLabel` returns `null`.
	**/
	public get currentLabel(): string
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__currentLabel;
		}
		else
		{
			return null;
		}
	}

	/**
		Returns an array of FrameLabel objects from the current scene. If the
		MovieClip instance does not use scenes, the array includes all frame
		labels from the entire MovieClip instance.
	**/
	public get currentLabels(): Array<FrameLabel>
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__currentLabels.slice();
		}
		else
		{
			return [];
		}
	}

	/**
		The current scene in which the playhead is located in the timeline of
		the MovieClip instance.
	**/
	public get currentScene(): Scene
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__currentScene;
		}
		else
		{
			if (this.__scene == null)
			{
				this.__scene = new Scene("", [], 1);
			}
			return this.__scene;
		}
	}

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
	public get enabled(): boolean
	{
		return this.__enabled;
	}

	public set enabled(value: boolean)
	{
		this.__enabled = value;
	}

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
	public get framesLoaded(): number
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__framesLoaded;
		}
		else
		{
			return 1;
		}
	}

	/**
		A Boolean value that indicates whether a movie clip is curently playing.
	**/
	public get isPlaying(): boolean
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__isPlaying;
		}
		else
		{
			return false;
		}
	}

	/**
		An array of Scene objects, each listing the name, the number of frames, and
		the frame labels for a scene in the MovieClip instance.
	**/
	public get scenes(): Array<Scene>
	{
		if (this.__timeline != null)
		{
			return this.__timeline.scenes.slice();
		}
		else
		{
			return [this.currentScene];
		}
	}

	/**
		The total number of frames in the MovieClip instance.

		If the movie clip contains multiple frames, the
		`totalFrames` property returns the total number of frames in
		_all_ scenes in the movie clip.
	**/
	public get totalFrames(): number
	{
		if (this.__timeline != null)
		{
			return (<internal.Timeline><any>this.__timeline).__totalFrames;
		}
		else
		{
			return 1;
		}
	}
}
