## spectator.pbo
The F3 spectator script, with some minor edits, ported to an addon form.

****

### Usage:

#### - Adding as respawn
If you want to have the spectator module activate upon player death, like the **[BC Mission Template](https://github.com/robtherad/BCArma)**, you will have to make sure the following lines are present in your mission's **description.ext** file:
```
respawnTemplates[] = {"Seagull", "f_spectator"};
class CfgRespawnTemplates {
    class Seagull {
        onPlayerRespawn = "";
    };
    class f_spectator {
        onPlayerRespawn = "bc_spectator_fnc_CamInit";
    };
};
```

#### - One time usage
If you just want to throw somebody into the spectator script for whatever reason you can use the following line of code to do so. The code will need to be executed on the machine that you want to have activate the spectator script.

```
[player,objNull,0,0,true] call bc_spectator_fnc_camInit;
```
