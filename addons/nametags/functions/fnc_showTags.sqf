/* ----------------------------------------------------------------------------
Function: bc_nametags_fnc_showTags
Description:
    Call this function to begin showing nametags.
Optional Parameters:
    nameArray - an array of values used for the name part of the nametag. format: [color, font, size, shadow] <ARRAY>
        color - the color of the nametag in hex color format. default: "#ba9d00" <STRING>
        font - the font used for the nametag. must be a font present in arma 3. default: "TahomaB" <STRING>
        size - the size of the font used for the nametag. default: 0.5 <SCALAR>
        shadow - the size of the border around the letters in the nametag. choices are 0, 1, or 2. default: 2 <SCALAR>
    groupArray - an array of values used for the name part of the nametag. format: [color, font, size, shadow] <ARRAY>
        color - the color of the nametag in hex color format. default: "#ba9d00" <STRING>
        font - the font used for the nametag. must be a font present in arma 3. default: "TahomaB" <STRING>
        size - the size of the font used for the nametag. default: 0.375 <SCALAR>
        shadow - the size of the border around the letters in the nametag. choices are 0, 1, or 2. default: 2 <SCALAR>
Examples:
    (begin example)
    (e1) // Shows nametags with default yellow color
        call bc_nametags_fnc_showTags
    (e2) // Shows WHITE name and group tags
        [["#ffffff"],["#ffffff"]] call bc_nametags_fnc_showTags;
    (e3) // Show BLACK, Zeppelin32, Size 2, Shadow 0, name and group tags.
        [["#000000","Zeppelin32",2,0], ["#000000","Zeppelin32",2,0]] call bc_nametags_fnc_showTags;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_nameArray", ["#ba9d00","TahomaB",0.5,2], [[]], [4]],
    ["_groupArray", ["#ba9d00","TahomaB",0.375,2], [[]], [4]]
];
_nameArray params [
    ["_colorName", "#ba9d00", [""]],
    ["_fontName", "TahomaB", [""]], 
    ["_sizeName", 0.5, [0]], 
    ["_shadowName", 2, [0]]
];
_groupArray params [
    ["_colorGroup", "#ba9d00", [""]],
    ["_fontGroup", "TahomaB", [""]], 
    ["_sizeGroup", 0.375, [0]], 
    ["_shadowGroup", 2, [0]]
];




private ["_hexArray", "_nonHexFound", "_colorGroupArray", "_colorNameArray", "_fontConfig", "_shadowArray", "_nameArray", "_groupArray", "_colorName", "_fontName", "_sizeName", "_shadowName", "_colorGroup", "_fontGroup", "_sizeGroup", "_shadowGroup"];
if (!hasInterface) exitWith {};

if (!isNil QGVAR(tagHandle)) exitWith {BC_LOGERROR_1("showTags: Script already running: %1", GVAR(tagHandle));};

// Set up vars
if (isNil QGVAR(fontArray)) then {
    _fontConfig = configProperties [configFile >> "CfgFontFamilies"];
    GVAR(fontArray) = [];
    {
        if !(configName _x isEqualTo "access") then {
            GVAR(fontArray) pushBack (configName (_x));
        };
    } forEach _fontConfig;
};
_shadowArray = [0, 1, 2];
_hexArray = ["#","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F"];

// TODO: Rewrite this so the defaults aren't hardcoded. Use XEH_PreInit to define the defaults for each array.

// Validate inputs
if (isNil "_nameArray") then {
    _colorName = "#ba9d00";
    _fontName = "TahomaB";
    _sizeName = 0.5;
    _shadowName = 2;
} else {
    if (IS_ARRAY(_nameArray)) then {
        if (isNil "_colorName") then {
            _colorName = "#ba9d00";
        } else {
            if !(IS_STRING(_colorName)) then {
                BC_LOGERROR_1("showTags: Given _colorName was not a string, using default color: %1", _colorName);
                _colorName = "#ba9d00";
            } else {
                // Color is a string - Make sure it's a color
                // Colors must have 7 characters, start with #, all hex
                _colorNameArray = _colorName splitString "";
                _nonHexFound = false;
                {
                    if !(_x in _hexArray) then {
                        _nonHexFound = true;
                    };
                } forEach _colorNameArray;
                if ( !(count _colorNameArray isEqualTo 7) || !(_colorNameArray select 0 isEqualTo "#") ||  (_nonHexFound) ) then {
                    BC_LOGERROR_4("showTags: Given value for _colorName was not a color: %1 -- count: %2 -- 1st value: %3 -- nonHex: %4", _colorName,count _colorNameArray,_colorNameArray select 0,_nonHexFound);
                    _colorName = "#ba9d00";
                };
            };
        };
        if (isNil "_fontName") then {
            _fontName = "TahomaB";
        } else {
            if !(_fontName in GVAR(fontArray)) then {
                _fontName = "TahomaB";
            };
        };
        if (isNil "_sizeName") then {
            _sizeName = 0.5;
        } else {
            if (!IS_SCALAR(_sizeName)) then {
                BC_LOGERROR_1("showTags: Given _sizeName was not a number, using default _sizeName: %1", _sizeName);
                _sizeName = 0.5;
            };
        };
        if (isNil "_shadowName") then {
            _shadowName = 2;
        } else {
            if !(_shadowName in _shadowArray) then {
                _shadowName = 2;
                BC_LOGERROR_1("showTags: Given _shadowName was not a valid choice, using default _shadowName: %1", _shadowName);
            };
        };
    } else {
        BC_LOGERROR_1("showTags: _nameArray wasn't an array: %1", _nameArray);
        _colorName = "#ba9d00";
        _fontName = "TahomaB";
        _sizeName = 0.5;
        _shadowName = 2;
    };
};

if (isNil "_groupArray") then {
    _colorGroup = "#ba9d00";
    _fontGroup = "TahomaB";
    _sizeGroup = 0.375;
    _shadowGroup = 2;
} else {
    if (IS_ARRAY(_groupArray)) then {
        if (isNil "_colorGroup") then {
            _colorGroup = "#ba9d00";
        } else {
            if !(IS_STRING(_colorGroup)) then {
                BC_LOGERROR_1("showTags: Given _colorGroup was not a string, using default color: %1", _colorGroup);
                _colorGroup = "#ba9d00";
            } else {
                // Color is a string - Make sure it's a color
                // Colors must have 7 characters, start with #, all hex
                _colorGroupArray = _colorGroup splitString "";
                _nonHexFound = false;
                {
                    if !(_x in _hexArray) then {
                        _nonHexFound = true;
                    };
                } forEach _colorGroupArray;
                if ( !(count _colorGroupArray isEqualTo 7) || !(_colorGroupArray select 0 isEqualTo "#") ||  (_nonHexFound) ) then {
                    BC_LOGERROR_4("showTags: Given value for _colorGroup was not a color: %1 -- count: %2 -- 1st value: %3 -- nonHex: %4", _colorGroup,count _colorGroupArray,_colorGroupArray select 0,_nonHexFound);
                    _colorGroup = "#ba9d00";
                };
            };
        };
        if (isNil "_fontGroup") then {
            _fontGroup = "TahomaB";
        } else {
            if !(_fontGroup in GVAR(fontArray)) then {
                _fontGroup = "TahomaB";
            };
        };
        if (isNil "_sizeGroup") then {
            _sizeGroup = 0.375;
        } else {
            if (!IS_SCALAR(_sizeGroup)) then {
                BC_LOGERROR_1("showTags: Given _sizeGroup was not a number, using default _sizeGroup: %1", _sizeGroup);
                _sizeGroup = 0.375;
            };
        };
        if (isNil "_shadowGroup") then {
            _shadowGroup = 2;
        } else {
            if !(_shadowGroup in _shadowArray) then {
                _shadowGroup = 2;
                BC_LOGERROR_1("showTags: Given _shadowGroup was not a valid choice, using default _shadowGroup: %1", _shadowGroup);
            };
        };
    } else {
        BC_LOGERROR_1("showTags: _groupArray wasn't an array: %1", _groupArray);
        _colorGroup = "#ba9d00";
        _fontGroup = "TahomaB";
        _sizeGroup = 0.375;
        _shadowGroup = 2;
    };
};

// Create containers
_nameArray = [_colorName, _fontName, _sizeName, _shadowName];
_groupArray = [_colorGroup, _fontGroup, _sizeGroup, _shadowGroup];

// Inputs processed, add tag PFH. Save handle to 
GVAR(tagHandle) = [FUNC(drawTags), 0, [_nameArray,_groupArray]] call CBA_fnc_addPerFrameHandler;
