// FHQ TT:
call compile preProcessFileLineNumbers "fhqtt.sqf";
call compile preProcessFileLineNumbers "briefing.sqf";

// Se for client, para aqui...
if (!isServer) exitWith {};

waitUntil { ([] call acre_api_fnc_isInitialized) };
sleep 1;
{
  _x addItem "ACRE_PRC152";
} forEach allPlayers;
