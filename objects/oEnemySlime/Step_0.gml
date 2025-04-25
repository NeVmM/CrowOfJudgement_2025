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
	sprite_index = Sprite_EnemySlime_Walking;
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

// Look 1 pixel ahead in facing direction, and 1 pixel below that
var checkX = x + 1;
var checkY = y + 1;

if (!position_meeting(checkX, checkY, eObject1)) {
    facing *= -1; // Turn around at ledge
}

#endregion

#region Follow oCrow if nearby and on same platform

// Find the nearest oCrow instance
var _player = instance_nearest(x, y, oCrow);

// Only follow if player exists
if (instance_exists(_player))
{
    // Check horizontal and vertical range (adjust range if needed)
    var dist_x = abs(_player.x - x);
    var dist_y = abs(_player.y - y);
    
    // Only follow if the player is nearby and horizontally aligned
    if (dist_x < 160 && dist_y < 16)
    {		
        // Check if slime and player are standing on the same platform
        var slime_on_ground = position_meeting(x, y + 1, eObject1);
        var player_on_ground = position_meeting(_player.x, _player.y + 1, eObject1);
        
        if (slime_on_ground && player_on_ground)
        {
            // If the player is behind the enemy, flip direction immediately
            if (_player.x < x && facing == 1)  // Player is to the left
            {
                facing = -1;  // Turn to face left
            }
            else if (_player.x > x && facing == -1)  // Player is to the right
            {
                facing = 1;  // Turn to face right
            }

            // If the distance is greater than 16 pixels, move towards player
            if (dist_x > 50)
            {
                is_moving = true;
                move_timer = 30; // prevent idle toggle
            }
            else
            {
                is_moving = false; // stop when close enough
                xSpeed = 0;
            }
        }
    }
}

#endregion


#region Attack Behavior

var _player = instance_nearest(x, y, oCrow);

// Only attack if the player exists
if (instance_exists(_player))
{
    var dist_x = abs(_player.x - x);
    var dist_y = abs(_player.y - y);

    var on_same_ground = position_meeting(x, y + 1, eObject1) && position_meeting(_player.x, _player.y + 1, eObject1);

    // Only attack if close enough and on same platform
    if (dist_x <= 50 && dist_y < 16 && on_same_ground && !is_moving && can_attack)
    {
        // Attack!
        instance_create_layer(x, y, "Enemies", oEnemySlimeAttack);
		is_attacking = true;


        // Start cooldown
        can_attack = false;
        attack_cooldown = 30; // 1 second if game is 60 FPS
    }
}

// Handle cooldown
if (!can_attack)
{
    attack_cooldown--;
    if (attack_cooldown <= 0)
    {
        can_attack = true;
		is_attacking = false;
    }
}

#endregion






 if (just_hit > 0)
{
    just_hit--;
}

 
 
 
 
 
 
 


// OTHER STUFF BELOW
#region Sprites Etc
if (is_moving) 
{
    sprite_index = Sprite_EnemySlime_Walking;
} 
else 
{
    sprite_index = Sprite_EnemySlime_Idle;
}
#endregion

if (is_attacking)
{
    sprite_index = Sprite_EnemySlime_Attack;
}
else if (is_moving)
{
    sprite_index = Sprite_EnemySlime_Walking;
}
else
{
    sprite_index = Sprite_EnemySlime_Idle;
}
