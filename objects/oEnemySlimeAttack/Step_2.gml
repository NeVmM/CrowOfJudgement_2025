//lock to players vertical position
if (instance_exists(oEnemySlime))
{
	image_xscale = oEnemySlime.xSpeed; //set orientation
	y = oEnemySlime.y; //follows players vertical position
	x_anchor = oEnemySlime.x; //track players x position
}

//horizontal movement
hsp += spd;
x = x_anchor + (hsp*dir);


// Adjust weapon's position based on player facing direction
if (oEnemySlime.xSpeed == 1) 
{
    x = oEnemySlime.x + 20; // If facing right, place weapon slightly to the right
} 
else 
{
    x = oEnemySlime.x - 20; // If facing left, place weapon slightly to the left
}


// Flip the weapon sprite according to the player's facing direction
if (instance_exists(oEnemySlime)) 
{
    image_xscale = oEnemySlime.xSpeed; // Flip the weapon sprite based on player's facing direction
}





