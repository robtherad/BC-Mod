// Modified F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
private ["_var"];

bc_spectator_forcedExit = true;
closeDialog 1;
["bc_spectator_tags","onEachFrame"] call bis_fnc_removeStackedEventHandler;
["bc_spectator_cams","onEachFrame"] call bis_fnc_removeStackedEventHandler;
terminate bc_spectator_updatevalues_script;
(call bc_spectator_GetCurrentCam) cameraEffect ["terminate","back"];
hintSilent "Spectator system has been forcefully closed";
{
    _var = _x getVariable ["bc_spectator_fired_eventid",nil];
    if(!isNil "_var") then {
        _x removeEventHandler ["fired",_var];
    };

} foreach (allunits + vehicles);
