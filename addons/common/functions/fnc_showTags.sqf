/* ----------------------------------------------------------------------------
Function: bc_nametags_fnc_showTags
Description:
    Displays nametags for players who are on the same side
Examples:
    (begin example)
        call bc_nametags_fnc_showTags;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private ["_target","_nameString"];

_target = cursorObject;
if (!isNull _target) then {
    if (player distance _target < 15) then {
        if (player isEqualTo vehicle player) then {
            if (_target isKindOf "Man") then {
                if (side group _target isEqualTo side group player)then {
                    if (alive _target) then {
                        _nameString = format ["<t size='0.375' shadow='2' font='TahomaB' color='#ba9d00'>%2<br/><t size='0.5'>%1</t></t>",name _target,groupID (group _target)];
                        [_nameString,0,1,0,0,0,4] spawn bis_fnc_dynamicText;
                    };
                };
            };
        };
    };
};