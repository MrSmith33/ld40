module entity;

import voxelman.text.linebuffer;
import graphics;
import math;
import datadriven;

class GameContext
{
	EntityIdManager entityIds;
	EntityManager entities;
	LineBuffer* debugText;

	this(LineBuffer* debugText)
	{
		this.debugText = debugText;
		entities.eidMan = &entityIds;
		registerComponents(entities);
	}

	EntityProxy createEntity(Components...)(Components components)
		if (components.length > 0)
	{
		auto eid = entityIds.nextEntityId();
		entities.set(eid, components);
		return EntityProxy(eid, this);
	}

	void drawEntities(
		ref RenderQueue renderQueue,
		ref Camera camera,
		float deltaTime)
	{
		foreach(id, transform, sprite; entities.query!(EntityTransform, EntitySprite))
		{
			renderQueue.drawSpriteCamera(
				sprite.spriteInst, transform.rotation,
				camera, transform.position, ENTITY_DEPTH);
			debugText.putfln("draw sprite %s", id);
		}

		foreach(id, transform, animation; entities.query!(EntityTransform, EntityAnimation))
		{
			// update and draw animation
		}
	}
}

struct EntityProxy
{
	EntityId eid;
	GameContext ctx;

	alias eid this;

	EntityProxy set(Components...)(Components components) { ctx.entities.set(eid, components); return this; }
	C* get(C)() { return ctx.entities.get!C(eid); }
	C* getOrCreate(C)(C defVal = C.init) { return ctx.entities.getOrCreate!C(eid, defVal); }
	bool has(C)() { return ctx.entities.has!C(eid); }
}


void registerComponents(ref EntityManager entities)
{
	entities.registerComponent!EntityTransform;
	entities.registerComponent!EntitySprite;
	entities.registerComponent!EntityAnimation;
	entities.registerComponent!EntityCameraTarget;
	entities.registerComponent!EntityMovementTarget;
}

@Component("ld40.EntityCameraTarget", Replication.none)
struct EntityCameraTarget {}

@Component("ld40.EntityMovementTarget", Replication.none)
struct EntityMovementTarget {}

@Component("ld40.EntityTransform", Replication.none)
struct EntityTransform
{
	vec2 position = vec2(0, 0);
	vec2 size = vec2(0, 0);
	float rotation;

	Aabb2d aabb() const { return Aabb2d(position, size); }
}

@Component("ld40.EntitySprite", Replication.none)
struct EntitySprite
{
	SpriteInstance spriteInst;
}

@Component("ld40.EntityAnimation", Replication.none)
struct EntityAnimation
{
	AnimationInstance anim;
}