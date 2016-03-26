/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_createMarker
Description:
    Internal function. Handles creating a marker for the unit then adds it to the array of tracked units.
Parameters:
    _object - the unit <OBJECT>
    _sides - the side(s) the marker will be visible to <SIDE> OR <ARRAY> of <SIDE>s
    _type - uses <obj> isKindOf <x>
    _group - the group of the unit. if the unit is a vehicle, grpNull
Examples:
    (begin example)
        [_object,_sides,_type, _group] call bc_gpsMarkers_fnc_createMarker;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_object","_sides","_type", "_group", "_name"];
private ["_object","_sides","_type","_group","_markerName","_sizeMarkOptions","_groupSize","_markerPos","_markerSide","_marker","_markerName2","_sizeMarker","_objectSide","_typeNum","_markerString", "_markerText"];

// Create an infantry marker
if (_type == "Man") then {
    _markerName = "bc_gpsMarker_inf_" + str( GVAR(gpsIterator) );
    INC(GVAR(gpsIterator));
    
    _sizeMarkOptions = ["group_0","group_2","group_3","group_4","Empty"];
    _groupSize = _group getVariable ["bc_gps_groupSize",4];
    _markerPos = getPos (leader _group);
    _markerSide = switch (side (leader _group)) do {
        case west: { ["ColorBLUFOR","b_inf"] };
        case east: { ["ColorOPFOR","b_inf"] };
        case independent: { ["ColorGUER","b_inf"] };
        case civilian: { ["ColorCivilian","b_inf"] };
        default { ["ColorUNKNOWN","b_inf"] };
    };
    if (!isNil "_name") then {
        _markerText = _name;
        _group setVariable [QGVAR(markerText), _markerText];
    } else {
        _markerText = _group getVariable [QGVAR(markerText), nil];
        if (isNil "_markerText") then {
            _markerText = (groupID _group);
            _group setVariable [QGVAR(markerText), _markerText];
        };
    };
    
    
    // Main Marker
    _marker = createMarkerLocal [_markerName,_markerPos];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerColorLocal (_markerSide select 0);
    _marker setMarkerTypeLocal (_markerSide select 1);
    _marker setMarkerSizeLocal [.75,.75];
    _marker setMarkerTextLocal _markerText;
    _marker setMarkerAlphaLocal 0;
    
    // NATO Pip Marker
    _markerName2 = _markerName + "Size";
    _sizeMarker = createMarkerLocal [_markerName2,_markerPos];
    _sizeMarker setMarkerShapeLocal "ICON";
    _sizeMarker setMarkerTypeLocal (_sizeMarkOptions select _groupSize);
    _sizeMarker setMarkerSizeLocal [.75,.75];
    _sizeMarker setMarkerAlphaLocal 0;
    
    // Convert _sides to array if it's not already
    if (typeName _sides == "SIDE") then {_sides = [_sides];};
    
    _group setVariable [QGVAR(markerName), _markerName];
    
    GVAR(trackedGroups) pushBackUnique [_group,_markerName,_sides];
    GVAR(trackedGroupsList) pushBackUnique _group;
} else {
// Create a non-infantry marker
    _markerName = "bc_gpsMarker_veh_" + str( GVAR(gpsIterator) );
    INC(GVAR(gpsIterator));
    _markerPos = getPos _object;
    
    // Determine which color + icon to use
    _objectSide = _object getVariable ["bc_objectSide",nil];
    if ((typeName _sides isEqualTo "SIDE") && (isNil "_objectSide")) then {_objectSide = _sides;};
    _markerSide = switch (_objectSide) do {
        case west: { ["ColorBLUFOR","b_armor","b_air","b_plane","b_unknown"] };
        case east: { ["ColorOPFOR","b_armor","b_air","b_plane","b_unknown"] };
        case independent: { ["ColorGUER","b_armor","b_air","b_plane","b_unknown"] };
        case civilian: { ["ColorCivilian","b_armor","b_air","b_plane","b_unknown"] };
        default { ["ColorUNKNOWN","b_armor","b_air","b_plane","b_unknown"] };
    };
    _typeNum = switch (_type) do {
        case "LandVehicle": { 1 }; 
        case "Helicopter": { 2 }; 
        case "Plane": { 3 }; 
        default { 4 };
    };
    
    // Create marker
    _marker = createMarkerLocal [_markerName,_markerPos];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerColorLocal (_markerSide select 0);
    _marker setMarkerTypeLocal (_markerSide select _typeNum);
    
    // Set up marker name for vehicle
    _markerString = _object getVariable QGVAR(vehMarkerText);
    if (!isNil "_markerString") then {
        _marker setMarkerTextLocal _markerString;
    } else {
        _marker setMarkerTextLocal str(_object);
        _object setVariable [QGVAR(vehMarkerText),str(_object)];
    };
    
    _marker setMarkerSizeLocal [.75,.75];
    _marker setMarkerAlphaLocal 0;
    
    // Convert _sides to array if it's not already
    if (typeName _sides isEqualTo "SIDE") then {_sides = [_sides];};
    
    _object setVariable [QGVAR(markerName), _markerName];
    
    GVAR(trackedVehicles) pushBackUnique [_object,_markerName,_sides];
    GVAR(trackedVehiclesList) pushBackUnique _object;
};