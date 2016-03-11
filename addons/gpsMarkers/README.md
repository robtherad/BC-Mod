## gpsMarkers

A simple framework for mission makers to easily attach markers to groups and vehicles. 

****

## Usage:

#### Adding Markers
Use the function `bc_gpsMarkers_fnc_addMarker` to add a marker for a group or vehicle. 
```
Parameters:
    _unit - the unit, group, or vehicle to add a marker to: <OBJECT>  OR  <GROUP>
    _sides - the side(s) the marker will be visible to: <SIDE>  OR  <ARRAY>
Examples:
    (begin example)
        [player,west] call bc_gpsMarkers_fnc_addMarker;
        [truck,[west,east]] call bc_gpsMarkers_fnc_addMarker;
    (end)
```    
    
#### Removing Markers
Use the function `bc_gpsMarkers_fnc_removeMarker` to remove a tracked marker from a group or vehicle. 
```
Parameters:
    _unit - the unit, group, or vehicle to add remove marker from: <OBJECT>  OR  <GROUP>
Examples:
    (begin example)
        [player] call bc_gpsMarkers_fnc_removeMarker;
        [truck] call bc_gpsMarkers_fnc_removeMarker;
    (end)
```

****

## Advanced Usage:

#### Vehicle Marker Names
When creating a marker for a vehicle the module checks to see if the variable `bc_gpsMarkers_vehName` is defined. If it is not defined, the vehicle's name in the editor is used instead. If you want to have a custom vehicle name it is reccommended that you assign the variable `bc_gpsMarkers_vehName` before your mission leaves the briefing phase. An easy way to do this is to add the following line to the vehicle's initialization field:

```this setVariable ["bc_gpsMarkers_vehName","-My Vehicle Name-"];```

#### Group Marker Names
When creating a marker for a group the module will use the group's groupID variable as it's marker text. The groupID variable needs to be set before the mission leaves the briefing phase or the module will not find it.

#### Disabling
By default the module will continously check to see if there are any markers to update. The performance overhead for this shouldn't be very heavy at all but if you don't intend on using the module in your mission you can disable it by setting the variable `bc_gpsMarkers_disableGPS` to `true`. Any other value besides `true` and the script will continue to run. 

Keep in mind, this will only disable the module for machines where `bc_gpsMarkers_disableGPS` is `true`, the effect is not global.

Once you have disabled the module in your mission you will need to follow the steps below to renable it.

#### Re-enabling
If you have disabled the module by setting the variable `bc_gpsMarkers_disableGPS` to `true`, you can only renable it by executing the following function on the machines where you want to re-enable it. 

```call bc_gpsMarkers_fnc_enableGPS;```

Five seconds after executing the above function on any machines that you want to re-enable the gpsMarkers module for, the module will restart.
