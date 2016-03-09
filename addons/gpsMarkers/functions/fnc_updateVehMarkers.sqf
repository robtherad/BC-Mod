#include "script_component.hpp"

{
    _x params ["_object","_markerName","_sides"];
    private ["_object","_markerName","_sides","_unitInside","_markerText"];
    diag_log format["[updateVehMarkers] _x - %1",_x];
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