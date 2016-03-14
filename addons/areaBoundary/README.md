## areaBoundary.pbo

A framework that allows mission makers to limit player movement into or from certain areas.

By default the framework comes with support for allowing exemptions to players in air or land vehicles.


##### TODO (A3 v1.57): 
* Add a debug command to show polygon areas on map.
* Convert some functions into engine commands.
* Add 4th positional option with format similar to `[[COORDS],[SIZE X], [SIZE Y]]`


****

### Usage:

#### - Adding boundary
Call the function `bc_areaBoundary_fnc_addArea` to add an area. A list of arguements and examples is given below.

Quick Example: 
```
// Create a boundary called "Name", for all teams, using the inside of the marker "Area_Marker" as the allowed space
["Name", [], "Area_Marker"] call bc_areaBoundary_fnc_addArea;
```

Longer info, same as the function's file header:
```
Parameters:
    _name - the name you want to give to the area <OBJECT>
    _sides - the side(s) that will be affected by the area boundary <SIDE> or <ARRAY>
    _positions - can either be a trigger, a marker, or an array of markers and/or positions. <ARRAY>
Optional Parameters:
    _isInclusive - if true, players on affected sides cannot leave the boundary. if false, players on affected sides cannot enter it. default true. <BOOLEAN>
    _allowAirVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _allowLandVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _customVariables - an array filled with variable names. variables should be boolean and saved in the missionNamespace. to leave empty set to []. default: [] <ARRAY>
    _customDelay - delay in seconds before killing the player. must be a multiple of 5. if not a multiple of 5, will round up to next nearest multiple of 5. default 25. <SCALAR>
    _customMessage - message that gets displayed when player leaves the boundary. <STRING>
Examples:
    (begin example)
    (ex1) // Add an area that nobody can leave. Based on a trigger's position and size.
        ["Albany", [], AlbanyTrigger] call bc_areaBoundary_fnc_addArea;
    
    (ex2) // Add an area that nobody can enter based on a marker's position and size. 
        ["Area51", [], "area_51", false] call bc_areaBoundary_fnc_addArea;
        
    (ex3) // Add an area that the 3 major teams can't enter on foot or in land vehicles. Based on a marker.
        ["Detroit", [east,west,independent], "Detroit Marker", false, true, false] call bc_areaBoundary_fnc_addArea;
        
    (ex4) // Add an area that OPFOR can't leave based on an array of positions and markers. Remember not to put the positions out of order or the points will be connected in a weird way.
        ["DefensiveZone", east, ["DefensivePoint1", "DefensivePoint2", [0,0,0], [10000,10000,10000], "DefensivePoint3", "DefensivePoint4"]] call bc_areaBoundary_fnc_addArea;
        
    (ex5) // Add an area that nobody can leave based on a trigger's position and size. Also use the value of variable playerIsNotAPimp to determine if player should be affected by boundaries.
        ["Newark", [], NewarkTrigger, true, false, false, ["playerIsNotAPimp"] call bc_areaBoundary_fnc_addArea;
        // If playerIsNotAPimp is true, allow player to be killed by going out of bounds. If playerIsNotAPimp is false, player cannot be killed by being out of bounds. Useful if you want some custom limitations for your area boundaries.
    (end)
```

#### - Removing boundary
To remove an area boundary, call the function `bc_areaBoundary_fnc_removeArea` and pass it the name of the boundary you want to delete. For example, the follow line would remove the area boundary named "Area51":

```
["Area51"] call bc_areaBoundary_fnc_removeArea;
```

#### - Disabling
By default the module will continuously check to see if there are any markers to update. The performance overhead for this shouldn't be very heavy at all but if you don't intend on using the module in your mission you can disable it by setting the variable `bc_areaBoundary_disableBoundaries` to `true`. Any other value besides `true` and the script will continue to run. 

Keep in mind, this will only disable the module for machines where `bc_areaBoundary_disableBoundaries` is `true`, the effect is not global.

Once you have disabled the module in your mission you will need to follow the steps below to re-enable it.

#### - Re-enabling
If you have disabled the module by setting the variable `bc_areaBoundary_disableBoundaries` to `true`, you can only re-enable it by executing the following function on the machines where you want to re-enable it. 

```call bc_areaBoundary_fnc_enableBoundaries;```

Ten seconds after executing the above function on any machines that you want to re-enable the gpsMarkers module for, the module will restart. During the ten seconds the function will set `bc_areaBoundary_disableBoundaries` to `true` to make sure there are no duplicate loops running.
