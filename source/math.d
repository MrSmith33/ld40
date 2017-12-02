module math;

public import voxelman.math;

struct Aabb2d
{
	vec2 center, size;

	vec2 start() const @property
	{
		return center - size * 0.5f;
	}

	vec2 end() const @property
	{
		return center + size * 0.5f;
	}

	bool collides(Aabb2d other) const
	{
		vec2 delta = (other.center - center).abs;
		vec2 min_distance = (size + other.size) * 0.5f;
		return delta.x < min_distance.x && delta.y < min_distance.y;
	}

	bool collides(ivec2 point) const
	{
		return point.x >= start.x && point.x < end.x && point.y >= start.y && point.y < end.y;
	}

	vec2 intersectionSize(Aabb2d other)
	{
		vec2 endPos = end;
		vec2 o_endPos = other.end;

		vec2 p_min = vector_max(start, other.start);
		vec2 p_max = vector_min(endPos, o_endPos);

		return p_max - p_min;
	}
}