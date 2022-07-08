package;

import openfl.geom.Matrix3D;
import openfl.geom.Orientation3D;
import openfl.geom.Vector3D;
import openfl.Vector;
import utest.Assert;
import utest.Test;

class Matrix3DTest extends Test
{
	public function test_new_()
	{
		var identity = Vector.ofArray([1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]);
		var matrix = Vector.ofArray([3.0, 2.0, 7.0, 1.0, 5.0, 1.0, 1.1, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 3.2, 1.0]);

		var matrix3D = new Matrix3D();

		assertMatrix3DnearEquals(new Matrix3D(identity), matrix3D);

		matrix3D = new Matrix3D(matrix);

		assertMatrix3DnearEquals(new Matrix3D(matrix), matrix3D);
	}

	public function test_determinant()
	{
		var matrix3D = setupTestMatrix3D();

		Assert.isTrue(nearEquals(3.2639, matrix3D.determinant));
	}

	public function test_position()
	{
		var matrix3D = new Matrix3D();
		matrix3D.position = new Vector3D(10, 20, 30, 40);

		Assert.equals(10, matrix3D.position.x);
		Assert.equals(20, matrix3D.position.y);
		Assert.equals(30, matrix3D.position.z);
		Assert.equals(0, matrix3D.position.w);
		Assert.equals(1, matrix3D.rawData[15]);

		matrix3D.rawData[15] = 40;

		Assert.equals(0, matrix3D.position.w);
	}

	public function test_rawData()
	{
		var matrix3D = new Matrix3D();
		matrix3D.rawData = Vector.ofArray([1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5]);

		Assert.isTrue(nearEquals(1.0, matrix3D.rawData[0]));
		Assert.isTrue(nearEquals(1.1, matrix3D.rawData[1]));
		Assert.isTrue(nearEquals(1.2, matrix3D.rawData[2]));
		Assert.isTrue(nearEquals(1.3, matrix3D.rawData[3]));
		Assert.isTrue(nearEquals(1.4, matrix3D.rawData[4]));
		Assert.isTrue(nearEquals(1.5, matrix3D.rawData[5]));
		Assert.isTrue(nearEquals(1.6, matrix3D.rawData[6]));
		Assert.isTrue(nearEquals(1.7, matrix3D.rawData[7]));
		Assert.isTrue(nearEquals(1.8, matrix3D.rawData[8]));
		Assert.isTrue(nearEquals(1.9, matrix3D.rawData[9]));
		Assert.isTrue(nearEquals(2.0, matrix3D.rawData[10]));
		Assert.isTrue(nearEquals(2.1, matrix3D.rawData[11]));
		Assert.isTrue(nearEquals(2.2, matrix3D.rawData[12]));
		Assert.isTrue(nearEquals(2.3, matrix3D.rawData[13]));
		Assert.isTrue(nearEquals(2.4, matrix3D.rawData[14]));
		Assert.isTrue(nearEquals(2.5, matrix3D.rawData[15]));
	}

	public function test_append()
	{
		var matrix3D = setupTestMatrix3D();
		matrix3D.append(new Matrix3D(Vector.ofArray([
			1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
		])));

		var expected = new Matrix3D(Vector.ofArray([
			64.28496551513672, 72.80441284179688, 81.32386779785156, 89.84331512451172, 2.8154678344726563, 3.088881254196167, 3.362294912338257,
			3.635709047317505, -5.6544413566589355, -4.923484802246094, -4.19252872467041, -3.461571216583252, 9090.5439453125, 10123.5390625,
			11156.533203125, 12189.5283203125
		]));

		assertMatrix3DnearEquals(expected, matrix3D);
	}

	public function test_appendRotation()
	{
		var matrix3D = setupTestMatrix3D();

		// Append rotations
		matrix3D.appendRotation(25, Vector3D.X_AXIS);
		matrix3D.appendRotation(-35, Vector3D.Y_AXIS);
		matrix3D.appendRotation(45, Vector3D.Z_AXIS);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var rotation = v1[1];
		var expectedRotation = v2[1];
		var expectedRotatedMatrix3D = new Matrix3D(Vector.ofArray([
			-0.3636549711227417, -3.372683525085449,  5.835120677947998, 0, 0.21577900648117065, -0.3639894127845764, 0.28737783432006836, 0,
			 0.9405853152275085, 1.4176323413848877, 0.2845056653022766, 0, -126.25172424316406,  -620.2042846679688,   740.5840454101563, 1
		]));

		assertVector3DnearEquals(expectedRotation, rotation);

		// Test the rotation matches to the rotation values in Flash
		assertMatrix3DnearEquals(expectedRotatedMatrix3D, matrix3D);
	}

	public function test_appendScale()
	{
		var matrix3D = setupTestMatrix3D();
		matrix3D.appendScale(3, 5, 7);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var scale = v1[2];
		var expectedScale = v2[2];
		var expectedScaledMatrix3D = new Matrix3D(Vector.ofArray([
			3.5480880737304688, 3.6606297492980957, 46.23238754272461, 0, 0.23695658147335052, -1.2332863807678223, 3.0875978469848633, 0, 4.587393760681152,
			0, -5.587223052978516, 0, -22.75981330871582, 338.8786315917969, 6802.64013671875, 1
		]));

		assertVector3DnearEquals(expectedScale, scale);

		// Test the scaling matches to the scaling values in Flash
		assertMatrix3DnearEquals(expectedScaledMatrix3D, matrix3D);
	}

	public function test_appendTranslation()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.appendTranslation;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		matrix3D.appendTranslation(123, -456, 789);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var translation = v1[0];
		var expectedTranslation = v2[0];
		var expectedTranslatedMatrix3D = new Matrix3D(Vector.ofArray([
			1.182695984840393, 0.7321259379386902, 6.604626655578613, 0, 0.07898552715778351, -0.24665726721286774, 0.4410853981971741, 0, 1.529131293296814,
			0, -0.7981747388839722, 0, 115.41339874267578, -388.2242736816406, 1760.8056640625, 1
		]));

		assertVector3DnearEquals(expectedTranslation, translation);

		// Test the translation matches to the translation values in Flash
		assertMatrix3DnearEquals(expectedTranslatedMatrix3D, matrix3D);
	}

	public function test_clone()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.clone;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();

		var clone = matrix3D.clone();

		assertMatrix3DnearEquals(clone, matrix3D);
	}

	public function test_copyColumnFrom()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyColumnFrom;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		matrix3D.copyColumnFrom(0, new Vector3D(1, 2, 3, 4));
		matrix3D.copyColumnFrom(1, new Vector3D(5, 6, 7, 8));
		matrix3D.copyColumnFrom(2, new Vector3D(9, 10, 11, 12));
		matrix3D.copyColumnFrom(3, new Vector3D(13, 14, 15, 16));

		var m2 = new Matrix3D(Vector.ofArray([
			1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
		]));

		assertMatrix3DnearEquals(m2, matrix3D);
	}

	public function test_copyColumnTo()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyColumnTo;

		Assert.notNull(exists);

		matrix3D = new Matrix3D(Vector.ofArray([
			1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
		]));

		var v0 = new Vector3D();
		var v1 = new Vector3D();
		var v2 = new Vector3D();
		var v3 = new Vector3D();
		matrix3D.copyColumnTo(0, v0);
		matrix3D.copyColumnTo(1, v1);
		matrix3D.copyColumnTo(2, v2);
		matrix3D.copyColumnTo(3, v3);

		// Test the values as expected in Flash
		assertVector3DnearEquals(new Vector3D(1, 2, 3, 4), v0);
		assertVector3DnearEquals(new Vector3D(5, 6, 7, 8), v1);
		assertVector3DnearEquals(new Vector3D(9, 10, 11, 12), v2);
		assertVector3DnearEquals(new Vector3D(13, 14, 15, 16), v3);
	}

	public function test_copyFrom()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyFrom;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		var m2 = new Matrix3D(Vector.ofArray([
			1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
		]));
		matrix3D.copyFrom(m2);

		assertMatrix3DnearEquals(m2, matrix3D);
	}

	public function test_copyRawDataFrom()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyRawDataFrom;

		Assert.notNull(exists);
	}

	public function test_copyRawDataTo()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyRawDataTo;

		Assert.notNull(exists);
	}

	public function test_copyRowFrom()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyRowFrom;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		matrix3D.copyRowFrom(0, new Vector3D(1, 2, 3, 4));
		matrix3D.copyRowFrom(1, new Vector3D(5, 6, 7, 8));
		matrix3D.copyRowFrom(2, new Vector3D(9, 10, 11, 12));
		matrix3D.copyRowFrom(3, new Vector3D(13, 14, 15, 16));

		var m2 = new Matrix3D(Vector.ofArray([
			1.0, 5.0, 9.0, 13.0, 2.0, 6.0, 10.0, 14.0, 3.0, 7.0, 11.0, 15.0, 4.0, 8.0, 12.0, 16.0
		]));

		// Test the values as expected in Flash
		assertMatrix3DnearEquals(m2, matrix3D);
	}

	public function test_copyRowTo()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyRowTo;

		Assert.notNull(exists);

		matrix3D = new Matrix3D(Vector.ofArray([
			1.0, 5.0, 9.0, 13.0, 2.0, 6.0, 10.0, 14.0, 3.0, 7.0, 11.0, 15.0, 4.0, 8.0, 12.0, 16.0
		]));

		var v0 = new Vector3D();
		var v1 = new Vector3D();
		var v2 = new Vector3D();
		var v3 = new Vector3D();
		matrix3D.copyRowTo(0, v0);
		matrix3D.copyRowTo(1, v1);
		matrix3D.copyRowTo(2, v2);
		matrix3D.copyRowTo(3, v3);

		// Test the values as expected in Flash
		assertVector3DnearEquals(new Vector3D(1, 2, 3, 4), v0);
		assertVector3DnearEquals(new Vector3D(5, 6, 7, 8), v1);
		assertVector3DnearEquals(new Vector3D(9, 10, 11, 12), v2);
		assertVector3DnearEquals(new Vector3D(13, 14, 15, 16), v3);
	}

	public function test_copyToMatrix3D()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.copyToMatrix3D;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();

		var copy = new Matrix3D();
		matrix3D.copyToMatrix3D(copy);

		// Test the values as expected in Flash
		assertMatrix3DnearEquals(copy, matrix3D);
	}

	public function test_decompose()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.decompose;

		Assert.notNull(exists);

		var recomposed = new Matrix3D();

		matrix3D = setupTestMatrix3D();
		var v1 = matrix3D.decompose(Orientation3D.QUATERNION);
		recomposed.recompose(matrix3D.decompose(Orientation3D.QUATERNION), Orientation3D.QUATERNION);
		var v2 = recomposed.decompose(Orientation3D.QUATERNION);
		var translation = v1[0];
		var rotation = v1[1];
		var scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0], 0.1);
		assertVector3DnearEquals(v1[1], v2[1], 0.1);
		assertVector3DnearEquals(v1[2], v2[2], 0.25);

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		// assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation, 0.1 );
		// assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale, 0.1 );
		// assertVector3DnearEquals(new Vector3D(0.7662321329116821, 0.04167995974421501, 0.6412106156349182, 3.0718624591827393 ), rotation, 0.25 );

		matrix3D = setupTestMatrix3D();
		v1 = matrix3D.decompose(Orientation3D.AXIS_ANGLE);
		recomposed.recompose(matrix3D.decompose(Orientation3D.AXIS_ANGLE), Orientation3D.AXIS_ANGLE);
		v2 = recomposed.decompose(Orientation3D.AXIS_ANGLE);
		translation = v1[0];
		rotation = v1[1];
		scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0]);
		assertVector3DnearEquals(v1[1], v2[1]);
		assertVector3DnearEquals(v1[2], v2[2]);

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		// assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation );
		// assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale );
		// assertVector3DnearEquals(new Vector3D(0.7657665014266968, 0.04165463149547577, 0.6408209204673767, 0.03485807776451111 ), rotation );

		matrix3D = setupTestMatrix3D();
		v1 = matrix3D.decompose();
		recomposed.recompose(matrix3D.decompose());
		v2 = recomposed.decompose();
		translation = v1[0];
		rotation = v1[1];
		scale = v1[2];

		assertVector3DnearEquals(v1[0], v2[0]);
		assertVector3DnearEquals(v1[1], v2[1]);
		assertVector3DnearEquals(v1[2], v2[2]);

		// Check values match the values from Flash
		// TODO: Descrepencies between flash API and the current implementation differ in results
		// assertVector3DnearEquals(new Vector3D(-7.586604595184326, 67.77572631835938, 971.8057250976563, 0 ), translation );
		// assertVector3DnearEquals(new Vector3D(6.749508857727051, 0.2938079237937927, 1.6458808183670044, 0 ), scale );
		// assertVector3DnearEquals(new Vector3D(2.5969605445861816, -1.3632254600524902, 0.5542957186698914, 1.169139158164002e-31 ), rotation );
	}

	public function test_deltaTransformVector()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.deltaTransformVector;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();

		var expected = new Vector3D(59.280609130859375, 2.3881149291992188, 50.9227294921875, 0);
		var actual = matrix3D.deltaTransformVector(new Vector3D(10, 20, 30));

		assertVector3DnearEquals(expected, actual);

		var v = new Vector<Float>();
		for (i in 0...16)
			v.push(i + 1);

		var a = new Vector3D(1, 2, 3, 4);
		var b = new Matrix3D(v);
		var c = b.deltaTransformVector(a);

		Assert.equals(1, a.x);
		Assert.equals(2, a.y);
		Assert.equals(3, a.z);
		Assert.equals(4, a.w);

		Assert.equals(38, c.x);
		Assert.equals(44, c.y);
		Assert.equals(50, c.z);
		Assert.equals(56, c.w);
	}

	public function test_identity()
	{
		var identity = Vector.ofArray([1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]);

		var matrix = Vector.ofArray([3.0, 2.0, 7.0, 1.0, 5.0, 1.0, 1.1, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 3.2, 1.0]);

		var matrix3D = new Matrix3D(matrix);
		matrix3D.identity();

		assertMatrix3DnearEquals(new Matrix3D(), matrix3D);
	}

	#if flash
	@Ignored
	#end
	public function test_interpolateTo()
	{
		var m1 = Vector.ofArray([3.0, 2.0, 7.0, 1.0, 5.0, 1.0, 1.1, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 3.2, 1.0]);

		var m2 = Vector.ofArray([1.0, 10.0, 2.0, 1.0, 2.0, 4.0, 2.0, 1.0, 3.0, 6.0, 1.0, 0.0, 0.0, 0.0, 3.5, 1.0]);

		#if !flash // TODO: For non-flash it behaves weirdly
		var result = Vector.ofArray([2.0, 6.0, 4.5, 1.0, 3.5, 2.5, 1.55, 0.5, 1.5, 3.5, 1.0, 0.0, 0.0, 0.0, 3.35, 1.0]);

		var matrix3D = new Matrix3D(m1);
		matrix3D.interpolateTo(new Matrix3D(m2), 0.5);

		assertMatrix3DnearEquals(new Matrix3D(result), matrix3D);
		#end
	}

	public function test_invert()
	{
		var matrix3D = new Matrix3D(Vector.ofArray([1.0, 2.0, 3.0, 4.0, 2.0, 1.0, 2.0, 3.0, 3.0, 2.0, 1.0, 2.0, 4.0, 3.0, 2.0, 1.0]));
		var inverted = matrix3D.invert();
		var expected = new Matrix3D(Vector.ofArray([-0.4, 0.5, 0, 0.1, 0.5, -1, 0.5, 0, 0, 0.5, -1, 0.5, 0.1, 0, 0.5, -0.4]));

		Assert.isTrue(inverted);

		assertMatrix3DnearEquals(expected, matrix3D);
	}

	@Ignored
	public function test_pointAt()
	{
		#if flash
		var matrix3D = new Matrix3D();
		matrix3D.pointAt(new Vector3D(1, 1, 1, 1), new Vector3D(2, 2, 2, 2), new Vector3D(3, 3, 3, 3));

		// var expected = new Matrix3D (Vector.ofArray ([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]));
		// assertMatrix3DnearEquals (expected, matrix3D);

		matrix3D.pointAt(new Vector3D(1, 1, 1, 1));

		var expected = new Matrix3D(Vector.ofArray([
			0.7071067690849304, 0, -0.7071067690849304, 0, 0.5773502588272095, 0.5773502588272095, 0.5773502588272095, 0, 0.40824827551841736,
			-0.8164965510368347, 0.40824827551841736, 0, 0, 0, 0, 1
		]));
		assertMatrix3DnearEquals(expected, matrix3D);

		matrix3D.pointAt(new Vector3D(2, 2, 2, 2), new Vector3D(1, 1, 1, 1));

		var expected = new Matrix3D(Vector.ofArray([
			0.6666666269302368,  0.6666666269302368, -0.3333333134651184, 0, -0.3333333134651184, 0.6666666269302368, 0.6666666269302368, 0,
			0.6666666269302368, -0.3333333134651184,  0.6666666269302368, 0,                   0,                  0,                  0, 1
		]));
		assertMatrix3DnearEquals(expected, matrix3D);
		#end
	}

	public function test_prepend()
	{
		var matrix3D = setupTestMatrix3D();
		matrix3D.prepend(new Matrix3D(Vector.ofArray([
			1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
		])));

		var expected = new Matrix3D(Vector.ofArray([
			-24.418357849121094, 271.3417053222656, 3892.315185546875, 4, -43.601524353027344, 544.386474609375, 7804.5283203125, 8, -62.784690856933594,
			817.4312744140625, 11716.7412109375, 12, -81.96785736083984, 1090.47607421875, 15628.9541015625, 16
		]));

		assertMatrix3DnearEquals(expected, matrix3D);
	}

	public function test_prependRotation()
	{
		var matrix3D = setupTestMatrix3D();

		// Append rotations
		matrix3D.prependRotation(25, Vector3D.X_AXIS);
		matrix3D.prependRotation(-35, Vector3D.Y_AXIS);
		matrix3D.prependRotation(45, Vector3D.Z_AXIS);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var rotation = v1[1];
		var expectedRotation = v2[1];
		var expectedRotatedMatrix3D = new Matrix3D(Vector.ofArray([
			1.74116849899292, 0.3082742691040039, 3.5007357597351074, 0, -0.7260121703147888, -0.6244180798530579, -3.412437915802002, 0, 0.42952263355255127,
			-0.3345402479171753, -4.533524990081787, 0, -7.586604595184326, 67.77572631835938, 971.8057250976563, 1
		]));

		assertVector3DnearEquals(expectedRotation, rotation);

		// Test the rotation matches to the rotation values in Flash
		assertMatrix3DnearEquals(expectedRotatedMatrix3D, matrix3D);
	}

	public function test_prependScale()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.prependScale;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		matrix3D.prependScale(3, 5, 7);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var scale = v1[2];
		var expectedScale = v2[2];
		var expectedScaledMatrix3D = new Matrix3D(Vector.ofArray([
			3.5480880737304688, 2.196377754211426, 19.813880920410156, 0, 0.39492762088775635, -1.2332863807678223, 2.2054269313812256, 0, 10.703919410705566,
			0, -5.587223052978516, 0, -7.586604595184326, 67.77572631835938, 971.8057250976563, 1
		]));

		assertVector3DnearEquals(expectedScale, scale);

		// Test the scaling matches to the scaling values in Flash
		assertMatrix3DnearEquals(expectedScaledMatrix3D, matrix3D);
	}

	public function test_prependTranslation()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.prependTranslation;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();
		matrix3D.prependTranslation(123, -456, 789);

		var recomposed = new Matrix3D();
		recomposed.recompose(matrix3D.decompose());

		var v1 = matrix3D.decompose();
		var v2 = recomposed.decompose();
		var translation = v1[0];
		var expectedTranslation = v2[0];
		var expectedTranslatedMatrix3D = new Matrix3D(Vector.ofArray([
			1.182695984840393, 0.7321259379386902, 6.604626655578613, 0, 0.07898552715778351, -0.24665726721286774, 0.4410853981971741, 0, 1.529131293296814,
			0, -0.7981747388839722, 0, 1308.352294921875, 270.30291748046875, 953.2799682617188, 1
		]));

		assertVector3DnearEquals(expectedTranslation, translation);

		// Test the translation matches to the translation values in Flash
		assertMatrix3DnearEquals(expectedTranslatedMatrix3D, matrix3D);
	}

	public function test_recompose()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.recompose;

		Assert.notNull(exists);
	}

	public function test_transformVector()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.transformVector;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();

		var transformed = matrix3D.transformVector(new Vector3D(100, 200, 300));

		// Test transformed values match transformed values from Flash
		assertVector3DnearEquals(new Vector3D(585.2195, 91.6569, 1481.0330), transformed);

		var v = new Vector<Float>();
		for (i in 0...16)
			v.push(i + 1);

		var a = new Vector3D(1, 2, 3, 4);
		var b = new Matrix3D(v);
		var c = b.deltaTransformVector(a);

		Assert.equals(1, a.x);
		Assert.equals(2, a.y);
		Assert.equals(3, a.z);
		Assert.equals(4, a.w);

		Assert.equals(38, c.x);
		Assert.equals(44, c.y);
		Assert.equals(50, c.z);
		Assert.equals(56, c.w);
	}

	public function test_transformVectors()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.transformVectors;

		Assert.notNull(exists);

		matrix3D = setupTestMatrix3D();

		var vIn:Vector<Float> = Vector.ofArray([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]);
		var actual:Vector<Float> = Vector.ofArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
		matrix3D.transformVectors(vIn, actual);

		var expected:Vector<Float> = Vector.ofArray([
			-1.6585435612600001,
			68.0145399603,
			976.8979877785,
			6.71389482185,
			69.470946012,
			995.6405996761,
			15.086333204960003,
			70.9273520637,
			1014.3832115737
		]);

		assertVectorNearEquals(expected, actual);
	}

	public function test_transpose()
	{
		// TODO: Confirm functionality

		var matrix3D = new Matrix3D();
		var exists = matrix3D.transpose;

		Assert.notNull(exists);

		var matrix3D = setupTestMatrix3D();
		var clone = matrix3D.clone();
		matrix3D.transpose();

		var expected = clone.rawData;
		var actual = matrix3D.rawData;

		Assert.equals(expected[1], actual[4]);
		Assert.equals(expected[2], actual[8]);
		Assert.equals(expected[3], actual[12]);
		Assert.equals(expected[4], actual[1]);
		Assert.equals(expected[6], actual[9]);
		Assert.equals(expected[7], actual[13]);
		Assert.equals(expected[8], actual[2]);
		Assert.equals(expected[9], actual[6]);
		Assert.equals(expected[11], actual[14]);
		Assert.equals(expected[12], actual[3]);
		Assert.equals(expected[13], actual[7]);
		Assert.equals(expected[14], actual[11]);
	}

	#if flash
	@Ignored
	#end
	public function test_interpolate()
	{
		var m1 = Vector.ofArray([3.0, 2.0, 7.0, 1.0, 5.0, 1.0, 1.1, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 3.2, 1.0]);

		var m2 = Vector.ofArray([1.0, 10.0, 2.0, 1.0, 2.0, 4.0, 2.0, 1.0, 3.0, 6.0, 1.0, 0.0, 0.0, 0.0, 3.5, 1.0]);

		#if !flash // TODO: For non-flash it behaves weirdly
		var result = Vector.ofArray([2.0, 6.0, 4.5, 1.0, 3.5, 2.5, 1.55, 0.5, 1.5, 3.5, 1.0, 0.0, 0.0, 0.0, 3.35, 1.0]);

		var m1_matrix3D = new Matrix3D(m1);
		var m2_matrix3D = new Matrix3D(m2);

		var result_matrix3D = Matrix3D.interpolate(m1_matrix3D, m2_matrix3D, 0.5);

		assertMatrix3DnearEquals(new Matrix3D(result), result_matrix3D);
		#end
	}

	private inline function setupTestMatrix3D():Matrix3D
	{
		var m1 = new Matrix3D();
		m1.prependTranslation(100, 200, 300);
		m1.prependRotation(30, Vector3D.X_AXIS);
		m1.prependRotation(45, Vector3D.Y_AXIS);
		m1.prependRotation(60, Vector3D.Z_AXIS);
		m1.prependScale(3, 4, 5);

		return new Matrix3D(Vector.ofArray([
			1.182695964, 0.7321259575, 6.604626666, 0, 0.07898552537, -0.2466572736, 0.4410853871, 0, 1.529131305, 0, -0.7981747539, 0, -7.586604491,
			67.77572855, 971.8057146, 1
		]));
	}

	private function assertMatrix3DnearEquals(expected:Matrix3D, actual:Matrix3D, ?tolerance:Float = 0.001, ?pos:haxe.PosInfos)
	{
		var rdExpected = expected.rawData;
		var rdActual = actual.rawData;

		// trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");
		// trace("Expected (Matrix3D)("+tolerance+"):"+rdExpected.join(", "));
		// trace("Actual   (Matrix3D)("+tolerance+"):"+rdActual.join(", "));

		Assert.isTrue(nearEquals(rdExpected[0], rdActual[0], tolerance));
		Assert.isTrue(nearEquals(rdExpected[1], rdActual[1], tolerance));
		Assert.isTrue(nearEquals(rdExpected[2], rdActual[2], tolerance));
		Assert.isTrue(nearEquals(rdExpected[3], rdActual[3], tolerance));
		Assert.isTrue(nearEquals(rdExpected[4], rdActual[4], tolerance));
		Assert.isTrue(nearEquals(rdExpected[5], rdActual[5], tolerance));
		Assert.isTrue(nearEquals(rdExpected[6], rdActual[6], tolerance));
		Assert.isTrue(nearEquals(rdExpected[7], rdActual[7], tolerance));
		Assert.isTrue(nearEquals(rdExpected[8], rdActual[8], tolerance));
		Assert.isTrue(nearEquals(rdExpected[9], rdActual[9], tolerance));
		Assert.isTrue(nearEquals(rdExpected[10], rdActual[10], tolerance));
		Assert.isTrue(nearEquals(rdExpected[11], rdActual[11], tolerance));
		Assert.isTrue(nearEquals(rdExpected[12], rdActual[12], tolerance));
		Assert.isTrue(nearEquals(rdExpected[13], rdActual[13], tolerance));
		Assert.isTrue(nearEquals(rdExpected[14], rdActual[14], tolerance));
		Assert.isTrue(nearEquals(rdExpected[15], rdActual[15], tolerance));
	}

	private function assertVector3DnearEquals(expected:Vector3D, actual:Vector3D, ?tolerance:Float = 0.001, ?pos:haxe.PosInfos)
	{
		// trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");
		// trace("Expected (Vector3D)("+tolerance+"):"+expected.x+", "+expected.y+", "+expected.z+", "+expected.w);
		// trace("Actual   (Vector3D)("+tolerance+"):"+actual.x+", "+actual.y+", "+actual.z+", "+actual.w);

		Assert.isTrue(nearEquals(expected.x, actual.x, tolerance));
		Assert.isTrue(nearEquals(expected.y, actual.y, tolerance));
		Assert.isTrue(nearEquals(expected.z, actual.z, tolerance));
	}

	private function assertVectorNearEquals(expected:Vector<Float>, actual:Vector<Float>, ?tolerance:Float = 0.001, ?pos:haxe.PosInfos)
	{
		// trace("Test : "+pos.methodName+" ("+pos.lineNumber+")");

		Assert.equals(expected.length, actual.length);
		for (i in 0...expected.length)
		{
			// trace("Expected (Vector)("+tolerance+"):"+expected[i]+" == "+actual[i]);
			Assert.isTrue(nearEquals(expected[i], actual[i], tolerance));
		}
	}

	private function nearEquals(expected:Float, actual:Float, tolerance:Float = 0.001):Bool
	{
		return (actual > expected - tolerance) && (actual < expected + tolerance);
	}
}
