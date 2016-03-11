private["_forbiddenControls"];
#include "macros.hpp"
_forbiddenControls = [BC_SPECTATOR_MOUSEHANDLER,BC_SPECTATOR_MINIMAP,BC_SPECTATOR_FULLMAP,BC_SPECTATOR_SPECHELP,BC_SPECTATOR_HELPCANCEL,BC_SPECTATOR_SPECHELP,BC_SPECTATOR_HELPFRAME,BC_SPECTATOR_HELPBACK];
{
    if(!(_x in _forbiddenControls)) then
    {
        ctrlShow [_x,!bc_spectator_hideUI];
    };
} foreach bc_spectator_controls;