#ifndef RENDERER_D3D11_SHADERS_CONSTANT_BUFFERS_HPP
#define RENDERER_D3D11_SHADERS_CONSTANT_BUFFERS_HPP

#include <glm/glm.hpp>

namespace renderer {
	struct global_buffer {
		alignas(16) glm::vec2 dimensions;
	};

	struct command_buffer {
		alignas(4) bool scissor_enable;
		alignas(16) glm::vec4 scissor_bounds;
		alignas(4) bool scissor_in;
		alignas(4) bool scissor_circle;
		alignas(4) bool key_enable;
		alignas(16) glm::vec4 key_color;
		alignas(4) float blur_strength;
		alignas(4) bool is_texture;
		alignas(4) bool is_mask;
	};
}// namespace renderer

#endif