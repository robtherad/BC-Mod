/*
 * Name: TMF_common_fnc_waitUntilAndExecute.sqf
 * Author: Snippers

 * Arguments:
 * CODE. code to execute
 * ANY. parameters to pass on
 * NUMBER. Delay in seconds (diag_tickTime)
 *
 * Return:
 * NUMBER index in the waitAndExecArray.
 *
 * Description:
 * Use this to delay code execution in the unscheluled code envinorment.
 */
#include "\x\tmf\addons\common\script_component.hpp"

params [["_code",{}],["_params",[]],["_delay",0]];

GVAR(waitAndExecArray) pushBack [diag_tickTime + _delay, _code, _params];


