module math;

public import voxelman.math;

struct Aabb2d
{
	vec2 position, size;

	vec2 center() const @property
	{
		return position + size * 0.5f;
	}

	vec2 end() const @property
	{
		return position + size;
	}

	bool collides(Aabb2d other) const
	{
		vec2 delta = (other.center - center).abs;
		vec2 min_distance = (size + other.size) * 0.5f;
		return delta.x < min_distance.x && delta.y < min_distance.y;
	}

	bool collides(ivec2 point) const
	{
		return point.x >= position.x && point.x < end.x && point.y >= position.y && point.y < end.y;
	}
}