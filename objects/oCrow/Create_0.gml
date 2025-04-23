//Custom functions for player
function setOnGround(_val = true)
{

	if _val == true
	{
		onGround = true;
		coyoteHangTimer = coyoteHangFrames;
	}
	else
	{
		onGround = false;
		coyoteHangTimer = 0;
	}
}

//Control Setup (Action Controls) Made for basic Input to access the file itself (accessed from Key_Configures)
controlsSetup();



#region //Sprites

maskSprite = Sprite_Idle;
idleSprite = Sprite_Idle;
runSprite = Sprite_Run;
jumpSprite1 = Sprite_1Jump;
jumpSprite2 = Sprite_2Jump;
glideSprite = Sprite_Glide;
jumpSprite2 = Sprite_2Jump;
rollSprite = Sprite_Roll;

#endregion

#region //Movement

face = 1;
moveDirection = 0;
moveSpeed = 5;
xSpeed = 0;
ySpeed = 0;

#endregion

#region //Ground Detection

is_on_ground = false; // Default to false (airborne)

#endregion

#region //Jumping

grav = .275;
termVelocity = 4;
onGround = true;
jumpMax = 2;
jumpCount = 0;
jumpHoldTimer = 0;
	//Jump values for each successful jumps
	jumpHoldFrames[0] = 18;
	jumpSpeed[0] = -3.15; //first jump height speed
	jumpHoldFrames[1] = 10; //hold jump height increase
	jumpSpeed[1] = -4.35; //Second jump height speed


jumpPower = 0.5;


#endregion

#region //Rolling & I-frames

is_rolling = false;
roll_Duration = room_speed * .3;
rollSpeed = 10; // Adjust this value for desired roll speed
rollCooldown = 0;
rollAir = 7.5;

canRoll = true;       // Determines if rolling is allowed
airRollUsed = false;  // Tracks if an air roll has been used

//Roll (i-frames)
i_frames = false;
i_frame_duration = 30;
	
#endregion

#region //Coyote Time

//Hang Time
coyoteHangFrames = 2.75;
coyoteHangTimer = 0;
//Jump Buffer Time
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;

#endregion

#region //Attack

attack_cooldown = 0;
attack_max = 10; //numebr of frames before we can attack again
stateAttack = AttackSlash;

#endregion

#region //Air Float & Air_Attack Timer

airFloatTimer = 0; // 60 is equal to 1 sec
floating = false; // Track if floating is active
airAttackCount = 0; // Tracks if the player has attacked mid-air

#endregion

#region	//hp
hp = 100;
hp_max = hp;
regen_timer = 0;
trap_timer = 0;
//healthbar_width = 100;
//healthbar_height = 10;
//healthbar_x =(320/2) - (healthbar_width/2);
//healthbar_y = ystart-100;;


flash = 0;
#endregion
