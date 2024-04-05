package;

class Group extends Sprite
{
	public var members:Array<Sprite> = [];

	public function new():Void
	{
		super();
		create();
	}

	public function create():Void {}
	public function update(dt:Float):Void {}

	public function add(obj:Sprite):Void {
		addChild(members[members.length] = obj);
	}

	public function remove(obj:Sprite):Void {
		removeChild(members[members.indexOf(obj)]);
	}

	public function destroy():Void {
		for (obj in members)
		{
			remove(obj);
			obj = null;
		}
	}
}