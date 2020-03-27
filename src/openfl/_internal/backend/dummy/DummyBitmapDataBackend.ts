namespace openfl._internal.backend.dummy;

import openfl.display3D.textures.TextureBase;
import Context3D from "../display3D/Context3D";
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.IBitmapDrawable;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import ColorTransfrom from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import ByteArray from "../utils/ByteArray";
import openfl.utils.Future;
import openfl.utils.Object;
import Vector from "../Vector";

class DummyBitmapDataBackend
{
	public constructor(parent: BitmapData, width: number, height: number, transparent: boolean = true, fillColor: number = 0xFFFFFFFF) { }

	public applyFilter(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, filter: BitmapFilter): void { }

	public clone(): BitmapData
	{
		return null;
	}

	public colorTransform(rect: Rectangle, colorTransform: ColorTransform): void { }

	public compare(otherBitmapData: BitmapData): Dynamic
	{
		return 0;
	}

	public copyChannel(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, sourceChannel: BitmapDataChannel,
		destChannel: BitmapDataChannel): void { }

	public copyPixels(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, alphaBitmapData: BitmapData = null, alphaPoint: Point = null,
		mergeAlpha: boolean = false): void { }

	public dispose(): void { }

	public disposeImage(): void { }

	public draw(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false): void { }

	public drawWithQuality(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false, quality: StageQuality = null): void { }

	public encode(rect: Rectangle, compressor: Object, byteArray: ByteArray = null): ByteArray
	{
		return null;
	}

	public fillRect(rect: Rectangle, color: number): void { }

	public floodFill(x: number, y: number, color: number): void { }

	public static fromBase64(base64: string, type: string): BitmapData
	{
		return null;
	}

	public static fromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): BitmapData
	{
		return null;
	}

	public static fromFile(path: string): BitmapData
	{
		return null;
	}

	public static fromTexture(texture: TextureBase): BitmapData
	{
		return null;
	}

	public generateFilterRect(sourceRect: Rectangle, filter: BitmapFilter): Rectangle
	{
		return null;
	}

	public getColorBoundsRect(mask: number, color: number, findColor: boolean = true): Rectangle
	{
		return null;
	}

	public getPixel(x: number, y: number): number
	{
		return 0;
	}

	public getPixel32(x: number, y: number): number
	{
		return 0;
	}

	public getPixels(rect: Rectangle): ByteArray
	{
		return null;
	}

	public getSurface(): #if lime CairoImageSurface #else Dynamic #end
	{
	return null;
}

	public getTexture(context: Context3D): TextureBase
{
	return null;
}

	public getVector(rect: Rectangle): Vector < UInt >
{
	return null;
}

	public getVersion() : number
{
	return 0;
}

	public histogram(hRect: Rectangle = null): Array < Array < Int >>
{
	return null;
}

	public hitTest(firstPoint: Point, firstAlphaThreshold : number, secondObject: Object, secondBitmapDataPoint: Point = null,
	secondAlphaThreshold : number = 1) : boolean
{
	return false;
}

	public static loadFromBase64(base64: string, type: string): Future < BitmapData >
{
	return null;
}

	public static loadFromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): Future < BitmapData >
{
	return null;
}

	public static loadFromFile(path: string): Future < BitmapData >
{
	return null;
}

	public lock(): void {}

	public merge(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redMultiplier: number, greenMultiplier: number, blueMultiplier: number,
	alphaMultiplier: number): void {}

	public noise(randomSeed : number, low : number = 0, high : number = 255, channelOptions : number = 7, grayScale : boolean = false): void {}

	public paletteMap(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redArray: Array < Int > = null, greenArray: Array < Int > = null,
		blueArray: Array < Int > = null, alphaArray: Array < Int > = null): void {}

	public perlinNoise(baseX : number, baseY : number, numOctaves: number, randomSeed : number, stitch : boolean, fractalNoise : boolean, channelOptions: number = 7,
			grayScale : boolean = false, offsets: Array < Point > = null): void {}

	public scroll(x : number, y : number): void {}

	public setDirty(): void {}

	public setPixel(x : number, y : number, color : number): void {}

	public setPixel32(x : number, y : number, color : number): void {}

	public setPixels(rect: Rectangle, byteArray: ByteArray): void {}

	public setVector(rect: Rectangle, inputVector: Vector<UInt>): void {}

	public threshold(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, operation: string, threshold : number, color : number = 0x00000000,
				mask : number = 0xFFFFFFFF, copySource : boolean = false) : number
	{
					return 0;
				}

	public unlock(changeRect: Rectangle = null): void {}

	private __applyAlpha(alpha: ByteArray): void {}

	private inline __fromBase64(base64: string, type: string): void {}

	private inline __fromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): void {}

	private __fromFile(path: string): void {}

	private inline __loadFromBase64(base64: string, type: string): Future < BitmapData >
			{
				return null;
			}

	private inline __loadFromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): Future < BitmapData >
			{
				return null;
			}

	private __loadFromFile(path: string): Future < BitmapData >
			{
				return null;
			}

	private inline __powerOfTwo(value : number) : number
	{
					return value;
				}

	private __resize(width : number, height : number): void {}

	private __sync(): void {}
}
