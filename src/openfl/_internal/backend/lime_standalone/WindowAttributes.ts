namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
typedef WindowAttributes =
	{
	@: optional public allowHighDPI: boolean;
@: optional public alwaysOnTop: boolean;
@: optional public borderless: boolean;
@: optional public context: RenderContextAttributes;
// @:optional public display:Int;
@: optional public element: js.html.Element;
@: optional public frameRate: number;
@: optional public fullscreen: boolean;
@: optional public height: number;
@: optional public hidden: boolean;
@: optional public maximized: boolean;
@: optional public minimized: boolean;
@: optional public parameters: Dynamic;
@: optional public resizable: boolean;
@: optional public title: string;
@: optional public width: number;
@: optional public x: number;
@: optional public y: number;
}
#end
