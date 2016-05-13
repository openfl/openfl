package openfl._internal.renderer.console;


class GraphicsPaths {
	
	
	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;


	public static inline function ellipse (
		points:Array<Float>,
		x:Float, y:Float,
		rx:Float, ry:Float,
		segmentCount:Int
	) {

		var seg = (Math.PI * 2) / segmentCount;

		for (i in 0...segmentCount + 1) {

			points.push (x + Math.sin (seg * i) * rx);
			points.push (y + Math.cos (seg * i) * ry);

		}

	}

	
	public static inline function cubicCurveTo (
		points:Array<Float>,
		cx:Float, cy:Float,
		cx2:Float, cy2:Float,
		x:Float, y:Float
	) {

		var n = 20;
		var dt:Float = 0;
		var dt2:Float = 0;
		var dt3:Float = 0;
		var t2:Float = 0;
		var t3:Float = 0;
		
		var fromX = points[points.length-2];
		var fromY = points[points.length-1];
		
		var px:Float = 0;
		var py:Float = 0;
		
		var tmp:Float = 0;
		
		for (i in 1...(n + 1)) {
			
			tmp = i / n;
			
			dt = 1 - tmp;
			dt2 = dt * dt;
			dt3 = dt2 * dt;
			
			t2 = tmp * tmp;
			t3 = t2 * tmp;
			
			px = dt3 * fromX + 3 * dt2 * tmp * cx + 3 * dt * t2 * cx2 + t3 * x;
			py = dt3 * fromY + 3 * dt2 * tmp * cy + 3 * dt * t2 * cy2 + t3 * y;
			
			points.push (px);
			points.push (py);
			
		}

	}


	public static function curveTo (
		points:Array<Float>,
		cx:Float, cy:Float, x:Float, y:Float
	) {
		
		var xa:Float = 0;
		var ya:Float = 0;
		var n = 20;
		
		var fromX = points[points.length-2];
		var fromY = points[points.length-1];
		
		var px:Float = 0;
		var py:Float = 0;
		
		var tmp:Float = 0;
		
		for (i in 1...(n + 1)) {
			
			tmp = i / n;
			
			xa = fromX + ((cx - fromX) * tmp);
			ya = fromY + ((cy - fromY) * tmp);
			
			px = xa + ((cx + (x - cx) * tmp) - xa) * tmp;
			py = ya + ((cy + (y - cy) * tmp) - ya) * tmp;
			
			points.push (px);
			points.push (py);
			
		}
	}


	public static function roundRectangle (
		points:Array<Float>,
		x:Float, y:Float, width:Float, height:Float,
		rx:Float, ry:Float
	) {

		var xe = x + width;
		var ye = y + height;
		var cx1 = -rx + (rx * SIN45);
		var cx2 = -rx + (rx * TAN22);
		var cy1 = -ry + (ry * SIN45);
		var cy2 = -ry + (ry * TAN22);

		points.push (xe);
		points.push (ye - ry);
		curveTo (points, xe, ye + cy2, xe + cx1, ye + cy1);
		curveTo (points, xe + cx2, ye, xe - rx, ye);
		points.push(x + rx);
		points.push(ye); 
		curveTo (points, x - cx2, ye, x - cx1, ye + cy1);
		curveTo (points, x, ye + cy2, x, ye - ry);
		points.push(x);
		points.push(y + ry);
		curveTo (points, x, y - cy2, x - cx1, y - cy1);
		curveTo (points, x - cx2, y, x + rx, y);
		points.push(xe - rx);
		points.push(y);
		curveTo (points, xe + cx2, y, xe + cx1, y - cy1);
		curveTo (points, xe, y - cy2, xe, y + ry);
		points.push(xe);
		points.push(ye - ry);

	}
	
	
}
