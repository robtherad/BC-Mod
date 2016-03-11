disableSerialization;
_show = _this select 0;
_disp = findDisplay 9228;
if(bc_spectator_menuWorking) exitWith {};
if(_show && !bc_spectator_menuShown) then
{
    bc_spectator_menuWorking = true;
    bc_spectator_menuShown = true;
    {
        _pos = ctrlPosition (_disp displayCtrl _x);
        _pos set [1,(_pos select 1) + 0.03];
        (_disp displayCtrl _x) ctrlSetPosition _pos;
    } foreach bc_spectator_menuControls;
    {(_disp displayCtrl _x) ctrlCommit 0.6; } foreach bc_spectator_menuControls;
    waitUntil {ctrlCommitted (_disp displayCtrl (bc_spectator_menuControls select 0))};
    bc_spectator_menuWorking = false;
};
if(!_show && bc_spectator_menuShown) then
{
    bc_spectator_menuWorking = true;
    bc_spectator_menuShown = false;
    {
        _pos = ctrlPosition (_disp displayCtrl _x);
        _pos set [1,(_pos select 1) - 0.03];
        (_disp displayCtrl _x) ctrlSetPosition _pos;
    } foreach bc_spectator_menuControls;
    {(_disp displayCtrl _x) ctrlCommit 0.6; } foreach bc_spectator_menuControls;
    waitUntil {ctrlCommitted (_disp displayCtrl (bc_spectator_menuControls select 0))};
    bc_spectator_menuWorking = false;
};