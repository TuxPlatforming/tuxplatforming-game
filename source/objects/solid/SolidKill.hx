package objects.solid;

import creatures.player.Tux;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class SolidKill extends FlxSprite
{
    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        solid = true;
        immovable = true;
    }

    public function interact(tux:Tux)
    {
        // Since this code is from my other game, there's this.
        // tux.die();
    }
}