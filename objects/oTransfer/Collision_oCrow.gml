randomize();





var pick = irandom(2);
oRoomLimiter.roomLimit += 1;

show_debug_message("Teleport #:" + string(oRoomLimiter.roomLimit) + " | Max " + string(oRoomLimiter.maxTeleport));

if (oRoomLimiter.roomLimit >= oRoomLimiter.maxTeleport)
{
	game_end();
}

else
{
	
if (pick == 0)
	room_goto(Room1);
if (pick == 1)
	room_goto(Room2);
if (pick == 2)
	room_goto(Room3);
	
}
