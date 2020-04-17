import Context3DState from "../../_internal/renderer/context3D/Context3DState";
import BitmapDataPool from "../../_internal/renderer/BitmapDataPool";
import DrawCommandBuffer from "../../_internal/renderer/DrawCommandBuffer";
import DisplayObjectRenderData from "../../_internal/renderer/DisplayObjectRenderData";
import DisplayObjectRendererType from "../../_internal/renderer/DisplayObjectRendererType";
import SamplerState from "../../_internal/renderer/SamplerState";
import DisplayObjectType from "../../_internal/renderer/DisplayObjectType";
import GraphicsDataType from "../../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../../_internal/renderer/GraphicsFillType";
import DisplayObjectIterator from "../../_internal/utils/DisplayObjectIterator";
import ObjectPool from "../../_internal/utils/ObjectPool";
import Bitmap from "../../display/Bitmap";
import BitmapData from "../../display/BitmapData";
import BlendMode from "../../display/BlendMode";
import DisplayObject from "../../display/DisplayObject";
import DisplayObjectContainer from "../../display/DisplayObjectContainer";
import DisplayObjectRenderer from "../../display/DisplayObjectRenderer";
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
import ShaderInput from "../../display/ShaderInput";
import ShaderParameter from "../../display/ShaderParameter";
import Sprite from "../../display/Sprite";
import Stage from "../../display/Stage";
import Stage3D from "../../display/Stage3D";
import Tile from "../../display/Tile";
import TileContainer from "../../display/TileContainer";
import Tileset from "../../display/Tileset";
import Timeline from "../../display/Timeline";
import RectangleTexture from "../../display3D/textures/RectangleTexture";
import Context3D from "../../display3D/Context3D";
import Context3DBufferUsage from "../../display3D/Context3DBufferUsage";
import Context3DProgramFormat from "../../display3D/Context3DProgramFormat";
import Context3DTextureFormat from "../../display3D/Context3DTextureFormat";
import IndexBuffer3D from "../../display3D/IndexBuffer3D";
import Event from "../../events/Event";
import EventPhase from "../../events/EventPhase";
import MouseEvent from "../../events/MouseEvent";
import RenderEvent from "../../events/RenderEvent";
import TouchEvent from "../../events/TouchEvent";
import BitmapFilter from "../../filters/BitmapFilter";
import ColorTransform from "../../geom/ColorTransform";
import Matrix from "../../geom/Matrix";
import Matrix3D from "../../geom/Matrix3D";
import Point from "../../geom/Point";
import Rectangle from "../../geom/Rectangle";
import Transform from "../../geom/Transform";
import SoundChannel from "../../media/SoundChannel";
import NetStream from "../../net/NetStream";
import ApplicationDomain from "../../system/ApplicationDomain";
import Font from "../../text/Font";
import TextFormat from "../../text/TextFormat";
import GameInputDevice from "../../ui/GameInputDevice";
import GameInputControl from "../../ui/GameInputControl";
import MouseCursor from "../../ui/MouseCursor";
import ByteArray from "../../utils/ByteArray";
import Vector from "../../Vector";
import TextEngine from "../text/TextEngine";

interface BitmapInternal
{
	__bitmapData: BitmapData;
	__image: HTMLImageElement;
	__imageVersion: number;
}
export { BitmapInternal as Bitmap }

interface BitmapDataInternal
{
	__isValid: boolean;
	__pool: BitmapDataPool;
	__renderData: DisplayObjectRenderData;
	__renderTransform: Matrix;

	__getCanvas(clearData?: boolean): HTMLCanvasElement;
	__getCanvasContext(clearData?: boolean): CanvasRenderingContext2D;
	__getElement(clearData?: boolean): CanvasImageSource;
	__getJSImage(): HTMLImageElement;
	__getVersion(): number;
	__setDirty(): void;
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

	__applyFilter(bitmapData: BitmapData, sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point): BitmapData;
}
export { BitmapFilterInternal as BitmapFilter }

interface ByteArrayInternal
{
	__buffer: ArrayBuffer;
}
export { ByteArrayInternal as ByteArray }

interface ColorTransformInternal
{
	__pool: ObjectPool<ColorTransform>;

	__clone(): ColorTransform;
	__combine(ct: ColorTransform): void;
	__copyFrom(ct: ColorTransform): void;
	__equals(ct: ColorTransform, ignoreAlphaMultiplier: boolean): boolean;
	__identity(): void;
	__invert(): void;
	__isDefault(ignoreAlphaMultiplier: boolean): boolean;
	__setArrays(colorMultipliers: Array<number>, colorOffsets: Array<number>): void;
}
export { ColorTransformInternal as ColorTransform }

interface Context3DInternal
{
	__bitmapDataPool: BitmapDataPool;
	__cleared: boolean;
	__contextState: Context3DState;
	__frontBufferTexture: RectangleTexture;
	__present: boolean;
	__quadIndexBuffer: IndexBuffer3D;
	__quadIndexBufferElements: number;
	__state: Context3DState;

	new(stage: Stage, contextState?: Context3DState, stage3D?: Stage3D): Context3D;
	__renderStage3D(stage3D: Stage3D): void;
}
export { Context3DInternal as Context3D }

interface CubeTextureInternal
{
	new(context: Context3D, size: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean, streamingLevels: number);
}
export { CubeTextureInternal as CubeTexture }

interface DisplayObjectContainerInternal
{
	__numChildren: number;

	__cleanupRemovedChildren(): void;
	__removedChildren: Vector<DisplayObject>;
}
export { DisplayObjectContainerInternal as DisplayObjectContainer }

interface DisplayObjectInternal
{
	__broadcastEvents: Map<string, Array<DisplayObject>>;
	__childIterators: ObjectPool<DisplayObjectIterator>;
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
	__parent: DisplayObjectContainer;
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
	__stage: Stage;
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

	__childIterator(childrenOnly?: boolean): DisplayObjectIterator;
	__cleanup(): void;
	__dispatch(event: Event): boolean;
	__dispatchChildren(event: Event): void;
	__dispatchWithCapture(event: Event): boolean;
	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__getCursor(): MouseCursor;
	__getFilterBounds(rect: Rectangle, matrix: Matrix): void;
	__getInteractive(stack: Array<DisplayObject>): boolean;
	__getRenderBounds(rect: Rectangle, matrix: Matrix): void;
	__getRenderTransform(): Matrix;
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

interface DOMElementInternal
{
	__active: boolean;
	__element: HTMLElement;
}
export { DOMElementInternal as DOMElement }

interface DOMRendererInternal
{
	__clearBitmap(bitmap: Bitmap): void;
}
export { DOMRendererInternal as DOMRenderer }

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

interface FontInternal
{
	__fontByName: Map<String, Font>;
}
export { FontInternal as Font }

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

interface GlowFilterInternal
{
	__blurAlphaShader: Shader;
	__combineKnockoutShader: Shader;
	__combineShader: Shader;
	__innerCombineShader: Shader;
	__innerCombineKnockoutShader: Shader;
	__invertAlphaShader: Shader;
}
export { GlowFilterInternal as GlowFilter }

interface GraphicsInternal
{
	__bitmap: BitmapData;
	__bounds: Rectangle;
	__commands: DrawCommandBuffer;
	__dirty: boolean;
	__hardwareDirty: boolean;
	__height: number;
	__owner: DisplayObject;
	__renderData: DisplayObjectRenderData;
	__renderTransform: Matrix;
	__softwareDirty: boolean;
	__transformDirty: boolean;
	__visible: boolean;
	__width: number;
	__worldTransform: Matrix;

	new(owner: DisplayObject): Graphics;

	__cleanup(): void;
	__getBounds(rect: Rectangle, matrix: Matrix): void;
	__hitTest(x: number, y: number, shapeFlag: boolean, matrix: Matrix): boolean;
	__readGraphicsData(graphicsData: Vector<IGraphicsData>): void;
	__update(displayMatrix: Matrix): void;
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

interface IndexBuffer3DInternal
{
	new(context3D: Context3D, numIndices: number, bufferUsage: Context3DBufferUsage);
}
export { IndexBuffer3DInternal as IndexBuffer3D }

interface InteractiveObjectInternal
{
	__tabEnabled: boolean;

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
	__identity: Matrix;
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

interface MovieClipInternal
{
	__timeline: Timeline;
}
export { MovieClipInternal as MovieClip }

interface NetStreamInternal
{
	__closed: boolean;

	__getVideoElement(): HTMLVideoElement;
}
export { NetStreamInternal as NetStream }

interface PointInternal
{
	__pool: ObjectPool<Point>;
}
export { PointInternal as Point }

interface Program3DInternal
{
	__context: Context3D;
	__format: Context3DProgramFormat;
	__samplerStates: Array<SamplerState>;

	new(context3D: Context3D, format: Context3DProgramFormat);

	__markDirty(isVertex: boolean, index: number, count: number): void;
	__setSamplerState(sampler: number, state: SamplerState): void;
}
export { Program3DInternal as Program3D }

interface RectangleInternal
{
	__pool: ObjectPool<Rectangle>;

	__contract(x: number, y: number, width: number, height: number): void;
	__expand(x: number, y: number, width: number, height: number): void;
	__transform(rect: Rectangle, m: Matrix): void;
}
export { RectangleInternal as Rectangle }

interface RectangleTextureInternal
{
	new(context: Context3D, width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean);
}
export { RectangleTextureInternal as RectangleTexture }

interface RenderEventInternal
{
	__renderer: DisplayObjectRenderer;
}
export { RenderEventInternal as RenderEvent }

interface ShaderInternal
{
	__alpha: ShaderParameter<number>;
	__alphaTexture: ShaderInput<BitmapData>;
	__alphaTextureMatrix: ShaderParameter<number>;
	__bitmap: ShaderInput<BitmapData>;
	__colorMultiplier: ShaderParameter<number>;
	__colorOffset: ShaderParameter<number>;
	__context: Context3D;
	__hasColorTransform: ShaderParameter<boolean>;
	__matrix: ShaderParameter<number>;
	__position: ShaderParameter<number>;
	__textureCoord: ShaderParameter<number>;
	__texture: ShaderInput<BitmapData>;
	__textureSize: ShaderParameter<number>;

	// __context: Context3D;
	__gl: WebGLRenderingContext;
	__inputBitmapData: Array<ShaderInput<BitmapData>>;
	__numPasses: number;
	__paramBool: Array<ShaderParameter<boolean>>;
	__paramFloat: Array<ShaderParameter<number>>;
	__paramInt: Array<ShaderParameter<number>>;

	__init(context3D?: Context3D): void;
}
export { ShaderInternal as Shader }

interface SimpleButtonInternal
{
	__currentState: DisplayObject;
	__previousStates: Vector<DisplayObject>;
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
	__renderData: DisplayObjectRenderData;
	__renderTransform: Matrix3D;

	new(stage: Stage): Stage3D;
	__resize(width: number, height: number): void;
}
export { Stage3DInternal as Stage3D }

interface StageInternal
{
	__clearBeforeRender: boolean;
	__colorSplit: Array<number>;
	__colorString: string;
	__contentsScaleFactor: number;
	__mouseX: number;
	__mouseY: number;
	__transparent: boolean;

	__startDrag(sprite: Sprite, lockCenter: boolean, bounds: Rectangle): void;
	__stopDrag(sprite: Sprite): void;
}
export { StageInternal as Stage }

interface TextFieldInternal
{
	__caretIndex: number;
	__defaultTextFormat: TextFormat;
	__dirty: boolean;
	__displayAsPassword: boolean;
	__div: HTMLDivElement;
	__domRender: boolean;
	__forceCachedBitmapUpdate: boolean;
	__isHTML: boolean;
	__layoutDirty: boolean;
	__offsetX: number;
	__offsetY: number;
	__rawHtmlText: string;
	__renderedOnCanvasWhileOnDOM: boolean;
	__selectionIndex: number;
	__showCursor: boolean;
	__text: string;
	__textEngine: TextEngine;
	__textFormat: TextFormat;

	__setRenderDirty(): void;
	__updateLayout(): void;
	__updateText(value: string): void
}
export { TextFieldInternal as TextField }

interface TextFormatInternal
{
	__ascent: null | number;
	__descent: null | number;

	__merge(format: TextFormat): void;
}
export { TextFormatInternal as TextFormat }

interface TextureBaseInternal
{
	__context: Context3D;
}
export { TextureBaseInternal as TextureBase }

interface TextureInternal
{
	new(context: Context3D, width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean,
		streamingLevels: number);
}
export { TextureInternal as Texture }

interface TileContainerInternal
{
	__length: number;
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

interface TilemapInternal
{
	__group: TileContainer;
	__tileset: Tileset;
	__height: number;
	__width: number;
}
export { TilemapInternal as Tilemap }

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

interface VertexBuffer3DInternal
{
	new(context3D: Context3D, numVertices: number, dataPerVertex: number, bufferUsage: Context3DBufferUsage);
}
export { VertexBuffer3DInternal as VertexBuffer3D }

interface VideoInternal
{
	__active: boolean;
	__dirty: boolean;
	__height: number;
	__stream: NetStream;
	__width: number;
}
export { VideoInternal as Video }

interface VideoTextureInternal
{
	new(context: Context3D);
}
export { VideoTextureInternal as VideoTexture }

export type Write<T> = { -readonly [P in keyof T]?: T[P]; };
