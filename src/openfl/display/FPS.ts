// import haxe.Timer;
import Event from "openfl/events/Event";
import TextField from "openfl/text/TextField";
import TextFormat from "openfl/text/TextFormat";

namespace openfl.display
{
	/**
		The FPS class provides an easy-to-use monitor to display
		the current frame rate of an OpenFL project
	**/
	export class FPS extends TextField
	{
		/**
			The current frame rate, expressed using frames-per-second
		**/
		public currentFPS(default , null): number;

		protected cacheCount: number;
		protected currentTime: number;
		protected times: Array<Float>;

		public constructor(x: number = 10, y: number = 10, color: number = 0x000000)
		{
			super();

			this.x = x;
			this.y = y;

			currentFPS = 0;
			selectable = false;
			mouseEnabled = false;
			defaultTextFormat = new TextFormat("_sans", 12, color);
			text = "FPS: ";

			cacheCount = 0;
			currentTime = 0;
			times = [];

			// #if flash
			addEventListener(Event.ENTER_FRAME, (e)
		{
				var time = Lib.getTimer();
				__enterFrame(time - currentTime);
			});
			// #end
		}

		// Event Handlers

		/** @hidden */
		private /*#if !flash#end*/ __enterFrame(deltaTime: number): void
		{
			currentTime += deltaTime;
			times.push(currentTime);

			while (times[0] < currentTime - 1000)
			{
				times.shift();
			}

			var currentCount = times.length;
			currentFPS = Math.round((currentCount + cacheCount) / 2);

			if (currentCount != cacheCount /*&& visible*/)
			{
				text = "FPS: " + currentFPS;

			#if(gl_stats && !disable_cffi && (!html5 || !canvas))
				text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
				text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
				text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
			}

			cacheCount = currentCount;
		}
	}
}

export default openfl.display.FPS;
