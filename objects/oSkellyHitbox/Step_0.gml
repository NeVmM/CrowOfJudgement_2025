life--;
if (life <= 0)
{
    instance_destroy();
}

// Damage player if colliding
if (place_meeting(x, y, oCrow))
{
    with (instance_place(x, y, oCrow))
    {
        hp -= 20;
        health -= 0.3;
        flash = 1.5;
    }
    
    with (oCamera)
    {
        shake_amount = 4;
        shake_timer = 10;
    }
    
    instance_destroy(); // Hit once, then disappear
}
