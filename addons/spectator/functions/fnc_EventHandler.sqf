// Modified F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// handles all the events. be afraid.
private ["_args", "_button", "_displayDialog", "_done", "_fullmapWindow", "_handled", "_index", "_key", "_pos", "_type", "_unit", "_y"];
_type = _this select 0;
_args = _this select 1;
_handled = true;
switch (_type) do
{
// ==================================================================
// handles the mouse.
case "MouseButtonDown":
{

    if(_args select 1 == 1 && bc_spectator_mode != 1) then {
        _button = _args select 1;
        bc_spectator_MouseButton set [_button,true];

    };
    if(_args select 1 == 1) then {
        if(bc_spectator_mode == 1) then {
            bc_spectator_ads = true;
            bc_spectator_curTarget switchCamera "gunner";
        }
    }
};
case "MouseButtonUp":
{
    if(_args select 1 == 1 && bc_spectator_mode != 1) then {
        _button = _args select 1;
        bc_spectator_MouseButton set [_button,false];
         [] spawn bc_spectator_fnc_HandleCamera;
    };
    if(_args select 1 == 1) then {
        if(bc_spectator_mode == 1) then {
            bc_spectator_ads = false;
            bc_spectator_curTarget switchCamera "internal";
        }
    }
};
case "MapZoom":
{
    bc_spectator_map_zoom = bc_spectator_map_zoom+((_args select 1)*0.05);
    if(bc_spectator_map_zoom > 0.5) then {
        bc_spectator_map_zoom = 0.5;
    };
    if(bc_spectator_map_zoom < 0.05) then {
        bc_spectator_map_zoom = 0.05;
    };
    _handled = true;
};
case "MouseMoving":
{
    _x = _args select 1;
    _y = _args select 2;
    bc_spectator_mouseCord = [_x,_y];
    [] spawn bc_spectator_fnc_HandleCamera;

};
case "MouseZChanged":
{
    if(!bc_spectator_ctrl_down) then {
        switch (bc_spectator_mode) do {
            case 0: {
                bc_spectator_zoom = ((bc_spectator_zoom - ((_args select 1)*bc_spectator_zoom/5)) max 0.1) min 650;
            };
            case 3: {
                bc_spectator_scrollHeight = (_args select 1);
            };
        };

    }
    else
    {
        bc_spectator_fovZoom = ((bc_spectator_fovZoom - ((_args select 1)*bc_spectator_fovZoom/5)) max 0.1) min 1;
    };

};

// ==================================================================
// handles dropboxes
case "LBListSelChanged":
{
    if(count bc_spectator_listUnits > (_args select 1)) then {
        _unit = bc_spectator_listUnits select (_args select 1);
        if(!isnil "_unit") then {
            if(typeName _unit == "GROUP") then {_unit = leader _unit};
            if(bc_spectator_mode == 0 || bc_spectator_mode == 1) then {
                bc_spectator_curTarget = _unit;
                if(bc_spectator_toggleCamera) then {
                  bc_spectator_curTarget switchCamera "INTERNAL";
                };
                ctrlSetText [1000,format ["Spectating:%1", name bc_spectator_curTarget]];
            };
            if(bc_spectator_mode == 3) then {
                _pos = getpos _unit;
                _x = _pos select 0;
                _y = _pos select 1;
                bc_spectator_freecamera setPosASL [_x,_y,((getposASL bc_spectator_freecamera) select 2 ) max ((getTerrainHeightASL [_x,_y])+1)];
            };
        };
    };
    ctrlEnable [2100, false];
    ctrlEnable [2100, true];
};
case "LBListSelChanged_modes":
{

    _index =  (_args select 1);
    switch (_index) do
    {
        case bc_spectator_lb_toggletiWHIndex:
        {
            bc_spectator_tiWHOn = !bc_spectator_tiWHOn;
            if(bc_spectator_tiWHOn) then {
                bc_spectator_tiBHOn = false;
                bc_spectator_nvOn = false;
                true setCamUseTi 0;
            }
            else
            {
                camUseNVG false;
                false setCamUseTi 0;
            };
            call bc_spectator_fnc_ReloadModes;

        };
        case bc_spectator_lb_toggletiBHIndex: // BlackHot
        {
            bc_spectator_tiBHOn = !bc_spectator_tiBHOn;
            if(bc_spectator_tiBHOn) then {
                camUseNVG false;
                bc_spectator_tiWHOn = false;
                bc_spectator_nvOn = false;
                true setCamUseTi 1;
            }
            else
            {
                camUseNVG false;
                false setCamUseTi 0;
            };
            call bc_spectator_fnc_ReloadModes;

        };
        case bc_spectator_lb_toggleNormal:
        {
                false setCamUseTi 0;
                camUseNVG false;
                bc_spectator_tiWHOn = false;
                bc_spectator_tiBHOn = false;
                bc_spectator_nvOn = false;
            call bc_spectator_fnc_ReloadModes;
        };
        case bc_spectator_lb_toggletiNVIndex: // Nightvision
        {
            bc_spectator_nvOn = !bc_spectator_nvOn;
            if(bc_spectator_nvOn) then {
                false setCamUseTi 0;
                camUseNVG true;
                bc_spectator_tiWHOn = false;
                bc_spectator_tiBHOn = false;
            }
            else
            {
                camUseNVG false;
                false setCamUseTi 0;
            };
            call bc_spectator_fnc_ReloadModes;

        };
    };
};
// ==================================================================
// handles keys
case "KeyDown":
{
    _key = _args select 1;
    _handled = false;
    if(!isNull (findDisplay 49)) exitWith {if(_key == 1) then {true}};
    switch (_key) do
    {
        case 78: // numpad +
        {
            bc_spectator_zoom = bc_spectator_zoom - 1;
            _handled = true;
        };
        case 1:
        {
            _handled = false;
        };
        case bc_spectator_zeusKey:
        {
            if(serverCommandAvailable "#kick" || !isNull (getAssignedCuratorLogic player) ) then {
                // handler to check when we can return to the spectator system ( when zeus interface is closed and not remoteing controlling)
                [] spawn {
                    _done = false;
                    waitUntil {sleep 0.1;!isNull (findDisplay 312)}; // wait until open
                    while {!_done} do
                    {
                        waitUntil {sleep 0.1;isNull (findDisplay 312)}; // then wait until its not open
                        if(isnil "bis_fnc_moduleRemoteControl_unit") then // check if someone is being remote controled
                        {
                            [player,player,player,0,true] spawn bc_spectator_fnc_CamInit; // if not retoggle
                            _done = true;
                        }; // restart spectator once exit.
                    };
                };
                // force exit
                [] call bc_spectator_fnc_ForceExit;


                // black out the screen
                ["bc_ScreenSetup",false] call BIS_fnc_blackOut;
                if(isNull (getAssignedCuratorLogic player)) then {
                    [[player,true,playableUnits],'bc_spectator_fnc_zeusInit',false] spawn BIS_fnc_MP;
                };
                [] spawn {
                    waitUntil {!isNull (getAssignedCuratorLogic player)};
                    ["bc_ScreenSetup"] call BIS_fnc_blackIn;
                    openCuratorInterface;
                };
                _handled = true;
            }
            else
            {
                _handled = true;
            };
        };
        case 74: // numpad -
        {
            bc_spectator_zoom = bc_spectator_zoom + 1;
            bc_spectator_zoom = 0.3 max bc_spectator_zoom;
            _handled = true;
        };
        case 20: // T
        {
            bc_spectator_tracerOn = !bc_spectator_tracerOn;
            if(bc_spectator_tracerOn) then {
                systemChat "Tracers on map activated.";
            } else {
                systemChat "Tracers on map deactivated.";
            };
            _handled = true;
        };
        case 22: // U
        {
            bc_spectator_hideUI = !bc_spectator_hideUI;
            [] spawn bc_spectator_fnc_ToggleGUI;
            _handled = true;
        };
        // Freecam movement keys
        case 17: // W
        {
            bc_spectator_freecam_buttons set [0,true];
            _handled = true;
        };
        case 31: // S
        {
            bc_spectator_freecam_buttons set [1,true];
            _handled = true;
        };
        case 30: // A
        {
            bc_spectator_freecam_buttons set [2,true];
            _handled = true;
        };
        case 32: // D
        {
            bc_spectator_freecam_buttons set [3,true];
            _handled = true;
        };
        case 49: // N
        {
            _index = (lbCurSel 2101)+1;
            if(_index >= (lbSize 2101 )) then { _index = 0};
            lbSetCurSel [2101,_index];
            _handled = true;
        };
        case 16: // Q
        {
            bc_spectator_freecam_buttons set [4,true];
            _handled = true;
        };
        case 44: // Z
        {
            bc_spectator_freecam_buttons set [5,true];
            _handled = true;
        };
        case 57: // SPACE
        {
            bc_spectator_freecamOn = !bc_spectator_freecamOn;
            if(bc_spectator_freecamOn) then {
                bc_spectator_angleY = 10;
                [bc_spectator_freecamera,bc_spectator_angleY,0] call BIS_fnc_setPitchBank;
                bc_spectator_freecamera cameraEffect ["internal", "BACK"];
                bc_spectator_mode = 3;
                bc_spectator_freecamera setPosASL getPosASL bc_spectator_camera;
                cameraEffectEnableHUD true;
                showCinemaBorder false;
            } else {
                bc_spectator_freecamera cameraEffect ["Terminate","BACK"];
                bc_spectator_angleY = 45;
                bc_spectator_camera cameraEffect ["internal", "BACK"];
                bc_spectator_mode = 0;
                cameraEffectEnableHUD true;
                showCinemaBorder false;
            };
             _handled = true;
        };

        case 35: //  H
        {
            ["Extra Keys\n\nPress 'H' or 'F1' to see this hint again.\nPress 'U' to hide the spectator UI.\nPress 'V' to hide the remaining time UI.\nPress 'Right Arrow' to make player tags bigger.\nPress 'Left Arrow' to make player tags smaller.\n\nPress 'F2' to hide this message and others like it.",15] call bc_common_fnc_hintThenClear;
            ctrlShow [1315, !ctrlVisible 1315];
            ctrlShow [1310, !ctrlVisible 1310];
            ctrlShow [1300, !ctrlVisible 1300];
            ctrlShow [1305, !ctrlVisible 1305];
             _handled = true;
        };
        case 42: // SHIFT
        {
            bc_spectator_shift_down = true;
            [] spawn bc_spectator_fnc_HandleCamera;
             _handled = true;
        };
        case 25: // P
        {
            bc_spectator_muteSpectators = !bc_spectator_muteSpectators;
            [player, bc_spectator_muteSpectators] call TFAR_fnc_forceSpectator;
            systemChat format ["Spectators Muted = %1",!bc_spectator_muteSpectators];
        };
        case 29: // CTRL
        {
            bc_spectator_ctrl_down = true;
            [] spawn bc_spectator_fnc_HandleCamera;
             _handled = true;
        };
        case 50: // M
        {
            bc_spectator_mapMode = bc_spectator_mapMode +1;
            if(bc_spectator_mapMode > 2) then {
                bc_spectator_mapMode = 0;
            };
            switch (bc_spectator_mapMode) do
            {
                // no maps
                case 0:
                {
                    ctrlShow [2110,true];
                    ctrlShow [2010,true];
                    ctrlShow [1350,false];
                    ctrlShow [1360,false];
                };

                case 1:
                {
                    ctrlShow [2110,true];
                    ctrlShow [2010,true];
                    ctrlShow [1350,true];
                    ctrlShow [1360,false];
                };
                // big map
                case 2:
                {
                    ctrlShow [2110,false];
                    ctrlShow [2010,false];
                    ctrlShow [1350,false];
                    ctrlShow [1360,true];
                    _displayDialog = (findDisplay 9228);
                    _fullmapWindow = _displayDialog displayCtrl 1360;
                    ctrlMapAnimClear _fullmapWindow;

                    _fullmapWindow ctrlMapAnimAdd [0.001, 0.1,getpos ([] call bc_spectator_GetCurrentCam)];
                    ctrlMapAnimCommit _fullmapWindow;
                };
            };
            _handled = true;
        };
        case 205: //RIGHT ARROW KEY
        {
            if (bc_spectator_tagTextSize < .05) then {
                bc_spectator_tagTextSize = bc_spectator_tagTextSize + .0005;
            } else {
                bc_spectator_tagTextSize = .05;
            };
        };
        case 203: //LEFT ARROW KEY
        {
            if (bc_spectator_tagTextSize >= 0.0005) then {
                bc_spectator_tagTextSize = bc_spectator_tagTextSize - .0005;
            } else {
                bc_spectator_tagTextSize = 0;
            };
        };
        case 59: // F1
        {
            ["Extra Keys\n\nPress 'H' or 'F1' to see this hint again.\nPress 'U' to hide the spectator UI.\nPress 'V' to hide the remaining time UI.\nPress 'Right Arrow' to make player tags bigger.\nPress 'Left Arrow' to make player tags smaller.\n\nPress 'F2' to hide this message and others like it.",15] call bc_common_fnc_hintThenClear;
        };
        case 60: // F2
        {
            hint "";
        };
        case 47: // V
        {
            bc_show_timeUI = !bc_show_timeUI;
        };
    };
    _handled
};


case "KeyUp":
{
    if(!isNull (findDisplay 49)) exitWith {};
    _key = _args select 1;
    _handled = false;
    switch (_key) do
    {
        case 42:
        {
            bc_spectator_shift_down = false;
            _handled = true;
        };
        case 1:
        {
            _handled = false;
        };
        case 29:
        {
            bc_spectator_ctrl_down = false;
            _handled = true;
        };
        case 203:
        {
            _handled = true;
        };
        case 205:
        {
            _handled = true;
        };
        case 24:
        {
            _handled = true;
        };
        case 28:
        {
            _handled = true;
        };
        case 49:
        {
            _handled = true;
        };
        case 200:
        {
            _handled = true;
        };
        case 208:
        {
            _handled = true;
        };
        case 74:
        {
            _handled = true;
        };
        case 78:
        {
            _handled = true;
        };
        case 57:
        {
            _handled = true;
        };
        case 17:
        {
            bc_spectator_freecam_buttons set [0,false];
            _handled = true;
        };
        case 31:
        {
            bc_spectator_freecam_buttons set [1,false];
            _handled = true;
        };
        case 30:
        {
            bc_spectator_freecam_buttons set [2,false];
            _handled = true;
        };
        case 32:
        {
            bc_spectator_freecam_buttons set [3,false];
            _handled = true;
        };
        case 16:
        {
            bc_spectator_freecam_buttons set [4,false];
            _handled = true;
        };
        case 44:
        {
            bc_spectator_freecam_buttons set [5,false];
            _handled = true;
        };
    };
    _handled
};
_handled
};
