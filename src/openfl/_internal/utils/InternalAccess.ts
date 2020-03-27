import Context3DState from "../../_internal/renderer/context3D/Context3DState";
import BitmapDataPool from "../../_internal/renderer/BitmapDataPool";
import DisplayObjectRenderData from "../../_internal/renderer/DisplayObjectRenderData";
import DisplayObjectType from "../../_internal/renderer/DisplayObjectType";
import GraphicsDataType from "../../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../../_internal/renderer/GraphicsFillType";
import ObjectPool from "../../_internal/utils/ObjectPool";
import BitmapData from "../../display/BitmapData";
import BlendMode from "../../display/BlendMode";
import DisplayObject from "../../display/DisplayObject";
import FrameLabel from "../../display/FrameLabel";
import Graphics from "../../display/Graphics";
import IBitmapDrawable from "../../display/IBitmapDrawable";
import IGraphicsData from "../../display/IGraphicsData";
import InteractiveObject from "../../display/InteractiveObject";
import Loader from "../../display/Loader";
import LoaderInfo from "../../display/LoaderInfo";
import MovieClip from "../../display/MovieClip";
import Scene from "../../display/Scene";
import Shader from "../../display/Shader";
import Sprite from "../../display/Sprite";
import Stage from "../../display/Stage";
import Stage3D from "../../display/Stage3D";
import Tile from "../../display/Tile";
import TileContainer from "../../display/TileContainer";
import Tileset from "../../display/Tileset";
import Context3D from "../../display3D/Context3D";
import Event from "../../events/Event";
import EventPhase from "../../events/EventPhase";
import MouseEvent from "../../events/MouseEvent";
import RenderEvent from "../../events/RenderEvent";
import TouchEvent from "../../events/TouchEvent";
import BitmapFilter from "../../filters/BitmapFilter";
import ColorTransform from "../../geom/ColorTransform";
import Matrix from "../../geom/Matrix";
import Point from "../../geom/Point";
import Rectangle from "../../geom/Rectangle";
import Transform from "../../geom/Transform";
import SoundChannel from "../../media/SoundChannel";
import ApplicationDomain from "../../system/ApplicationDomain";
import GameInputDevice from "../../ui/GameInputDevice";
import GameInputControl from "../../ui/GameInputControl";
import MouseCursor from "../../ui/MouseCursor";
import ByteArray from "../../utils/ByteArray";
import Vector from "../../Vector";

interface BitmapDataInternal
{
	__pool: BitmapDataPool;
}
export { BitmapDataInternal as BitmapData }

interface BitmapFilterInternal
{
	__bottomExtension: number;
	__leftExtension: number;
	__needSecondBitmapData: boolean;
	__numShaderPasses: number;
	__preserveObject: boolean;
	__renderDirty: boolean;
	__rightExtension: number;
	__shaderBlendMode: BlendMode;
	__smooth: boolean;
	__topExtension: number;
}
export { BitmapFilterInternal as BitmapFilter }

interface ColorTransformInternal
{
	__clone(): ColorTransform;
	__combine(ct: ColorTransform): void;
	__copyFrom(ct: ColorTransform): void;
	__equals(ct: ColorTransform, ignoreAlphaMultiplier: boolean): boolean;
	__identity(): void;
	__invert(): void;
}
export { ColorTransformInternal as ColorTransform }

interface Context3DInternal
{
	__bitmapDataPool: BitmapDataPool;
	__cleared: boolean;
	__contextState: Context3DState;
	__present: boolean;

	new(stage: Stage, contextState?: Context3DState, stage3D?: Stage3D): Context3D;
	__renderStage3D(stage3D: Stage3D): void;
}
export { Context3DInternal as Context3D }

interface DisplayObjectContainerInternal
{
	__cleanupRemovedChildren(): void;
	__removedChildren: Vector<DisplayObject>;
}
export { DisplayObjectContainerInternal as DisplayObjectContainer }

interface DisplayObjectInternal
{
	__broadcastEvents: Map<string, Array<DisplayObject>>;
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

	__cleanup(): void;
	__dispatch(event: Event): boolean;
	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__getCursor(): MouseCursor;
	__getInteractive(stack: Array<DisplayObject>): boolean;
	__getRenderBounds(rect: Rectangle, matrix: Matrix): void;
	__getWorldTransform(): Matrix;
	__globalToLocal(global: Point, local: Point): Point;
	__hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean, hitObject: DisplayObject): boolean;
	__hitTestMask(x: number, y: number): boolean;
	__readGraphicsData(graphicsData: Vector<IGraphicsData>, recurse: boolean): void;
	__setParentRenderDirty(): void;
	__setRenderDirty(): void;
	__setStageReferences(stage: Stage): void;
	__setTransformDirty(force?: boolean): void;
	__stopAllMovieClips(): void;
	__update(transformOnly: boolean, updateChildren: boolean): void;
	__updateSingle(transformOnly: boolean, updateChildren: boolean): void;
}
export { DisplayObjectInternal as DisplayObject }

interface DisplayObjectRendererInternal
{
	__allowSmoothing: boolean;
	__blendMode: BlendMode;
	__cleared: boolean;
	__overrideBlendMode: BlendMode;
	__roundPixels: boolean;
	__stage: Stage;
	__transparent: boolean;
	__type: DisplayObjectRendererType;
	__worldAlpha: number;
	__worldColorTransform: ColorTransform;
	__worldTransform: Matrix;

	__clear(): void;
	__drawBitmapData(bitmapData: BitmapData, source: IBitmapDrawable, clipRect: Rectangle): void;
	__enterFrame(displayObject: DisplayObject, deltaTime: number): void;
	__render(object: IBitmapDrawable): void;
	__resize(width: number, height: number): void;
}
export { DisplayObjectRendererInternal as DisplayObjectRenderer }

interface ErrorInternal
{
	__errorID: number;
}
export { ErrorInternal as Error }

interface EventDispatcherInternal
{
	__dispatchEvent(event: Event): boolean;
}
export { EventDispatcherInternal as EventDispatcher }

interface EventInternal
{
	__pool: ObjectPool<Event>;

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

	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__hitTest(x: number, y: number, shapeFlag: boolean, matrix: Matrix): boolean;
	__readGraphicsData(graphicsData: Vector<IGraphicsData>): void;
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

interface InteractiveObjectInternal
{
	__allowMouseFocus(): boolean;
}
export { InteractiveObjectInternal as InteractiveObject }

interface LoaderInfoInternal
{
	__applicationDomain: ApplicationDomain;
	__bytes: ByteArray;
	__bytesLoaded: number;
	__bytesTotal: number;
	__childAllowsParent: boolean;
	__completed: boolean;
	__content: DisplayObject;
	__contentType: string;
	__frameRate: number;
	__height: number;
	__loader: Loader;
	__loaderURL: string;
	__parameters: Object;
	__parentAllowsChild: boolean;
	__sameDomain: boolean;
	// __sharedEvents: EventDispatcher;
	// __uncaughtErrorEvents: UncaughtErrorEvents;
	__url: string;
	__width: number;
}
export { LoaderInfoInternal as LoaderInfo }

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

interface MouseEventInternal
{
	__altKey: boolean;
	__buttonDown: boolean;
	__commandKey: boolean;
	__ctrlKey: boolean;
	__pool: ObjectPool<MouseEvent>;
	__shiftKey: boolean;

	__create(type: string, button: number, stageX: number, stageY: number, local: Point, target: InteractiveObject,
		delta?: number): MouseEvent;
}
export { MouseEventInternal as MouseEvent }

interface MouseInternal
{
	__cursor: MouseCursor;
	__hidden: boolean;

	__setStageCursor(stage: Stage, cursor: MouseCursor): void;
}
export { MouseInternal as Mouse }

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

interface SimpleButtonInternal
{
	__currentState: DisplayObject;
}
export { SimpleButtonInternal as SimpleButton }

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

interface SpriteInternal
{
	__dropTarget: DisplayObject;
}
export { SpriteInternal as Sprite }

interface Stage3DInternal
{
	new(stage: Stage): Stage3D;
	__resize(width: number, height: number): void;
}
export { Stage3DInternal as Stage3D }

interface StageInternal
{
	__mouseX: number;
	__mouseY: number;

	__startDrag(sprite: Sprite, lockCenter: boolean, bounds: Rectangle): void;
	__stopDrag(sprite: Sprite): void;
}
export { StageInternal as Stage }

interface TileContainerInternal
{
	__tiles: Array<Tile>;
}
export { TileContainerInternal as TileContainer }

interface TileInternal
{
	__dirty: boolean;
	__length: number;

	__getWorldTransform(): Matrix;
	__findTileset(): Tileset;
	__parent: TileContainer;
	__setRenderDirty(): void;
}
export { TileInternal as Tile }

interface TimelineInternal
{
	__currentFrame: number;
	__currentFrameLabel: string;
	__currentLabel: string;
	__currentLabels: Array<FrameLabel>;
	__currentScene: Scene;
	__framesLoaded: number;
	__isPlaying: boolean;
	__totalFrames: number;

	__addFrameScript(index: number, method: () => void): void;
	__attachMovieClip(movieClip: MovieClip): void;
	__enterFrame(deltaTime: number): void;
	// __evaluateFrameScripts(advanceToFrame : number) : boolean
	// __getNextFrame(deltaTime : number) : number
	// __goto(frame : number): void
	__gotoAndPlay(frame: number | string, scene?: string): void;
	__gotoAndStop(frame: number | string, scene?: string): void;
	__nextFrame(): void;
	__nextScene(): void;
	__play(): void;
	__prevFrame(): void;
	__prevScene(): void;
	__stop(): void;
	// __resolveFrameReference(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end) : number
	// __updateFrameLabel(): void
	// __updateSymbol(targetFrame : number): void
}
export { TimelineInternal as Timeline }

interface TouchEventInternal
{
	__create(type: string, /*event:lime.ui.TouchEvent,*/ touch: Object /*js.html.Touch*/, stageX: number, stageY: number,
		local: Point, target: InteractiveObject): TouchEvent;
}
export { TouchEventInternal as TouchEvent }

export type Write<T> = { -readonly [P in keyof T]?: T[P]; };
