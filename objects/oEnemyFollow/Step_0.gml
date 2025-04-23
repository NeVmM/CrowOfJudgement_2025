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
            // Move toward the player
            is_moving = true;
            facing = sign(_player.x - x);
            
            // Optional: reset the move_timer to prevent toggling back to idle while chasing
            move_timer = 30;
        }
    }
}

#endregion