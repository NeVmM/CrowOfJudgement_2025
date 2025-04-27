with (other)
{
	hp--; // decrement by only 1 per hit
	health-= 0.3;
	flash = 1.5;
	with (oCamera)
	{
	shake_amount = 4; // How intense the shake is
	shake_timer = 10;
	}
}
