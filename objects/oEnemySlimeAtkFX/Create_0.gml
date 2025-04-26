spd = 0; // weapon doesn't move
hsp = 0;
facing = 1;
owner = noone;

if (instance_exists(owner)) {
    x = owner.x + (facing * 20); // Offset based on facing direction
    y = owner.y;
    image_xscale = facing;
    image_yscale = 1;
}

if (image_xscale == 1) {
    dir = 1; // Right
} else {
    dir = -1; // Left
}

sprite_index = Sprite_EnemySlime_AttackEffect; // Assign the effect sprite
image_index = 0; // Start from the first frame
image_speed = 1; // Adjust speed
depth = -10; // Ensure it appears in front of most objects
alarm[0] = room_speed;

// Position adjustment
if (facing == 1) {
    x += 8; // Right
} else {
    x -= 8; // Left
}
