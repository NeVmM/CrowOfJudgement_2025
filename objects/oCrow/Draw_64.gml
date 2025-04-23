// Player Draw GUI Event (Manual Health Bar)

// Position of the health bar on screen
var bar_x = 100	;
var bar_y = 20;

// Dimensions of the bar
var bar_width = 220;
var bar_height = 20;

// Health calculation
var health_percent = clamp(health / 100, 0, 1);

// Colors
var border_color = c_black;
var fill_color = c_red;
var text_color = c_white;

// Outline thickness
var outline_thickness = 6;

// Draw thicker border by layering multiple rectangles
draw_set_color(border_color);
for (var i = 0; i < outline_thickness; i++) {
    draw_rectangle(
        bar_x - i, 
        bar_y - i, 
        bar_x + bar_width + i, 
        bar_y + bar_height + i, 
        false
    );
}

// Draw inner red bar
draw_set_color(fill_color);
draw_rectangle(bar_x, bar_y, bar_x + bar_width * health_percent, bar_y + bar_height, false);

// Draw text
draw_set_color(text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(bar_x + bar_width / 2, bar_y + bar_height / 2, string(round(health)) + "/100");

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
