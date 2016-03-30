#include "script_component.hpp"

class cfgPatches
{
	class ADDON
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.54;
		requiredAddons[] = {"bc_common"};
		author[] = {"Snippers"};
		authorURL = "http://www.teamonetactical.com";
		version = "0.0.1";
		versionStr = "0.0.1";
		versionAr[] = {0,0,1};
	};
};

#include "Cfg3DEN.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "CfgLoadouts.hpp"
#include "display3DEN.hpp"