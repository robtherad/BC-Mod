## nametags.pbo

Allows mission maker to easily use nametags with their missions.

****

#### Features:
* Simple to use standard BC nametags.
* Mission maker can customize color, font, size, and shadow of nametags.
* Possibility to customize name and group tags separately.

****

### Usage:

#### - Showing Nametags
If you just want to have the standard BC nametags showing in your mission it's as simple as adding the following line to your mission's `init.sqf`:

``` call bc_nametags_fnc_showTags; ```

If you would like to customize the look of the nametags then you can use the arguments listed below to do so.

```
Optional Parameters:
    nameArray - an array of values used for the name part of the nametag. format: [color, font, size, shadow] <ARRAY>
        color - the color of the nametag in hex color format. default: "#ba9d00" <STRING>
        font - the font used for the nametag. must be a font present in arma 3. default: "TahomaB" <STRING>
        size - the size of the font used for the nametag. default: 0.5 <SCALAR>
        shadow - the size of the border around the letters in the nametag. choices are 0, 1, or 2. default: 2 <SCALAR>
    groupArray - an array of values used for the name part of the nametag. format: [color, font, size, shadow] <ARRAY>
        color - the color of the nametag in hex color format. default: "#ba9d00" <STRING>
        font - the font used for the nametag. must be a font present in arma 3. default: "TahomaB" <STRING>
        size - the size of the font used for the nametag. default: 0.375 <SCALAR>
        shadow - the size of the border around the letters in the nametag. choices are 0, 1, or 2. default: 2 <SCALAR>
        
Examples:
    (begin example)
    (e1) // Shows standard BC name and group tags. 
        call bc_nametags_fnc_showTags
    (e2) // Shows WHITE name and group tags
        [["#ffffff"],["#ffffff"]] call bc_nametags_fnc_showTags;
    (e3) // Show BLACK, Zeppelin32, Size 2, Shadow 0, name and group tags.
        [["#000000","Zeppelin32",2,0], ["#000000","Zeppelin32",2,0]] call bc_nametags_fnc_showTags;
    (end)
```

#### - Hiding Nametags
To stop the nametag module from running, call the function `bc_nametags_fnc_hideTags`. There are no arguments for this function.

``` call bc_nametags_fnc_hideTags; ```