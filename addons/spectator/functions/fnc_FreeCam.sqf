// Modified F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
private ["_commitTime","_delta","_zLevel","_pos","_visPos","_mode","_currPos","_mX","_mY","_mZ","_accel","_accelshift","_scroll","_y","_z","_height","_newHeight"];
// Menu shown/hidden
if(abs (bc_spectator_menuShownTime - time) <= 0.1 && !bc_spectator_menuShown) then // disable due to being a bit wonky
{
    [true] spawn bc_spectator_fnc_showMenu;
};
if(abs (bc_spectator_menuShownTime - time) >= 1 && bc_spectator_menuShown) then // disable due to being a bit wonky
{
    [false] spawn bc_spectator_fnc_showMenu;
};


// ====================================================================================
// if freemode.
bc_spectator_camera camSetFov bc_spectator_fovZoom;
if(bc_spectator_mode == 0) then {
        cameraEffectEnableHUD true;
        _commitTime = ((1.0 - ((speed vehicle bc_spectator_curTarget)/65))/3) max 0.1;
        _delta = (-(2*(0.3 max bc_spectator_zoom)));
        _zLevel = sin(bc_spectator_angleY)*(2*(0.3 max bc_spectator_zoom));
        //_pos = getpos bc_spectator_curTarget;
        _visPos = visiblePositionASL bc_spectator_curTarget;
        if(!(surfaceIsWater _visPos)) then {_visPos = ASLtoATL (_visPos)};
        bc_spectator_fakecamera camSetPos [_visPos select 0,_visPos select 1,(_visPos select 2) + 1.5];
        bc_spectator_fakecamera camCommit _commitTime;
        bc_spectator_camera camSetRelPos[(sin(bc_spectator_angleX)*_delta)*cos(bc_spectator_angleY), (cos(bc_spectator_angleX)*_delta)*cos(bc_spectator_angleY), _zLevel];
        bc_spectator_camera camCommit _commitTime;
};
// first person
if(bc_spectator_mode == 1) then {
//        player setpos (getpos cameraOn);
    if(vehicle cameraOn != cameraOn) then
    {
        _mode = "internal";
        if(gunner (vehicle cameraon) == cameraon) then {_mode = "gunner"};
        if(driver (vehicle cameraon) == cameraon) then {_mode = "gunner"};
        if(commander (vehicle cameraon) == cameraon) then {_mode = "gunner"};
        vehicle cameraOn switchCamera _mode;
    };
    if(vehicle cameraOn == cameraOn && !bc_spectator_ads) then
    {
        cameraon switchCamera "internal";
    };
};
if(bc_spectator_mode == 3) then {
    _delta = (time - bc_spectator_timestamp)*10;
    bc_spectator_freecamera camSetFov bc_spectator_fovZoom;
    _currPos = getposASL bc_spectator_freecamera;
    _mX = 0;
    _mY = 0;
    _mZ = 0;
    _height = 0 max (((getPosATL bc_spectator_freecamera) select 2));
    _accel = 0.2 max (_height/8); // 0.8
    _accelshift = _accel*4.25;//2;
    if(bc_spectator_freecam_buttons select 0) then // W
    {
        if(bc_spectator_shift_down) then
        {
            _mY = _accelshift;
        }
        else
        {
            _mY = _accel;
        };
    };
    if(bc_spectator_freecam_buttons select 1) then // S
    {
        if(bc_spectator_shift_down) then
        {
            _mY = -_accelshift;
        }
        else
        {
            _mY = -_accel;
        };
    };
    if(bc_spectator_freecam_buttons select 2) then // A
    {
        if(bc_spectator_shift_down) then
        {
            _mX = -_accelshift;
        }
        else
        {
            _mX = -_accel;
        };
    };

    if(bc_spectator_freecam_buttons select 3) then // D
    {
        if(bc_spectator_shift_down) then
        {
            _mX = _accelshift;
        }
        else
        {
            _mX = _accel;
        };
    };
    if(bc_spectator_freecam_buttons select 4) then // Q
    {
        _scroll = 1*((sqrt _height)/2)*_delta;
        if (abs _scroll < 0.1) then {
            if (_scroll < 0) then { _scroll = -0.1;}
            else { _scroll = 0.1;};
        };
        _mZ = _scroll;
    };
    if(bc_spectator_freecam_buttons select 5) then // Z
    {
        _scroll = -1*((sqrt _height)/2)*_delta;
        if (abs _scroll < 0.1) then {
            if (_scroll < 0) then { _scroll = -0.1;}
            else { _scroll = 0.1;};
        };
        _mZ = _scroll;
    };
    if(bc_spectator_scrollHeight <0 || bc_spectator_scrollHeight > 0) then
    {
        _scroll = -bc_spectator_scrollHeight * _delta*3;//was 3 and was positive
        bc_spectator_scrollHeight = _scroll;
        if(bc_spectator_scrollHeight < 0.2 && bc_spectator_scrollHeight > -0.2) then
        {
            bc_spectator_scrollHeight = 0;
        };
        _scroll = _scroll*((sqrt _height)/2);
        if (abs _scroll < 0.1) then {
            if (_scroll < 0) then { _scroll = -0.1;}
            else { _scroll = 0.1;};
        };
        _mZ = _mZ + _scroll;
    };

    //Max speed 50 m/s
    _mX = _delta * ((_mX min 50) max -50);
    _mY = _delta * ((_mY min 50) max -50);
    bc_freecam_x_speed = bc_freecam_x_speed * 0.5 + _mX;
    bc_freecam_y_speed = bc_freecam_y_speed * 0.5 + _mY;
    bc_freecam_z_speed = bc_freecam_z_speed * 0.5 + _mZ;

    _x = (_currPos select 0) + (bc_freecam_x_speed * (cos bc_spectator_angleX)) + (bc_freecam_y_speed * (sin bc_spectator_angleX));
    _y = (_currPos select 1) - (bc_freecam_x_speed * (sin bc_spectator_angleX)) + (bc_freecam_y_speed * (cos bc_spectator_angleX));
    _newHeight = (getTerrainHeightASL [_x,_y]);
    _z = ((_currPos select 2) + bc_freecam_z_speed) min (650 + _newHeight);
    bc_spectator_freecamera setPosASL [_x,_y,_z max _newHeight];
    bc_spectator_freecamera setDir bc_spectator_angleX;
    [bc_spectator_freecamera,bc_spectator_angleY,0] call BIS_fnc_setPitchBank;
    bc_spectator_scrollHeight = 0;
    bc_spectator_timestamp = time;
};
//MAKE SURE PLAYER IS HIDDEN + NOT SIMULATED
if (simulationEnabled player) then {
    player enableSimulationGlobal false;
};
if (!isObjectHidden player) then {
    player hideObjectGlobal true;
};
cameraEffectEnableHUD true;
showCinemaBorder false;
// =======================================================================================================================================
