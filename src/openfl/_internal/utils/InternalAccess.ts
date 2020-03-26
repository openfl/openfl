import BlendMode from "openfl/display/BlendMode";
import DisplayObject from "openfl/display/DisplayObject";
import ColorTransform from "openfl/geom/ColorTransform";
import Matrix from "openfl/geom/Matrix";
import GameInputDevice from "openfl/ui/GameInputDevice";
import GameInputControl from "openfl/ui/GameInputControl";

export interface ColorTransformInternal
{
	__clone(): ColorTransform;
	__copyFrom(ct: ColorTransform): void;
	__equals(ct: ColorTransform, ignoreAlphaMultiplier: boolean): boolean;
}

export interface DisplayObjectInternal
{
	// __alpha: number;
	// __blendMode: BlendMode;
	// __cacheAsBitmap: boolean;
	// __cacheAsBitmapMatrix: Matrix;
	// __childTransformDirty: boolean;
	// __customRenderClear: boolean;
	// __customRenderEvent: RenderEvent;
	// __filters: Array<BitmapFilter>;
	// __firstChild: DisplayObject;
	// __graphics: Graphics;
	// __interactive: boolean;
	// __isMask: boolean;
	// __lastChild: DisplayObject;
	// __loaderInfo: LoaderInfo;
	// __localBounds: Rectangle;
	// __localBoundsDirty: boolean;
	// __mask: DisplayObject;
	// __maskTarget: DisplayObject;
	// __name: string;
	// __nextSibling: DisplayObject;
	// __objectTransform: Transform;
	// __previousSibling: DisplayObject;
	// __renderable: boolean;
	// __renderData: DisplayObjectRenderData;
	// __renderDirty: boolean;
	// __renderParent: DisplayObject;
	// __renderTransform: Matrix;
	// __renderTransformCache: Matrix;
	// __renderTransformChanged: boolean;
	__rotation: number;
	__rotationCosine: number;
	__rotationSine: number;
	// __scale9Grid: Rectangle;
	__scaleX: number;
	__scaleY: number;
	// __scrollRect: Rectangle;
	// __shader: Shader;
	// __tempPoint: Point;
	__transform: Matrix;
	// __transformDirty: boolean;
	// __type: DisplayObjectType;
	// __visible: boolean;
	// __worldAlpha: number;
	// __worldAlphaChanged: boolean;
	// __worldBlendMode: BlendMode;
	// __worldClip: Rectangle;
	// __worldClipChanged: boolean;
	// __worldColorTransform: ColorTransform;
	// __worldShader: Shader;
	// __worldScale9Grid: Rectangle;
	// __worldTransform: Matrix;
	// __worldVisible: boolean;
	// __worldVisibleChanged: boolean;
	// __worldZ: number;

	__getWorldTransform(): Matrix;
	__setParentRenderDirty(): void;
	__setRenderDirty(): void;
	__setTransformDirty(force?: boolean): void;
}

export interface EventInternal
{
	__currentTarget: Object;
	__isCanceledNow: boolean;
	__target: Object;
}

export interface FutureInternal<T>
{
	__completeListeners: Array<(value: T) => void>;
	__error: any;
	__errorListeners: Array<(error: Object) => void>;
	__isComplete: boolean;
	__isError: boolean;
	__progressListeners: Array<(bytesLoaded: number, bytesTotal: number) => void>;
	__value: T;
}

export interface GameInputControlInternal
{
	__new(device: GameInputDevice, id: string, minValue: number, maxValue: number, value?: number): GameInputControl;
}
