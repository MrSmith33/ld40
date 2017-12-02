module tilemap;

import voxelman.graphics;
import voxelman.math;

/// Tile texture array
enum Tile : ubyte
{
	square,
	circle
}

enum TILE_SIZE = 16;
enum ivec2 TILE_SIZE_VEC = ivec2(TILE_SIZE, TILE_SIZE);

struct AABBRectangle
{
	ivec2 position, size;

	ivec2 center() const @property
	{
		return position + size / 2;
	}

	ivec2 end() const @property
	{
		return position + size;
	}

	bool collides(ivec2 point) const
	{
		return point.x >= position.x && point.x < end.x && point.y >= position.y && point.y < end.y;
	}

	bool collides(AABBRectangle other) const
	{
		return other.collides(position) || other.collides(position + ivec2(size.x,
				0)) || other.collides(end) || other.collides(position + ivec2(0, size.y));
	}
}

struct Tilemap(int width, int height)
{
	/// Tile textures
	Tile[width][height] tiles;
	AABBRectangle[] colliders;
}

void drawTileMap(Tilemap : Tilemap)(ref RenderQueue renderQueue, ref Tilemap tilemap, SpriteRef[] spriteSheet)
{
	foreach (x, column; tilemap.tiles)
	{
		foreach (y, tile; column)
		{
			renderQueue.draw(*(spriteSheet[tile]), vec2(ivec2(x, y) * TILE_SIZE_VEC), 0);
		}
	}
}
