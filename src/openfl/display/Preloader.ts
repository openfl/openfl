import Event from "openfl/events/Event";
import ProgressEvent from "openfl/events/ProgressEvent";
import Lib from "openfl/Lib";

namespace openfl.display
{
	/**
		The Preloader class is a Lime Preloader instance that uses an OpenFL
		display object to display loading progress.
	**/
	export class Preloader
	{
		@SuppressWarnings("checkstyle:Dynamic")
		public onComplete: lime.app.Event<Void-> Void > = new lime.app.Event < Void -> Void > ();

	protected complete: boolean;
	protected display: Sprite;
	protected ready: boolean;

public constructor(display: Sprite = null)
	{
		this.display = display;

		if (display != null)
		{
			display.addEventListener(Event.UNLOAD, display_onUnload);
			Lib.current.addChild(display);
		}
	}

	protected start(): void
		{
			ready = true;

			#if!flash
	Lib.current.loaderInfo.__complete();
			#end

	if(display != null)
	{
		var complete = new Event(Event.COMPLETE, true, true);
		display.dispatchEvent(complete);

		if (!complete.isDefaultPrevented())
		{
			display.dispatchEvent(new Event(Event.UNLOAD));
		}
	}
	else
	{
		if (!complete)
		{
			complete = true;
			onComplete.dispatch();
		}
	}
}

	protected update(loaded : number, total : number): void
	{
		#if!flash
	Lib.current.loaderInfo.__update(loaded, total);
		#end

	if(display != null)
{
	display.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, true, true, loaded, total));
}
}

	// Event Handlers
	protected display_onUnload(event: Event): void
	{
		if(display != null)
{
	display.removeEventListener(Event.UNLOAD, display_onUnload);

	if (display.parent == Lib.current)
	{
		Lib.current.removeChild(display);
	}

	Lib.current.stage.focus = null;
	display = null;
}

if (ready)
{
	if (!complete)
	{
		complete = true;
		onComplete.dispatch();
	}
}
}
}

@SuppressWarnings("checkstyle:FieldDocComment")
class DefaultPreloader extends Sprite
{
	protected endAnimation: number;
	protected outline: Sprite;
	protected progress: Sprite;
	protected startAnimation: number;

	public new()
	{
		super();

		var backgroundColor = getBackgroundColor();
		var r = backgroundColor >> 16 & 0xFF;
		var g = backgroundColor >> 8 & 0xFF;
		var b = backgroundColor & 0xFF;
		var perceivedLuminosity = (0.299 * r + 0.587 * g + 0.114 * b);
		var color = 0x000000;

		if (perceivedLuminosity < 70)
		{
			color = 0xFFFFFF;
		}

		var x = 30;
		var height = 7;
		var y = getHeight() / 2 - height / 2;
		var width = getWidth() - x * 2;

		var padding = 2;

		outline = new Sprite();
		outline.graphics.beginFill(color, 0.07);
		outline.graphics.drawRect(0, 0, width, height);
		outline.x = x;
		outline.y = y;
		outline.alpha = 0;
		addChild(outline);

		progress = new Sprite();
		progress.graphics.beginFill(color, 0.35);
		progress.graphics.drawRect(0, 0, width - padding * 2, height - padding * 2);
		progress.x = x + padding;
		progress.y = y + padding;
		progress.scaleX = 0;
		progress.alpha = 0;
		addChild(progress);

		startAnimation = Lib.getTimer() + 100;
		endAnimation = startAnimation + 1000;

		addEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);
	}

	public getBackgroundColor(): number
	{
		var attributes = Lib.current.stage.limeWindow.context.attributes;

		if (Reflect.hasField(attributes, "background") && attributes.background != null)
		{
			return attributes.background;
		}
		else
		{
			return 0;
		}
	}

	public getHeight(): number
	{
		var height = Lib.current.stage.limeWindow.height;

		if (height > 0)
		{
			return height;
		}
		else
		{
			return Lib.current.stage.stageHeight;
		}
	}

	public getWidth(): number
	{
		var width = Lib.current.stage.limeWindow.width;

		if (width > 0)
		{
			return width;
		}
		else
		{
			return Lib.current.stage.stageWidth;
		}
	}

	public onInit(): void
	{
		addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public onLoaded(): void
	{
		removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);

		dispatchEvent(new Event(Event.UNLOAD));
	}

	public onUpdate(bytesLoaded: number, bytesTotal: number): void
	{
		var percentLoaded = 0.0;

		if (bytesTotal > 0)
		{
			percentLoaded = bytesLoaded / bytesTotal;

			if (percentLoaded > 1)
			{
				percentLoaded = 1;
			}
		}

		progress.scaleX = percentLoaded;
	}

	// Event Handlers
	protected this_onAddedToStage(event: Event): void
	{
		removeEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);

		onInit();
		onUpdate(loaderInfo.bytesLoaded, loaderInfo.bytesTotal);

		addEventListener(ProgressEvent.PROGRESS, this_onProgress);
		addEventListener(Event.COMPLETE, this_onComplete);
	}

	protected this_onComplete(event: Event): void
	{
		event.preventDefault();

		removeEventListener(ProgressEvent.PROGRESS, this_onProgress);
		removeEventListener(Event.COMPLETE, this_onComplete);

		onLoaded();
	}

	protected this_onEnterFrame(event: Event): void
	{
		var elapsed = Lib.getTimer() - startAnimation;
		var total = endAnimation - startAnimation;

		var percent = elapsed / total;

		if (percent < 0) percent = 0;
		if (percent > 1) percent = 1;

		outline.alpha = percent;
		progress.alpha = percent;
	}

	protected this_onProgress(event: ProgressEvent): void
	{
		onUpdate(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
	}
}
}

export default openfl.display.Preloader;
