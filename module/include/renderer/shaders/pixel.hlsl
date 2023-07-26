#include "rgb2hsv.hlsl"
#include "types.hlsl"

cbuffer command : register(b0) {
	bool scissor_enable;
	float4 scissor_bounds;
	bool scissor_in;
	bool scissor_circle;
	bool key_enable;
	float4 key_color;
	float blur_strength;
	bool is_texture;
	bool is_mask;
}

Texture2D active_texture : TEXTURE : register(t0);
SamplerState samplerState : SAMPLER : register(s0);

// How can I stack color keys?
float4 ps_main(VS_Output input) : SV_TARGET {
	if (key_enable) {
		if (input.color.x == key_color.x && input.color.y == key_color.y && input.color.z == key_color.z) {
			return float4(0.0f, 0.0f, 0.0f, 0.0f);
		}
	}

	if (scissor_enable) {
		bool inside = true;

		if (input.position.x < scissor_bounds.x || input.position.y < scissor_bounds.y ||
			input.position.x > scissor_bounds.x + scissor_bounds.z ||
			input.position.y > scissor_bounds.y + scissor_bounds.w) {
			inside = false;
		}

		if (scissor_in) {
			if (inside) {
				return float4(0.0f, 0.0f, 0.0f, 0.0f);
			}
		}
		else if (!inside) {
			return float4(0.0f, 0.0f, 0.0f, 0.0f);
		}
	}

	if (is_texture) {
		float4 sampled = active_texture.Sample(samplerState, input.uv);

		if (is_mask) {
			// Set sampled hue to be input hue
			/*float3 hsl = RGBtoHSL(sampled.xyz);
			hsl.x = RGBtoHSL(input.color.xyz).x;

			float3 rgb = HSLtoRGB(hsl);
			return float4(rgb.xyz, sampled.w * input.color.w);*/

			return float4(input.color.xyz, sampled.w * input.color.w);
		}

		return sampled;
	}

	return input.color;
}