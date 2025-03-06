spd = 6; //set speed
hsp = 0; //horizontal movement variable

if (instance_exists(oCrow))
{
	image_xscale = oCrow.face; //set orientation
	y = oCrow.y; // Lock vertical position to player
	x_anchor = oCrow.x;
}

if (image_xscale == 1)
{
	dir = 1; //set direction to 1 (right)
}
else
{
	dir = -1; //set direction to -1 (left)
}

