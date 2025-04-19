//lock to players vertical position
if (instance_exists(oCrow))
{
	image_xscale = oCrow.face; //set orientation
	y = oCrow.y; //follows players vertical position
	x_anchor = oCrow.x; //track players x position
}

//horizontal movement
hsp += spd;
x = x_anchor + (hsp*dir);


// Adjust weapon's position based on player facing direction
if (oCrow.face == 1) 
{
    x = oCrow.x + 20; // If facing right, place weapon slightly to the right
} 
else 
{
    x = oCrow.x - 20; // If facing left, place weapon slightly to the left
}


// Flip the weapon sprite according to the player's facing direction
if (instance_exists(oCrow)) 
{
    image_xscale = oCrow.face; // Flip the weapon sprite based on player's facing direction
}





