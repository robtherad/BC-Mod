/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_updateVehMarkers
Description:
    Internal function. Updates the state of markers attached to vehicles.
Examples:
    (begin example)
        call bc_gpsMarkers_fnc_updateVehMarkers;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

{ //forEach GVAR(trackedVehicles)
    _x params ["_object","_markerName","_sides"];
    private ["_object","_markerName","_sides","_unitInside","_markerText"];
    if ("ItemGPS" in (assignedItems player)) then {
        _unitInside = _object getVariable [QGVAR(unitInsideVeh),nil];
        //Check to see if any units with markers attached are in a vehicle with a marker. If so attach their name to the vehicle marker.
        if (!isNil "_unitInside") then {
            _markerText = (_object getVariable QGVAR(vehMarkerText)) + " (" + (_object getVariable QGVAR(unitInsideVeh)) + ")";
            _object setVariable [QGVAR(unitInsideVeh),nil];
            _object setVariable [QGVAR(lastInsideVeh),nil];
            _markerName setMarkerTextLocal _markerText;
        } else {
            _markerText = (_object getVariable QGVAR(vehMarkerText));
            _markerName setMarkerTextLocal _markerText;
        };
        _markerName setMarkerAlphaLocal 1;
        _markerName setMarkerPosLocal (getPos _object);
    } else {
        _markerName setMarkerAlphaLocal 0;
    };
} forEach GVAR(trackedVehicles);