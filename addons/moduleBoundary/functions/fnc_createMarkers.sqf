/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_singlePosCheck
Description:
    Internal function. Gets called by checkBoundsPFH for boundaries where type is 1 or 2.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_positions","_color"];

private _posCount = (count _positions) - 1;
private _j = [];
private _markerThickness = 1;

if !(_posCount isEqualTo 0) then{
    // Polygon
    for "_i" from 0 to (_posCount) do {
        if (_i isEqualTo _posCount) then {_j = 0;} else {_j = _i + 1;};
        private _pos1 = (_positions select _i);
        private _pos2 = (_positions select _j);
        
        private _dist = (_pos1 distance2D _pos2);
        private _dir = _pos1 getDir _pos2;
        private _mkrPos = _pos1 getPos [_dist/2, _dir];
        
        private _count = count GVAR(markerArray);
        private _mkrName = format["areaBoundaryMark_%1",_count];
        private _mkr = createMarker [_mkrName, _mkrPos];
        _mkr setMarkerDir _dir+90;
        _mkr setMarkerShape "RECTANGLE";
        _mkr setMarkerSize [_dist/ 2, _markerThickness];
        _mkr setMarkerColor _color;
        _mkr setMarkerBrush "Solid";
        
        GVAR(markerArray) pushBack _mkr;
    };
} else {
    // Trigger
    private _triggerVars = triggerArea (_positions select 0);
    
    private _count = count GVAR(markerArray);
    private _mkrName = format["areaBoundaryMark_%1",_count];
    private _mkr = createMarker [_mkrName, (getPos (_positions select 0))];
    _mkr setMarkerDir (_triggerVars select 2);
    if (_triggerVars select 3) then {
        _mkr setMarkerShape "RECTANGLE";
    } else {
        _mkr setMarkerShape "ELLIPSE";
    };
    _mkr setMarkerSize [_triggerVars select 0, _triggerVars select 1];
    _mkr setMarkerColor _color;
    _mkr setMarkerBrush "Border";
    
    GVAR(markerArray) pushBack _mkr;
};