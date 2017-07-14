package openfl.utils;

abstract UnshrinkableArray<T>(UnshrinkableArrayData<T>)
{
    public var length(get, never):Int;

    public inline function new(maxSize:Int = 64, internalArray:Array<T> = null)
    {
        this = new UnshrinkableArrayData();
        this._items = internalArray != null ? internalArray : new Array<T>();

        this._length = this._items.length;
    }

    public inline function getInternalArray():Array<T>
    {
        return this._items;
    }

    public inline function push(item:T)
    {
        this._items[this._length++] = item;
    }

    public inline function pop():T
    {
        var popped = this._items[--this._length];
        this._items[this._length] = null;
        return popped;
    }

    public inline function insert(index:Int, item:T)
    {
        var i = this._length - 1;
        while(i >= index)
        {
            this._items[i + 1] = this._items[i];
            --i;
        }

        this._items[index] = item;
        this._length = index > this._length ? index : this._length;
        ++this._length;
    }

    public function concat(a:UnshrinkableArray<T>):UnshrinkableArray<T> {
        this._items.concat(a.getInternalArray().slice(0, a.length));
        this._length += a.length;
        return cast this;
    }

    public inline function clear()
    {
        for ( i in 0...this._length) {
            this._items[i] = null;
        }
        this._length = 0;
    }

    public function filter(f:T -> Bool):UnshrinkableArray<T> {
        var result = new UnshrinkableArray<T>();

        for ( i in 0...this._length) {
            var item = this._items[i];
            if (f(item)) {
                result.push (item);
            }
        }

        return result;
    }

    public function remove(item:T)
    {
        var found = indexOf(item);

        if(found >= 0)
        {
            for(i in found...this._length - 1)
            {
                this._items[i] = this._items[i + 1];
            }

            --this._length;
            this._items[this._length] = null;
        }

        return found >= 0;
    }

    public function splice(from:Int, count:Int)
    {
        from = cast Math.max(from , 0);
        count = cast Math.min(count, this._length - from);

        if(count > 0)
        {
            for(i in from...this._length - count)
            {
                this._items[i] = this._items[i + count];
            }
            for(i in this._length - count...this._length)
            {
                this._items[i] = null;
            }
            this._length -= count;
        }
    }

    public function slice(from:Int, ?end:Int):UnshrinkableArray<T>
    {
        end = end == null ? this._length : cast Math.min(this._length, end);
        var result = new UnshrinkableArray<T>(this._items.slice(from, end));
        return result;
    }

    public inline function reverse()
    {
        var i = 0;
        var j = this._length - 1;
        while (i < j)
        {
            var x = this._items[i];
            this._items[i] = this._items[j];
            this._items[j] = x;
            i++;
            j--;
        }
    }

    public inline function copyFrom(other:UnshrinkableArray<T>, ?startIndex = 0)
    {
        var cached_length = this._length;
        this._length = other.length - startIndex;

        for(i in 0...this._length)
        {
            this._items[i] = other[startIndex + i];
        }
        for(i in this._length...cached_length)
        {
            this._items[i] = null;
        }
    }

    public inline function pushFromArray(other:UnshrinkableArray<T>)
    {
        var startIndex = this._length;

        for(i in 0...other.length)
        {
            this._items[startIndex + i] = other[i];
        }

        this._length += other.length;
    }

    public inline function indexOf(item:T, ?fromIndex:Int):Int
    {
        var found = this._items.indexOf(item, fromIndex);
        return found >= this._length ? -1 : found;
    }

    public inline function last():T
    {
        return this._items[this._length - 1];
    }

    @:arrayAccess
    public inline function get(index:Int):T
    {
        if(index >= this._length) return null;

        return this._items[index];
    }

    @:arrayAccess
    public inline function set(index:Int, value:T):T
    {
        if(index >= this._length)
        {
            this._length = index + 1;
        }

        this._items[index] = value;
        return value;
    }

    private inline function get_length():Int
    {
        return this._length;
    }
}

class UnshrinkableArrayData<T>
{

    public var _items:Array<T>;
    public var _length:Int;

    public function new () {
        _length = 0;
    }
}