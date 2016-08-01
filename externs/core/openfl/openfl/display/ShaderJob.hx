package openfl.display;#if (display || !flash)

import openfl.events.EventDispatcher;
import openfl.display.Shader;

@:final extern class ShaderJob extends EventDispatcher {
    @:isVar public var width(get, set):Int;
    @:isVar public var height(get, set):Int;
    @:isVar public var progress(get, never):Float;
    @:isVar public var shader(get, set):Shader;
    @:isVar public var target(get, set):Dynamic;

    public function new(shader:Shader = null, target:Dynamic = null, width:Int = 0, height:Int = 0){
        super();
    }

    public function cancel():Void
    {
        //Stub
    }

    public function start(waitForCompletion:Bool = false):Void
    {
        //Stub
    }


    public function set_target(t:Dynamic):Dynamic
    {
        target = t;
        return target;
    }

    public function get_target():Dynamic
    {
        return target;
    }

    public function set_shader(s:Shader):Shader
    {
        shader = s;
        return shader;
    }


    public function get_shader():Shader
    {
        return shader;
    }

    public function get_progress():Float
    {
        return 0.0;
    }

    public function get_height():Int
    {
        return height;
    }

    public function set_height(h:Int):Int
    {
        height = h;
        return height;
    }

    public function set_width(w:Int):Int
    {
        width = w;
        return width;
    }

    public function get_width():Int
    {
        return width;
    }


}
#else
typedef ShaderJob = flash.display.ShaderJob;
#end