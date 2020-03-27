import EventDispatcher from "../events/EventDispatcher";

namespace openfl.display
{
	/**
		The FrameLabel object contains properties that specify a frame number and
		the corresponding label name. The Scene class includes a `labels`
		property, which is an array of FrameLabel objects for the scene.
	**/
	export class FrameLabel extends EventDispatcher
	{
		/**
			The frame number containing the label.
		**/
		public readonly frame: number;

		/**
			The name of the label.
		**/
		public readonly name: string;

		public constructor(name: string, frame: number)
		{
			super();

			this.name = name;
			this.frame = frame;
		}
	}
}

export default openfl.display.FrameLabel;
