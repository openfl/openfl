namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
typedef RenderContextAttributes =
	{
	@: optional antialiasing: number;
@: optional background: null | number;
@: optional colorDepth: number;
@: optional depth: boolean;
@: optional hardware: boolean;
@: optional stencil: boolean;
@: optional type: RenderContextType;
@: optional version: string;
@: optional vsync: boolean;
}
#end
