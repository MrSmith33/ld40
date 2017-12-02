module graphics;

public import voxelman.graphics;
import math;

struct Camera
{
	float zoom = 2;
	vec2 position = vec2(0,0);
	vec2 cameraSize = vec2(0,0);
}

void drawSpriteCamera(
	ref RenderQueue renderQueue,
	Sprite sprite,
	ref Camera camera,
	vec2 target,
	float depth,
	Color4ub color = Colors.white)
{
	vec2 size = vec2(sprite.atlasRect.size) * camera.zoom;
	vec2 pos = (target - camera.position) * camera.zoom + camera.cameraSize/2;

	renderQueue.texBatch.putRect(
		frect(pos, size),
		frect(sprite.atlasRect),
		depth,
		color,
		renderQueue.atlasTexture);
}