/* ----------------------------------------------------------------------------
Function: bc_marker_tracker_fnc_addMarkerEHs
Description:
    Adds event handlers to clients to watch for key presses that correspond with marker placement/deletion.
Author:
    KillzoneKid - http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private["_i", "_mrkdetails", "_mrknames"];

scopeName "func";
waitUntil {
    if (
        _this == 53 && getClientState == "BRIEFING READ"
    ) then {
        breakOut "func";
    };
    !isNull findDisplay _this
};
findDisplay _this displayAddEventHandler [
    "KeyDown", 
    {
        if (_this select 1 == 211) then {
            _mrknames = allMapMarkers;
            _mrkdetails = [];
            {
                _mrkdetails pushBack (
                    _x call FUNC(collectMarkerInfo)
                );
            } forEach _mrknames;
            0 = [_mrknames, _mrkdetails] spawn {
                _mrknames = _this select 0;
                _mrkdetails = _this select 1;
                GVAR(markerPV) = [
                    "Deleted",
                    player,
                    getplayerUID player
                ];
                {
                    _i = _mrknames find _x;
                    if (_i > -1) then {
                        GVAR(markerPV) pushBack (_mrkdetails select _i);
                    };
                } forEach (_mrknames - allMapMarkers);
                if (count GVAR(markerPV) > 3) then {
                    if (!isServer) then {
                        publicVariableServer QGVAR(markerPV);
                    } else {
                        // Player is server
                        GVAR(markerPV) call FUNC(pvehAction);
                    };
                };
            };
            false
        };
    }
];
findDisplay _this displayAddEventHandler [
    "ChildDestroyed", 
    {
        if (
            ctrlIdd (_this select 1) == 54 && _this select 2 == 1
        ) then {
            0 = all_mrkrs spawn {
                GVAR(markerPV) = [
                    "Placed",
                    player,
                    getplayerUID player
                ];
                {
                    GVAR(markerPV) pushBack (
                        _x call FUNC(collectMarkerInfo)
                    );      
                } forEach (allMapMarkers - _this);
                if (count GVAR(markerPV) > 3) then {
                    if (!isServer) then {
                        publicVariableServer QGVAR(markerPV);
                    } else {
                        // Player is server
                        GVAR(markerPV) call FUNC(pvehAction);
                    };
                };  
            };
        };
    }
];
findDisplay _this displayCtrl 51 ctrlAddEventHandler [
    "MouseButtonDblClick", 
    {
        0 = 0 spawn {
            if (!isNull findDisplay 54) then {
                findDisplay 54 displayCtrl 1 
                    buttonSetAction "all_mrkrs = allMapMarkers";
            };
        };
    }
];