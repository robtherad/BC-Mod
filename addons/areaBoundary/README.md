## areaBoundary.pbo

A framework that allows mission makers to limit player movement to certain areas.

****

### Usage:

#### - Adding boundary

With this framework you have multiple options for creating boundaries.


#### - Disabling
By default the module will continuously check to see if there are any markers to update. The performance overhead for this shouldn't be very heavy at all but if you don't intend on using the module in your mission you can disable it by setting the variable `bc_gpsMarkers_disableGPS` to `true`. Any other value besides `true` and the script will continue to run. 

Keep in mind, this will only disable the module for machines where `bc_gpsMarkers_disableGPS` is `true`, the effect is not global.

Once you have disabled the module in your mission you will need to follow the steps below to re-enable it.

#### - Re-enabling
If you have disabled the module by setting the variable `bc_gpsMarkers_disableGPS` to `true`, you can only re-enable it by executing the following function on the machines where you want to re-enable it. 

```call bc_areaBoundary_fnc_enableBoundaries;```

Five seconds after executing the above function on any machines that you want to re-enable the gpsMarkers module for, the module will restart. During the five seconds the function will set `bc_gpsMarkers_disableGPS` to `true` to make sure there are no duplicate loops running.