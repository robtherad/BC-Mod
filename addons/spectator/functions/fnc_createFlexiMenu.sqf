/* ----------------------------------------------------------------------------
Function: bc_common_fnc_createFlexiMenu
Description:
     Internal function that create's a menu for other modules to place options into.
---------------------------------------------------------------------------- */


/*
[
    ["Menu Caption", "flexiMenu resource dialog", "optional icon folder", menuStayOpenUponSelect],
    [
        [
            "caption", 
            "action", 
            "icon", 
            "tooltip", 
            {"submenu"|["menuName", "", {0|1} (optional - use embedded list menu)]}, 
            -1 (shortcut DIK code),
            {0|1/"0"|"1"/false|true} (enabled), 
            {-1|0|1/"-1"|"0"|"1"/false|true} (visible)
        ],
    ]
]

https://dev.withsix.com/projects/cca/wiki/FlexiMenu

https://dev.withsix.com/projects/cca/wiki/Keybinding?version=20
*/

#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

Func_Populate_Menu = {
    _menus = [];
    //Grass Cutter
    _menus pushBack ["Change Default Spectator Mode", QUOTE(call FUNC(changeDefaultSpectator)), "", "Change the spectator script that you will entere when you die.", [], -1, true, true];
    if (!isNil QGVAR(currentSpectateMode)) then {
        _menus pushBack ["Switch Scripts", QUOTE(call FUNC(changeSpectator)), "", "Switch between using the F3 and EG spectator modes.", [], -1, true, true];
    };
    [
        ["BCSelfMenu1", "BC Actions", "popup"], _menus
        
        
        
        /*[
            [
                "Change Spectator Mode", 
                "_this call BC_fnc_cutGrass", 
                "", 
                "Switch between using the F3 and EG spectator modes.", 
                [],
                -1, 
                true, 
                true
            ]
        ]*/
    ];
};

_add = [
    "BC", 
    "BC_Menu", 
    ["Open BC Menu","Opens a menu with various Bravo Company actions."], 
    ["player", [], -100, "call Func_Populate_Menu"], 
    [DIK_LWIN, [false, false, false]]
] call cba_fnc_addKeybindToFleximenu;