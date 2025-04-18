// Movement
x += hsp;
y += vsp;

// Fade out (optional)
image_alpha -= 1 / lifespan;

// Destroy after time
lifespan--;
if (lifespan <= 0) {
    instance_destroy();
}
