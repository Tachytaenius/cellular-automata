vec4 boolToColour(bool x) {
	if (x) {
		return vec4(1.0);
	}
	return vec4(vec3(0.0), 1.0);
}

bool colourToBool(vec4 x) {
	return x.r > 0.5;
}

bool get(sampler2D image, vec2 windowCoords, int x, int y) {
	return colourToBool(Texel(image,
		(windowCoords + vec2(float(x), float(y))) / love_ScreenSize.xy
	));
}

vec4 effect(vec4 colour, sampler2D image, vec2 textureCoords, vec2 windowCoords) {
	bool centre = get(image, windowCoords, 0, 0);
	bool right = get(image, windowCoords, 1, 0);
	bool rightDown = get(image, windowCoords, 1, 1);
	bool down = get(image, windowCoords, 0, 1);
	bool leftDown = get(image, windowCoords, -1, 1);
	bool left = get(image, windowCoords, -1, 0);
	bool leftUp = get(image, windowCoords, -1, -1);
	bool up = get(image, windowCoords, 0, -1);
	bool rightUp = get(image, windowCoords, 1, -1);
	
	bool current = centre;

	current = current != right;
	current = current != down;
	current = current != left;
	current = current != up;

	// current = current != rightDown;
	// current = current != leftDown;
	// current = current != leftUp;
	// current = current != rightUp;

	return boolToColour(current);
}
