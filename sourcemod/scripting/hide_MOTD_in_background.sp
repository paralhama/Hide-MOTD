#include <sourcemod>

public Plugin:myinfo =
{
	name = "Hide MOTD in background",
	author = "Paralhama",
	description = "",
	version = "1.0",
	url = "https://github.com/paralhama/Hide-MOTD"
}

ConVar UrlMotd;

public void OnPluginStart()
{
	UrlMotd = CreateConVar("hidden_motd_url", "", "URL to use for the hidden MOTD.", 0);
}

public OnClientPutInServer(client)
{
	CreateTimer(0.5, ShowHiddenMOTD, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action ShowHiddenMOTD(Handle timer, int client)
{
	if(IsClientInGame(client) && IsClientConnected(client))
	{
		char url[PLATFORM_MAX_PATH];
		UrlMotd.GetString(url, sizeof(url));
		Handle kv = CreateKeyValues("data");
		KvSetString(kv, "msg", url);
		KvSetString(kv, "title", "adverts");
		KvSetNum(kv, "type", MOTDPANEL_TYPE_URL);
		ShowVGUIPanel(client, "info", kv, false); // last arugment of false, hides the panel
		CloseHandle(kv);
		ClientCommand(client, "chooseteam");
	}

	return Plugin_Stop;
}