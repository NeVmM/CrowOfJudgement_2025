// Player Draw GUI Event

// Position of the health bar
var bar_x = 20;
var bar_y = 20;

// Dimensions for the health bar (these are the same as the sprites)
var bar_width = 103;  // Width of the health bar
var bar_height = 18;  // Height of the health bar

// Health percent (0.0 to 1.0)
var health_percent = health / 100;

// **Draw the background** (using the spr_healthbg sprite)
// Position the background at the top-left corner
draw_sprite(spr_healthbg, 0, bar_x, bar_y);

// **Set health bar color**
var health_bar_color = c_lime; // Default color is green

// If health is less than 2%, change to red
if (health_percent < 0.02) {
    health_bar_color = c_red; // Change to red if below 2%
}

// **Draw the health bar** (using the spr_healthbar sprite)
// The width of the health bar should be proportional to the current health
var health_bar_width = bar_width * health_percent;

// Use the chosen color for the health bar
draw_set_color(health_bar_color);

// **Draw a portion of the health bar** using the width calculated from health percent
// This draws the health bar portion based on health, from left to right
draw_sprite_part(spr_healthbar, 0, 0, 0, health_bar_width, bar_height, bar_x-4, bar_y-4);

// **Draw the border** (using the spr_healthborder sprite)
// The border will sit on top of the background and health bar
draw_sprite(spr_healthborder, 0, bar_x, bar_y);  // This will draw the border on top

// Optional: Text to show health value
draw_set_color(c_white);
draw_text(bar_x + bar_width + 10, bar_y, string_format(health, 1, 1) + " / 100");
