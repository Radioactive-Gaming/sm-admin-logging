#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define PLUGIN_VERSION "1.1.1"


public Plugin myinfo =
{
        name = "Admin logging",
        author = "vIr-Dan, Foxhound27, X8ETr1x",
        description = "Logs to admin_STEAMID",
        version = PLUGIN_VERSION,
        url = "https://forums.alliedmods.net/showthread.php?t=60471"
};

public void OnPluginStart(){
        CreateConVar("sm_al_version", PLUGIN_VERSION, "The version of 'admin logging' running.", FCVAR_SPONLY|FCVAR_REPLICATE>
}       

public Action OnLogAction(Handle source, Identity ident, int client, int target, const char[] message){
        /* If there is no client or they're not an admin, we don't care. */
        if (client < 1 || GetUserAdmin(client) == INVALID_ADMIN_ID)
        {
                return Plugin_Continue;
        }

        char logtag[64];

        /* At the moment extensions can't be passed through here yet,
         * so we only bother with plugins, and use "SM" for anything else.
         */
        if (ident == Identity_Plugin)
        {
                GetPluginFilename(source, logtag, sizeof(logtag));
        } else {
                strcopy(logtag, sizeof(logtag), "SM");
        }

        /* ':' is not a valid filesystem token on Windows so we replace
         * it with '-' to keep the file names readable.
         */
        char steamid[32];
        GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
        ReplaceString(steamid, sizeof(steamid), ":", "-");

        /* Prefix our file with the word 'admin_' */
        char file[PLATFORM_MAX_PATH];
        BuildPath(Path_SM, file, sizeof(file), "logs/admin_%s.log", steamid);

        /* Finally, write to the log file with the log tag we deduced. */
        LogToFileEx(file, "[%s] %s", logtag, message);

        /* Block Core from re-logging this. */
        return Plugin_Handled;
}
