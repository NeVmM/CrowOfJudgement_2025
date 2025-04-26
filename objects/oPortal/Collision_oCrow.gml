if (oRoomLimiter.roomLimit >= oRoomLimiter.maxTeleport)
{
    room_goto(RestArea);
}
else
{
    randomize();
    var pick = irandom(4);
    oRoomLimiter.roomLimit += 1;

    if (pick == 0) room_goto(Room1);
    if (pick == 1) room_goto(Room2);
    if (pick == 2) room_goto(Room3);
    if (pick == 3) room_goto(Room4);
	if (pick == 4) room_goto(Room5);
}
