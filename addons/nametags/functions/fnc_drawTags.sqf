/* ----------------------------------------------------------------------------
Function: bc_nametags_fnc_drawTags
Description:
    Internal function. Checks conditions for and handles drawing the nametags.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args"];
_args params ["_nameArray", "_groupArray"];
_nameArray params ["_colorName", "_fontName", "_sizeName", "_shadowName"];
_groupArray params ["_colorGroup", "_fontGroup", "_sizeGroup", "_shadowGroup"];
private ["_target","_textString"];

_target = cursorObject;
if (!isNull _target) then {
    if (player distance _target < 15) then {
        if (player isEqualTo vehicle player) then {
            if (_target isKindOf "Man") then {
                if (side group _target isEqualTo side group player)then {
                    if (alive _target) then {
                        _textString = format ["<t size='%2' shadow='%3' font='%4' color='%5'>%1<br/></t><t size='%7' shadow='%8' font='%9' color='%10'>%6</t>", groupID (group _target), _sizeGroup, _shadowGroup, _fontGroup, _colorGroup, name _target, _sizeName, _shadowName, _fontName, _colorName];
                        [_textString,0,1,0,0,0,4] spawn bis_fnc_dynamicText;
                    };
                };
            };
        };
    };
};