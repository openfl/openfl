import DisplayObjectType from "openfl/_internal/renderer/DisplayObjectType";
import ColorTransfrom from "openfl/geom/ColorTransform";
import Matrix from "openfl/geom/Matrix";
import Rectangle from "openfl/geom/Rectangle";

namespace openfl.display
{
	export interface IBitmapDrawable
	{
		protected __blendMode: BlendMode;
		protected __isMask: boolean;
		protected __mask: DisplayObject;
		protected __renderable: boolean;
		protected __renderTransform: Matrix;
		protected __scrollRect: Rectangle;
		protected __transform: Matrix;
		protected __type: DisplayObjectType;
		protected __worldAlpha: number;
		protected __worldColorTransform: ColorTransform;
		protected __worldTransform: Matrix;
		protected __getBounds(rect: Rectangle, matrix: Matrix): void;
		protected __update(transformOnly: boolean, updateChildren: boolean): void;
	}
}

export default openfl.display.IBitmapDrawable;
