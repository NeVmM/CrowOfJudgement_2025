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

if (move_timer <= 0 && !is_attacking) // Don't switch states if attacking
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
if (is_moving && !is_attacking) 
{
    xSpeed = moveSpeed * facing;
} 
else 
{
    xSpeed = 0;
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
#endregion

#region Ledge Detection (floor)
var checkX = x + facing;
var checkY = y + 1;

if (!position_meeting(checkX, checkY, eObject1) && is_moving && !is_attacking) 
{
    facing *= -1; // Turn around at ledge
}
#endregion

#region Follow Player & Attack
var _player = instance_nearest(x, y, oCrow);

if (instance_exists(_player) && !is_attacking) // Only follow if not attacking
{
    var dist_x = abs(_player.x - x);
    var dist_y = abs(_player.y - y);
    
    if (dist_x < 160 && dist_y < 16) // Check range
    {		
        var slime_on_ground = position_meeting(x, y + 1, eObject1);
        var player_on_ground = position_meeting(_player.x, _player.y + 1, eObject1);
        
        if (slime_on_ground && player_on_ground)
        {
            // Face the player
            facing = (_player.x < x) ? -1 : 1;

            if (dist_x > 50) // Move toward player
            {
                is_moving = true;
                move_timer = 30; 
            }
            else // Attack when close enough
            {
                is_moving = false;
                xSpeed = 0;
                is_attacking = true;
                sprite_index = Sprite_EnemySlime_Attack;
                image_index = 0;
                image_speed = 1; 
				
				
				// Create attack effect (spawn on the side of the enemy)
                var effect_x = (facing == 1) ? x + 16 : x - 16; // Adjust position based on facing direction
    var effect_y = y; // Place at the same height as the enemy
    var attackEffect = instance_create_layer(effect_x, effect_y, "Enemies", oEnemySlimeAtkFX);

            }
        }
    }
}
#endregion

#region Handle Attack Animation
if (is_attacking)
{
    if (image_index >= image_number - 1) // Attack animation finished
    {
        is_attacking = false;
        sprite_index = Sprite_EnemySlime_Idle;
    }
}
#endregion

#region Sprites
if (!is_attacking) // Only change sprite if NOT attacking
{
    if (is_moving) 
    {
        sprite_index = Sprite_EnemySlime_Walking;
    } 
    else 
    {
        sprite_index = Sprite_EnemySlime_Idle;
    }
}

image_xscale = facing; // Flip sprite based on direction
#endregion
