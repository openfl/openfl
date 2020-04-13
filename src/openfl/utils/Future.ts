import Promise from "../utils/Promise";

/**
	`Future` is an implementation of Futures and Promises, with the exception that
	in addition to "success" and "failure" states (represented as "complete" and "error"),
	Lime `Future` introduces "progress" feedback as well to increase the value of
	`Future` values.

	```haxe
	var future = Image.loadFromFile ("image.png");
	future.onComplete (function (image) { trace ("Image loaded"); });
	future.onProgress (function (loaded, total) { trace ("Loading: " + loaded + ", " + total); });
	future.onError (function (error) { trace (error); });

	Image.loadFromFile ("image.png").then (function (image) {

		return Future.withValue (image.width);

	}).onComplete (function (width) { trace (width); })
	```

	`Future` values can be chained together for asynchronous processing of values.

	If an error occurs earlier in the chain, the error is propagated to all `onError` callbacks.

	`Future` will call `onComplete` callbacks, even if completion occurred before registering the
	callback. This resolves race conditions, so even functions that return immediately can return
	values using `Future`.

	`Future` values are meant to be immutable, if you wish to update a `Future`, you should create one
	using a `Promise`, and use the `Promise` interface to influence the error, complete or progress state
	of a `Future`.
**/
export default class Future<T>
{
	protected __completeListeners: Array<(value: T) => void>;
	protected __error: any;
	protected __errorListeners: Array<(error: any) => void>;
	protected __isComplete: boolean;
	protected __isError: boolean;
	protected __progressListeners: Array<(bytesLoaded: number, bytesTotal: number) => void>;
	protected __value: T;

	/**
		Create a new `Future` instance
		@param	work	(Optional) A to execute
		@param	async	(Optional) If a is specified, whether to execute it asynchronously where supported
	**/
	public constructor(work: () => T = null, async: boolean = false)
	{
		if (work != null)
		{
			// if (async)
			// {
			// 	var promise = new Promise<T>();
			// 	promise.future = this;

			// 	FutureWork.queue({promise: promise, work: work});
			// }
			// else
			// {
			try
			{
				this.__value = work();
				this.__isComplete = true;
			}
			catch (e)
			{
				this.__error = e;
				this.__isError = true;
			}
			// }
		}
	}

	/**
		Create a new `Future` instance based on complete and (optionally) error and/or progress `Event` instances
	**/
	// public static ofEvents<T>(onComplete:Event<T->Void>, onError:Event<Dynamic->Void> = null, onProgress:Event<Int->Int->Void> = null):Future<T>
	// {
	// 	var promise = new Promise<T>();
	// 	onComplete.add(function(data) promise.complete(data), true);
	// 	if (onError != null) onError.add(function(error) promise.error(error), true);
	// 	if (onProgress != null) onProgress.add(function(progress, total) promise.progress(progress, total), true);
	// 	return promise.future;
	// }

	/**
		Register a listener for when the `Future` completes.

		If the `Future` has already completed, this is called immediately with the result
		@param	listener	A callback method to receive the result value
		@return	The current `Future`
	**/
	public onComplete(listener: (value: T) => void): Future<T>
	{
		if (listener != null)
		{
			if (this.__isComplete)
			{
				listener(this.__value);
			}
			else if (!this.__isError)
			{
				if (this.__completeListeners == null)
				{
					this.__completeListeners = new Array();
				}

				this.__completeListeners.push(listener);
			}
		}

		return this;
	}

	/**
		Register a listener for when the `Future` ends with an error state.

		If the `Future` has already ended with an error, this is called immediately with the error value
		@param	listener	A callback method to receive the error value
		@return	The current `Future`
	**/
	public onError(listener: (error: any) => void): Future<T>
	{
		if (listener != null)
		{
			if (this.__isError)
			{
				listener(this.__error);
			}
			else if (!this.__isComplete)
			{
				if (this.__errorListeners == null)
				{
					this.__errorListeners = new Array();
				}

				this.__errorListeners.push(listener);
			}
		}

		return this;
	}

	/**
		Register a listener for when the `Future` updates progress.

		If the `Future` is already completed, this will not be called.
		@param	listener	A callback method to receive the progress value
		@return	The current `Future`
	**/
	public onProgress(listener: (bytesLoaded: number, bytesTotal: number) => void): Future<T>
	{
		if (listener != null)
		{
			if (this.__progressListeners == null)
			{
				this.__progressListeners = new Array();
			}

			this.__progressListeners.push(listener);
		}

		return this;
	}

	/**
		Attempts to block on an asynchronous `Future`, returning when it is completed.
		@param	waitTime	(Optional) A timeout before this call will stop blocking
		@return	This current `Future`
	**/
	public ready(waitTime: number = -1): Future<T>
	{
		if (this.__isComplete || this.__isError)
		{
			return this;
		}
		else
		{
			console.warn("Cannot block thread in JavaScript");
			return this;
		}
	}

	/**
		Attempts to block on an asynchronous `Future`, returning the completion value when it is finished.
		@param	waitTime	(Optional) A timeout before this call will stop blocking
		@return	The completion value, or `null` if the request timed out or blocking is not possible
	**/
	public result(waitTime: number = -1): null | T
	{
		this.ready(waitTime);

		if (this.__isComplete)
		{
			return this.__value;
		}
		else
		{
			return null;
		}
	}

	/**
		Chains two `Future` instances together, passing the result from the first
		as input for creating/returning a new `Future` instance of a new or the same type
	**/
	public then<U>(next: (value: T) => Future<U>): Future<U>
	{
		if (this.__isComplete)
		{
			return next(this.value);
		}
		else if (this.__isError)
		{
			var future = new Future<U>();
			future.__isError = true;
			future.__error = this.__error;
			return future;
		}
		else
		{
			var promise = new Promise<U>();

			this.onError(promise.error);
			this.onProgress(promise.progress);

			this.onComplete(function (val)
			{
				var future = next(val);
				future.onError(promise.error);
				future.onComplete(promise.complete);
			});

			return promise.future;
		}
	}

	/**
		Creates a `Future` instance which has finished with an error value
		@param	error	The error value to set
		@return	A new `Future` instance
	**/
	public static withError(error: any): Future<any>
	{
		var future = new Future<any>();
		future.__isError = true;
		future.__error = error;
		return future;
	}

	/**
		Creates a `Future` instance which has finished with a completion value
		@param	error	The completion value to set
		@return	A new `Future` instance
	**/
	public static withValue<T>(value: T): Future<T>
	{
		var future = new Future<T>();
		future.__isComplete = true;
		future.__value = value;
		return future;
	}

	// Get & Set Methods

	/**
		If the `Future` has finished with an error state, the `error` value
	**/
	public get error(): any
	{
		return this.__error;
	}

	/**
		Whether the `Future` finished with a completion state
	**/
	public get isComplete(): boolean
	{
		return this.__isComplete;
	}

	/**
		Whether the `Future` finished with an error state
	**/
	public get isError(): boolean
	{
		return this.__isError;
	}

	/**
		If the `Future` has finished with a completion state, the completion `value`
	**/
	public get value(): T
	{
		return this.__value;
	}
}
