module math;

public import voxelman.math;

struct AABBRectangle
{
	ivec2 position, size;

	ivec2 center() const @property
	{
		return position + size / 2;
	}

	ivec2 end() const @property
	{
		return position + size;
	}

	bool collides(ivec2 point) const
	{
		return point.x >= position.x && point.x < end.x && point.y >= position.y && point.y < end.y;
	}

	bool collides(AABBRectangle other) const
	{
		return other.collides(position) || other.collides(position + ivec2(size.x,
				0)) || other.collides(end) || other.collides(position + ivec2(0, size.y));
	}
}