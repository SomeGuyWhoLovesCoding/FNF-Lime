package;

// Global shit

class SoundChannel
{
	// Class variables

	static private final __contents:Map<String, Sound> = [];
	static public var global_volume:Float = 0.5;

	// Constructor

	inline public function new():Void {}

	// Class functions

	// Regular functions

	inline static public function add_to_list(str:String, sound:Sound):Sound
	{
		if (inline __contents.exists(str))
			inline stop_from_content(str);

		inline __contents.set(str, sound);
		return sound;
	}

	inline static public function play_from_content(str:String):Sound
	{
		var snd:Sound = inline get_from_content(str);
		inline snd.play();
		return snd;
	}

	inline static public function remove_from_content(str:String):Void
	{
		var snd:Sound = inline get_from_content(str);
		inline __contents.remove(str);
		inline snd.destroy();
		snd = null;
	}

	// One-liner functions

	inline static public function get_from_content(str:String):Sound
		return inline __contents.get(str);

	inline static public function stop_from_content(str:String):Void
		inline get_from_content(str).stop();

	inline static public function remove_all():Void
		for (str in (inline __contents.keys()))
			inline remove_from_content(str);

	inline static public function update(dt:Float):Void
		for (str in (inline __contents.keys()))
			inline get_from_content(str).update(dt);

	inline static public function onFocusLost():Void
		for (str in (inline __contents.keys()))
			inline get_from_content(str).onFocusLost();

	inline static public function onFocus():Void
		for (str in (inline __contents.keys()))
			inline get_from_content(str).onFocus();
}

class Main extends Sprite
{
	static public final SoundChannel:SoundChannel = new SoundChannel();
	static public var Engine:Engine;

	public function new()
	{
		super();
		addChild(Engine = new Engine());
	}
}