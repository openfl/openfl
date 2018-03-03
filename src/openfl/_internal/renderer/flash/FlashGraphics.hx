package openfl._internal.renderer.flash;


import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;


class FlashGraphics {
	
	
	public static var lastBitmapFill:BitmapData;
	
	
	public static function drawQuads (graphics:Graphics, matrices:Vector<Float>, sourceRects:Vector<Float>, rectIndices:Vector<Int>):Void {
		
		if (matrices == null || matrices.length == 0 || lastBitmapFill == null) return;
		
		var hasRect = (sourceRects != null);
		var hasID = (hasRect && rectIndices != null);
		var sourceRect = lastBitmapFill.rect;
		
		var rect = new Rectangle ();
		var tileTransform = new Matrix ();
		
		var id, i4, i6, tileRect = null;
		
		var length = Math.floor (matrices.length / 6);
		
		var vertices = new Vector<Float> (length * 8);
		var indices = new Vector<Int> (length * 6);
		var uvtData = new Vector<Float> (length * 8);
		var offset4 = 0;
		var offset6 = 0;
		var offset8 = 0;
		
		var x, y, tw, th, t0, t1, t2, t3, ox, oy, ox_;
		var uvX, uvY, uvWidth, uvHeight;
		
		for (i in 0...length) {
			
			if (hasRect) {
				
				if (hasID) {
					
					id = rectIndices[i];
					if (id == -1) continue;
					i4 = id * 4;
					
				} else {
					
					i4 = i * 4;
					
				}
				
				rect.setTo (sourceRects[i4], sourceRects[i4 + 1], sourceRects[i4 + 2], sourceRects[i4 + 3]);
				tileRect = rect;
				
			} else {
				
				tileRect = sourceRect;
				
			}
			
			i6 = i * 6;
			
			tileTransform.setTo (matrices[i6], matrices[i6 + 1], matrices[i6 + 2], matrices[i6 + 3], matrices[i6 + 4], matrices[i6 + 5]);
			
			tw = tileRect.width;
			th = tileRect.height;
			t0 = tileTransform.a;
			t1 = tileTransform.b;
			t2 = tileTransform.c;
			t3 = tileTransform.d;
			x = tileTransform.tx;
			y = tileTransform.ty;
			ox = tileRect.x * tw;
			oy = tileRect.y * th;
			ox_ = ox * t0 + oy * t2;
			
			oy = ox * t1 + oy * t3;
			x -= ox_;
			y -= oy;
			vertices[offset8] = x;
			vertices[offset8 + 1] = y;
			vertices[offset8 + 2] = x + tw * t0;
			vertices[offset8 + 3] = y + tw * t1;
			vertices[offset8 + 4] = x + th * t2;
			vertices[offset8 + 5] = y + th * t3;
			vertices[offset8 + 6] = x + tw * t0 + th * t2;
			vertices[offset8 + 7] = y + tw * t1 + th * t3;
			
			indices[offset6] = 0 + offset4;
			indices[offset6 + 1] = indices[offset6 + 3] = 1 + offset4;
			indices[offset6 + 2] = indices[offset6 + 5] = 2 + offset4;
			indices[offset6 + 4] = 3 + offset4;
			
			uvX = tileRect.x / sourceRect.width;
			uvY = tileRect.y / sourceRect.height;
			uvWidth = tileRect.right / sourceRect.width;
			uvHeight = tileRect.bottom / sourceRect.height;
			
			uvtData[offset8] = uvtData[offset8 + 4] = uvX;
			uvtData[offset8 + 1] = uvtData[offset8 + 3] = uvY;
			uvtData[offset8 + 2] = uvtData[offset8 + 6] = uvWidth;
			uvtData[offset8 + 5] = uvtData[offset8 + 7] = uvHeight;
			
			offset4 += 4;
			offset6 += 6;
			offset8 += 8;
			
		}
		
		graphics.drawTriangles (vertices, indices, uvtData);
		
	}
	
	
}