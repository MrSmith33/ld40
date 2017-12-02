module entity;

import voxelman.text.linebuffer;
import graphics;
import math;
import tilemap;
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
				*sprite, transform.rotation,
				camera, transform.position, ENTITY_DEPTH);
			debugText.putfln("draw sprite %s", id);
		}

		foreach(id, transform, animation; entities.query!(EntityTransform, EntityAnimation))
		{
			animation.update(deltaTime);
			auto sprite = animation.currentFrameSprite;
			renderQueue.drawSpriteCamera(
				sprite, transform.rotation,
				camera, transform.position, ENTITY_DEPTH);
			debugText.putfln("draw animation %s", id);
		}
	}

	vec2 moveEntity(vec2 pos, vec2 size, vec2 delta, scope bool delegate(ivec2) isTileSolid)
	{
		float distance = delta.length;
		int num_steps = cast(int)ceil(distance * 2); // num cells moved
		if (num_steps == 0) return pos;

		vec2 moveStep = delta / num_steps;

		foreach(i; 0..num_steps) {
			pos += moveStep;
			collide(pos, moveStep, size, isTileSolid);
		}

		return pos;
	}

	void collide(ref vec2 point, ref vec2 moveStep, vec2 size, scope bool delegate(ivec2) isTileSolid)
	{
		ivec2 cell = ivec2(floor(point.x), floor(point.y));
		Aabb2d body_aabb = Aabb2d(point, size);

		foreach(dx; [0, -1, 1])
		{
		foreach(dy; [0, -1, 1])
		{
			ivec2 local_cell = cell + ivec2(dx, dy);
			if (isTileSolid(local_cell))
			{
				Aabb2d cell_aabb = Aabb2d(vec2(local_cell)+0.5f, vec2(1, 1));
				bool collides = cell_aabb.collides(body_aabb);
				if (collides)
				{
					vec2 vector = cell_aabb.intersectionSize(body_aabb);
					if (vector.x < vector.y) {
						int dir = cell_aabb.center.x < body_aabb.center.x ? 1 : -1;
						body_aabb.center.x += vector.x * dir;
						moveStep.x = 0;
					} else {
						int dir = cell_aabb.center.y < body_aabb.center.y ? 1 : -1;
						body_aabb.center.y += vector.y * dir;
						moveStep.y = 0;
					}
				}
				
			}
		}
		}

		point.x = body_aabb.center.x;
		point.y = body_aabb.center.y;
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
	alias spriteInst this;
}

@Component("ld40.EntityAnimation", Replication.none)
struct EntityAnimation
{
	AnimationInstance anim;
	alias anim this;
}