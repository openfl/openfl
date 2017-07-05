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
        ctx.addBytes( value.toBytes() );
    }

    @:keep
    public function customUnserialize(ctx:hxbit.Serializer)
    {
        value = new Float32Array(cast ctx.getBytes().getData());
    }
}
