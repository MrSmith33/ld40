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
	SpriteRef[string] sprites;
	Sprite square;
	Sprite circle;
	Tilemap!(32, 32) tilemap;

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

		sprites = renderQueue.resourceManager.loadNamedSpriteSheet("tex/sprites",
			renderQueue.resourceManager.texAtlas, TILE_SIZE_VEC);

		square = *sprites["square"];
		circle = *sprites["circle"];
		renderQueue.reuploadTexture();

		tilemap.tiles[4][2] = Tile.circle;
	}

	override void userPreUpdate(double delta)
	{
		debugText.putfln("FPS: %.1f", fpsHelper.fps);
		debugText.putfln("Delta: %ss", scaledNumberFmt(fpsHelper.updateTime));
	}

	override void userPostUpdate(double delta)
	{
		ivec2 squareGridPos = ivec2(4, 4);

		renderQueue.drawTileMap(tilemap, null);
	}

	void onKey(KeyCode key, uint modifiers)
	{
		     if (key == KeyCode.KEY_W){}
		else if (key == KeyCode.KEY_A){}
		else if (key == KeyCode.KEY_S){}
		else if (key == KeyCode.KEY_D){}
	}
}
