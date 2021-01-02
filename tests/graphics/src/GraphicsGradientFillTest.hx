package;

import openfl.display.GraphicsGradientFill;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

class GraphicsGradientFillTest extends Test
{
	public function test_alphas()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		gradientFill.alphas = [];
		var exists = gradientFill.alphas;

		Assert.notNull(exists);
	}

	public function test_colors()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		gradientFill.colors = [];
		var exists = gradientFill.colors;

		Assert.notNull(exists);
	}

	public function test_focalPointRatio()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		var exists = gradientFill.focalPointRatio;

		Assert.notNull(exists);
	}

	public function test_interpolationMethod()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		var exists = gradientFill.interpolationMethod;

		Assert.notNull(exists);
	}

	public function test_matrix()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		gradientFill.matrix = new Matrix();
		var exists = gradientFill.matrix;

		Assert.notNull(exists);
	}

	public function test_ratios()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		gradientFill.ratios = [];
		var exists = gradientFill.ratios;

		Assert.notNull(exists);
	}

	public function test_spreadMethod()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		var exists = gradientFill.spreadMethod;

		Assert.notNull(exists);
	}

	public function test_type()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();
		var exists = gradientFill.type;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var gradientFill = new GraphicsGradientFill();

		Assert.notNull(gradientFill);
	}
}
