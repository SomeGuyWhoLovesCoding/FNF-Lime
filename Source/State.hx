package;

class State extends Group
{
	public var persistentUpdate:Bool = false;

	public var subState:SubState;
	public var inSubState:Bool = false;

	public function new():Void
	{
		super();
	}

	public function openSubState(newSubState:Class<SubState>):Void
	{
		if (!inSubState)
		{
			addChild(subState = Type.createInstance(newSubState, []));
			inSubState = true;
		}
	}

	public function closeSubState():Void
	{
		if (inSubState)
		{
			subState.close();
			inSubState = false;
		}
	}

	public function onFocusLost():Void {}
	public function onFocus():Void {}
}