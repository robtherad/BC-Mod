// Check if this unit was respawned.
if (_this getVariable ['tmf_isRespawnUnit',false]) exitWith {};

_this spawn {
    waitUntil {!([] call BIS_fnc_isLoading)};
    sleep 2;
    [_this, objNull, true] call tmf_spectator_fnc_init;
    systemChat "You joined the mission in progress. Entering spectator.";
    deleteVehicle _this;
};