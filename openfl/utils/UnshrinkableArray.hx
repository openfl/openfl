package openfl.utils;

import haxe.ds.Vector;

abstract UnshrinkableArray<T>(UnshrinkableArrayData<T>)
{
    public var length(get, never):Int;

    public inline function new(maxSize:Int)
    {
        this = new UnshrinkableArrayData();
        this._items = new Array<T>();

        this._length = 0;
    }

    public inline function push(item:T)
    {
        this._items[this._length++] = item;
    }

    public inline function pop():T
    {
        return this._items[--this._length];
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
        ++this._length;
    }

    public inline function clear()
    {
        this._length = 0;
    }

    public inline function remove(item:T)
    {
        var found = indexOf(item);

        if(found >= 0)
        {
            for(i in found...this._length - 1)
            {
                this._items[i] = this._items[i + 1];
            }

            --this._length;
        }

        return found >= 0;
    }

    public inline function splice(from:Int, count:Int)
    {
        from = cast Math.max(from , 0);
        count = cast Math.min(count, this._length - from);

        if(count > 0)
        {
            for(i in from...this._length - count)
            {
                this._items[i] = this._items[i + count];
            }

            this._length -= count;
        }
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
        this._length = other.length - startIndex;

        for(i in 0...this._length)
        {
            this._items[i] = other[startIndex + i];
        }
    }

    public inline function indexOf(item:T):Int
    {
        var found = this._items.indexOf(item);
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

        return this._items[index] = value;
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
