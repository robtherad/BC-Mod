class CfgVehicles
{
	class Logic;
	class Module_F: Logic {
		class ArgumentsBaseUnits {
			class Units;
		};
		class ModuleDescription {
			class AnyBrain;
		};
	};
	class GVAR(timeLimit): Module_F {
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "Mission Timelimit"; // Name displayed in the menu
        icon = "\y\bc\addons\objectives\ui\icon.paa"; // Map icon. Delete this entry to use the default icon
		category = "Multiplayer";

		function = QFUNC(time_module); // Name of function triggered once conditions are met
		functionPriority = 1; // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 0; // 1 for module waiting until all synced triggers are activated
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)

		// Module arguments
		class Arguments: ArgumentsBaseUnits {
			// Module specific arguments
			class Duration {
				displayName = "Mission Duration (seconds)"; // Argument label
				description = "The time in seconds that the mission will last."; // Tooltip description
				typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "2700";
			};
            class Execution {
                displayName = "Ending Code Execution";
                description = "Code to call once the mission duration has been reached.";
                typeName = "STRING";
                defaultValue = "";
            };
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription {
			description = "Tracks time since "; // Short description, will be formatted as structured text
		};
	};
    class GVAR(destroy): Module_F {
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "Objective - Destroy"; // Name displayed in the menu
        icon = "\y\bc\addons\objectives\ui\icon.paa"; // Map icon. Delete this entry to use the default icon
		category = "Multiplayer";

		function = QFUNC(destroy_module); // Name of function triggered once conditions are met
		functionPriority = 1; // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 0; // 1 for module waiting until all synced triggers are activated
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)

		// Module arguments
		class Arguments: ArgumentsBaseUnits {
			// Module specific arguments
            class objectiveName {
				displayName = "Objective Name"; // Argument label
				description = "The name of the objective which will be shown to players in tasks, markers, etc."; // Tooltip description
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "";
			};
            class bluforStatus {
                displayName = "Assign Objective to BLUFOR";
                description = "";
				typeName = "NUMBER";
				class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
					class attacker	{name = "Attacker";	value = 2;};
					class defender	{name = "Defender"; value = 3;};
				};
            };
            class opforStatus {
                displayName = "Assign Objective to OPFOR";
                description = "";
				typeName = "NUMBER";
				class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
					class attacker	{name = "Attacker";	value = 2;};
					class defender	{name = "Defender"; value = 3;};
				};
            };
            class indforStatus {
                displayName = "Assign Objective to INDFOR";
                description = "";
				typeName = "NUMBER";
				class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
					class attacker	{name = "Attacker";	value = 2;};
					class defender	{name = "Defender"; value = 3;};
				};
            };
            class defenderTasks {
                displayName = "Create defender tasks";
                description = "Creates defend task for teams set to defend the synced object. Neutral teams will not have any tasks created for them.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class execution {
                displayName = "Ending Code Execution";
                description = "Code to call once the objective has been destroyed.";
                typeName = "STRING";
                defaultValue = "";
            };
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription {
			description = "Sync the module to an object. If the module is synced to more than one object or no objects it will not activate."; // Short description, will be formatted as structured text
			sync[] = {"Anything"}; // Array of synced entities (can contain base classes)
			class unit {
				description = "Any unit";
				displayName = "Any unit"; // Custom name
				icon = "iconMan"; // Custom icon (can be file path or CfgVehicleIcons entry)
				side = 1; // Custom side (will determine icon color)
			};
		};
	};
};
