package openfl.utils;

import haxe.Serializer;
import haxe.Unserializer;

class Float32ArrayContainer
{
    public var value:Float32Array;

    public function new(value:Float32Array)
    {
        this.value = value;
    }

    @:keep
    function hxSerialize(s:Serializer)
    {
        s.serialize(value.length);

        for(i in 0...value.length)
        {
            s.serialize(value[i]);
        }
    }

    @:keep
    function hxUnserialize(u:Unserializer)
    {
        var length = u.unserialize();
        var tempArray = new Array<Float>();

        for(i in 0...length)
        {
            tempArray.push(u.unserialize());
        }

        value = new Float32Array(tempArray);
    }
}
