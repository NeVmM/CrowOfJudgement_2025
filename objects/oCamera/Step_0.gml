#region Camera Stuff

//Fullscreen toggle
if keyboard_check_pressed(vk_f8)
{
	window_set_fullscreen(!window_get_fullscreen());
}
// === 0. Fullscreen toggle ===
if keyboard_check_pressed(vk_f11) {
    window_set_fullscreen(!window_get_fullscreen());
}

// === 1. Exit if no player ===
if !instance_exists(oCrow) exit;

// === 2. Get camera size ===
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

// === 3. Input & vertical movement offset ===

camOffsetX = 0;
camOffsetY = 0;

var inputX = 0;
var inputY = 0;

// Detect movement key input
if keyboard_check(vk_left)  or keyboard_check(ord("A")) inputX -= 1;
if keyboard_check(vk_right) or keyboard_check(ord("D")) inputX += 1;
if keyboard_check(vk_up)    or keyboard_check(ord("W")) inputY -= 1;
if keyboard_check(vk_down)  or keyboard_check(ord("S")) inputY += 1;

var pressingInput = (inputX != 0) || (inputY != 0);

// Use input-based offset if pressing keys
if (pressingInput) {
    camOffsetX = inputX * camOffsetDist;
    camOffsetY = inputY * camOffsetDist;
}
else {
    // Pan down and follow faster when falling
    if (oCrow.vspeed > 0.5) {
        var fall_speed = clamp(oCrow.vspeed, 0, 16); // Cap fall effect
        camOffsetY = fall_speed * 6; // Adjust for pan distance

        camTrailSpd_dynamic = 0.18; // Follow faster while falling
    }
    else if (oCrow.vspeed < -0.5) {
        camOffsetY = camJumpOffset;
        camTrailSpd_dynamic = camTrailSpd; // Normal speed while rising
    }
    else {
        camTrailSpd_dynamic = camTrailSpd; // Reset to default
    }
}

// === 4. Smooth offset movement ===
var offsetSmoothFactor = camOffsetSmooth;

camOffsetX_final += (camOffsetX - camOffsetX_final) * offsetSmoothFactor;
camOffsetY_final += (camOffsetY - camOffsetY_final) * offsetSmoothFactor;

// === 5. Camera target centered on player + offset
var _camX = oCrow.x - _camWidth / 2 + camOffsetX_final;
var _camY = oCrow.y - _camHeight / 2 + camOffsetY_final + camVerticalBias;

// Clamp camera inside room
_camX = clamp(_camX, 0, room_width - _camWidth);
_camY = clamp(_camY, 0, room_height - _camHeight);

// === 6. Smoothly move camera towards target
finalCamX += (_camX - finalCamX) * camTrailSpd_dynamic;
finalCamY += (_camY - finalCamY) * camTrailSpd_dynamic;

// === 7. Apply camera position
camera_set_view_pos(view_camera[0], finalCamX, finalCamY);

#endregion;


if (shake_timer > 0) {
    shake_timer--;
    var shake_x = random_range(-shake_amount, shake_amount);
    var shake_y = random_range(-shake_amount, shake_amount);
    camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]) + shake_x, camera_get_view_y(view_camera[0]) + shake_y);
}