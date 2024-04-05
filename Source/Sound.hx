package;

import openfl.events.Event;
import openfl.display.Sprite;
import lime.media.AudioSource;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;

// Just a sound class made to ogg sounds near-instant (streaming).
// You MUST add the sound to the sound list, or it'll cause unintential behavior.

class Sound
{
	public var source(default, null):AudioSource = null;

	public var length:UInt = 0;
	public var time:UInt = 0;

	public var volume:Float = 1;

	public var pitch(default, set):Float = 1;
	inline function set_pitch(value:Float):Float
	{
		source.pitch = value;
		return pitch = value;
	}

	public var playing(default, null):Bool = false;
	public var paused(default, null):Bool = false;

	inline public function new(sourceFile:String):Void
	{
		load(sourceFile);
	}

	inline public function load(sourceFile:String):Void
	{
		source = new AudioSource(AudioBuffer.fromVorbisFile(VorbisFile.fromFile(sourceFile)));
		length = source.length;
	}

	inline public function update(elapsed:Float):Void
	{
		if (playing && !paused && null != source)
		{
			source.gain = volume * Main.SoundChannel.global_volume;
			time = source.currentTime;
		}
		//trace(time, length);
	}

	inline public function play(forceRestart:Bool = false, startTime:Int = 0):Void
		if (null != source && (!playing || paused))
		{
			if (forceRestart)
				source.stop();
			else
				time = startTime;

			source.play();

			playing = true;
			paused = false;
		}

	inline public function pause():Void
		if (null != source && (playing || !paused))
		{
			source.pause();
			playing = false;
			paused = true;
		}

	inline public function stop():Void
		if (null != source && playing)
		{
			source.stop();

			playing = paused = false;
		}

	inline public function destroy():Void
	{
		if (null != source)
			source.dispose();

		source = null;
		playing = paused = false;
	}

	inline public function onFocusLost():Void
		pause();

	inline public function onFocus():Void
		play();

	inline public function setTime(newTime:Int):Void
		time = source.currentTime = newTime;
}