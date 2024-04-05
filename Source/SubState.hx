package;

class SubState extends Group
{
	public function new():Void
	{
		super();
	}

	public function onFocusLost():Void {}
	public function onFocus():Void {}

	// Soon
	public function close():Void {
		destroy();
		Main.Engine.game_stage.currentClass.removeChild(this);
	}
}