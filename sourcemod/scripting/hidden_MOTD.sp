public OnClientPutInServer(client)
{
	CreateTimer(0.5, ShowHiddenMOTD, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action ShowHiddenMOTD(Handle timer, int client)
{
	if(IsClientInGame(client) && IsClientConnected(client))
	{
		Handle kv = CreateKeyValues("data");
		KvSetString(kv, "msg", "https://www.youtube.com/watch?v=2chcvo_70N0");
		KvSetString(kv, "title", "adverts");
		KvSetNum(kv, "type", MOTDPANEL_TYPE_URL);
		ShowVGUIPanel(client, "info", kv, false); // last arugment of false, hides the panel
		CloseHandle(kv);
	}

	return Plugin_Stop;
}