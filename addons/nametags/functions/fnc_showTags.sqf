/* ----------------------------------------------------------------------------
Function: bc_nametags_fnc_showTags
Description:
    Call this function to begin showing nametags.
Optional Parameters:
    _color - the color of the nametags in hex color format. default: "#ba9d00" <STRING>
Examples:
    (begin example)
    (e1) // Shows nametags with default yellow color
        call bc_nametags_fnc_showTags
    (e2) // Shows WHITE nametags
        ["#ffffff"] call bc_nametags_fnc_showTags;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_color"];
private["_colorArray", "_hexArray", "_nonHexFound"];

if (!hasInterface) exitWith {};

if (!isNil QGVAR(tagHandle)) exitWith {BC_LOGERROR_1("showTags: Script already running: %1", GVAR(tagHandle));};

// Check color
if (isNil "_color") then {
    _color = "#ba9d00";
} else {
    if !(IS_STRING(_color)) then {
        BC_LOGERROR_1("showTags: Given _color was not a string, using default color: %1", _color);
        _color = "#ba9d00";
    } else {
        // Color is a string - Make sure it's a color
        // Colors must have 7 characters, start with #, all hex
        _colorArray = _color splitString "";
        _hexArray = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F"];
        {
            if !(_x in _hexArray) then {
                _nonHexFound = true;
            };
        } forEach _colorArray
        if ( !(count _colorArray isEqualTo 7) || !(_colorArray select 0 isEqualTo "#") ||  (_nonHexFound) ) then {
            BC_LOGERROR_1("showTags: Given value for _color was not a color, using default color: %1", _color);
            _color = "#ba9d00";
        };
    };
};

// Inputs processed, add tag PFH. Save handle to 
GVAR(tagHandle) = [FUNC(drawTags), 0, [_color]] call CBA_fnc_addPerFrameHandler;
