//Player Input Controls (Key_Configures)
getControls();


#region Horizontal Movement
//X-Movement
//Directions
moveDirection = rightKey - leftKey;

//Get My Face
if moveDirection != 0 { face = moveDirection; }

//X-Speed
xSpeed = moveDirection * moveSpeed;

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
    is_on_ground = true;
}
else 
{
    is_on_ground = false;
}

#endregion

#region Roll State	

//Roll Cooldown
if (rollCooldown > 0) 
{
    rollCooldown--; 
}

//Roll Controls
if (rollKey && !is_rolling && rollCooldown <= 0) 
{
    is_rolling = true;
    alarm[0] = roll_Duration; // Start the roll duration timer
	i_frames = true; // Start i-frames if Character Rolls
	
	// Set xSpeed to rollSpeed regardless of movement direction
    xSpeed = rollSpeed * face; // Face determines the direction
	
	// Apply cooldown after rolling
    rollCooldown = 25; // 60 frames = 1 second
}

if (is_rolling) 
{
	sprite_index = Sprite_Roll;
    
	if (is_on_ground) 
	{
		// Maintain rolling speed only if on the ground (10)
		xSpeed = rollSpeed * face;
	}
	else 
	{
		// Reduces the roll_speed from 10 to 7.5
		xSpeed = rollAir*face;
	}
} 

else
{
    xSpeed = moveDirection * moveSpeed; // Normal Running Speed
}

if (!is_rolling)
{
	grav = .275;
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
//Attack
if (attack_cooldown > 0)
{
	//if attack cooldown is not 0, reduce it to 0
	attack_cooldown = max(0, attack_cooldown-1);
}
else
{
	//if it is 0, then player can attack again
	if(attackKey && !is_rolling) //Prevents attacking while roll state
	{
		attack_cooldown= attack_max; //set cooldown timer
		instance_create_layer(x, y, "Weapon", oWeapon);
	}
}

#endregion

#region Air Attack / Float Mechanic

// When attacking mid-air, stop completely and reset float timer
if (!onGround && attackKey && airAttackCount == 0) 
{
    floating = true;        // Activate floating state
    airFloatTimer = 30;     // 0.5 seconds
    ySpeed = 0;             // Completely stop movement
    grav = 0;               // Disable gravity
	airAttackCount = 1;	// Prevent future floating resets
}

// Maintain floating state while timer is active
if (floating) 
{
    airFloatTimer--;         // Countdown

    // Prevent movement while floating
    ySpeed = 0;
    grav = 0;

    if (airFloatTimer <= 0) 
    {
        floating = false;   // End floating state
        grav = 0.275;       // Restore normal gravity
    }
}

// Reset air attack count when landing
if (onGround) 
{
    airAttackCount = 0;
}


#endregion






//=========================================================================================
//OTHER STUFF BELOW
//=========================================================================================

#region Particle System
// Emit particles when the player is running
if (abs(xSpeed) > 0 && onGround) 
{
	// Emit the particle behind the player
	var xOffset = -2 * face; // Adjust this value to control where particles appear
	part_particles_create(part_sys, x + xOffset, y + 5, part_type, 1);
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

#region Sprites Etc
//Sprite Controls
//Running
if (abs(xSpeed) > 0) 
{ 
	sprite_index = Sprite_Run; 
}
//Not Moving (idle)
if (xSpeed == 0) 
{ 
	sprite_index = Sprite_Idle; 
}
//In the Air (1st jump)
if (!onGround && jumpCount == 1 && ySpeed <= 0) 
{ 
	sprite_index = Sprite_1Jump; 
}
//In the Air (2nd jump)
if (!onGround && jumpCount == 2 && ySpeed <= 0) 
{ 
	sprite_index = Sprite_2Jump; 
}
//Falling (after jump)
if (!onGround && ySpeed > 0) 
{ 
	sprite_index = Sprite_Fall; 
}
//Gliding
if (!onGround && jumpCount == 2 && jumpKey && ySpeed > 0) 
{ 
	sprite_index = Sprite_Glide; 
}
//Rolling
if (is_rolling) 
{
	sprite_index = Sprite_Roll; // Set the rolling sprite
	// Optional: Set a specific speed for rolling, if needed
	direction = sign(xSpeed); // Maintain the direction of the roll
}




{
//set the Collision Mask
mask_index = Sprite_Run;
mask_index = Sprite_Idle;
mask_index = Sprite_1Jump;
mask_index = Sprite_2Jump;
mask_index = Sprite_Fall;
mask_index = Sprite_Glide;
}

#endregion

// testing if github desktop works pushing to website