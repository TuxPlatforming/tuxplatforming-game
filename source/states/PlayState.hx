package states;

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	public var map:FlxTilemap;

	// Add things part 1
	public var collision(default, null):FlxTypedGroup<FlxSprite>;
	public var tux(default, null):Tux;

	override public function create()
	{
		// Add things part 2
		collision = new FlxTypedGroup<FlxSprite>();
		tux = new Tux();

		LevelLoader.loadLevel(this, "test");

		// Add things part 3
		add(collision);
		add(tux);

		// Camera
		FlxG.camera.follow(tux, PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Tux collision
		FlxG.collide(collision, tux);
	}
}
