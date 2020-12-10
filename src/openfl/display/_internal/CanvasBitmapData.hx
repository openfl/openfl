package openfl.display._internal;

#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO

#end
@:access(openfl.display.BitmapData)
class CanvasBitmapData
{
	public static function renderDrawable(bitmapData:BitmapData, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		if (!bitmapData.readable) return;

		var image = bitmapData.image;

		if (image.type == DATA)
		{
			ImageCanvasUtil.convertToCanvas(image);
		}

		var context = renderer.context;
		context.globalAlpha = 1;

		renderer.setTransform(bitmapData.__renderTransform, context);

		context.drawImage(image.src, 0, 0, image.width, image.height);
		#end
	}

	public static function renderDrawableMask(bitmapData:BitmapData, renderer:CanvasRenderer):Void {}
}
