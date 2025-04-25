draw_sprite_ext( sprite_index, image_index, x, y, image_xscale*face, image_yscale, image_angle, image_blend, image_alpha )

if (flash > 0)
{
    flash--;
    shader_set(shWhite);

    var scale_backup = image_xscale; // backup current scale

    // Flip the flash sprite relative to original scale
    image_xscale = face * abs(scale_backup);

	draw_self();

    image_xscale = scale_backup; // restore original scale
    shader_reset();
}



// Flash Flicker Effect
if (flash_count > 0)
{
    // Toggle visibility every flash_timer frames
    if (flash_timer mod 2 == 0)
    {
		var scale_backup = image_xscale; // backup current scale
		image_xscale = face * abs(scale_backup);
        draw_self(); // visible
		image_xscale = scale_backup; // restore original scale
    }
    // else, don't draw (invisible frame)
}
else
{
	var scale_backup = image_xscale; // backup current scal
	image_xscale = face * abs(scale_backup);
    draw_self(); // normal drawing
	image_xscale = scale_backup; // restore original scale
}


