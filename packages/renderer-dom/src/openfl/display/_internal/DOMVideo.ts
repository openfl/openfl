import * as internal from "../../../_internal/utils/InternalAccess";
import Video from "../../../media/Video";
import DOMRenderer from "./DOMRenderer";

export default class DOMVideo
{
	public static clear(video: Video, renderer: DOMRenderer): void
	{
		if ((<internal.Video><any>video).__active)
		{
			renderer.element.removeChild((<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement());
			(<internal.Video><any>video).__active = false;
		}
	}

	public static render(video: Video, renderer: DOMRenderer): void
	{
		if (video.stage != null && (<internal.Video><any>video).__stream != null && (<internal.DisplayObject><any>video).__worldVisible && (<internal.DisplayObject><any>video).__renderable)
		{
			var videoElement = (<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement();

			if (!(<internal.Video><any>video).__active)
			{
				renderer.__initializeElement(video, videoElement);
				(<internal.Video><any>video).__active = true;
				(<internal.Video><any>video).__dirty = true;
			}

			if ((<internal.Video><any>video).__dirty)
			{
				videoElement.width = Math.floor((<internal.Video><any>video).__width);
				videoElement.height = Math.floor((<internal.Video><any>video).__height);
				(<internal.Video><any>video).__dirty = false;
			}

			renderer.__updateClip(video);
			renderer.__applyStyle(video, true, true, true);
		}
		else
		{
			this.clear(video, renderer);
		}
	}
}
