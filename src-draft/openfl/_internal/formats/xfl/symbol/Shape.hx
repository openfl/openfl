package openfl._internal.formats.xfl.symbol;

import openfl._internal.formats.xfl.symbol.Symbol;
import openfl._internal.formats.xfl.dom.DOMShape;
import openfl.display.Graphics;

class Shape extends ShapeBase
{
	public function new(domShape:DOMShape)
	{
		super();
		for (edge in domShape.edges)
		{
			var fillStyles:Array<RenderCommand> = readFillStyles(domShape);
			var lineStyles:Array<RenderCommand> = readLineStyles(domShape);
			var penX = 0.0;
			var penY = 0.0;
			var currentFill0 = -1;
			var currentFill1 = -1;
			var currentLine = -1;
			var edges = new Array<RenderCommand>();
			var fills = new Array<ShapeEdge>();
			var newLineStyle = (edge.strokeStyle > -1 && edge.strokeStyle != currentLine);
			var newFillStyle0 = (edge.fillStyle0 > -1 && edge.fillStyle0 != currentFill0);
			var newFillStyle1 = (edge.fillStyle1 > -1 && edge.fillStyle1 != currentFill1);
			if (newFillStyle0)
			{
				currentFill0 = edge.fillStyle0;
			}
			if (newFillStyle1)
			{
				currentFill1 = edge.fillStyle1;
			}
			if (newLineStyle)
			{
				var lineStyle = edge.strokeStyle;
				var func = lineStyles[lineStyle];
				edges.push(func);
				currentLine = lineStyle;
			}
			var data = edge.edges;
			if (data != null && data != "")
			{
				data = StringTools.replace(data, "!", " ! ");
				data = StringTools.replace(data, "|", " | ");
				data = StringTools.replace(data, "/", " | ");
				data = StringTools.replace(data, "[", " [ ");
				data = StringTools.replace(data, "]", " [ ");
				data = StringTools.replace(data, "S1", ""); // Not sure what this actually means right now, I just remove it
				data = StringTools.replace(data, "\r", "");
				data = StringTools.replace(data, "\n", "");
				var cmds = data.split(" ");
				var ignoreI:Int = 0;
				for (i in 0...cmds.length)
				{
					if (ignoreI > 0)
					{
						ignoreI--;
						continue;
					}
					switch (cmds[i])
					{
						case "!":
							var px = Std.parseInt(cmds[i + 1]) / 20;
							var py = Std.parseInt(cmds[i + 2]) / 20;
							edges.push(function(g:Graphics)
							{
								g.moveTo(px, py);
							});
							penX = px;
							penY = py;
							ignoreI += 2;
						case "|":
							var px = Std.parseInt(cmds[i + 1]) / 20;
							var py = Std.parseInt(cmds[i + 2]) / 20;
							if (currentLine > 0)
							{
								edges.push(function(g:Graphics)
								{
									g.lineTo(px, py);
								});
							}
							else
							{
								edges.push(function(g:Graphics)
								{
									g.moveTo(px, py);
								});
							}
							if (currentFill0 > 0)
							{
								fills.push(ShapeEdge.line(currentFill0, penX, penY, px, py));
							}
							if (currentFill1 > 0)
							{
								fills.push(ShapeEdge.line(currentFill1, px, py, penX, penY));
							}
							penX = px;
							penY = py;
							ignoreI += 2;
						case "[":
							var cx = parseHexCmd(cmds[i + 1].split(".")[0]) / 20;
							var cy = parseHexCmd(cmds[i + 2].split(".")[0]) / 20;
							var px = parseHexCmd(cmds[i + 3].split(".")[0]) / 20;
							var py = parseHexCmd(cmds[i + 4].split(".")[0]) / 20;
							if (currentLine > 0)
							{
								edges.push(function(g:Graphics)
								{
									g.curveTo(cx, cy, px, py);
								});
							}
							if (currentFill0 > 0)
							{
								fills.push(ShapeEdge.curve(currentFill0, penX, penY, cx, cy, px, py));
							}
							if (currentFill1 > 0)
							{
								fills.push(ShapeEdge.curve(currentFill1, px, py, cx, cy, penX, penY));
							}
							penX = px;
							penY = py;
							ignoreI += 4;
						case "":
						// no op
						default:
							trace("new(): Unknown command '" + cmds[i] + "'");
					}
				}
			}
			flushCommands(edges, fills, fillStyles, lineStyles);
		}
		/*
			// Note: This does not yet work with OpenFL
			cacheAsBitmap = true;
		 */
	}

	private function parseHexCmd(cmd:String):Int
	{
		var value:Int = Std.parseInt(StringTools.replace(cmd, "#", "0x").split(".")[0]);
		if (StringTools.startsWith(cmd, "#") == true && (value & (1 << 23)) == 1 << 23)
		{
			value = 0xFFFFFF - value;
			value = -value;
		}
		return value;
	}
	/*
		// Note: This does not yet work with OpenFL
		#if flash
			@:setter(scaleX) public function set_scaleX(_scaleX: Float): Void {
				cacheAsBitmap = false;
				super.scaleX = _scaleX;
				cacheAsBitmap = true;
				return super.scaleX;
			}

			@:setter(scaleY) function set_scaleY(_scaleY: Float): Void {
				cacheAsBitmap = false;
				super.scaleY = _scaleY;
				cacheAsBitmap = true;
				return super.scaleY;
			}

			@:setter(width) public function set_width(_width: Float) {
				cacheAsBitmap = false;
				super.width = _width;
				cacheAsBitmap = true;
				return super.width;
			}

			@:setter(height) public function set_height(_height: Float) {
				cacheAsBitmap = false;
				super.height = _height;
				cacheAsBitmap = true;
				return super.height;
			}
		#else
			public override function set_scaleX(_scaleX: Float): Float {
				cacheAsBitmap = false;
				super.scaleX = _scaleX;
				cacheAsBitmap = true;
				return super.scaleX;
			}

			public override function set_scaleY(_scaleY: Float): Float {
				cacheAsBitmap = false;
				super.scaleY = _scaleY;
				cacheAsBitmap = true;
				return super.scaleY;
			}

			public override function set_width(_width: Float): Float {
				cacheAsBitmap = false;
				super.width = _width;
				cacheAsBitmap = true;
				return super.width;
			}

			public override function set_height(_height: Float): Float {
				cacheAsBitmap = false;
				super.height = _height;
				cacheAsBitmap = true;
				return super.height;
			}
		#end
	 */
}
