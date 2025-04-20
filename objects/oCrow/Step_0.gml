//Player Input Controls (Key_Configures)
getControls();


#region Horizontal Movement
//X-Movement
//Directions
moveDirection = rightKey - leftKey;

//Get My Face
if moveDirection != 0 
{ 
	face = moveDirection; 
}

//X-Speed
if (!floating)
{
	xSpeed = moveDirection * moveSpeed;
}

#endregion	

#region Vertical Movement
//Y-Movement
//Gravity
if (coyoteHangTimer > 0) 
{
	//Count Timer Down
	coyoteHangTimer--;
} 
else 
{    
	//Apply gravity to player
	ySpeed += grav;
	termVelocity += 0.6;
	//No longer on the ground
	setOnGround(false);
}



//Reset Jump Variables
if (onGround) 
{
	jumpCount = 0;
	jumpHoldTimer = 0;
	coyoteJmpTimer = coyoteJumpFrames;
} 
else 
{
	//If player in air already, only able to jump once (not 2)
	coyoteJumpTimer--;
	if (jumpCount == 0 && coyoteJumpTimer <= 0) 
	{
		jumpCount = 1;
	}
}


//Initiate the Jump
if (jumpKeyBuffered && jumpCount < jumpMax) 
{
	//Reset Buffer
	jumpKeyBuffered = false;
	jumpKeyBufferTimer = 0;
	//Increase the number of formed jumps
	jumpCount++;
	//Set the jump hold timer
	jumpHoldTimer = jumpHoldFrames[jumpCount-1];
	//Tell ourselves we're no longer on the ground
	setOnGround(false);
	coyoteJumpTimer = 0;
}

//Cut off jump when releasing button
if (!jumpKey) 
{
	jumpHoldTimer = 0;
}

//Jump based on the timer/hold of the jump button
if (jumpHoldTimer > 0) 
{
	//Constantly set the ySpeed to be the jumpSpeed
	ySpeed = jumpSpeed[jumpCount-1];
	//Count down the timer
	jumpHoldTimer--;
}



//Gliding Mechanic
if (jumpCount == 2 && jumpKey) 
{
	//Limit the falling speed for gliding
	ySpeed = min(ySpeed, 3.5); 
	sprite_index = Sprite_Glide; 
}

if (ySpeed > 0) 
{
	//Falling after gliding or jumping
	sprite_index = Sprite_Fall;
}

#endregion
	
#region on_ground detection

// Check if the player is on the ground
if (place_meeting(x, y + 1, eObject1)) 
{
	// Detects if on the ground
    is_on_ground = true;
}
else 
{
	// Detects if NOT on the ground
    is_on_ground = false;
}

#endregion

#region Roll State	

// Roll Cooldown Timer
if (rollCooldown > 0) 
{
    rollCooldown--; 
}

// Prevent unlimited air rolls
if (!onGround && airRollUsed) 
{
	rollAir = 13.7;
    canRoll = false;
}

// Roll Controls
if (rollKey && !is_rolling && rollCooldown <= 0 && canRoll) 
{
    is_rolling = true;
    alarm[0] = roll_Duration; // Start the roll duration timer
    i_frames = true; // Enable invincibility frames
    xSpeed = rollSpeed * face; // Set roll speed in the facing direction
    rollCooldown = 60; // 1.5 seconds cooldown (60 frames = 1 sec)

    // If rolling in the air, prevent multiple air rolls
    if (!onGround) 
    {
        airRollUsed = true;
    }
}

// Rolling animation & movement
if (is_rolling) 
{
    sprite_index = Sprite_Roll;
	rollSpeed = 11.5;

    if (onGround) 
    {
        xSpeed = rollSpeed * face; // Maintain ground rolling speed
    }
    else 
    {
        xSpeed = rollAir * face; // Reduce air rolling speed
    }
	
	
	// Create afterimage every few frames
    if (game_get_speed(gamespeed_fps) mod 5 == 0) 
    {
        var ghost = instance_create_layer(x, y, layer, oCrow_RollFade);
        ghost.image_index = image_index; // Match the current animation frame
        ghost.sprite_index = sprite_index; // Match current sprite
    }
}

// Reset rolling ability when touching the ground
if (onGround) 
{
    airRollUsed = false;
    canRoll = true;
}

if (!is_rolling)
{
    grav = 0.275;
}

#endregion

#region I-Frames (roll)

// I-FRAMES (Rolling)
if (i_frames)
{
	/*if (collision_with_enemy)
	{
		//code here
	}*/
	
	//Reduce i-frame timer
	i_frame_duration--;
	if (i_frame_duration <= 0)
	{
		i_frames = false;
	}
}
#endregion


//_________________________________________________________________________________________
// X-Collision stuff
#region

//X Collision w/ eObject01 (floor/wall)
var _subPixel = .5;
if place_meeting(x + xSpeed, y, eObject1) 
{
	//Scoot up to the wall precisely
	var _pixelCheck = _subPixel * sign(xSpeed);
	while (!place_meeting(x + _pixelCheck, y, eObject1)) 
	{
		x += _pixelCheck;
	}

	//Set xSpeed to 0 to collide
	xSpeed = 0;
	is_on_wall = true;
	
	
	// Wall Slide/Climb Mechanic
	if (is_on_wall == true) 
	{
		if (ySpeed > 0) 
		{
			ySpeed = grav / .250; // Adjust vertical movement for wall slide
		}
			
		//Reset Jump when sliding on wall
		jumpCount = 0;
		jumpHoldTimer = 0;
		coyoteJumpTimer = coyoteJumpFrames;
	}
	else
	{
		is_on_wall = false;
	}
}

//Move
x += xSpeed;

#endregion

//=========================================================================================
// Y-Collision stuff
#region

//Y Collision & Movement
//Cap Falling Speed
if (ySpeed > termVelocity) { ySpeed = termVelocity; };

//_________________________________________________________________________________________

//Collision
var _subPixel = .5;
if place_meeting(x, y + ySpeed, eObject1) 
{
	// Scoot up to the wall precisely
	var _pixelCheck = _subPixel * sign(ySpeed);
	while (!place_meeting(x, y + _pixelCheck, eObject1)) 
	{ 
		y += _pixelCheck; 
	}

	//Bonk Code (optional) - use /* ex  */
	if (ySpeed < 0) 
	{ 
		jumpHoldTimer = 0; 
	}

	//Set ySpeed to 0 to collide
	ySpeed = 0;
}



//Set if Player on the Ground
if (ySpeed >= 0 && place_meeting(x, y + 1, eObject1)) 
{
	setOnGround(true);
}

//Move
y += ySpeed;

#endregion

//_________________________________________________________________________________________

#region Attack
// Attack cooldown for normal attacks
if (attack_cooldown > 0)
{
    // If attack cooldown is not 0, reduce it
    attack_cooldown = max(0, attack_cooldown - 1);
}
else
{
    // If attack cooldown is 0, player can attack again
    if (attackKey && !is_rolling) // Prevent attacking while rolling
    {
        // Normal ground attack (if not in the air)
        if (onGround)
        {
            attack_cooldown = attack_max; // Set cooldown timer
            instance_create_layer(x, y, "Weapon", oCrowWeapon); // Create weapon instance
        }
    }
}
#endregion

#region Air Attack / Float Mechanic

// When attacking mid-air, allow up to 3 attacks
if (!onGround && attackKey && airAttackCount < 3) 
{
    airAttackCount++;  // Increase attack count
    floating = true;    // Activate floating state
    airFloatTimer = 20;  // Short pause (adjust if needed)
    ySpeed = 0;         // Stop vertical movement
    xSpeed = 0;
    grav = 0;           // Disable gravity temporarily

    // Create weapon instance for the attack
    instance_create_layer(x, y, "Weapon", oCrowWeapon);
}

// Stop attacks after 3 air attacks
if (!onGround && airAttackCount == 3)
{
    attackKey = false;  // Disable attack input after 3 attacks
}

// Maintain floating state while timer is active
if (floating) 
{
    airFloatTimer--; // Countdown timer

    // Prevent movement while floating
    xSpeed = 0;
    ySpeed = 0;
    grav = 0;

    if (airFloatTimer <= 0) 
    {
        floating = false;  // End floating state
        grav = 0.275;      // Restore gravity
    }
}

// Reset air attack count and clear attack state when landing
if (onGround) 
{
    airAttackCount = 0;   // Reset the air attack count
    attackKey = true;     // Re-enable attack key once the player is on the ground
}

#endregion

#region ENEMIES (Specifically TRAP/SPIKES)

if (place_meeting(x,y,oBad))
{
	game_restart();
}

#endregion

#region Pause/Exit

if (exitGame)
{
	game_end();
}

#endregion







// --- OTHER STUFF BELOW ---   ============================================================

#region OLD Built-In PARTICLE (NOT IN USED)
//=========================================================================================
//OTHER STUFF BELOW
//=========================================================================================
/*
#region Particle System
// Emit particles when the player is running
if (abs(xSpeed) > 0 && onGround) 
{
	// Emit the particle behind the player
	var xOffset = -2 * face; // Adjust this value to control where particles appear
	part_particles_create(part_sys, x + xOffset, y - 5, part_type, 1);
}

//Create the particle system
part_sys = part_system_create();
part_type = part_type_create();
	
//Running Particle Properties
part_type_shape(part_type, pt_shape_pixel); // Set shape to pixel or customize
part_type_size(part_type, 0.1, 0.2, 0.1, 0); // Size of the particle
//(THIS IS USED HERE, IF THE RANDOM-COLOR BELOW IS NOT PRESENT)  >>>   part_type_color1(part_type, c_white); // You can change the color
part_type_speed(part_type, 1, 2, 0, 0); // Speed of the particles
part_type_direction(part_type, 0, 360, 0, 0); // Random directions
part_type_life(part_type, 15, 30); // Lifespan of the particles

//ParticleColor - Random Choose
// Set up the particle colors
var color1 = c_white; // First color
var color2 = c_ltgray;   // Second color

// Randomly choose one of the two colors for the particles
var chosen_color = irandom(1); // Randomly get 0 or 1
	
if (chosen_color == 0) 
{
	part_type_color1(part_type, color1);
} 
else 
{
	part_type_color1(part_type, color2);
}

#endregion
*/
#endregion

#region New Better Particle (USED)

if (abs(xSpeed) > 0 && onGround) 
{
	var dust_x = x - 20 * face;
	var dust_y = y - 5;

	// Check if not inside the floor before creating
	if (abs(xSpeed) > 0 && onGround && position_meeting(x, y + 1, eObject1))
	{
		var dust_x = x - 20 * face;
		var dust_y = y - 5;

		instance_create_layer(dust_x, dust_y, "Objects_Blocks", oParticleCrow);
	}
}

#endregion

#region Sprites Etc
// Sprite Controls

// Running
if (abs(xSpeed) > 0 && onGround) 
{ 
    sprite_index = Sprite_Run; 
} 
// Idle
if (xSpeed == 0 && onGround) 
{ 
    sprite_index = Sprite_Idle; 
} 
// First Jump
if (!onGround && jumpCount == 1 && ySpeed <= 0) 
{ 
    sprite_index = Sprite_1Jump; 
} 
// Second Jump
if (!onGround && jumpCount == 2 && ySpeed <= 0) 
{ 
    sprite_index = Sprite_2Jump; 
} 
// Gliding (Give it high priority before falling)
if (!onGround && jumpCount == 2 && jumpKey && ySpeed > 0)  
{ 
    sprite_index = Sprite_Glide; 
} 
// GlidingIdle (not moving)
if (!onGround && jumpCount == 2 && jumpKey && ySpeed > 0 && xSpeed == 0) 
{ 
    sprite_index = Sprite_GlideIdle; 
} 
// Rolling
if (is_rolling) 
{
    sprite_index = Sprite_Roll; 
} 
// Air Attack (Has priority over falling)
if (!onGround && attackKey) 
{
    sprite_index = Sprite_AttackFX; 
} 
// Falling - Only apply if NOT gliding, attacking, OR rolling
if (!onGround && ySpeed > 0 && !attackKey && !(jumpCount == 2 && jumpKey) && !is_rolling)  
{ 
    sprite_index = Sprite_Fall; 
}


// HELLO THIS IS TESTING (if you are reading this from GithubDesktop, it means its working, im editing this directly from GithubWebsite)

{
//set the Collision Mask
mask_index = Sprite_Run;
mask_index = Sprite_Idle;
mask_index = Sprite_1Jump;
mask_index = Sprite_2Jump;
mask_index = Sprite_Fall;
mask_index = Sprite_Glide;
mask_index = Sprite_GlideIdle;
}

#endregion

// UPDATED IN APRIL 20

