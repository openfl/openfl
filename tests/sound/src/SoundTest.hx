package;

import openfl.media.Sound;
import utest.Assert;
import utest.Test;

class SoundTest extends Test
{
	public function test_bytesLoaded()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.bytesLoaded;

		Assert.notNull(exists);
	}

	public function test_bytesTotal()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.bytesTotal;

		Assert.notNull(exists);
	}

	public function test_id3()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.id3;

		Assert.notNull(exists);
	}

	public function test_isBuffering()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.isBuffering;

		Assert.notNull(exists);
	}

	public function test_length()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.length;

		Assert.notNull(exists);
	}

	public function test_url()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.url;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		Assert.notNull(sound);
	}

	public function test_close()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.close;

		Assert.notNull(exists);
	}

	public function test_load()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.load;

		Assert.notNull(exists);
	}

	public function test_loadCompressedDataFromByteArray()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.loadCompressedDataFromByteArray;

		Assert.notNull(exists);
	}

	public function test_loadPCMFromByteArray()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.loadPCMFromByteArray;

		Assert.notNull(exists);
	}

	public function test_play()
	{
		// TODO: Confirm functionality

		var sound = new Sound();
		var exists = sound.play;

		Assert.notNull(exists);
	}
}
