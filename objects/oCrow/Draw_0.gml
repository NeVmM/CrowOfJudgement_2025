draw_sprite_ext( sprite_index, image_index, x, y, image_xscale*face, image_yscale, image_angle, image_blend, image_alpha )

if (flash > 0)
{
	flash--;
	shader_set(shWhite);
	var prev_scale = image_xscale;
	image_xscale = face; // Flip sprite based on direction
	draw_self();
	image_xscale = prev_scale; // Restore scale so it doesn't affect other things
	shader_reset();
}