module graphics;

public import voxelman.graphics;
import math;

enum float TILE_DEPTH = 0;
enum float ENTITY_DEPTH = 100;

struct Camera
{
	float zoom = 2;
	vec2 position = vec2(0,0);
	vec2 cameraSize = vec2(0,0);
}

void drawSpriteCamera(
	ref RenderQueue renderQueue, Sprite sprite, float rotation,
	ref Camera camera, vec2 target, float depth, Color4ub color = Colors.white)
{
	drawSpriteCamera(
		renderQueue, sprite, vec2(1, 1), vec2(0, 0), rotation,
		camera, target, depth, color);
}

void drawSpriteCamera(
	ref RenderQueue renderQueue,
	SpriteInstance spriteInstance,
	float rotation,
	ref Camera camera,
	vec2 target,
	float depth,
	Color4ub color = Colors.white)
{
	drawSpriteCamera(
		renderQueue, *spriteInstance.sprite, spriteInstance.scale,
		spriteInstance.origin, rotation, camera, target, depth, color);
}

void drawSpriteCamera(
	ref RenderQueue renderQueue,
	Sprite sprite,
	vec2 spriteScale,
	vec2 spriteOrigin,
	float rotation,
	ref Camera camera,
	vec2 target,
	float depth,
	Color4ub color = Colors.white)
{
	vec2 size = vec2(sprite.atlasRect.size) * spriteScale * camera.zoom;
	vec2 pos = (target - spriteOrigin * spriteScale - camera.position) * camera.zoom + camera.cameraSize/2;

	renderQueue.texBatch.putRect(
		frect(pos, size),
		frect(sprite.atlasRect),
		depth,
		color,
		renderQueue.atlasTexture);
}