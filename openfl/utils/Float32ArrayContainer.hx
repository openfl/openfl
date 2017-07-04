package openfl.utils;

class Float32ArrayContainer implements hxbit.Serializable
{
    public var value:Float32Array;

    public function new(value:Float32Array)
    {
        this.value = value;
    }

    @:keep
    public function customSerialize(ctx:hxbit.Serializer)
    {
        ctx.addInt(value.length);

        for(i in 0...value.length)
        {
            ctx.addFloat(value[i]);
        }
    }

    @:keep
    public function customUnserialize(ctx:hxbit.Serializer)
    {
        var length = ctx.getInt();
        var tempArray = new Array<Float>();

        for(i in 0...length)
        {
            tempArray.push(ctx.getFloat());
        }

        value = new Float32Array(tempArray);
    }
}
