module main;

import voxelman.graphics;
import voxelman.gui;
import voxelman.log;
import voxelman.math;
import voxelman.text.scale;

void main(string[] args)
{
	import std.stdio : stdout;
	auto conciseLogger = new ConciseLogger(stdout);
	conciseLogger.logLevel = LogLevel.info;
	sharedLog = conciseLogger;

	auto app = new App("LD40", ivec2(800, 600));
	app.run(args);
}

enum TILE_SIZE = 16;
enum ivec2 TILE_SIZE_VEC = ivec2(TILE_SIZE, TILE_SIZE);

class App : GuiApp
{
	vec2 playerPos = vec2(100, 100);
	SpriteRef[string] sprites;
	Sprite square;
	Sprite circle;

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

		sprites = renderQueue.resourceManager.loadNamedSpriteSheet("sprites",
			renderQueue.resourceManager.texAtlas, TILE_SIZE_VEC);

		square = *sprites["square"];
		circle = *sprites["circle"];
		renderQueue.reuploadTexture();
	}

	override void userPreUpdate(double delta)
	{
		debugText.putfln("FPS: %.1f", fpsHelper.fps);
		debugText.putfln("Delta: %ss", scaledNumberFmt(fpsHelper.updateTime));
	}

	override void userPostUpdate(double delta)
	{
		ivec2 squareGridPos = ivec2(4, 4);

		renderQueue.draw(square, vec2(squareGridPos * TILE_SIZE_VEC), 10000);
		auto bitmap = renderQueue.resourceManager.texAtlas.bitmap;
	}

	void onKey(KeyCode key, uint modifiers)
	{
		     if (key == KeyCode.KEY_W){}
		else if (key == KeyCode.KEY_A){}
		else if (key == KeyCode.KEY_S){}
		else if (key == KeyCode.KEY_D){}
	}
}
