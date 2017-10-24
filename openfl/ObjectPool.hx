/*
Copyright (c) 2016 Michael Baczynski, http://www.polygonal.de

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package openfl;

/**
	A lightweight object pool
**/
#if generic
@:generic
#end
class ObjectPool<T>
{
	/**
		The current number of pooled objects.
	**/
	public var size(default, null):Int = 0;

	/**
		The maximum allowed number of pooled objects.
	**/
	public var maxSize(default, null):Int;

	var mPool:Vector<T>;
	var mFactory:Void->T;
	var mDispose:T->Void;
	var mCapacity:Int = 16;

	/**
		@param factory a function responsible for creating new objects.
		@param dispose a function responsible for disposing objects (optional).
		<br/>Invoked when the user tries to return an object to a full pool.
		@param maxNumObjects the maximum allowed number of pooled object.
		<br/>If omitted, there is no upper limit.
	**/
	public function new(factory:Void->T, ?dispose:T->Void, maxNumObjects:Int = -1)
	{
		mFactory = factory;
		mDispose = dispose == null ? function(x:T) {} : dispose;
		maxSize = maxNumObjects;
		mPool = new Vector(mCapacity);
	}

	/**
		Fills the pool in advance with `numObjects` objects.
	**/
	public function preallocate(numObjects:Int)
	{
		if(size != 0) {
			throw "Can't preallocate when size is already set";
		}

		size = mCapacity = numObjects;
		mPool = new Vector(size);
		for (i in 0...numObjects) mPool.set(i, mFactory());
	}

	/**
		Destroys this object
	**/
	public function free()
	{
		for (i in 0...mCapacity) mDispose(mPool.get(i));
		mPool = null;
		mFactory = null;
		mDispose = null;
	}

	/**
		Gets an object from the pool; the method either creates a new object if the pool is empty (no object has been returned yet) or returns an existing object from the pool.
		To minimize object allocation, return objects back to the pool as soon as their life cycle ends.
	**/
	public inline function get():T
	{
		var obj = size > 0 ? mPool.get(--size) : mFactory();
		#if dev
			if ( obj != null ) {
				if( Reflect.hasField(obj, "__objectPoolUsed") && Reflect.field(obj, "__objectPoolUsed") == true ) {
						throw 'WOOOOW! Reusing a pooled object multiple times!!';
				} else {
					Reflect.setField(obj, "__objectPoolUsed", true);
					//Reflect.setField(obj, "__objectPoolUsedStack", haxe.CallStack.callStack());
				}
			}
		#end
		return obj;
	}

	/**
		Puts `obj` into the pool, incrementing `this.size`.

		Discards `obj` if the pool is full by passing it to the dispose function (`this.size` == `this.maxSize`).
	**/
	inline public function put(obj:T)
	{
		#if dev
			if( Reflect.hasField(obj, "__objectPoolUsed") && Reflect.field(obj, "__objectPoolUsed") == false ) {
					throw 'WOOOOW! Discarding a pooled object multiple times!!';
			} else {
				Reflect.setField(obj, "__objectPoolUsed", false);
			}
		#end
		if (size == maxSize)
			mDispose(obj);
		else
		{
			if (size == mCapacity) resize();
			mPool.set(size++, obj);
		}
	}

	public function iterator():Iterator<T>
	{
		var i = 0;
		var s = size;
		var d = mPool;
		return
		{
			hasNext: function() return i < s,
			next: function() return d.get(i++)
		}
	}

	function resize()
	{
		var newCapacity:Int = Std.int(mCapacity + mCapacity*0.5);
		mPool.length = newCapacity;
		mCapacity = newCapacity;
	}
}
