#region Gravity

var grav = 0.5;
ySpeed += grav;
ySpeed = clamp(ySpeed, -10, 10);

#endregion

#region Turn Around On Wall Collision

if (is_moving && place_meeting(x + moveSpeed * facing, y, eObject1))
{
    facing *= -1;
}

#endregion

#region Random Walk & Random Timer Idle

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

#region Horizontal Movement

if (is_moving) 
{
    xSpeed = moveSpeed * facing;
} 
else 
{
    xSpeed = 0;
	sprite_index = Sprite_EnemyEye_Idle;
}

#endregion

#region Horizontal Collision

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

#region Vertical Collision

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


#region Ledge Detection (floor)

// Look ahead in the facing direction, and check just below that
var checkX = x + facing * 6; // 6 pixels ahead in facing direction
var checkY = y + sprite_height / 2 + 1; // just below feet

if (!position_meeting(checkX, checkY, eObject1)) {
    facing *= -1; // Turn around at ledge
}

#endregion



 
 
 
 
 
 
 

// --- OTHER STUFF BELOW ---
#region Sprites Etc
if (is_moving) 
{
    sprite_index = Sprite_EnemyEye_Walking;
} 
else 
{
    sprite_index = Sprite_EnemyEye_Idle;
}
#endregion


