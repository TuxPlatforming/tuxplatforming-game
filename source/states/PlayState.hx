package states;

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import objects.Coin;

class PlayState extends FlxState
{
	public var map:FlxTilemap;

	// Add things part 1
	public var collision(default, null):FlxTypedGroup<FlxSprite>;
	public var tux(default, null):Tux;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	private var hud:HUD;

	override public function create()
	{
		// Add things part 2
		collision = new FlxTypedGroup<FlxSprite>();
		tux = new Tux();
		items = new FlxTypedGroup<FlxSprite>();
		hud = new HUD();

		LevelLoader.loadLevel(this, "test");

		// Add things part 3
		add(collision);
		add(items);
		add(tux);
		add(hud);

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
		FlxG.overlap(items, tux, collideItems);
	}

	function collideItems(coin:Coin, tux:Tux)
	{
		coin.collect();
	}
}
