enableSaving [false, false];

// FHQ TT:
call compile preProcessFileLineNumbers "scripts\fhqtt.sqf";
call compile preProcessFileLineNumbers "scripts\briefing.sqf";

[false, false] call acre_api_fnc_setupMission;

[] execVM "aegis\init.sqf";
