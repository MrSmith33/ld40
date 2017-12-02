module tilemap;

import graphics;
import math;

/// Tile texture array
enum TileType : ubyte
{
	square,
	circle
}

struct Tile
{
	TileType type;
	bool solid; // can be changed to flags
}

enum TILE_SIZE = 16;
enum ivec2 TILE_SIZE_VEC = ivec2(TILE_SIZE, TILE_SIZE);

struct Tilemap(int width, int height)
{
	Tile[width][height] tiles;
}

void drawTileMap(Tilemap : Tilemap)(
	ref RenderQueue renderQueue,
	ref Tilemap tilemap,
	ref Camera camera,
	SpriteRef[] spriteSheet)
{
	foreach (x, column; tilemap.tiles)
	{
		foreach (y, tile; column)
		{
			auto sprite = *(spriteSheet[tile.type]);
			renderQueue.drawSpriteCamera(sprite, 0, camera, vec2(x, y) * vec2(TILE_SIZE_VEC), 0);
		}
	}
}
