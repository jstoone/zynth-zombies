// NOTE: Shader automatically converted from Godot Engine 4.0.alpha15's ParticleProcessMaterial.

shader_type particles;
uniform vec3 direction;
uniform float spread;
uniform float flatness;
uniform float initial_linear_velocity_min;
uniform float initial_angle_min;
uniform float angular_velocity_min;
uniform float orbit_velocity_min;
uniform float linear_accel_min;
uniform float radial_accel_min;
uniform float tangent_accel_min;
uniform float damping_min;
uniform float scale_min;
uniform float hue_variation_min;
uniform float anim_speed_min;
uniform float anim_offset_min;
uniform float initial_linear_velocity_max;
uniform float initial_angle_max;
uniform float angular_velocity_max;
uniform float orbit_velocity_max;
uniform float linear_accel_max;
uniform float radial_accel_max;
uniform float tangent_accel_max;
uniform float damping_max;
uniform float scale_max;
uniform float hue_variation_max;
uniform float anim_speed_max;
uniform float anim_offset_max;
uniform float lifetime_randomness;
uniform vec3 emission_box_extents;
uniform vec4 color_value : source_color;
uniform vec3 gravity;
uniform float turbulence_noise_strength;
uniform float turbulence_noise_scale;
uniform float turbulence_influence_min;
uniform float turbulence_influence_max;
uniform float turbulence_initial_displacement_min;
uniform float turbulence_initial_displacement_max;
uniform float turbulence_noise_speed_random;
uniform vec3 turbulence_noise_speed = vec3(1.0, 1.0, 1.0);
uniform sampler2D sprite;


// 3D Noise with friendly permission by Inigo Quilez
vec3 hash_noise( vec3 p ) {
	p *= mat3(vec3(127.1, 311.7, -53.7), vec3(269.5, 183.3, 77.1), vec3(-301.7, 27.3, 215.3));
	return 2.0 * fract(fract(p)*4375.55) -1.;
}

float noise( vec3 p) {
	vec3 i = floor(p);;
	vec3 f = fract(p);
 	vec3 u = f * f * (3.0 - 2.0 * f);

	return 2.0*mix( mix( mix( dot( hash_noise( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), dot( hash_noise( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
			mix( dot( hash_noise( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), dot( hash_noise( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
		mix( mix( dot( hash_noise( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), dot( hash_noise( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
			mix( dot( hash_noise( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), dot( hash_noise( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z);
}

// Curl 3D and noise_3d function with friendly permission by Isaac Cohen
vec3 noise_3d(vec3 p) {
	float s = noise(p);
	float s1 = noise(vec3(p.y - 19.1, p.z + 33.4, p.x + 47.2));
   float s2 = noise(vec3(p.z + 74.2, p.x - 124.5, p.y + 99.4));
	vec3 c = vec3(s, s1, s2);
	return c;
}

vec3 curl_3d(vec3 p, float c) {
	float epsilon = 0.001 + c;
	vec3 dx = vec3(epsilon, 0.0, 0.0);
	vec3 dy = vec3(0.0, epsilon, 0.0);
	vec3 dz = vec3(0.0, 0.0, epsilon);
	vec3 x0 = noise_3d(p - dx).xyz;
	vec3 x1 = noise_3d(p + dx).xyz;
	vec3 y0 = noise_3d(p - dy).xyz;
	vec3 y1 = noise_3d(p + dy).xyz;
	vec3 z0 = noise_3d(p - dz).xyz;
	vec3 z1 = noise_3d(p + dz).xyz;
	float x = y1.z - y0.z - z1.y + z0.y;
	float y = z1.x - z0.x - x1.z + x0.z;
	float z = x1.y - x0.y - y1.x + y0.x;
	float divisor = 1.0 / (2.0 * epsilon);
	return vec3(normalize(vec3(x, y, z) * divisor));
}
vec3 get_noise_direction(vec3 pos, vec3 emission_pos, vec3 time_noise) {
	float adj_contrast = max((turbulence_noise_strength - 1.0), 0.0) * 70.0;
	vec3 noise_time = (vec3(TIME) * turbulence_noise_speed) + time_noise;
	vec3 noise_pos = (pos * turbulence_noise_scale) - emission_pos;
	vec3 diff = pos - emission_pos;
	vec3 noise_direction = curl_3d(noise_pos + noise_time - diff, adj_contrast);
	noise_direction = mix(0.9 * noise_direction, noise_direction, turbulence_noise_strength - 9.0);
	return noise_direction;
}


float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

float rand_from_seed_m1_p1(inout uint seed) {
	return rand_from_seed(seed) * 2.0 - 1.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

void start() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float angle_rand = rand_from_seed(alt_seed);
	float scale_rand = rand_from_seed(alt_seed);
	float hue_rot_rand = rand_from_seed(alt_seed);
	float anim_offset_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	float tex_angle = 0.0;
	float tex_anim_offset = 1.0;
	float spread_rad = spread * degree_to_rad;
	if (RESTART_VELOCITY) {
		float tex_linear_velocity = 1.0;
		{
			float angle1_rad = rand_from_seed_m1_p1(alt_seed) * spread_rad;
			angle1_rad += direction.x != 0.0 ? atan(direction.y, direction.x) : sign(direction.y) * (pi / 2.0);
			vec3 rot = vec3(cos(angle1_rad), sin(angle1_rad), 0.0);
			VELOCITY = rot * mix(initial_linear_velocity_min,initial_linear_velocity_max, rand_from_seed(alt_seed));
		}
	}
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, angle_rand);
	CUSTOM.x = base_angle * degree_to_rad;
	CUSTOM.y = 0.0;
	CUSTOM.w = (1.0 - lifetime_randomness * rand_from_seed(alt_seed));
	CUSTOM.z = (tex_anim_offset) * mix(anim_offset_min, anim_offset_max, anim_offset_rand);
	if (RESTART_POSITION) {
		TRANSFORM[3].xyz = vec3(rand_from_seed(alt_seed) * 2.0 - 1.0, rand_from_seed(alt_seed) * 2.0 - 1.0, rand_from_seed(alt_seed) * 2.0 - 1.0) * emission_box_extents;
	if (RESTART_VELOCITY) VELOCITY = (EMISSION_TRANSFORM * vec4(VELOCITY, 0.0)).xyz;
	vec3 time_noise = noise_3d( vec3(TIME) * turbulence_noise_speed_random ) * -turbulence_noise_speed;
	vec3 noise_direction = get_noise_direction(TRANSFORM[3].xyz, EMISSION_TRANSFORM[3].xyz, time_noise);
	float turb_init_displacement = mix(turbulence_initial_displacement_min, turbulence_initial_displacement_max, rand_from_seed(alt_seed));	TRANSFORM[3].xyz += noise_direction * turb_init_displacement;
	TRANSFORM = EMISSION_TRANSFORM * TRANSFORM;
	VELOCITY.z = 0.0;
	TRANSFORM[3].z = 0.0;
	}
    
    vec2 positionOffset = vec2(8.0, 16.0);
    // add position offset to center the sprite at (0,0)
    vec2 particlePosition = TRANSFORM[3].xy + positionOffset;
    vec2 textureS = vec2(textureSize(sprite, 0));
    vec4 spriteColor = texture(sprite, particlePosition / textureS);
    COLOR = spriteColor * color_value;
    
    if (spriteColor.a == 0.0) {
        ACTIVE = false;
    }
}

void process() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float angle_rand = rand_from_seed(alt_seed);
	float scale_rand = rand_from_seed(alt_seed);
	float hue_rot_rand = rand_from_seed(alt_seed);
	float anim_offset_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	CUSTOM.y += DELTA / LIFETIME;
	float tv = CUSTOM.y / CUSTOM.w;
	float tex_linear_velocity = 1.0;
	float tex_orbit_velocity = 1.0;
	float tex_angular_velocity = 1.0;
	float tex_linear_accel = 1.0;
	float tex_radial_accel = 1.0;
	float tex_tangent_accel = 1.0;
	float tex_damping = 1.0;
	float tex_angle = 1.0;
	float tex_anim_speed = 1.0;
	float tex_anim_offset = 1.0;
	vec3 force = gravity;
	vec3 pos = TRANSFORM[3].xyz;
	pos.z = 0.0;
	// apply linear acceleration
	force += length(VELOCITY) > 0.0 ? normalize(VELOCITY) * tex_linear_accel * mix(linear_accel_min, linear_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply radial acceleration
	vec3 org = EMISSION_TRANSFORM[3].xyz;
	vec3 diff = pos - org;
	force += length(diff) > 0.0 ? normalize(diff) * tex_radial_accel * mix(radial_accel_min, radial_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply tangential acceleration;
	float tangent_accel_val = tex_tangent_accel * mix(tangent_accel_min, tangent_accel_max, rand_from_seed(alt_seed));
	force += length(diff.yx) > 0.0 ? vec3(normalize(diff.yx * vec2(-1.0, 1.0)), 0.0) * tangent_accel_val : vec3(0.0);
	force += ATTRACTOR_FORCE;

	// apply attractor forces
	VELOCITY += force * DELTA;
	// apply turbulence
	const float turbulence_influence = 1.0;
	
	vec3 time_noise = noise_3d( vec3(TIME) * turbulence_noise_speed_random ) * -turbulence_noise_speed;
	vec3 noise_direction = get_noise_direction(TRANSFORM[3].xyz, EMISSION_TRANSFORM[3].xyz, time_noise);
	if (!COLLIDED) {
		
		float vel_mag = length(VELOCITY);
		float vel_infl = clamp(mix(turbulence_influence_min, turbulence_influence_max, rand_from_seed(alt_seed)) * turbulence_influence, 0.0, 1.0);
		VELOCITY = mix(VELOCITY, normalize(noise_direction) * vel_mag * (1.0 + (1.0 - vel_infl) * 0.2), vel_infl);
	}	
	// orbit velocity
	float orbit_amount = tex_orbit_velocity * mix(orbit_velocity_min, orbit_velocity_max, rand_from_seed(alt_seed));
	if (orbit_amount != 0.0) {
	     float ang = orbit_amount * DELTA * pi * 2.0;
	     mat2 rot = mat2(vec2(cos(ang), -sin(ang)), vec2(sin(ang), cos(ang)));
	     TRANSFORM[3].xy -= diff.xy;
	     TRANSFORM[3].xy += rot * diff.xy;
	}
	float dmp = mix(damping_min, damping_max, rand_from_seed(alt_seed));
	if (dmp * tex_damping > 0.0) {
		float v = length(VELOCITY);
		float damp = tex_damping * dmp;
		v -= damp * DELTA;
		if (v < 0.0) {
			VELOCITY = vec3(0.0);
		} else {
			VELOCITY = normalize(VELOCITY) * v;
		}
	}
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, rand_from_seed(alt_seed));
	base_angle += CUSTOM.y * LIFETIME * (tex_angular_velocity) * mix(angular_velocity_min,angular_velocity_max, rand_from_seed(alt_seed));
	CUSTOM.x = base_angle * degree_to_rad;
	CUSTOM.z = (tex_anim_offset) * mix(anim_offset_min, anim_offset_max, rand_from_seed(alt_seed)) + tv * tex_anim_speed * mix(anim_speed_min, anim_speed_max, rand_from_seed(alt_seed));
	vec3 tex_scale = vec3(1.0);
	float tex_hue_variation = 1.0;
//	float hue_rot_angle = (tex_hue_variation) * pi * 2.0 * mix(hue_variation_min, hue_variation_max, rand_from_seed(alt_seed));
//	float hue_rot_c = cos(hue_rot_angle);
//	float hue_rot_s = sin(hue_rot_angle);
//	mat4 hue_rot_mat = mat4(vec4(0.299, 0.587, 0.114, 0.0),
//			vec4(0.299, 0.587, 0.114, 0.0),
//			vec4(0.299, 0.587, 0.114, 0.0),
//			vec4(0.000, 0.000, 0.000, 1.0)) +
//		mat4(vec4(0.701, -0.587, -0.114, 0.0),
//			vec4(-0.299, 0.413, -0.114, 0.0),
//			vec4(-0.300, -0.588, 0.886, 0.0),
//			vec4(0.000, 0.000, 0.000, 0.0)) * hue_rot_c +
//		mat4(vec4(0.168, 0.330, -0.497, 0.0),
//			vec4(-0.328, 0.035,  0.292, 0.0),
//			vec4(1.250, -1.050, -0.203, 0.0),
//			vec4(0.000, 0.000, 0.000, 0.0)) * hue_rot_s;
//	COLOR = hue_rot_mat * color_value;

    if (COLOR.a > 0.0) {
        COLOR.a -= 2.0 / LIFETIME * DELTA;
    }

	TRANSFORM[0] = vec4(cos(CUSTOM.x), -sin(CUSTOM.x), 0.0, 0.0);
	TRANSFORM[1] = vec4(sin(CUSTOM.x), cos(CUSTOM.x), 0.0, 0.0);
	TRANSFORM[2] = vec4(0.0, 0.0, 1.0, 0.0);
	TRANSFORM[3].z = 0.0;
	float base_scale = mix(scale_min, scale_max, scale_rand);
	base_scale = sign(base_scale) * max(abs(base_scale), 0.001);
	TRANSFORM[0].xyz *= base_scale * sign(tex_scale.r) * max(abs(tex_scale.r), 0.001);
	TRANSFORM[1].xyz *= base_scale * sign(tex_scale.g) * max(abs(tex_scale.g), 0.001);
	TRANSFORM[2].xyz *= base_scale * sign(tex_scale.b) * max(abs(tex_scale.b), 0.001);
	if (CUSTOM.y > CUSTOM.w) {
		ACTIVE = false;
	}
}

