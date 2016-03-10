#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Set up type names
GVAR(SCALAR) = 0; //SCALAR
GVAR(STRING) = ""; //STRING
GVAR(BOOL) = true; //BOOL
GVAR(ARRAY) = []; //ARRAY
GVAR(CODE) = {}; //CODE
GVAR(OBJECT) = objNull; //OBJECT
GVAR(GROUP) = grpNull; //GROUP
//GVAR(CONTROL) = controlNull; //CONTROL
GVAR(TEAM_MEMBER) = teamMemberNull; //TEAM_MEMBER
//GVAR(DISPLAY) = displayNull; //DISPLAY
GVAR(TASK) = taskNull; //TASK
GVAR(LOCATION) = locationNull; //LOCATION
GVAR(SIDE) = sideUnknown; //SIDE
GVAR(TEXT) = text ""; //TEXT
GVAR(CONFIG) = configNull; //CONFIG (Since Arma 3 v1.53.133130)
GVAR(NAMESPACE) = missionNamespace; //NAMESPACE


ADDON = true;
