package openfl._internal.renderer.console;


import cpp.Pointer;
import cpp.Float32;
import cpp.UInt16;
import lime.graphics.console.VertexOutput;
import openfl.geom.Matrix;


class ConsoleLineTesselator {


	private var vertices:VertexOutput;
	private var indices:Pointer<UInt16>;

	private var thin = false;
	private var radius:Float32;
	private var bitmapMatrix:Matrix;

	private var prevX:Float32;
	private var prevY:Float32;
	private var corner0X:Float32;
	private var corner0Y:Float32;
	private var corner1X:Float32;
	private var corner1Y:Float32;
	private var intersectX:Float32;
	private var intersectY:Float32;

	public var vertexCount:Int;
	public var indexCount:Int;


	// NOTE(james4k): Every method is inline because by-value field access does
	// not seem to work otherwise due to the way the generated code uses temp
	// values, at least in Haxe 3.2.


	public inline function new (vertices:VertexOutput, indices:Pointer<UInt16>, radius:Float32, bitmapMatrix:Matrix) {

		reset (vertices, indices, radius, bitmapMatrix);

	}


	public inline function reset (vertices:VertexOutput, indices:Pointer<UInt16>, radius:Float32, bitmapMatrix:Matrix) {

		this.vertices = vertices;
		this.indices = indices;
		this.radius = radius;
		this.bitmapMatrix = bitmapMatrix;
		vertexCount = 0;
		indexCount = 0;

		thin = (radius < 0.75);
		
	}


	public inline function capNone (
		originX:Float32, originY:Float32,
		nextX:Float32, nextY:Float32
	):Void {
		if (vertexCount == 0) {

			// beginning cap

			var diffX = originX - nextX;
			var diffY = originY - nextY;
			var length = Math.sqrt (diffX*diffX + diffY*diffY);
			var vectorX = (length < 0.0001) ? 1.0 : (diffX) / length;
			var vectorY = (length < 0.0001) ? 0.0 : (diffY) / length;
			vectorX *= radius;
			vectorY *= radius;

			writeVertex (originX + -vectorY, originY + vectorX);
			writeVertex (originX + vectorY, originY + -vectorX);

			vertexCount += 2;

			prevX = originX;
			prevY = originY;

		} else {

			// ending cap

			var diffX = originX - prevX;
			var diffY = originY - prevY;
			var length = Math.sqrt (diffX*diffX + diffY*diffY);
			var vectorX = (length < 0.0001) ? -1.0 : (diffX) / length;
			var vectorY = (length < 0.0001) ? 0.0 : (diffY) / length;
			vectorX *= radius;
			vectorY *= radius;

			writeVertex (originX + -vectorY, originY + vectorX);
			writeVertex (originX + vectorY, originY + -vectorX);

			// segment connects with vertices from previous joint/cap
			indices[indexCount+0] = vertexCount - 2;
			indices[indexCount+1] = vertexCount - 1;
			indices[indexCount+2] = vertexCount + 0;
			indices[indexCount+3] = vertexCount - 2;
			indices[indexCount+4] = vertexCount + 0;
			indices[indexCount+5] = vertexCount + 1;

			vertexCount += 2;
			indexCount += 6;

		}

	}


	public inline function capRound (
		originX:Float32, originY:Float32,
		nextX:Float32, nextY:Float32
	):Void {

		if (thin) {
			capNone (originX, originY, nextX, nextY);
			return;
		}

		// TODO(james4k): not actually round yet, but good enough for thin lines

		if (vertexCount == 0) {

			// beginning cap

			var diffX = originX - nextX;
			var diffY = originY - nextY;
			var length = Math.sqrt (diffX*diffX + diffY*diffY);
			var vectorX = (length < 0.0001) ? 1.0 : (diffX) / length;
			var vectorY = (length < 0.0001) ? 0.0 : (diffY) / length;
			vectorX *= radius;
			vectorY *= radius;

			writeVertex (originX + vectorX, originY + vectorY);
			writeVertex (originX + -vectorY, originY + vectorX);
			writeVertex (originX + vectorY, originY + -vectorX);

			indices[indexCount+0] = vertexCount + 0;
			indices[indexCount+1] = vertexCount + 1;
			indices[indexCount+2] = vertexCount + 2;

			vertexCount += 3;
			indexCount += 3;

			prevX = originX;
			prevY = originY;

		} else {

			// ending cap

			var diffX = originX - prevX;
			var diffY = originY - prevY;
			var length = Math.sqrt (diffX*diffX + diffY*diffY);
			var vectorX = (length < 0.0001) ? -1.0 : (diffX) / length;
			var vectorY = (length < 0.0001) ? 0.0 : (diffY) / length;
			vectorX *= radius;
			vectorY *= radius;

			writeVertex (originX + vectorX, originY + vectorY);
			writeVertex (originX + -vectorY, originY + vectorX);
			writeVertex (originX + vectorY, originY + -vectorX);

			// segment connects with vertices from previous joint/cap
			indices[indexCount+0] = vertexCount - 2;
			indices[indexCount+1] = vertexCount - 1;
			indices[indexCount+2] = vertexCount + 1;
			indices[indexCount+3] = vertexCount - 2;
			indices[indexCount+4] = vertexCount + 1;
			indices[indexCount+5] = vertexCount + 2;
			indices[indexCount+6] = vertexCount + 0;
			indices[indexCount+7] = vertexCount + 1;
			indices[indexCount+8] = vertexCount + 2;

			vertexCount += 3;
			indexCount += 9;

		}

	}


	public inline function jointRound (
		originX:Float32, originY:Float32,
		nextX:Float32, nextY:Float32
	):Void {

		// TODO(james4k): not actually round, but good enough for thin lines

		// TODO(james4k): no need for extra joint verts if radius is really small

		var dir = calculateJoint (originX, originY, nextX, nextY);

		if (dir == BendLeft) {

			var outwardX = originX - intersectX;
			var outwardY = originY - intersectY;
			var outwardLength = Math.sqrt (outwardX*outwardX + outwardY*outwardY);
			outwardX /= outwardLength;
			outwardY /= outwardLength;

			writeVertex (originX, originY);
			writeVertex (originX + outwardX * radius, originY + outwardY * radius);
			writeVertex (corner0X, corner0Y);

			// shared with next joint/cap for segment
			writeVertex (intersectX, intersectY);
			writeVertex (corner1X, corner1Y);

			// segment connects with vertices from previous joint/cap
			indices[indexCount+0]  = vertexCount - 2;
			indices[indexCount+1]  = vertexCount - 1;
			indices[indexCount+2]  = vertexCount + 3;
			indices[indexCount+3]  = vertexCount + 3;
			indices[indexCount+4]  = vertexCount + 2;
			indices[indexCount+5]  = vertexCount - 1;

			// joint
			indices[indexCount+6]  = vertexCount + 0;
			indices[indexCount+7]  = vertexCount + 3;
			indices[indexCount+8]  = vertexCount + 2;
			indices[indexCount+9]  = vertexCount + 0;
			indices[indexCount+10] = vertexCount + 4;
			indices[indexCount+11] = vertexCount + 3;
			indices[indexCount+12] = vertexCount + 0;
			indices[indexCount+13] = vertexCount + 2;
			indices[indexCount+14] = vertexCount + 1;
			indices[indexCount+15] = vertexCount + 0;
			indices[indexCount+16] = vertexCount + 1;
			indices[indexCount+17] = vertexCount + 4;

			vertexCount += 5;
			indexCount += 18;

			prevX = originX;
			prevY = originY;
				
		} else if (dir == BendRight) {

			var outwardX = originX - intersectX;
			var outwardY = originY - intersectY;
			var outwardLength = Math.sqrt (outwardX*outwardX + outwardY*outwardY);
			outwardX /= outwardLength;
			outwardY /= outwardLength;

			writeVertex (originX, originY);
			writeVertex (originX + outwardX * radius, originY + outwardY * radius);
			writeVertex (corner0X, corner0Y);

			// shared with next joint/cap for segment
			writeVertex (corner1X, corner1Y);
			writeVertex (intersectX, intersectY);

			// segment connects with vertices from previous joint/cap
			indices[indexCount+0]  = vertexCount - 2;
			indices[indexCount+1]  = vertexCount - 1;
			indices[indexCount+2]  = vertexCount + 4;
			indices[indexCount+3]  = vertexCount + 4;
			indices[indexCount+4]  = vertexCount + 2;
			indices[indexCount+5]  = vertexCount - 2;

			// joint
			indices[indexCount+6]  = vertexCount + 0;
			indices[indexCount+7]  = vertexCount + 4;
			indices[indexCount+8]  = vertexCount + 2;
			indices[indexCount+9]  = vertexCount + 0;
			indices[indexCount+10] = vertexCount + 3;
			indices[indexCount+11] = vertexCount + 4;
			indices[indexCount+12] = vertexCount + 0;
			indices[indexCount+13] = vertexCount + 2;
			indices[indexCount+14] = vertexCount + 1;
			indices[indexCount+15] = vertexCount + 0;
			indices[indexCount+16] = vertexCount + 1;
			indices[indexCount+17] = vertexCount + 3;

			vertexCount += 5;
			indexCount += 18;

			prevX = originX;
			prevY = originY;

		}

	}


	private function calculateJoint (
		originX:Float32, originY:Float32,
		nextX:Float32, nextY:Float32
	):LineBendDirection {

		var startX = prevX; // prevX
		var startY = prevY; // prevY
		var endX = originX; // originX
		var endY = originY; // originY

		var startEndX = endX - startX;
		var startEndY = endY - startY;
		var nextEndX = endX - nextX;
		var nextEndY = endY - nextY;
		var startEndLength = Math.sqrt (startEndX*startEndX + startEndY*startEndY);
		var nextEndLength = Math.sqrt (nextEndX*nextEndX + nextEndY*nextEndY);

		startEndX = startEndX / startEndLength;
		startEndY = startEndY / startEndLength;
		nextEndX = nextEndX / nextEndLength;
		nextEndY = nextEndY / nextEndLength;

		var dot = nextEndY*(-startEndX) + -nextEndX*(-startEndY);

		if (dot < -0.00001) {

			//var intersectX:Float32 = 0.0;
			//var intersectY:Float32 = 0.0;
			var ok = intersectLines (
				Pointer.addressOf (intersectX), Pointer.addressOf(intersectY),
				startX + startEndY*radius, startY + -startEndX*radius,
				endX + startEndY*radius, endY + -startEndX*radius, 
				endX + -nextEndY*radius, endY + nextEndX*radius,
				nextX + -nextEndY*radius, nextY + nextEndX*radius
			);
			if (!ok) {
				// midpoint of inside corners
				intersectX = (originX + startEndY*radius + originX + -nextEndY*radius) * 0.5;
				intersectY = (originY + -startEndX*radius + originY + nextEndX*radius) * 0.5;
				trace ("need to verify this intersectLines failsafe is sane");
			}
			corner0X = originX + -startEndY*radius;
			corner0Y = originY + startEndX*radius;
			corner1X = originX + nextEndY*radius;
			corner1Y = originY + -nextEndX*radius;

			return BendLeft;

		} else if (dot > 0.00001) {

			//var intersectX:Float32 = 0.0;
			//var intersectY:Float32 = 0.0;
			var ok = intersectLines (
				Pointer.addressOf (intersectX), Pointer.addressOf(intersectY),
				startX + -startEndY*radius, startY + startEndX*radius,
				endX + -startEndY*radius, endY + startEndX*radius, 
				endX + nextEndY*radius, endY + -nextEndX*radius,
				nextX + nextEndY*radius, nextY + -nextEndX*radius
			);
			if (!ok) {
				// midpoint of inside corners
				intersectX = (originX + -startEndY*radius + originX + nextEndY*radius) * 0.5;
				intersectY = (originY + startEndX*radius + originY + -nextEndX*radius) * 0.5;
				trace ("need to verify this intersectLines failsafe is sane");
			}
			corner0X = originX + startEndY*radius;
			corner0Y = originY + -startEndX*radius;
			corner1X = originX + -nextEndY*radius;
			corner1Y = originY + nextEndX*radius;

			return BendRight;
		}

		// joint that creates no bend is skipped
		return NoBend;

	}


	private inline function writeVertex (x:Float32, y:Float32):Void {

		vertices.vec3 (x, y, 0.0);
		vertices.vec2 (
			(x*bitmapMatrix.a + y*bitmapMatrix.c + bitmapMatrix.tx),
			(x*bitmapMatrix.b + y*bitmapMatrix.d + bitmapMatrix.ty)
		);
		vertices.color (0xff, 0xff, 0xff, 0xff);
		
	}


	// intersectLines tests for intersection of two line segments. Translated
	// from Paul Bourke's C code. http://paulbourke.net/
	private static function intersectLines (
		x:Pointer<Float32>, y:Pointer<Float32>,
		x1:Float32, y1:Float32,
		x2:Float32, y2:Float32,
		x3:Float32, y3:Float32,
		x4:Float32, y4:Float32
	):Bool {

		var denom  = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
		var numerA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
		var numerB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
		var absDenom = Math.abs (denom);

		// coincident?
		if (Math.abs (numerA) < 0.0001 && Math.abs(numerB) < 0.0001 && absDenom < 0.0001) {
			x.ref = (x1 + x2) / 2;
			y.ref = (y1 + y2) / 2;
			return true;
		}

		// parallel?
		if (absDenom < 0.0001) {
			x.ref = 0;
			y.ref = 0;
			return false;
		}

		// within segments?
		var muA = numerA / denom;
		var muB = numerB / denom;
		if (muA < 0.0 || muA > 1.0 || muB < 0.0 || muB > 1.0) {
			x.ref = 0;
			y.ref = 0;
			return false;
		}

		x.ref = x1 + muA * (x2 - x1);
		y.ref = y1 + muA * (y2 - y1);
		return true;
		
	}

}


@:enum private abstract LineBendDirection (Int) {

	var NoBend = 0;
	var BendLeft = 1;
	var BendRight = 2;

}
