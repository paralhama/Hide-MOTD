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
	if (IsClientInGame(client) && IsClientConnected(client))
	{
		char url[PLATFORM_MAX_PATH];
		UrlMotd.GetString(url, sizeof(url));

		// Verifica se a URL está vazia ou não contém "http://" ou "https://"
		if (strlen(url) != 0 && (StrContains(url, "http://") == -1 && StrContains(url, "https://") == -1))
		{
			// Mostra "erro de ConVar" no painel MOTD
			ShowMOTDPanel(client, "Error", "\n\n\n\n\n\n\n\n\n\n\n\"hidden_motd_url\" must contain a URL with \"http://\" or \"https://\" in your server.cfg.\nExample: hidden_motd_url \"https://google.com\"\n( Change the map to apply the changes. )", MOTDPANEL_TYPE_TEXT);
		}
		else if (strlen(url) == 0)
		{
			// Mostra "erro de ConVar" no painel MOTD
			ShowMOTDPanel(client, "Error", "\n\n\n\n\n\n\n\n\n\n\nThe ConVar \"hidden_motd_url\" is empty or does not exist in your server.cfg.\nEnter a URL with \"http://\" or \"https://\"\nExample: hidden_motd_url \"https://google.com\"\n( Change the map to apply the changes. )", MOTDPANEL_TYPE_TEXT);
		}
		else
		{
			Handle kv = CreateKeyValues("data");
			KvSetString(kv, "msg", url);
			KvSetString(kv, "title", "adverts");
			KvSetNum(kv, "type", MOTDPANEL_TYPE_URL);
			ShowVGUIPanel(client, "info", kv, false); // último argumento "false" para ocultar o MOTD
			CloseHandle(kv);
			ClientCommand(client, "chooseteam");
		}
	}

	return Plugin_Stop;
}
