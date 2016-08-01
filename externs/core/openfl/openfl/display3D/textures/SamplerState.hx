package openfl.display3D.textures;
#if (display || !flash)
@:final extern class SamplerState {

    public var MinFilter(default, null):Int;
    public var MagFilter(default, null):Int;
    public var WrapModeS(default, null):Int;
    public var WrapModeT(default, null):Int;
    public var LodBias(default, null):Float;
    public var MaxAniso(default, null):Float;

    private var mIsInterned:Bool = false;
    private static var sInterns:List<SamplerState> = new List<SamplerState>();

    public function new(minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int, lodBias:Float = 0.0, maxAniso:Float = 0.0);
    public function Intern():SamplerState;
    public function ToString():String;
    public function Equals(other:SamplerState):Bool;
}
#else
// Nothing?
#end