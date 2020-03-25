import ColorTransform from "openfl/geom/ColorTransform";

export interface ColorTransformInternal
{
	__clone(): ColorTransform;
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
