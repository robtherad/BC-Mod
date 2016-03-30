// Modified F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
//[this,objNull,0,0,true] call bc_spectator_fnc_camInit;
// params
#include "script_component.hpp"

_this spawn {
private["_forced", "_oldUnit", "_unit"];
_unit = [_this, 0, player,[objNull]] call BIS_fnc_param;
_oldUnit = [_this, 1, objNull,[objNull]] call BIS_fnc_param;
_forced = [_this, 4, false,[false]] call BIS_fnc_param;
if(isNil "bc_spectator_isJIP") then { bc_spectator_isJIP = false; };
// if they are jip, these are null
if(isNull _unit ) then {_unit = cameraOn;bc_spectator_isJIP=true;};
// escape the script if you are not a seagull unless forced
if (typeof _unit != "seagull" && !_forced || !hasInterface) ExitWith {};
// disable this to instantly switch to the spectator script.
waituntil {missionnamespace getvariable ["BIS_fnc_feedback_allowDeathScreen",true] || isNull (_oldUnit) || bc_spectator_isJIP || _forced };


GVAR(currentSpectateMode) = 0;

// ====================================================================================

if(!isnil "BIS_fnc_feedback_allowPP") then {
  // disable effects death effects
  BIS_fnc_feedback_allowPP = false;
};

if(bc_spectator_isJIP || _forced) then {
  ["bc_ScreenSetup",false] call BIS_fnc_blackOut;
  systemChat "Initializing Spectator Script";
  uiSleep 3;
  ["bc_ScreenSetup"] call BIS_fnc_blackIn;
};

// Create a Virtual Agent to act as our player to make sure we get to keep Draw3D
if(isNil "bc_spectator_VirtualCreated") then {
  private ["_newUnit", "_newGrp"];
  createCenter sideLogic;
  _newGrp = createGroup sideLogic;
  _newUnit = _newGrp createUnit ["VirtualCurator_F", [0,0,5], [], 0, "FORM"];
  _newUnit allowDamage false;
  _newUnit hideObjectGlobal true;
  _newUnit enableSimulationGlobal false;
  _newUnit setpos [0,0,5];
  selectPlayer _newUnit;
  waituntil{player == _newUnit};
  deleteVehicle _unit;
  bc_spectator_VirtualCreated = true;
};

private ["_oldUnit"];
if(isNull _oldUnit ) then {if(count playableUnits > 0) then {_oldUnit = (playableUnits select 0)} else {_oldUnit = (allUnits select 0)};};
if (isNil "_oldUnit") then {
    createCenter civilian;
    _grp = createGroup civilian;
    _oldUnit = _grp createUnit ["C_man_1", [0,0,5], [], 0, "FORM"];
    //_oldUnit enableSimulationGlobal false;
    _oldUnit disableAI "MOVE";
    _oldUnit allowDamage false;
};
// ====================================================================================

// Set spectator mode for whichever radio system is in use
[player, true] call TFAR_fnc_forceSpectator;
// ====================================================================================

private ["_listBox"];
_listBox = 2100;
lbClear _listBox;
// set inital values.
#include "macros.hpp"
bc_spectator_controls = [BC_SPECTATOR_HELPFRAME,BC_SPECTATOR_HELPBACK,BC_SPECTATOR_MOUSEHANDLER,BC_SPECTATOR_UNITLIST,BC_SPECTATOR_MODESCOMBO,BC_SPECTATOR_SPECTEXT,BC_SPECTATOR_SPECHELP,BC_SPECTATOR_HELPCANCEL,BC_SPECTATOR_HELPCANCEL,BC_SPECTATOR_MINIMAP,BC_SPECTATOR_FULLMAP,BC_SPECTATOR_BUTTIONFILTER,BC_SPECTATOR_BUTTIONTAGS,BC_SPECTATOR_BUTTIONTAGSNAME,BC_SPECTATOR_BUTTIONFIRSTPERSON,BC_SPECTATOR_DIVIDER];
bc_spectator_units = [];
bc_spectator_players = [];
bc_spectator_startX = 0;
bc_spectator_startY = 0;
bc_spectator_detlaX = 0;
bc_spectator_detlaY = 0;
bc_spectator_zoom = 0;
bc_spectator_hideUI = false;
bc_spectator_map_zoom = 0.5;
bc_spectator_mode = 0;
bc_spectator_toggleCamera = false;
bc_spectator_playersOnly = false;
bc_spectator_toggleTags = true;
bc_spectator_ads = false;
bc_spectator_nvOn = false;
bc_spectator_tiBHOn = false;
bc_spectator_tiWHOn = false;
bc_spectator_tagsEvent = -1;
bc_spectator_mShift = false;
bc_spectator_freecamOn = false;
bc_spectator_toggleTagsName = true;
bc_spectator_mapMode = 0;
bc_spectator_MouseButton = [false,false];
bc_spectator_mouseCord = [0.5,0.5];
bc_spectator_mouseDeltaX = 0.5;
bc_spectator_mouseDeltaY = 0.5;
bc_spectator_mouseLastX = 0.5;
bc_spectator_mouseLastY = 0.5;
bc_spectator_angleYcached  = 0;
bc_spectator_angleX = 0;
bc_spectator_tracerOn = false;
bc_spectator_angleY = 60;
bc_spectator_ctrl_down = false;
bc_spectator_shift_down = false;
bc_spectator_freecam_buttons = [false,false,false,false,false,false];
bc_spectator_forcedExit = false;
bc_freecam_x_speed = 0;
bc_freecam_y_speed = 0;
bc_freecam_z_speed = 0;
bc_spectator_tagTextSize = 0.025;
bc_show_timeUI = true;

bc_spectator_timestamp = time;
bc_spectator_muteSpectators = true;

// ====================================================================================
// Menu (Top left)
bc_spectator_menuControls = [2111,2112,2113,2114,2101,4302];
bc_spectator_menuShownTime = 0;
bc_spectator_menuShown = true;
bc_spectator_menuWorking = false;
bc_spectator_sideButton = 0; // 0 = ALL, 1 = BLUFOR , 2 = OPFOR, 3 = INDFOR , 4 = Civ
bc_spectator_sideNames = ["All Sides","Blufor","Opfor","Indfor","Civ"];
// ====================================================================================
// Colors

bc_spectator_blufor_color = [BLUFOR] call bis_fnc_sideColor;
bc_spectator_opfor_color = [OPFOR] call bis_fnc_sideColor;
bc_spectator_indep_color = [independent] call bis_fnc_sideColor;
bc_spectator_civ_color = [civilian] call bis_fnc_sideColor;
bc_spectator_empty_color = [sideUnknown] call bis_fnc_sideColor;
bc_spectator_gray_color = [0.75,0.75,0.75,1];

// ================================
// Camera
bc_spectator_angle = 360;
bc_spectator_zoom = 3;
bc_spectator_height = 3;
bc_spectator_fovZoom = 1.2;
bc_spectator_scrollHeight = 0;
bc_spectator_cameraMode = 0; // set camera mode (default)
// ====================================================================================

bc_spectator_listUnits = [];

bc_spectator_ToggleFPCamera = {
    bc_spectator_toggleCamera = !bc_spectator_toggleCamera;
    if(bc_spectator_toggleCamera) then {
        bc_spectator_mode = 1; //(view)
        bc_spectator_camera cameraEffect ["terminate", "BACK"];
        bc_spectator_curTarget switchCamera "internal";
    }
    else
    {
        bc_spectator_mode = 0;
        bc_spectator_camera cameraEffect ["internal", "BACK"];
    };
    call bc_spectator_fnc_ReloadModes;
};
bc_spectator_GetCurrentCam = {
  private ["_camera"];
  _camera = bc_spectator_camera;
  switch(bc_spectator_mode) do
  {
    case 0:
    {
        _camera = bc_spectator_camera; // Standard
    };
    case 1:
    {
      _camera = cameraOn; // FP
    };
    case 3:
    {
      _camera = bc_spectator_freecamera; // freecam
    };
  };
  _camera
};


// =============================================================================

// create the UI
createDialog "bc_spec_dialog";
// add keyboard events
// hide minimap
((findDisplay 9228) displayCtrl 1350) ctrlShow false;
((findDisplay 9228) displayCtrl 1350) mapCenterOnCamera false;

// hide big map
((findDisplay 9228) displayCtrl 1360) ctrlShow false;
((findDisplay 9228) displayCtrl 1360) mapCenterOnCamera false;

["Extra Keys\n\nPress 'H' or 'F1' to see this hint again.\nPress 'U' to hide the spectator UI.\nPress 'V' to hide the remaining time UI.\nPress 'Right Arrow' to make player tags bigger.\nPress 'Left Arrow' to make player tags smaller.\n\nPress 'F2' to hide this message and others like it.",15] call bc_common_fnc_hintThenClear;
bc_spectator_helptext = "<t color='#EAA724'>Press F1 to see more keys.<br />Hold right-click to pan the camera.<br />Use the scroll wheel or numpad+/- to zoom in and out.<br />Use ctrl + rightclick to fov zoom<br />Press H to show and close the help window.<br />Press M to toggle between no map,minimap and full size map.<br />T for switching on tracers on the map<br/>Space to switch to freecam <br/>Use the left and right arrow keys to adjust size of player tags.</t>";
((findDisplay 9228) displayCtrl 1310) ctrlSetStructuredText parseText (bc_spectator_helptext);
// create the camera and set it up.
bc_spectator_camera = "camera" camCreate [position _oldUnit select 0,position _oldUnit select 1,3];

bc_spectator_fakecamera = "camera" camCreate [position _oldUnit select 0,position _oldUnit select 1,3];

bc_spectator_curTarget = _oldUnit;
bc_spectator_freecamera = "camera" camCreate [position _oldUnit select 0,position _oldUnit select 1,3];
bc_spectator_camera camCommit 0;
bc_spectator_fakecamera camCommit 0;
bc_spectator_camera cameraEffect ["internal","back"];
bc_spectator_camera camSetTarget bc_spectator_fakecamera;
bc_spectator_camera camSetFov 1.2;
bc_spectator_freecamera camSetFov 1.2;
bc_spectator_zeusKey = 21;
if( count (actionKeys "curatorInterface") > 0 ) then {
    bc_spectator_zeusKey = (actionKeys "curatorInterface") select 0;
};
bc_spectator_MouseMoving = false;
cameraEffectEnableHUD true;
showCinemaBorder false;
bc_spectator_fired = [];
{
  private ["_event"];
  _event = _x addEventHandler ["fired",{bc_spectator_fired = bc_spectator_fired - [objNull];bc_spectator_fired pushBack (_this select 6)}];
  _x setVariable ["bc_spectator_fired_eventid",_event];

} foreach (allunits + vehicles);
// ====================================================================================
// spawn sub scripts
call bc_spectator_fnc_ReloadModes;
lbSetCurSel [2101,0];
//bc_spectator_freeCam_script = [] spawn bc_spectator_fnc_FreeCam;
bc_spectator_updatevalues_script = [] spawn bc_spectator_fnc_UpdateValues;
 ["bc_spectator_tags", "onEachFrame", {_this call bc_spectator_fnc_DrawTags}] call BIS_fnc_addStackedEventHandler;
 ["bc_spectator_cams", "onEachFrame", {_this call bc_spectator_fnc_FreeCam}] call BIS_fnc_addStackedEventHandler;
};
