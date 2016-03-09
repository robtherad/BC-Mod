#include "script_component.hpp"
diag_log _this;
params ["_object","_sides","_type", "_group"];
private ["_object","_sides","_type","_group","_markerName","_sizeMarkOptions","_groupSize","_markerPos","_markerSide","_marker","_markerName2","_sizeMarker","_objectSide","_typeNum"];
// Create an infantry marker
if (_type == "Man") then {
    _markerName = "bc_gpsMarker_grp_" + str( count GVAR(trackedGroups) );
    
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
    
    // Main Marker
    _marker = createMarkerLocal [_markerName,_markerPos];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerColorLocal (_markerSide select 0);
    _marker setMarkerTypeLocal (_markerSide select 1);
    _marker setMarkerSizeLocal [.75,.75];
    _marker setMarkerTextLocal (groupID _group);
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
    
    GVAR(trackedGroups) pushBack [_group,_markerName,_sides];
    GVAR(trackedGroupsList) pushBack _group;
} else {
// Create a non-infantry marker
    _markerName = "bc_gpsMarker_veh_" + str( count GVAR(trackedVehicles) );
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
    
    GVAR(trackedVehicles) pushBack [_object,_markerName,_sides];
    GVAR(trackedVehiclesList) pushBack _object;
};