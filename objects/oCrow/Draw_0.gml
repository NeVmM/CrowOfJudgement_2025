draw_sprite_ext( sprite_index, image_index, x, y, image_xscale*face, image_yscale, image_angle, image_blend, image_alpha )

if (flash > 0)
{
	flash--;
	shader_set(shWhite);
	draw_self();
	shader_reset();
}