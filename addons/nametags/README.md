## nametags.pbo

Allows mission maker to use standard BC nametags with their missions.

****

#### Features:
* Allows mission maker to set custom nametag color.

****

### Usage:

#### - Starting nametag module
Call the function `bc_nametags_fnc_showTags` to add an area. A list of arguments and examples is given below.

```
Optional Parameter:
    _color - the color of the nametags in hex color format. default: "#ba9d00" <STRING>

Examples:
(e1)
    // Show default colored nametags
    call bc_nametags_fnc_showTags;
(e2)
    // Show white nametags
    ["#ffffff"] call bc_nametags_fnc_showTags;
```

#### - Stopping nametag module
To stop the nametag module from running, call the function `bc_nametags_fnc_hideTags`. There are no arguments for this function.

```
Example:
    (e1) // Stop showing nametags
    call bc_nametags_fnc_hideTags;
```