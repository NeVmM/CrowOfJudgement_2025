// === GRAVITY ===
#region

var grav = 0.5;
ySpeed += grav;
ySpeed = clamp(ySpeed, -10, 10);

#endregion

// === TURN AROUND ON WALL COLLISION ===
#region

if (is_moving && place_meeting(x + moveSpeed * facing, y, eObject1))
{
    facing *= -1;
}

#endregion

// === RANDOM WALK & TIMER (Left or Right) ===
#region

move_timer -= 1;

if (move_timer <= 0)
{
    is_moving = !is_moving; // toggle between moving and stopping
    move_timer = irandom_range(180, 420); // random delay before next toggle
	
	// Randomly flip direction when going idle
    if (!is_moving)
    {
        facing = choose(1, -1);
    }
}

#endregion

// === HORIZONTAL MOVEMENT ===
#region

if (is_moving) {
    xSpeed = moveSpeed * facing;
} else {
    xSpeed = 0;
	sprite_index = Sprite_EnemySlime_Idle;
}

#endregion

// --- HORIZONTAL COLLISION ---
#region

if (place_meeting(x + xSpeed, y, eObject1))
{
    while (!place_meeting(x + sign(xSpeed), y, eObject1))
    {
        x += sign(xSpeed);
    }
    xSpeed = 0;
}
x += xSpeed;

#endregion

// --- VERTICAL COLLISION ---
#region 

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

#endregion

// === LEDGE DETECTION ===
#region

// Look 1 pixel ahead in facing direction, and 1 pixel below that
var checkX = x + 1;
var checkY = y + 1;

if (!position_meeting(checkX, checkY, eObject1)) {
    facing *= -1; // Turn around at ledge
}

#endregion





// OTHER STUFF BELOW
#region sprites
if (is_moving) 
{
    sprite_index = Sprite_EnemySlime_Walking;
} 
else 
{
    sprite_index = Sprite_EnemySlime_Idle;
}
#endregion


