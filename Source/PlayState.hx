package;

class PlayState extends State
{
	var spr:Sprite;

	var sound:Sound;

	var testGrp:Group;
	var grpSpr:Sprite;

	override public function create():Void
	{
		persistentUpdate = true;

		spr = new Sprite();
		spr.graphics.beginFill(0xFF00FF00);
		spr.graphics.drawRect(0, 0, 120, 120);
		spr.graphics.endFill();
		add(spr);

		super.create();

		sound = Main.SoundChannel.add_to_list("test_sound_1", new Sound("assets/test.ogg"));
		sound.play();

		testGrp = new Group();
		add(testGrp);

		grpSpr = new Sprite();
		grpSpr.graphics.beginFill(0xFFFF0000);
		grpSpr.graphics.drawRect(0, 0, 120, 120);
		grpSpr.graphics.endFill();
		testGrp.add(grpSpr);

		haxe.Timer.delay(openSubState.bind(SubStateTest), 2000);
	}

	var time:Float = 0;
	override public function update(dt:Float):Void
	{
		time += dt;
		spr.x = spr.y = 600 * ((Math.sin(time) * 0.5) + 0.5);
		super.update(dt);
	}
}

class SubStateTest extends SubState
{
	var spr:Sprite;

	override public function create():Void
	{
		super.create();

		trace('test');

		spr = new Sprite();
		spr.graphics.beginFill(0xFFFFFF00);
		spr.graphics.drawRect(0, 0, 120, 120);
		spr.graphics.endFill();
		add(spr);

		haxe.Timer.delay(close, 6000);
	}

	var time:Float = 0;
	override public function update(dt:Float):Void
	{
		time += dt;
		spr.x = spr.y = 400 * ((Math.sin(time) * 0.5) + 0.5);
		super.update(dt);
	}
}