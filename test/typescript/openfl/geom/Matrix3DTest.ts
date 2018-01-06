/*
import Matrix3D from "openfl/geom/Matrix3D";
import Vector3D from "openfl/geom/Vector3D";
import Vector from "openfl/Vector";
import * as assert from "assert";


describe ("TypeScript | Matrix3D", function () {
	
	
	var nearEquals = function (expected:number, actual:number, tolerance:number = 0.001 ):boolean {
		return (actual > expected - tolerance) && (actual < expected + tolerance);
	}
	
	
	var assertMatrix3DnearEquals = function (expected:Matrix3D, actual:Matrix3D, tolerance:number = 0.001) {

		var rdExpected = expected.rawData;
		var rdActual = actual.rawData;
		
		//trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");
		//trace("Expected (Matrix3D)("+tolerance+"):"+rdExpected.join(", "));
		//trace("Actual   (Matrix3D)("+tolerance+"):"+rdActual.join(", "));
		
		assert (nearEquals (rdExpected[  0 ], rdActual[  0 ], tolerance));
		assert (nearEquals (rdExpected[  1 ], rdActual[  1 ], tolerance));
		assert (nearEquals (rdExpected[  2 ], rdActual[  2 ], tolerance));
		assert (nearEquals (rdExpected[  3 ], rdActual[  3 ], tolerance));
		assert (nearEquals (rdExpected[  4 ], rdActual[  4 ], tolerance));
		assert (nearEquals (rdExpected[  5 ], rdActual[  5 ], tolerance));
		assert (nearEquals (rdExpected[  6 ], rdActual[  6 ], tolerance));
		assert (nearEquals (rdExpected[  7 ], rdActual[  7 ], tolerance));
		assert (nearEquals (rdExpected[  8 ], rdActual[  8 ], tolerance));
		assert (nearEquals (rdExpected[  9 ], rdActual[  9 ], tolerance));
		assert (nearEquals (rdExpected[ 10 ], rdActual[ 10 ], tolerance));
		assert (nearEquals (rdExpected[ 11 ], rdActual[ 11 ], tolerance));
		assert (nearEquals (rdExpected[ 12 ], rdActual[ 12 ], tolerance));
		assert (nearEquals (rdExpected[ 13 ], rdActual[ 13 ], tolerance));
		assert (nearEquals (rdExpected[ 14 ], rdActual[ 14 ], tolerance));
		assert (nearEquals (rdExpected[ 15 ], rdActual[ 15 ], tolerance));
 
	}
	
	
	var assertVector3DnearEquals = function (expected:Vector3D, actual:Vector3D, tolerance:number =0.001) {

		//trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");
		//trace("Expected (Vector3D)("+tolerance+"):"+expected.x+", "+expected.y+", "+expected.z+", "+expected.w);
		//trace("Actual   (Vector3D)("+tolerance+"):"+actual.x+", "+actual.y+", "+actual.z+", "+actual.w);
		
		assert (nearEquals (expected.x, actual.x, tolerance));
		assert (nearEquals (expected.y, actual.y, tolerance));
		assert (nearEquals (expected.z, actual.z, tolerance));

	}
	
	
	var assertVectorNearEquals = function (expected:Vector<number>, actual:Vector<number>, tolerance:number =0.001) {

		//trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");
		
		assert.equal(expected.length, actual.length);
		for (i in 0...expected.length) {
			//trace("Expected (Vector)("+tolerance+"):"+expected[i]+" == "+actual[i]);
			assert (nearEquals (expected[i], actual[i], tolerance));
		}

	}
	
	
	var setupTestMatrix3D = function (): Matrix3D {
		
		var m1 = new Matrix3D ();
		m1.prependTranslation (100, 200, 300);
		m1.prependRotation (30, Vector3D.X_AXIS);
		m1.prependRotation (45, Vector3D.Y_AXIS);
		m1.prependRotation (60, Vector3D.Z_AXIS);
		m1.prependScale (3, 4, 5);
		
		return new Matrix3D (Vector.ofArray ([ 1.182695964,0.7321259575,6.604626666,0,0.07898552537,-0.2466572736,0.4410853871,0,1.529131305,0,-0.7981747539,0,-7.586604491,67.77572855,971.8057146,1 ]));
	
	}
	
	
	it ("determinant", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.determinant;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D ();
		assert (nearEquals (3.2639, matrix3D.determinant));
		
	});
	
	
	it ("position", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.position;
		
		assert.notEqual (exists, null);
		
		matrix3D.position = new Vector3D (10, 20, 30);
		
		assert (nearEquals (10, matrix3D.position.x));
		assert (nearEquals (20, matrix3D.position.y));
		assert (nearEquals (30, matrix3D.position.z));
		
	});
	
	
	it ("rawData", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.rawData;
		
		assert.notEqual (exists, null);
		
		matrix3D.rawData = Vector.ofArray ([ 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5 ]);
		
		assert (nearEquals (1.0, matrix3D.rawData[0]));
		assert (nearEquals (1.1, matrix3D.rawData[1]));
		assert (nearEquals (1.2, matrix3D.rawData[2]));
		assert (nearEquals (1.3, matrix3D.rawData[3]));
		assert (nearEquals (1.4, matrix3D.rawData[4]));
		assert (nearEquals (1.5, matrix3D.rawData[5]));
		assert (nearEquals (1.6, matrix3D.rawData[6]));
		assert (nearEquals (1.7, matrix3D.rawData[7]));
		assert (nearEquals (1.8, matrix3D.rawData[8]));
		assert (nearEquals (1.9, matrix3D.rawData[9]));
		assert (nearEquals (2.0, matrix3D.rawData[10]));
		assert (nearEquals (2.1, matrix3D.rawData[11]));
		assert (nearEquals (2.2, matrix3D.rawData[12]));
		assert (nearEquals (2.3, matrix3D.rawData[13]));
		assert (nearEquals (2.4, matrix3D.rawData[14]));
		assert (nearEquals (2.5, matrix3D.rawData[15]));

	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		assert.notEqual (matrix3D, null);
		
	});
	
	
	it ("append", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.appendRotation;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D ();
		matrix3D.append (new Matrix3D (Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0 ])));
		
		var expected = new Matrix3D(Vector.ofArray ([ 64.28496551513672, 72.80441284179688, 81.32386779785156, 89.84331512451172, 2.8154678344726563, 3.088881254196167, 3.362294912338257, 3.635709047317505, -5.6544413566589355, -4.923484802246094, -4.19252872467041, -3.461571216583252, 9090.5439453125, 10123.5390625, 11156.533203125, 12189.5283203125 ]));
		
		assertMatrix3DnearEquals(expected, matrix3D );
		
	});
	
	
	it ("appendRotation", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.appendRotation;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		// Append rotations
		matrix3D.appendRotation( 25, Vector3D.X_AXIS );
		matrix3D.appendRotation(-35, Vector3D.Y_AXIS );
		matrix3D.appendRotation( 45, Vector3D.Z_AXIS );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());
		
		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var rotation = v1[1];
		var expectedRotation = v2[1];
		var expectedRotatedMatrix3D = new Matrix3D(Vector.ofArray ([ -0.3636549711227417, -3.372683525085449, 5.835120677947998, 0, 0.21577900648117065, -0.3639894127845764, 0.28737783432006836, 0, 0.9405853152275085, 1.4176323413848877, 0.2845056653022766, 0, -126.25172424316406, -620.2042846679688, 740.5840454101563, 1 ]));
		
		assertVector3DnearEquals(expectedRotation, rotation );
		
		// Test the rotation matches to the rotation values in Flash
		assertMatrix3DnearEquals(expectedRotatedMatrix3D, matrix3D );
		
	});
	
	
	it ("appendScale", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.appendScale;
		
		assert.notEqual (exists, null);

		matrix3D = setupTestMatrix3D();
		matrix3D.appendScale(3, 5, 7 );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var scale = v1[2];
		var expectedScale = v2[2];
		var expectedScaledMatrix3D = new Matrix3D(Vector.ofArray ([ 3.5480880737304688, 3.6606297492980957, 46.23238754272461, 0, 0.23695658147335052, -1.2332863807678223, 3.0875978469848633, 0, 4.587393760681152, 0, -5.587223052978516, 0, -22.75981330871582, 338.8786315917969, 6802.64013671875, 1 ]));

		assertVector3DnearEquals(expectedScale,  scale );
		
		// Test the scaling matches to the scaling values in Flash
		assertMatrix3DnearEquals(expectedScaledMatrix3D, matrix3D );
		
	});
	
	
	it ("appendTranslation", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.appendTranslation;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.appendTranslation(123, -456, 789 );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var translation = v1[0];
		var expectedTranslation = v2[0];
		var expectedTranslatedMatrix3D = new Matrix3D(Vector.ofArray ([ 1.182695984840393, 0.7321259379386902, 6.604626655578613, 0, 0.07898552715778351, -0.24665726721286774, 0.4410853981971741, 0, 1.529131293296814, 0, -0.7981747388839722, 0, 115.41339874267578, -388.2242736816406, 1760.8056640625, 1 ]));

		assertVector3DnearEquals(expectedTranslation, translation );
		
		// Test the translation matches to the translation values in Flash
		assertMatrix3DnearEquals(expectedTranslatedMatrix3D, matrix3D );

	});
	
	
	it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.clone;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		var clone = matrix3D.clone();
		
		assertMatrix3DnearEquals(clone, matrix3D);

	});
	
	
	it ("copyColumnFrom", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyColumnFrom;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.copyColumnFrom(0, new Vector3D(1,  2,  3,  4) );
		matrix3D.copyColumnFrom(1, new Vector3D(5,  6,  7,  8) );
		matrix3D.copyColumnFrom(2, new Vector3D(9, 10, 11, 12) );
		matrix3D.copyColumnFrom(3, new Vector3D(13, 14, 15, 16) );
		
		var m2 = new Matrix3D(Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0 ]));
		
		assertMatrix3DnearEquals(m2, matrix3D );
		
	});
	
	
	it ("copyColumnTo", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyColumnTo;
		
		assert.notEqual (exists, null);
		
		matrix3D = new Matrix3D(Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0 ]));
		
		var v0 = new Vector3D();
		var v1 = new Vector3D();
		var v2 = new Vector3D();
		var v3 = new Vector3D();
		matrix3D.copyColumnTo(0, v0 );
		matrix3D.copyColumnTo(1, v1 );
		matrix3D.copyColumnTo(2, v2 );
		matrix3D.copyColumnTo(3, v3 );
		
		// Test the values as expected in Flash
		assertVector3DnearEquals(new Vector3D(1,  2,  3,  4 ), v0);
		assertVector3DnearEquals(new Vector3D(5,  6,  7,  8 ), v1);
		assertVector3DnearEquals(new Vector3D(9, 10, 11, 12 ), v2);
		assertVector3DnearEquals(new Vector3D(13, 14, 15, 16 ), v3);

	});
	
	
	it ("copyFrom", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyFrom;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		var m2 = new Matrix3D(Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0 ]));
		matrix3D.copyFrom(m2 );
		
		assertMatrix3DnearEquals(m2, matrix3D );
		
	});
	
	
	it ("copyRawDataFrom", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyRawDataFrom;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("copyRawDataTo", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyRawDataTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("copyRowFrom", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyRowFrom;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.copyRowFrom(0, new Vector3D(1,  2,  3,  4) );
		matrix3D.copyRowFrom(1, new Vector3D(5,  6,  7,  8) );
		matrix3D.copyRowFrom(2, new Vector3D(9, 10, 11, 12) );
		matrix3D.copyRowFrom(3, new Vector3D(13, 14, 15, 16) );
		
		var m2 = new Matrix3D(Vector.ofArray ([ 1.0, 5.0, 9.0, 13.0, 2.0, 6.0, 10.0, 14.0, 3.0, 7.0, 11.0, 15.0, 4.0, 8.0, 12.0, 16.0 ]));
		
		// Test the values as expected in Flash
		assertMatrix3DnearEquals(m2, matrix3D );
		
	});
	
	
	it ("copyRowTo", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyRowTo;
		
		assert.notEqual (exists, null);
		
		matrix3D = new Matrix3D(Vector.ofArray ([ 1.0, 5.0, 9.0, 13.0, 2.0, 6.0, 10.0, 14.0, 3.0, 7.0, 11.0, 15.0, 4.0, 8.0, 12.0, 16.0 ]));
		
		var v0 = new Vector3D();
		var v1 = new Vector3D();
		var v2 = new Vector3D();
		var v3 = new Vector3D();
		matrix3D.copyRowTo(0, v0 );
		matrix3D.copyRowTo(1, v1 );
		matrix3D.copyRowTo(2, v2 );
		matrix3D.copyRowTo(3, v3 );
		
		// Test the values as expected in Flash
		assertVector3DnearEquals(new Vector3D(1,  2,  3,  4 ), v0 );
		assertVector3DnearEquals(new Vector3D(5,  6,  7,  8 ), v1 );
		assertVector3DnearEquals(new Vector3D(9, 10, 11, 12 ), v2 );
		assertVector3DnearEquals(new Vector3D(13, 14, 15, 16 ), v3 );
		
	});
	
	
	it ("copyToMatrix3D", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.copyToMatrix3D;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		var copy = new Matrix3D();
		matrix3D.copyToMatrix3D(copy);

		// Test the values as expected in Flash
		assertMatrix3DnearEquals(copy, matrix3D);

	});
	
	
	it ("decompose", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.decompose;
		
		assert.notEqual (exists, null);

		var recomposed = new Matrix3D();
		
		matrix3D = setupTestMatrix3D();
		var v1 = matrix3D.decompose(Orientation3D.QUATERNION);
		recomposed.recompose(matrix3D.decompose(Orientation3D.QUATERNION), Orientation3D.QUATERNION );
		var v2 = recomposed.decompose(Orientation3D.QUATERNION);
		var translation = v1[0];
		var rotation = v1[1];
		var scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0], 0.1 );
		assertVector3DnearEquals(v1[1], v2[1], 0.1 );
		assertVector3DnearEquals(v1[2], v2[2], 0.25 );

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		//assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation, 0.1 );
		//assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale, 0.1 );
		//assertVector3DnearEquals(new Vector3D(0.7662321329116821, 0.04167995974421501, 0.6412106156349182, 3.0718624591827393 ), rotation, 0.25 );

		matrix3D = setupTestMatrix3D();
		v1 = matrix3D.decompose(Orientation3D.AXIS_ANGLE);
		recomposed.recompose(matrix3D.decompose(Orientation3D.AXIS_ANGLE), Orientation3D.AXIS_ANGLE );
		v2 = recomposed.decompose(Orientation3D.AXIS_ANGLE);
		translation = v1[0];
		rotation = v1[1];
		scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0] );
		assertVector3DnearEquals(v1[1], v2[1] );
		assertVector3DnearEquals(v1[2], v2[2] );

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		//assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation );
		//assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale );
		//assertVector3DnearEquals(new Vector3D(0.7657665014266968, 0.04165463149547577, 0.6408209204673767, 0.03485807776451111 ), rotation );

		matrix3D = setupTestMatrix3D();
		v1 = matrix3D.decompose();
		recomposed.recompose(matrix3D.decompose() );
		v2 = recomposed.decompose();
		translation = v1[0];
		rotation = v1[1];
		scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0] );
		assertVector3DnearEquals(v1[1], v2[1] );
		assertVector3DnearEquals(v1[2], v2[2] );

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		//assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation );
		//assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale );
		//assertVector3DnearEquals(new Vector3D(2.5969605445861816, -1.3632254600524902, 0.5542957186698914, 1.169139158164002e-31 ), rotation );
		
	});
	
	
	it ("deltaTransformVector", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.deltaTransformVector;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();

		var expected = new Vector3D(59.280609130859375, 2.3881149291992188, 50.9227294921875, 0 );
		var actual = matrix3D.deltaTransformVector(new Vector3D(10, 20, 30) );
		
		assertVector3DnearEquals(expected, actual );

	});
	
	
	it ("identity", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.identity;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("interpolateTo", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.interpolateTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("invert", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.invert;
		
		assert.notEqual (exists, null);
		
		matrix3D = new Matrix3D(Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 2.0, 1.0, 2.0, 3.0, 3.0, 2.0, 1.0, 2.0, 4.0, 3.0, 2.0, 1.0 ]));
		var inverted = matrix3D.invert(); 
		var expected = new Matrix3D(Vector.ofArray ([ -0.4, 0.5, 0, 0.1, 0.5, -1, 0.5, 0, 0, 0.5, -1, 0.5, 0.1, 0, 0.5, -0.4 ]));
		
		assert(inverted);
		
		assertMatrix3DnearEquals(expected, matrix3D ); 
		
	});
	
	
	it ("pointAt", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.pointAt;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("prepend", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.prepend;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.prepend(new Matrix3D(Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0 ])));
		
		var expected = new Matrix3D(Vector.ofArray ([ -24.418357849121094, 271.3417053222656, 3892.315185546875, 4, -43.601524353027344, 544.386474609375, 7804.5283203125, 8, -62.784690856933594, 817.4312744140625, 11716.7412109375, 12, -81.96785736083984, 1090.47607421875, 15628.9541015625, 16 ]));
		
		assertMatrix3DnearEquals(expected, matrix3D);
		
	});
	
	
	it ("prependRotation", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.prependRotation;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		// Append rotations
		matrix3D.prependRotation( 25, Vector3D.X_AXIS );
		matrix3D.prependRotation(-35, Vector3D.Y_AXIS );
		matrix3D.prependRotation( 45, Vector3D.Z_AXIS );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());
		
		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var rotation = v1[1];
		var expectedRotation = v2[1];
		var expectedRotatedMatrix3D = new Matrix3D(Vector.ofArray ([ 1.74116849899292, 0.3082742691040039, 3.5007357597351074, 0, -0.7260121703147888, -0.6244180798530579, -3.412437915802002, 0, 0.42952263355255127, -0.3345402479171753, -4.533524990081787, 0, -7.586604595184326, 67.77572631835938, 971.8057250976563, 1 ]));
		
		assertVector3DnearEquals(expectedRotation, rotation );
		
		// Test the rotation matches to the rotation values in Flash
		assertMatrix3DnearEquals(expectedRotatedMatrix3D, matrix3D );
		
	});
	
	
	it ("prependScale", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.prependScale;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.prependScale(3, 5, 7 );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var scale = v1[2];
		var expectedScale = v2[2];
		var expectedScaledMatrix3D = new Matrix3D(Vector.ofArray ([ 3.5480880737304688, 2.196377754211426, 19.813880920410156, 0, 0.39492762088775635, -1.2332863807678223, 2.2054269313812256, 0, 10.703919410705566, 0, -5.587223052978516, 0, -7.586604595184326, 67.77572631835938, 971.8057250976563, 1 ]));
		
		assertVector3DnearEquals(expectedScale,  scale );
		
		// Test the scaling matches to the scaling values in Flash
		assertMatrix3DnearEquals(expectedScaledMatrix3D, matrix3D );
		
	});
	
	
	it ("prependTranslation", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.prependTranslation;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		matrix3D.prependTranslation(123, -456, 789 );
		
		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());
		
		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var translation = v1[0];
		var expectedTranslation = v2[0];
		var expectedTranslatedMatrix3D = new Matrix3D(Vector.ofArray ([ 1.182695984840393, 0.7321259379386902, 6.604626655578613, 0, 0.07898552715778351, -0.24665726721286774, 0.4410853981971741, 0, 1.529131293296814, 0, -0.7981747388839722, 0, 1308.352294921875, 270.30291748046875, 953.2799682617188, 1 ]));
		
		assertVector3DnearEquals(expectedTranslation, translation );
		
		// Test the translation matches to the translation values in Flash
		assertMatrix3DnearEquals(expectedTranslatedMatrix3D, matrix3D );
		
	});
	
	
	it ("recompose", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.recompose;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("transformVector", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.transformVector;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		var transformed = matrix3D.transformVector(new Vector3D(100, 200, 300));
		
		// Test transformed values match transformed values from Flash
		assertVector3DnearEquals(new Vector3D(585.2195, 91.6569, 1481.0330), transformed );
		
	});
	
	
	it ("transformVectors", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.transformVectors;
		
		assert.notEqual (exists, null);
		
		matrix3D = setupTestMatrix3D();
		
		var vIn:Vector<Float> = Vector.ofArray ([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 ]);
		var actual:Vector<Float> = Vector.ofArray ([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
		matrix3D.transformVectors(vIn, actual );
		
		var expected:Vector<Float> = Vector.ofArray ([ -1.6585435612600001, 68.0145399603, 976.8979877785, 6.71389482185, 69.470946012, 995.6405996761, 15.086333204960003, 70.9273520637, 1014.3832115737 ]);
		
		assertVectorNearEquals(expected, actual);
		
	});
	
	
	it ("transpose", function () {
		
		// TODO: Confirm functionality
		
		var matrix3D = new Matrix3D ();
		var exists = matrix3D.transpose;
		
		assert.notEqual (exists, null);
		
		var matrix3D = setupTestMatrix3D();
		var clone = matrix3D.clone();
		matrix3D.transpose();
		
		var expected = clone.rawData;
		var actual = matrix3D.rawData;
		
		assert.equal(actual[  4 ], expected[  1 ]);
		assert.equal(actual[  8 ], expected[  2 ]);
		assert.equal(actual[ 12 ], expected[  3 ]);
		assert.equal(actual[  1 ], expected[  4 ]);
		assert.equal(actual[  9 ], expected[  6 ]);
		assert.equal(actual[ 13 ], expected[  7 ]);
		assert.equal(actual[  2 ], expected[  8 ]);
		assert.equal(actual[  6 ], expected[  9 ]);
		assert.equal(actual[ 14 ], expected[ 11 ]);
		assert.equal(actual[  3 ], expected[ 12 ]);
		assert.equal(actual[  7 ], expected[ 13 ]);
		assert.equal(actual[ 11 ], expected[ 14 ]);
		
	});
	
	
	it ("interpolate", function () {
		
		// TODO: Confirm functionality
		
		var exists = Matrix3D.interpolate;
		
		assert.notEqual (exists, null);
		
	});
	
	
});*/