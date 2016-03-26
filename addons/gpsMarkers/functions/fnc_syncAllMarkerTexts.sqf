/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_syncAllMarkerTexts
Description:
    For all tracked groups + vehicles, syncs marker text from the marker text variable.
Examples:
    (begin example)
        call bc_gpsMarkers_fnc_syncAllMarkerTexts;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!hasInterface) exitWith {};

// Groups
{
    _x params ["_unit", "_markerName", "_sides"];
    
    _newMarkerText = _unit getVariable [QGVAR(markerText), (markerText _markerName)];
    _markerName setMarkerTextLocal _newMarkerText;
} forEach GVAR(trackedGroups);

// Vehicles
{
    _x params ["_vehicle", "_markerName", "_sides"];
    _newMarkerText = _vehicle getVariable [QGVAR(vehMarkerText), (markerText _markerName)];
    _markerName setMarkerTextLocal _newMarkerText;
} forEach GVAR(trackedVehicles);