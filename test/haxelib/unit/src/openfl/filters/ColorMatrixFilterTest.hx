package openfl.filters;

import massive.munit.Assert;

class ColorMatrixFilterTest
{
	@Test public function new_()
	{
		var identity = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		var matrix = [1.0, 2.0, 3.0];

		var color = new ColorMatrixFilter();
		var color_matrix = color.matrix;

		Assert.areEqual(identity.length, color_matrix.length);

		for (i in 0...color_matrix.length)
		{
			Assert.areEqual(identity[i], color_matrix[i]);
		}

		color = new ColorMatrixFilter(matrix);
		color_matrix = color.matrix;

		#if flash
		Assert.areEqual(20, color_matrix.length);
		#else
		Assert.areEqual(matrix.length, color_matrix.length);
		#end

		#if flash
		for (i in 0...color_matrix.length)
		{
			if (i < matrix.length)
			{
				Assert.areEqual(matrix[i], color_matrix[i]);
			}
			else
			{
				Assert.areEqual(0.0, color_matrix[i]);
			}
		}
		#else
		for (i in 0...matrix.length)
		{
			Assert.areEqual(matrix[i], color_matrix[i]);
		}
		#end
	}

	@Test public function clone()
	{
		var matrix = [1.0, 2.0, 3.0];

		var color = new ColorMatrixFilter(matrix);
		var color_clone = color.clone();

		Assert.isType(color_clone, ColorMatrixFilter);

		var result = cast(color_clone, ColorMatrixFilter).matrix;

		#if flash
		for (i in 0...matrix.length)
		{
			Assert.areEqual(matrix[i], result[i]);
		}
		#else
		Assert.areSame(matrix, result);
		#end
	}

	@Test public function matrix()
	{
		var identity = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		var matrix = [5.0, 1.0, 3.0];

		var color = new ColorMatrixFilter();
		var color_matrix = null;

		#if !flash
		color.matrix = null;

		var color_matrix = color.matrix;

		Assert.areEqual(identity.length, color_matrix.length);

		for (i in 0...color_matrix.length)
		{
			Assert.areEqual(identity[i], color_matrix[i]);
		}
		#end

		color.matrix = matrix;

		color_matrix = color.matrix;

		#if flash
		Assert.areEqual(20, color_matrix.length);
		#else
		Assert.areEqual(matrix.length, color_matrix.length);
		#end

		#if flash
		for (i in 0...color_matrix.length)
		{
			if (i < matrix.length)
			{
				Assert.areEqual(matrix[i], color_matrix[i]);
			}
			else
			{
				Assert.areEqual(0.0, color_matrix[i]);
			}
		}
		#else
		for (i in 0...matrix.length)
		{
			Assert.areEqual(matrix[i], color_matrix[i]);
		}
		#end
	}
}
