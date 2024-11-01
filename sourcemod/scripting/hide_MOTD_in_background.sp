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
	UrlMotd = CreateConVar("hidden_motd_url", "about:blank", "URL to use for the hidden MOTD.", 0);
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
		if (strlen(url) == 0 || (StrContains(url, "http://") == -1 && StrContains(url, "https://") == -1))
		{
			// Define a URL como "about:blank" se a condição acima for verdadeira
			strcopy(url, sizeof(url), "about:blank");
		}

		// Cria a estrutura KeyValues para enviar a URL
		Handle kv = CreateKeyValues("data");
		KvSetString(kv, "msg", url);
		KvSetString(kv, "title", "adverts");
		KvSetNum(kv, "type", MOTDPANEL_TYPE_URL);
		
		// Mostra o painel oculto para o jogador
		ShowVGUIPanel(client, "info", kv, false); // false para manter o painel oculto
		CloseHandle(kv);
		
		// Executa o comando "chooseteam" para o cliente
		ClientCommand(client, "chooseteam");
	}

	return Plugin_Stop;
}
