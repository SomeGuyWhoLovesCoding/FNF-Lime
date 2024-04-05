package;

class Game extends Sprite
{
	inline static public var initialState:Class<State> = PlayState;

	public var bgColor(default, set):UInt = 0xFF999999;

	public var focus_lost:Bool = false;
	public var auto_pause:Bool = true;

	inline function set_bgColor(value:UInt):UInt
	{
		this.graphics.beginFill(value);
		this.graphics.drawRect(0, 0, Application.current.window.width, Application.current.window.height);
		this.graphics.endFill();
		return bgColor = value;
	}

	public function new():Void
	{
		super();

		bgColor = bgColor; // Don't remove this

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(Event.ADDED_TO_STAGE, onCreate);

		addEventListener(Event.DEACTIVATE, onFocusLost);
		addEventListener(Event.ACTIVATE, onFocus);
	}

	inline public function onCreate(_:Event):Void
		inline switchState(initialState);

	public var currentClass:State = null;
	inline public function switchState(newClass:Class<State>):Void
	{
		removeChild(currentClass);
		addChild(currentClass = inline Type.createInstance(newClass, []));
	}

	public var elapsed(default, null):Float = 0;
	private var prevTime(default, null):Float = 0;

	inline public function onEnterFrame(_:Event):Void
	{
		final startTimer:Float = inline haxe.Timer.stamp();
		elapsed = startTimer - prevTime;
		//trace(elapsed);

		if (!focus_lost || !auto_pause)
		{
			inline Main.SoundChannel.update(elapsed);
			inline Main.Engine.updateMain(elapsed);

			if (!currentClass.inSubState || currentClass.persistentUpdate)
				currentClass.update(elapsed);

			if (null != currentClass.subState)
				currentClass.subState.update(elapsed);
		}

		prevTime = startTimer;
	}

	inline public function onFocusLost(_:Event):Void
	{
		if (!focus_lost && auto_pause)
		{
			inline Main.SoundChannel.onFocusLost();
			focus_lost = true;
		}
	}

	inline public function onFocus(_:Event):Void
	{
		if (focus_lost)
		{
			inline Main.SoundChannel.onFocus();
			focus_lost = false;
		}
	}
}