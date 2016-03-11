private["_leftButton", "_rightButton", "_y", "_x"];
_x = bc_spectator_mouseCord select 0;
_y = bc_spectator_mouseCord select 1;
_leftButton = bc_spectator_MouseButton select 0;
_rightButton = bc_spectator_MouseButton select 1;
bc_spectator_mouseDeltaX = bc_spectator_mouseLastX - (_x);
bc_spectator_mouseDeltaY = bc_spectator_mouseLastY - (_y);


if(_rightButton && !_leftButton) then
{
    bc_spectator_angleX = (bc_spectator_angleX - (bc_spectator_mouseDeltaX*360));
    bc_spectator_angleY = (bc_spectator_angleY + (bc_spectator_mouseDeltaY*180)) min 89 max -89;
};
if(bc_spectator_ctrl_down && _rightButton && _leftButton) then
{
    bc_spectator_fovZoom = 0.7;
};

bc_spectator_mouseLastX = (bc_spectator_mouseCord select 0);
bc_spectator_mouseLastY = (bc_spectator_mouseCord select 1);
