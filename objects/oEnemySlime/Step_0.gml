// === GRAVITY ===
var grav = 0.5;
ySpeed += grav;
ySpeed = clamp(ySpeed, -10, 10);

// === TURN AROUND ON WALL COLLISION ===
if (is_moving && place_meeting(x + moveSpeed * facing, y, eObject1))
{
    facing *= -1;
}

// === RANDOM WALK TIMER ===
move_timer -= 1;

if (move_timer <= 0)
{
    is_moving = !is_moving; // toggle between moving and stopping
    move_timer = irandom_range(60, 180); // random delay before next toggle
}

// === HORIZONTAL MOVEMENT ===
if (is_moving) {
    xSpeed = moveSpeed * facing;
} else {
    xSpeed = 0;
	sprite_index = Sprite_EnemySlime_Idle;
}

// --- HORIZONTAL COLLISION ---
if (place_meeting(x + xSpeed, y, eObject1))
{
    while (!place_meeting(x + sign(xSpeed), y, eObject1))
    {
        x += sign(xSpeed);
    }
    xSpeed = 0;
}
x += xSpeed;

// --- VERTICAL COLLISION ---
if (place_meeting(x, y + ySpeed, eObject1))
{
    while (!place_meeting(x, y + sign(ySpeed), eObject1))
    {
        y += sign(ySpeed);
    }
    ySpeed = 0;
}
y += ySpeed;

// --- FLIP SPRITE BASED ON FACING DIRECTION ---
if (is_moving) 
{
    image_xscale = facing;
}






// OTHER STUFF BELOW

if (is_moving) 
{
    sprite_index = Sprite_EnemySlime_Walking;
} 
else 
{
    sprite_index = Sprite_EnemySlime_Idle;
}