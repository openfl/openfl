package openfl.display; #if !flash #if !openfl_legacy
import haxe.ds.Either;
import openfl.utils.Float32Array;

class ShaderParameter {

	public var index:Int;
	public var type(default, null):ShaderParameterType;
	public var value(default, null):Array<Float>;
	
	public function new(type:ShaderParameterType) {
		this.type = type;
		var l = switch(type) {
			case INT | BOOL | FLOAT: 1;
			case INT2 | BOOL2 | FLOAT2: 2;
			case INT3 | BOOL3 | FLOAT3: 3;
			case INT4 | BOOL4 | FLOAT4: 4;
			case MATRIX2X2: 4;
			case MATRIX3X3: 9;
			case MATRIX4X4: 16;
		}
		value = [for (i in 0...l) 0];
	}
	
}


abstract Either2<A,B>(Either<A,B>) {
	public inline function new( e:Either<A,B> ) this = e;
	
	public var value(get,never):Dynamic;

	inline function get_value() {
        return switch(this) {
            case Left(v) | Right(v): v;
            case _: null;
        }
    }
	
    @:from static function fromA( v ) {
        return new Either2( Left(v) );
    }
	@:from static function fromB( v ) {
        return new Either2( Right(v) );
    }
}
            
abstract Either4<A,B,C,D>(Either2<Either2<A,B>,Either2<C,D>>) {
	public inline function new( e:Either2<Either2<A,B>,Either2<C,D>> ) this = e;
            
	public var value(get,never):Dynamic;

	inline function get_value() {
        return this.value != null ? this.value.value : null;
    }
	
    @:from static function fromA( v ) {
        return new Either4(new Either2(Left(new Either2(Left(v)))));
    }
	@:from static function fromB( v ) {
        return new Either4(new Either2(Left(new Either2(Right(v)))));
    }
    @:from static function fromC( v ) {
        return new Either4(new Either2(Right(new Either2(Left(v)))));
    }
	@:from static function fromD( v ) {
        return new Either4(new Either2(Right(new Either2(Right(v)))));
    }
}

#else
typedef ShaderParameter = openfl._legacy.display.ShaderParameter;
#end
#else
typedef ShaderParameter = flash.display.ShaderParameter;
#end