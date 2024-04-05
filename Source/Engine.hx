package;

// Roughly a copy of FNF Zenith's ``Main``.

typedef Transitioning =
{
	var _in:TransitioningInfo;
	var _out:TransitioningInfo;
}

typedef TransitioningInfo =
{
	var callback:Void->Void;
}

class Engine extends Sprite
{
	private final transitioning:Transitioning = {_in: null, _out: null};

	public var game_stage:Game;
	public var transition:Sprite;

	public var memTxt:TextField;

	public var skipTransIn:Bool = false;
	public var skipTransOut:Bool = false;

	public function new()
	{
		super();

		#if windows //DPI AWARENESS BABY
		@:functionCode('
			#include <Windows.h>
			SetProcessDPIAware();
		')
		#end

		var transitionMatrix:Matrix = new Matrix();
		transitionMatrix.createGradientBox(2560, 2880, Math.PI * 0.5);

		transition = new Sprite();
		transition.graphics.beginGradientFill(LINEAR, [0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000], [0, 1, 1, 0], [127, 157, 225, 255], transitionMatrix);
		transition.graphics.drawRect(0, 0, 2560, 2880);
		transition.graphics.endFill();
		transition.x = -transition.width * 0.5;

		addChild(game_stage = new Game());
		addChild(transition);

		memTxt = new TextField();
		memTxt.defaultTextFormat = new TextFormat('fonts/vcr.ttf', 18, 0xFFFFFFFF, true);
		memTxt.selectable = false;
		memTxt.width = game_stage.width;
		addChild(memTxt);
	}

	public function startTransition(_transIn:Bool = false, _callback:Void->Void = null):Void
	{
		if (_transIn)
		{
			if (skipTransIn)
			{
				transitionY = 720;

				if (null != _callback)
					_callback();

				return;
			}

			transitionY = -transition.height;

			if (null == transitioning._in)
				transitioning._in = {callback: _callback};
		}
		else
		{
			if (skipTransOut)
			{
				transitionY = 720;

				return;
			}

			transitionY = -transition.height * 0.6;

			if (null == transitioning._out)
				transitioning._out = {callback: _callback};
		}
	}

	private var transitionY:Float = 0;
	public function updateMain(dt:Float):Void
	{
		if (@:privateAccess game_stage.focus_lost && !game_stage.auto_pause)
			return;

		if (null != memTxt)
			memTxt.text = inline formatBytes(openfl.system.System.totalMemory);

		transition.y = transitionY;

		if (transitionY < 720 * transition.scaleY)
			transitionY += (1585 * transition.scaleY) * dt;

		if (null != transitioning._in)
		{
			if (transitionY > -transition.height * 0.6)
			{
				if (null != transitioning._in.callback)
					transitioning._in.callback();
				transitioning._in = null;
			}
		}

		if (null != transitioning._out)
			if (transitionY > 720 * transition.scaleY)
				transitioning._out = null;

		transition.scaleX = Application.current.window.width / game_stage.width;
		transition.scaleY = Application.current.window.height / game_stage.height;
	}

	inline public function formatBytes(b:Float):String
	{
		var units:Array<String> = [" Bytes", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", "BB", "GPB", ""];
		var curUnit = 0;
		while (b >= 1024 && curUnit < units.length - 1)
		{
			b /= 1024;
			curUnit++;
		}
		return (inline Std.string(inline Math.floor(b * 100) * 0.01)) + units[curUnit];
	}
}