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
if (!is_following_player && !is_attacking) // Only random walk if not chasing or attacking
{
    move_timer -= 1;
    if (move_timer <= 0)
    {
        is_moving = !is_moving; // toggle between moving and stopping
        move_timer = irandom_range(180, 420);
        
        if (!is_moving)
        {
            facing = choose(1, -1);
        }
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

#region Flip Sprite
image_xscale = facing;
#endregion

#region Ledge Detection
var checkX = x + facing;
var checkY = y + 1;
if (!position_meeting(checkX, checkY, eObject1))
{
    facing *= -1;
}
#endregion

#region Follow Player & Attack
var _player = instance_nearest(x, y, oCrow);
is_following_player = false;

if (instance_exists(_player) && !dead)
{
    var dist_x = abs(_player.x - x);
    var dist_y = abs(_player.y - y);

    if (dist_x < 170 && dist_y < 32) // detect player horizontally, and a little more vertically
    {
        is_following_player = true;
        
        if (!is_attacking)
        {
            // Face the player
            facing = (_player.x < x) ? -1 : 1;

            if (dist_x > 100) // If player is far enough, keep moving toward them
            {
                is_moving = true;
            }
            else
            {
                // Begin attack
                is_attacking = true;
                attack_effect_spawned = false;
                attack_cooldown = room_speed * irandom_range(2, 3); // 2-3 seconds cooldown
                sprite_index = Sprite_EnemySkelly_Attack;
                image_index = 0;
                image_speed = 1.5;
            }
        }
    }
}
#endregion

#region Handle Attack Cooldown and Spawn Hitbox
if (is_attacking)
{
    if (sprite_index == Sprite_EnemySkelly_Attack)
    {
        if (image_index >= 4 && image_index <= 6 && !attack_effect_spawned)
        {
            var hitbox = instance_create_layer(x + facing * 16, y - 4, layer, oSkellyHitbox);
            hitbox.image_xscale = facing; // Flip the hitbox according to facing direction
            attack_effect_spawned = true;
			
			hp--; // decrement by only 1 per hit
			health-= 20;
			flash = 1.5;
			
			with (oCamera)
			{
				shake_amount = 4; // How intense the shake is
				shake_timer = 10;
			}
        }
    }
    
    if (attack_cooldown > 0)
    {
        attack_cooldown--;
    }
    else
    {
        is_attacking = false;
        is_moving = false;
        move_timer = irandom_range(60, 120); // Short idle after attack
    }
}
else
{
    if (is_moving)
    {
        sprite_index = Sprite_EnemySkelly_Walking;
    }
    else
    {
        is_moving = false;
        sprite_index = Sprite_EnemySkelly_Idle;
    }
}
#endregion
