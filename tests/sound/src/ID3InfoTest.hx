package;

import openfl.media.Sound;
import utest.Assert;
import utest.Test;

class ID3InfoTest extends Test
{
	public function test_album()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.album;

		Assert.isNull(exists);
	}

	public function test_artist()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.artist;

		Assert.isNull(exists);
	}

	public function test_comment()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.comment;

		Assert.isNull(exists);
	}

	public function test_genre()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.genre;

		Assert.isNull(exists);
	}

	public function test_songName()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.songName;

		Assert.isNull(exists);
	}

	public function test_track()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.track;

		Assert.isNull(exists);
	}

	public function test_year()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		var exists = id3Info.year;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var id3Info = new Sound().id3;
		Assert.notNull(id3Info);
	}
}
