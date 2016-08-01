package openfl.display3D.textures;

import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;
import openfl.gl.GL;
import openfl.gl.GLTexture;


class TextureBase extends EventDispatcher {

    private var mAllocated:Bool = false;

    private var mOutputTextureMemoryUsage:Bool = false;

    public var allocated(get, set):Bool;
    public var textureId(get, null):GLTexture;
    public var textureTarget(get, null):Int;
    public var alphaTexture(get, null):Texture;

    private var mContext(default, null):Context3D;
    private var mTextureId(default, null):GLTexture;
    private var mTextureTarget(default, null):Int;
    private var mSamplerState:SamplerState;
    private var mAlphaTexture:Texture;
    private var mMemoryUsage:Int = 0;
    private var mCompressedMemoryUsage:Int = 0;

    public function get_allocated():Bool
    {
        return mAllocated;
    }

    public function set_allocated(value:Bool):Bool
    {
        mAllocated = value;
        return value;
    }

    public function get_textureId():GLTexture
    {
        return mTextureId;
    }

    public function get_textureTarget():Int
    {
        return mTextureTarget;
    }

    public function get_alphaTexture():Texture
    {
        return mAlphaTexture;
    }


    private function new(context:Context3D, target:Int)
    {
        super();

        // store context
        mContext = context;

        // set texture target
        mTextureTarget = target;

        // generate texture id
        mTextureId = GL.createTexture();
    }

    public function dispose():Void
    {
        if (mAlphaTexture != null) {
            mAlphaTexture.dispose();
        }

        // delete texture
        GL.deleteTexture(mTextureId);

        // decrement stats for compressed texture data
        if (mCompressedMemoryUsage > 0) {
            mContext.statsDecrement(Context3D.Stats.Count_Texture_Compressed);
            var currentCompressedMemory:Int = mContext.statsSubtract(Context3D.Stats.Mem_Texture_Compressed, mCompressedMemoryUsage);
#if DEBUG
            if (mOutputTextureMemoryUsage) {
                System.Console.WriteLine(" - Texture Compressed GPU Memory (-" + mCompressedMemoryUsage + ") - Current Compressed Memory : " + currentCompressedMemory);
            }
#end
            mCompressedMemoryUsage = 0;
        }

        // decrement stats for un compressed texture data
        if (mMemoryUsage > 0) {
            mContext.statsDecrement(Context3D.Stats.Count_Texture);
            var currentMemory:Int = mContext.statsSubtract(Context3D.Stats.Mem_Texture, mMemoryUsage);
#if DEBUG
            if (mOutputTextureMemoryUsage) {
                System.Console.WriteLine(" - Texture GPU Memory (-" + mMemoryUsage + ") - Current Memory : " + currentMemory);
            }
#end
            mMemoryUsage = 0;
        }
    }


    // sets the sampler state associated with this texture
    // due to the way GL works, sampler states are parameters of texture objects

    public function setSamplerState(state:SamplerState):Void
    {
        // prevent redundant setting of sampler state
        if (!state.Equals(mSamplerState)) {
            // set texture
            GL.bindTexture(mTextureTarget, mTextureId);
            // apply state to texture
            GL.texParameteri(mTextureTarget, GL.TEXTURE_MIN_FILTER, /*(Int)*/state.MinFilter);
            GL.texParameteri(mTextureTarget, GL.TEXTURE_MAG_FILTER, /*(Int)*/state.MagFilter);
            GL.texParameteri(mTextureTarget, GL.TEXTURE_WRAP_S, /*(Int)*/state.WrapModeS);
            GL.texParameteri(mTextureTarget, GL.TEXTURE_WRAP_T, /*(Int)*/state.WrapModeT);
            if (state.LodBias != 0.0) {
                throw new IllegalOperationError("Lod bias setting not supported yet");
            }

            mSamplerState = state;
        }
    }

    // adds to the memory usage for this texture

    private function trackMemoryUsage(memory:Int):Void
    {
        if (mMemoryUsage == 0) {
            mContext.statsIncrement(Context3D.Stats.Count_Texture);
        }
        mMemoryUsage += memory;
        var currentMemory:Int = mContext.statsAdd(Context3D.Stats.Mem_Texture, memory);
#if DEBUG
        if (mOutputTextureMemoryUsage) {
            System.Console.WriteLine(" + Texture GPU Memory (+" + memory + ") - Current Memory : " + currentMemory);
        }
#end
    }

    // adds to the compressed memory usage for this texture

    private function trackCompressedMemoryUsage(memory:Int):Void
    {
        if (mCompressedMemoryUsage == 0) {
            mContext.statsIncrement(Context3D.Stats.Count_Texture_Compressed);
        }
        mCompressedMemoryUsage += memory;
        var currentCompressedMemory:Int = mContext.statsAdd(Context3D.Stats.Mem_Texture_Compressed, memory);
#if DEBUG
        if (mOutputTextureMemoryUsage) {
            System.Console.WriteLine(" + Texture Compressed GPU Memory (+" + memory + ") - Current Compressed Memory : " + currentCompressedMemory);
        }
#end
        // add to normal memory usage as well
        trackMemoryUsage(memory);
    }

}

