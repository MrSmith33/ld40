module main;

import voxelman.graphics;
import voxelman.gui;
import voxelman.log;
import voxelman.math;
import voxelman.text.scale;

import tilemap;

void main(string[] args)
{
	import std.stdio : stdout;
	auto conciseLogger = new ConciseLogger(stdout);
	conciseLogger.logLevel = LogLevel.info;
	sharedLog = conciseLogger;

	auto app = new App("LD40", ivec2(800, 600));
	app.run(args);
}

class App : GuiApp
{
	vec2 playerPos = vec2(100, 100);
	SpriteRef[] sprites;
	Sprite square;
	Sprite circle;
	Tilemap!(32, 32) tilemap;
	Camera camera;
	float speed = 100;

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

		sprites = renderQueue.resourceManager.loadIndexedSpriteSheet("tex/sprites",
			renderQueue.resourceManager.texAtlas, TILE_SIZE_VEC);

		renderQueue.reuploadTexture();

		tilemap.tiles[4][2] = Tile.circle;
		camera.cameraSize = windowSize;
	}

	override void userPreUpdate(double delta)
	{
		if (window.isKeyPressed(KeyCode.KEY_W)) { camera.position += vec2( 0, -1) * delta * speed; }
		if (window.isKeyPressed(KeyCode.KEY_A)) { camera.position += vec2(-1,  0) * delta * speed; }
		if (window.isKeyPressed(KeyCode.KEY_S)) { camera.position += vec2( 0,  1) * delta * speed; }
		if (window.isKeyPressed(KeyCode.KEY_D)) { camera.position += vec2( 1,  0) * delta * speed; }

		debugText.putfln("FPS: %.1f", fpsHelper.fps);
		debugText.putfln("Delta: %ss", scaledNumberFmt(fpsHelper.updateTime));
	}

	override void userPostUpdate(double delta)
	{
		renderQueue.drawTileMap(tilemap, camera, sprites);
	}

	void onKey(KeyCode key, uint modifiers)
	{
		if (key == KeyCode.KEY_Q){ camera.zoom += 1; }
		else if (key == KeyCode.KEY_E){ camera.zoom = max(camera.zoom - 1, 1); }
	}
}
