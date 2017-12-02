module main;

import voxelman.gui;
import voxelman.log;
import voxelman.text.scale;

import datadriven;
import graphics;
import math;
import tilemap;
import entity;

void main(string[] args)
{
	import std.stdio : stdout;
	auto conciseLogger = new ConciseLogger(stdout);
	conciseLogger.logLevel = LogLevel.info;
	sharedLog = conciseLogger;

	auto app = new Game("LD40", ivec2(800, 600));
	app.run(args);
}

class Game : GuiApp
{
	SpriteRef[] sprites;
	SpriteSheetAnimationRef playerAnim;
	
	Tilemap!(32, 32) tilemap;
	Camera camera;
	EntityProxy player;
	float speed = 10;

	GameContext ctx;

	this(string title, ivec2 windowSize)
	{
		super(title, windowSize);
		maxFps = 120;
	}

	override void load(string[] args, string resourcePath)
	{
		super.load(args, "./res");

		showDebugInfo = true;
		window.keyPressed.connect(&onKey);

		sprites = renderQueue.resourceManager.loadIndexedSpriteSheet("tex/sprites", TILE_SIZE_IVEC);

		playerAnim = renderQueue.resourceManager.loadAnimation("tex/player");

		renderQueue.reuploadTexture();
		camera.cameraSize = windowSize;
		camera.zoom = 32;

		ctx = new GameContext(&debugText);
		setupLevel();
	}

	void setupLevel()
	{
		ctx.entities.removeAll();

		tilemap.tiles[4][2] = Tile(TileType.circle, true);
		tilemap.tiles[6][2] = Tile(TileType.circle, true);

		auto firstFrame = &playerAnim.frames[0].sprite;
		auto spriteSize = vec2(firstFrame.atlasRect.size);
		auto playerSprite = SpriteInstance(
			firstFrame,
			vec2(1,1) / TILE_SIZE_VEC,
			spriteSize*0.5f);

		player = ctx.createEntity(
			EntityTransform(vec2(4, 4), vec2(14, 14) / TILE_SIZE_VEC),
			EntityCameraTarget(),
			EntityMovementTarget(),
			EntitySprite(playerSprite));
	}

	bool isTileSolid(ivec2 pos)
	{
		if (pos.x >= 0 && pos.x < tilemap.width && pos.y >= 0 && pos.y < tilemap.height)
			return tilemap.tiles[pos.x][pos.y].isSolid;
		else return true;
	}

	override void userPreUpdate(double delta)
	{
		vec2 moveVec = vec2(0, 0);
		if (window.isKeyPressed(KeyCode.KEY_W)) { moveVec.y = -1; }
		if (window.isKeyPressed(KeyCode.KEY_A)) { moveVec.x = -1; }
		if (window.isKeyPressed(KeyCode.KEY_S)) { moveVec.y =  1; }
		if (window.isKeyPressed(KeyCode.KEY_D)) { moveVec.x =  1; }

		foreach(eid, transform; ctx.entities.query!(EntityTransform, EntityMovementTarget))
		{
			vec2 deltaPos = moveVec.normalized * delta * speed;
			transform.position = ctx.moveEntity(transform.position, transform.size, deltaPos, &isTileSolid);
			debugText.putfln("eid: %s pos %s", eid, transform.position);
		}

		debugText.putfln("FPS: %.1f", fpsHelper.fps);
		debugText.putfln("Delta: %ss", scaledNumberFmt(fpsHelper.updateTime));
	}

	override void userPostUpdate(double delta)
	{
		foreach(eid, transform; ctx.entities.query!(EntityTransform, EntityCameraTarget))
		{
			camera.position = transform.position;
		}
		
		renderQueue.drawTileMap(tilemap, camera, sprites);
		ctx.drawEntities(renderQueue, camera, delta);
	}

	void onKey(KeyCode key, uint modifiers)
	{
		if (key == KeyCode.KEY_Q){ camera.zoom *= 2; }
		else if (key == KeyCode.KEY_E){ camera.zoom = max(camera.zoom / 2, 1); }
	}
}
