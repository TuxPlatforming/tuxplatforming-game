package;

import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import objects.solid.Solid;
import objects.solid.Unisolid;
import states.PlayState;

class LevelLoader extends FlxState
{
    public static function loadLevel(state:PlayState, level:String)
    {
        var tiledMap = new TiledMap("assets/data/levels/" + level + ".tmx");

        // Quickly taken from my other game...
        for (layer in tiledMap.layers)
        {
            if (Std.isOfType(layer, TiledImageLayer))
            {
                var imageLayer:TiledImageLayer = cast layer;
                var path:String = Std.string(imageLayer.imagePath);
                path = StringTools.replace(path, "../", "");
                path = "assets/" + path;

                var image = new FlxBackdrop(path, XY);

                image.offset.x = Std.parseFloat(imageLayer.properties.get("offsetX"));
                image.offset.y = Std.parseFloat(imageLayer.properties.get("offsetY"));
                
                image.scrollFactor.x = imageLayer.parallaxX;
                image.scrollFactor.y = imageLayer.parallaxY;

                state.add(image);

                trace(path); // This is here so you can see if the path is correct if the image isn't showing.
            }
        }

        var mainTwoLayer:TiledTileLayer = cast tiledMap.getLayer("Main 2");
        
        var mainTwoMap = new FlxTilemap();
        mainTwoMap.loadMapFromArray(mainTwoLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        mainTwoMap.solid = false;

        var mainLayer:TiledTileLayer = cast tiledMap.getLayer("Main");
        
        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        state.map.solid = false;

        var backgroundLayer:TiledTileLayer = cast tiledMap.getLayer("Background");
        
        var backgroundMap = new FlxTilemap();
        backgroundMap.loadMapFromArray(backgroundLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        backgroundMap.solid = false;

        var backgroundTwoLayer:TiledTileLayer = cast tiledMap.getLayer("Background 2");
        
        var backgroundTwoMap = new FlxTilemap();
        backgroundTwoMap.loadMapFromArray(backgroundTwoLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        backgroundTwoMap.solid = false;

        state.add(backgroundTwoMap);
        state.add(backgroundMap);
        state.add(state.map);
        state.add(mainTwoMap);

        if (tiledMap.getLayer("Player") != null)
        {
            var tuxLayer:TiledObjectLayer = cast tiledMap.getLayer("Player");
            var tuxPosition:TiledObject = tuxLayer.objects[0];
            state.tux.setPosition(tuxPosition.x, tuxPosition.y - 56);
        }
        else
        {
            trace("Player object layer not found, credits to Discover HaxeFlixel for this code");
        }

        // Quickly taken from LevelLoader in my other game that also used Discover HaxeFlixel.
        for (solid in getLevelObjects(tiledMap, "Solid"))
        {
            var solidSquare = new Solid(solid.x, solid.y, solid.width, solid.height); // Need this because width and height.
            state.collision.add(solidSquare);
        }

        for (solid in getLevelObjects(tiledMap, "Unisolid"))
        {
            var unisolidSquare = new Unisolid(solid.x, solid.y, solid.width, solid.height); // Need this because width and height.
            state.collision.add(unisolidSquare);
        }
    }

    // This is from a part of Discover HaxeFlixel I have yet to reach again, specifically I used it in my other game and I copied and pasted it from there to here.
    public static function getLevelObjects(map:TiledMap, layer:String):Array<TiledObject>
    {
        if ((map != null) && (map.getLayer(layer) != null))
        {
            var objLayer:TiledObjectLayer = cast map.getLayer(layer);
            return objLayer.objects;
        }
        else
        {
            trace("Object layer " + layer + " not found! Also credits to Discover Haxeflixel.");
            return [];
        }
    }
}