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
	bool isSolid; // can be changed to flags
}

enum TILE_SIZE = 16;
enum vec2 TILE_SIZE_VEC = vec2(TILE_SIZE, TILE_SIZE);
enum ivec2 TILE_SIZE_IVEC = ivec2(TILE_SIZE, TILE_SIZE);

struct Tilemap(int w, int h)
{
	int width = w;
	int height = h;
	Tile[h][w] tiles;
}

void drawTileMap(Tilemap : Tilemap)(
	ref RenderQueue renderQueue,
	ref Tilemap tilemap,
	ref Camera camera,
	SpriteRef[] spriteSheet)
{
	vec2 tileScale = vec2(1,1)/TILE_SIZE_VEC;
	foreach (x, column; tilemap.tiles)
	{
		foreach (y, tile; column)
		{
			auto sprite = *(spriteSheet[tile.type]);
			renderQueue.drawSpriteCamera(sprite, tileScale, vec2(0,0), 0, camera, vec2(x, y), 0);
		}
	}
}
