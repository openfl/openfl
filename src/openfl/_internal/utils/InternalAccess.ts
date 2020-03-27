import Context3DState from "../../_internal/renderer/context3D/Context3DState";
import DisplayObjectRenderData from "../../_internal/renderer/DisplayObjectRenderData";
import DisplayObjectType from "../../_internal/renderer/DisplayObjectType";
import GraphicsDataType from "../../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../../_internal/renderer/GraphicsFillType";
import ObjectPool from "../../_internal/utils/ObjectPool";
import BlendMode from "../../display/BlendMode";
import DisplayObject from "../../display/DisplayObject";
import Graphics from "../../display/Graphics";
import IGraphicsData from "../../display/IGraphicsData";
import LoaderInfo from "../../display/LoaderInfo";
import Shader from "../../display/Shader";
import Sprite from "../../display/Sprite";
import Stage from "../../display/Stage";
import Stage3D from "../../display/Stage3D";
import Context3D from "../../display3D/Context3D";
import EventPhase from "../../events/EventPhase";
import RenderEvent from "../../events/RenderEvent";
import BitmapFilter from "../../filters/BitmapFilter";
import ColorTransform from "../../geom/ColorTransform";
import Matrix from "../../geom/Matrix";
import Point from "../../geom/Point";
import Rectangle from "../../geom/Rectangle";
import Transform from "../../geom/Transform";
import SoundChannel from "../../media/SoundChannel";
import GameInputDevice from "../../ui/GameInputDevice";
import GameInputControl from "../../ui/GameInputControl";
import Vector from "../../Vector";

interface ColorTransformInternal
{
	__clone(): ColorTransform;
	__copyFrom(ct: ColorTransform): void;
	__equals(ct: ColorTransform, ignoreAlphaMultiplier: boolean): boolean;
}
export { ColorTransformInternal as ColorTransform }

interface Context3DInternal
{
	new(stage: Stage, contextState?: Context3DState, stage3D?: Stage3D): Context3D;

	__contextState: Context3DState;
}
export { Context3DInternal as Context3D }

interface DisplayObjectInternal
{
	__supportDOM: boolean;

	__alpha: number;
	__blendMode: BlendMode;
	__cacheAsBitmap: boolean;
	__cacheAsBitmapMatrix: Matrix;
	__childTransformDirty: boolean;
	__customRenderClear: boolean;
	__customRenderEvent: RenderEvent;
	__filters: Array<BitmapFilter>;
	__firstChild: DisplayObject;
	__graphics: Graphics;
	__interactive: boolean;
	__isMask: boolean;
	__lastChild: DisplayObject;
	__loaderInfo: LoaderInfo;
	__localBounds: Rectangle;
	__localBoundsDirty: boolean;
	__mask: DisplayObject;
	__maskTarget: DisplayObject;
	__name: string;
	__nextSibling: DisplayObject;
	__objectTransform: Transform;
	__previousSibling: DisplayObject;
	__renderable: boolean;
	__renderData: DisplayObjectRenderData;
	__renderDirty: boolean;
	__renderParent: DisplayObject;
	__renderTransform: Matrix;
	__renderTransformCache: Matrix;
	__renderTransformChanged: boolean;
	__rotation: number;
	__rotationCosine: number;
	__rotationSine: number;
	__scale9Grid: Rectangle;
	__scaleX: number;
	__scaleY: number;
	__scrollRect: Rectangle;
	__shader: Shader;
	__tempPoint: Point;
	__transform: Matrix;
	__transformDirty: boolean;
	__type: DisplayObjectType;
	__visible: boolean;
	__worldAlpha: number;
	__worldAlphaChanged: boolean;
	__worldBlendMode: BlendMode;
	__worldClip: Rectangle;
	__worldClipChanged: boolean;
	__worldColorTransform: ColorTransform;
	__worldShader: Shader;
	__worldScale9Grid: Rectangle;
	__worldTransform: Matrix;
	__worldVisible: boolean;
	__worldVisibleChanged: boolean;
	__worldZ: number;

	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__getRenderBounds(rect: Rectangle, matrix: Matrix): void;
	__getWorldTransform(): Matrix;
	__hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean, hitObject: DisplayObject): boolean;
	__hitTestMask(x: number, y: number): boolean;
	__readGraphicsData(graphicsData: Vector<IGraphicsData>, recurse: boolean): void;
	__setParentRenderDirty(): void;
	__setRenderDirty(): void;
	__setStageReferences(stage: Stage): void;
	__setTransformDirty(force?: boolean): void;
	__update(transformOnly: boolean, updateChildren: boolean): void;
	__updateSingle(transformOnly: boolean, updateChildren: boolean): void;
}
export { DisplayObjectInternal as DisplayObject }

interface EventInternal
{
	__bubbles: boolean;
	__cancelable: boolean;
	__currentTarget: Object;
	__eventPhase: EventPhase;
	__isCanceled: boolean;
	__isCanceledNow: boolean;
	__preventDefault: boolean;
	__target: Object;
	__type: string;
}
export { EventInternal as Event }

interface FutureInternal<T>
{
	__completeListeners: Array<(value: T) => void>;
	__error: any;
	__errorListeners: Array<(error: Object) => void>;
	__isComplete: boolean;
	__isError: boolean;
	__progressListeners: Array<(bytesLoaded: number, bytesTotal: number) => void>;
	__value: T;
}
export { FutureInternal as Future }

interface GameInputControlInternal
{
	new(device: GameInputDevice, id: string, minValue: number, maxValue: number, value?: number): GameInputControl;
}
export { GameInputControlInternal as GameInputControl }

interface GraphicsInternal
{
	new(owner: DisplayObject): Graphics;
	__hitTest(x: number, y: number, shapeFlag: boolean, matrix: Matrix): boolean;
}
export { GraphicsInternal as Graphics }

interface IBitmapDrawableInternal
{
	__blendMode: BlendMode;
	__isMask: boolean;
	__mask: DisplayObject;
	__renderable: boolean;
	__renderTransform: Matrix;
	__scrollRect: Rectangle;
	__transform: Matrix;
	__type: DisplayObjectType;
	__worldAlpha: number;
	__worldColorTransform: ColorTransform;
	__worldTransform: Matrix;
	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__update(transformOnly: boolean, updateChildren: boolean): void;
}
export { IBitmapDrawableInternal as IBitmapDrawable }

interface IGraphicsDataInternal
{
	__graphicsDataType: GraphicsDataType;
}
export { IGraphicsDataInternal as IGraphicsData }

interface IGraphicsFillInternal
{
	__graphicsFillType: GraphicsFillType;
}
export { IGraphicsFillInternal as IGraphicsFill }


interface MatrixInternal
{
	__pool: ObjectPool<Matrix>;

	__transformInversePoint(point: Point): void;
	__transformInverseX(px: number, py: number): number;
	__transformInverseY(px: number, py: number): number;
	__transformPoint(point: Point): void;
	__transformX(px: number, py: number): number;
	__transformY(px: number, py: number): number;
	__translateTransformed(px: number, py: number): void;
}
export { MatrixInternal as Matrix }

interface PointInternal
{
	__pool: ObjectPool<Point>;
}
export { PointInternal as Point }

interface RectangleInternal
{
	__pool: ObjectPool<Rectangle>;
	__expand(x: number, y: number, width: number, height: number): void;
	__transform(rect: Rectangle, m: Matrix): void;
}
export { RectangleInternal as Rectangle }

interface SoundChannelInternal
{
	__updateTransform(): void;
}
export { SoundChannelInternal as SoundChannel }

interface SoundMixerInternal
{
	__registerSoundChannel(soundChannel: SoundChannel): void;
	__unregisterSoundChannel(soundChannel: SoundChannel): void;
}
export { SoundMixerInternal as SoundMixer }

interface StageInternal
{
	__startDrag(sprite: Sprite, lockCenter: boolean, bounds: Rectangle): void;
	__stopDrag(sprite: Sprite): void;
}
export { StageInternal as Stage }

export type Write<T> = { -readonly [P in keyof T]?: T[P]; };
