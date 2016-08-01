package openfl._internal.stage3D;

/// Represents a collection of sampler state to be set together.
/// Usually parsed from an AGAL shader and associated with a tex instruction source

class SamplerState {

    public var MinFilter(default, null):Int;
    public var MagFilter(default, null):Int;
    public var WrapModeS(default, null):Int;
    public var WrapModeT(default, null):Int;
    public var LodBias(default, null):Float;
    public var MaxAniso(default, null):Float;

    private var mIsInterned:Bool = false;
    private static var sInterns:List<SamplerState> = new List<SamplerState>();

    public function new(minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int,
                        lodBias:Float = 0.0, maxAniso:Float = 0.0)
    {
        this.MinFilter = minFilter;
        this.MagFilter = magFilter;
        this.WrapModeS = wrapModeS;
        this.WrapModeT = wrapModeT;
        this.LodBias = lodBias;
        this.MaxAniso = maxAniso;
    }


    /// Interns this sampler state.
    /// Interning will return an object of the same value but makes equality testing faster since
    /// it is a reference comparison only.


    public function Intern():SamplerState
    {
        if (mIsInterned) return this;

        // find Intern'd object that equals this
        // TODO: use hash or dictionary
        for (i in sInterns) {
            if (i.Equals(this)) {
                return i;
            }
        }

        // Intern this object
        sInterns.add(this);
        mIsInterned = true;
        return this;
    }

    public /*override*/ function ToString():String
    {
        var result:String = "[SamplerState " +
                            " min:" + MinFilter +
                            " mag:" + MagFilter +
                            " wrapS:" + WrapModeS +
                            " wrapT:" + WrapModeT +
                            " bias:" + LodBias +
                            " aniso:" + MaxAniso + "]]";
        return result;
    }

    public function Equals(other:SamplerState):Bool
    {
        // handle reference equality
        if (this == other)
            return true;

        // handle null case
        if (other == null)
            return false;

        return this.MinFilter == other.MinFilter &&
               this.MagFilter == other.MagFilter &&
               this.WrapModeS == other.WrapModeS &&
               this.WrapModeT == other.WrapModeT &&
               this.LodBias == other.LodBias &&
               MaxAniso == other.MaxAniso;
    }

}
