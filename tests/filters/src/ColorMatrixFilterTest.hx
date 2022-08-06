package;

import openfl.filters.ColorMatrixFilter;
import utest.Assert;
import utest.Test;

class ColorMatrixFilterTest extends Test
{
	public function test_new_()
	{
		var identity = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		var matrix = [1.0, 2.0, 3.0];

		var color = new ColorMatrixFilter();
		var color_matrix = color.matrix;

		Assert.equals(identity.length, color_matrix.length);

		for (i in 0...color_matrix.length)
		{
			Assert.equals(identity[i], color_matrix[i]);
		}

		color = new ColorMatrixFilter(matrix);
		color_matrix = color.matrix;

		#if flash
		Assert.equals(20, color_matrix.length);
		#else
		Assert.equals(matrix.length, color_matrix.length);
		#end

		#if flash
		for (i in 0...color_matrix.length)
		{
			if (i < matrix.length)
			{
				Assert.equals(matrix[i], color_matrix[i]);
			}
			else
			{
				Assert.equals(0.0, color_matrix[i]);
			}
		}
		#else
		for (i in 0...matrix.length)
		{
			Assert.equals(matrix[i], color_matrix[i]);
		}
		#end
	}

	public function test_clone()
	{
		var matrix = [1.0, 2.0, 3.0];

		var color = new ColorMatrixFilter(matrix);
		var color_clone = color.clone();

		Assert.isOfType(color_clone, ColorMatrixFilter);

		var result = cast(color_clone, ColorMatrixFilter).matrix;

		#if flash
		for (i in 0...matrix.length)
		{
			Assert.equals(matrix[i], result[i]);
		}
		#else
		Assert.equals(matrix, result);
		#end
	}

	public function test_matrix()
	{
		var identity = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		var matrix = [5.0, 1.0, 3.0];

		var color = new ColorMatrixFilter();
		var color_matrix = null;

		#if !flash
		color.matrix = null;

		var color_matrix = color.matrix;

		Assert.equals(identity.length, color_matrix.length);

		for (i in 0...color_matrix.length)
		{
			Assert.equals(identity[i], color_matrix[i]);
		}
		#end

		color.matrix = matrix;

		color_matrix = color.matrix;

		#if flash
		Assert.equals(20, color_matrix.length);
		#else
		Assert.equals(matrix.length, color_matrix.length);
		#end

		#if flash
		for (i in 0...color_matrix.length)
		{
			if (i < matrix.length)
			{
				Assert.equals(matrix[i], color_matrix[i]);
			}
			else
			{
				Assert.equals(0.0, color_matrix[i]);
			}
		}
		#else
		for (i in 0...matrix.length)
		{
			Assert.equals(matrix[i], color_matrix[i]);
		}
		#end
	}
}
