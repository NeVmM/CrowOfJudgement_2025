randomize();





var pick = irandom(3);
oRoomLimiter.roomLimit += 1;


if (oRoomLimiter.roomLimit >= oRoomLimiter.maxTeleport)
{
	health = 100; //this gets the health and every finish game it will revert hp to 100, this is temporary and will be removed
	game_restart();
}

else
{
	
if (pick == 0)
	room_goto(Room1);
if (pick == 1)
	room_goto(Room2);
if (pick == 2)
	room_goto(Room3);
if (pick == 3)
	room_goto(Room4);
	
}

