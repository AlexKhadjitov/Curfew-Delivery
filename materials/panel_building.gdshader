shader_type spatial;

uniform float x_panels;
uniform float y_panels;
uniform float texture_x_variations;
uniform float texture_y_variations;

uniform sampler2D wall_texture: filter_nearest;
uniform sampler2D rand: filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO.rgb = vec3(0,0,0);
	
	vec2 panel_coord = UV;
	panel_coord.x *= x_panels;
	panel_coord.y *= y_panels;
	panel_coord = floor(panel_coord);
	
	//ALBEDO.rg = panel_coord;
	if(panel_coord.x >= 0.){
		vec2 uv = UV;
		uv.x *= x_panels;
		uv.y *= y_panels;
		uv.x /= texture_x_variations;
		//uv.x += 0.5;
		uv.y /= texture_y_variations;
	
		//randomize vertical
		/*vec2 rand_coord = panel_coord;
		rand_coord.x /= x_panels;
		rand_coord.y /= y_panels;
		uv.y += ceil(texture(rand, panel_coord/7.).r*100.) * 1./texture_y_variations;*/
		
		ALBEDO.rgb = texture(wall_texture, uv).rgb;
	}
}

void light() {
	// Called for every pixel for every light affecting the material.
}
