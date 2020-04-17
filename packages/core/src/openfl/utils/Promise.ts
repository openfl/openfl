import * as internal from "../_internal/utils/InternalAccess";
import Future from "./Future";

/**
	`Promise` is an implementation of Futures and Promises, with the exception that
	in addition to "success" and "failure" states (represented as "complete" and "error"),
	Lime `Future` introduces "progress" feedback as well to increase the value of
	`Future` values.

	While `Future` is meant to be read-only, `Promise` can be used to set the state of a future
	for receipients of it's `Future` object. For example:

	```haxe
	function examplePromise ():Future<string> {

		var promise = new Promise<string> ();

		var progress = 0, total = 10;
		var timer = new Timer (100);
		timer.run = () {

			promise.progress (progress, total);
			progress++;

			if (progress == total) {

				promise.complete ("Done!");
				timer.stop ();

			}

		};

		return promise.future;

	}

	var future = examplePromise ();
	future.onComplete (function (message) { trace (message); });
	future.onProgress (function (loaded, total) { trace ("Progress: " + loaded + ", " + total); });
	```
**/
export default class Promise<T>
{
	protected __future: Future<T>;

	/**
		Create a new `Promise` instance
	**/
	public constructor()
	{
		this.__future = new Future<T>();
	}

	/**
		Resolves this `Promise` with a completion state
		@param	data	The completion value
		@return	The current `Promise`
	**/
	public complete(data: T): Promise<T>
	{
		var future = (<internal.Future<T>><any>this.__future);
		if (!future.__isError)
		{
			future.__isComplete = true;
			future.__value = data;

			if (future.__completeListeners != null)
			{
				for (let i = 0; i < future.__completeListeners.length; i++)
				{
					future.__completeListeners[i](data);
				}

				future.__completeListeners = null;
			}
		}

		return this;
	}

	/**
		Resolves this `Promise` with the complete, error and/or progress state
		of another `Future`
		@param	future	The `Future` to use to resolve this `Promise`
		@return	The current `Promise`
	**/
	public completeWith(future: Future<T>): Promise<T>
	{
		this.__future.onComplete(this.complete);
		this.__future.onError(this.error);
		this.__future.onProgress(this.progress);

		return this;
	}

	/**
		Resolves this `Promise` with an error state
		@param	msg	The error value
		@return	The current `Promise`
	**/
	public error(msg: any): Promise<T>
	{
		var future = (<internal.Future<T>><any>this.__future);
		if (!future.__isComplete)
		{
			future.__isError = true;
			future.__error = msg;

			if (future.__errorListeners != null)
			{
				for (let i = 0; i < future.__errorListeners.length; i++)
				{
					future.__errorListeners[i](msg);
				}

				future.__errorListeners = null;
			}
		}

		return this;
	}

	/**
		Sends progress updates to the related `Future`
		@param	progress	A progress value
		@param	total	A total value. This should be equal or greater to the `progress` value
		@return	The current `Promise`
	**/
	public progress(progress: number, total: number): Promise<T>
	{
		var future = (<internal.Future<T>><any>this.__future);
		if (!future.__isError && !future.__isComplete)
		{
			if (future.__progressListeners != null)
			{
				for (let i = 0; i < future.__progressListeners.length; i++)
				{
					future.__progressListeners[i](progress, total);
				}
			}
		}

		return this;
	}

	// Get & Set Methods

	/**
		The `Future` associated with this `Promise`.

		All subsequent calls to set an error, completion or progress state
		will update the status and notify listeners to this `Future`
	**/
	public get future(): Future<T>
	{
		return this.__future;
	}

	/**
		Whether the `Promise` (and related `Future`) has finished with a completion state.
		This will be `false` if the `Promise` has not been resolved with a completion or error state.
	**/
	public get isComplete(): boolean
	{
		return this.__future.isComplete;
	}

	/**
		Whether the `Promise` (and related `Future`) has finished with an error state.
		This will be `false` if the `Promise` has not been resolved with a completion or error state.
	**/
	public get isError(): boolean
	{
		return this.__future.isError;
	}
}
