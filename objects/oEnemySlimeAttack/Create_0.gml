spd = 6; //set speed
hsp = 0; //horizontal movement variable

if (instance_exists(oEnemySlime))
{
	image_xscale = oEnemySlime.xSpeed; //set orientation
	y = oEnemySlime.y; // Lock vertical position to player
	x_anchor = oEnemySlime.x;
}

if (image_xscale == 1)
{
	dir = 1; //set direction to 1 (right)
}
else
{
	dir = -1; //set direction to -1 (left)
}


