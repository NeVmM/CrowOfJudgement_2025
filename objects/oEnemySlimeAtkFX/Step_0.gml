// Update position and direction based on the owner's position
if (instance_exists(owner)) {
    x = owner.x + (facing * 20); // Adjust based on facing direction
    y = owner.y;
    image_xscale = facing; // Flip horizontally based on direction
}
