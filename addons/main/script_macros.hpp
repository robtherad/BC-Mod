#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

#define MOD_TEAM "BC Mod Team"

// Default versioning level
#define DEFAULT_VERSIONING_LEVEL 2

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)

#define QFUNC(var1) QUOTE(DFUNC(var1))
#define QEFUNC(var1,var2) QUOTE(DEFUNC(var1,var2))

#define PATHTOEF(var1,var2) PATHTOF_SYS(PREFIX,var1,var2)

#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]
#define SETVAR_SYS(var1,var2) setVariable [ARR_2(QUOTE(var1),var2)]
#define SETPVAR_SYS(var1,var2) setVariable [ARR_3(QUOTE(var1),var2,true)]

#define GETVAR(var1,var2,var3) var1 GETVAR_SYS(var2,var3)
#define GETMVAR(var1,var2) missionNamespace GETVAR_SYS(var1,var2)
#define GETUVAR(var1,var2) uiNamespace GETVAR_SYS(var1,var2)
#define GETPRVAR(var1,var2) profileNamespace GETVAR_SYS(var1,var2)
#define GETPAVAR(var1,var2) parsingNamespace GETVAR_SYS(var1,var2)

#define SETVAR(var1,var2,var3) var1 SETVAR_SYS(var2,var3)
#define SETPVAR(var1,var2,var3) var1 SETPVAR_SYS(var2,var3)
#define SETMVAR(var1,var2) missionNamespace SETVAR_SYS(var1,var2)
#define SETUVAR(var1,var2) uiNamespace SETVAR_SYS(var1,var2)
#define SETPRVAR(var1,var2) profileNamespace SETVAR_SYS(var1,var2)
#define SETPAVAR(var1,var2) parsingNamespace SETVAR_SYS(var1,var2)

#define GETGVAR(var1,var2) GETMVAR(GVAR(var1),var2)
#define GETEGVAR(var1,var2,var3) GETMVAR(EGVAR(var1,var2),var3)

#define ARR_SELECT(ARRAY,INDEX,DEFAULT) if (count ARRAY > INDEX) then {ARRAY select INDEX} else {DEFAULT}

// item types
#define TYPE_DEFAULT 0
#define TYPE_MUZZLE 101
#define TYPE_OPTICS 201
#define TYPE_FLASHLIGHT 301
#define TYPE_BIPOD 302
#define TYPE_FIRST_AID_KIT 401
#define TYPE_FINS 501 // not implemented
#define TYPE_BREATHING_BOMB 601 // not implemented
#define TYPE_NVG 602
#define TYPE_GOGGLE 603
#define TYPE_SCUBA 604 // not implemented
#define TYPE_HEADGEAR 605
#define TYPE_FACTOR 607
#define TYPE_RADIO 611
#define TYPE_HMD 616
#define TYPE_BINOCULAR 617
#define TYPE_MEDIKIT 619
#define TYPE_TOOLKIT 620
#define TYPE_UAV_TERMINAL 621
#define TYPE_VEST 701
#define TYPE_UNIFORM 801
#define TYPE_BACKPACK 901

#ifdef DISABLE_COMPILE_CACHE
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QUOTE(PATHTOF(functions\DOUBLES(fnc,fncName).sqf))
#else
    #define PREP(fncName) [QUOTE(PATHTOF(functions\DOUBLES(fnc,fncName).sqf)), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define PREP_MODULE(folder) [] call compile preprocessFileLineNumbers QUOTE(PATHTOF(folder\__PREP__.sqf))

//By default CBA's TRACE/LOG/WARNING spawn a buffer, which can cause messages to be logged out of order:
#ifdef CBA_DEBUG_SYNCHRONOUS
    #define CBA_fnc_log { params ["_file","_lineNum","_message"]; diag_log [diag_frameNo, diag_tickTime, time,  _file + ":"+str(_lineNum + 1), _message]; }
#endif

#define BC_LOG(module,level,message) diag_log text BC_LOGFORMAT(module,level,message)
#define BC_LOGFORMAT(module,level,message) FORMAT_2(QUOTE([BC] (module) %1: %2),level,message)

#define BC_LOGERROR(message) BC_LOG(COMPONENT,"ERROR",message)
#define BC_LOGERROR_1(message,arg1) BC_LOGERROR(FORMAT_1(message,arg1))
#define BC_LOGERROR_2(message,arg1,arg2) BC_LOGERROR(FORMAT_2(message,arg1,arg2))
#define BC_LOGERROR_3(message,arg1,arg2,arg3) BC_LOGERROR(FORMAT_3(message,arg1,arg2,arg3))
#define BC_LOGERROR_4(message,arg1,arg2,arg3,arg4) BC_LOGERROR(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_LOGERROR_5(message,arg1,arg2,arg3,arg4,arg5) BC_LOGERROR(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_LOGERROR_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_LOGERROR(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_LOGERROR_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_LOGERROR(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_LOGERROR_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_LOGERROR(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_ERRORFORMAT(message) BC_LOGFORMAT(COMPONENT,"ERROR",message)
#define BC_ERRORFORMAT_1(message,arg1) BC_ERRORFORMAT(FORMAT_1(message,arg1))
#define BC_ERRORFORMAT_2(message,arg1,arg2) BC_ERRORFORMAT(FORMAT_2(message,arg1,arg2))
#define BC_ERRORFORMAT_3(message,arg1,arg2,arg3) BC_ERRORFORMAT(FORMAT_3(message,arg1,arg2,arg3))
#define BC_ERRORFORMAT_4(message,arg1,arg2,arg3,arg4) BC_ERRORFORMAT(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_ERRORFORMAT_5(message,arg1,arg2,arg3,arg4,arg5) BC_ERRORFORMAT(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_ERRORFORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_ERRORFORMAT(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_ERRORFORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_ERRORFORMAT(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_ERRORFORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_ERRORFORMAT(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_LOGWARNING(message) BC_LOG(COMPONENT,"WARNING",message)
#define BC_LOGWARNING_1(message,arg1) BC_LOGWARNING(FORMAT_1(message,arg1))
#define BC_LOGWARNING_2(message,arg1,arg2) BC_LOGWARNING(FORMAT_2(message,arg1,arg2))
#define BC_LOGWARNING_3(message,arg1,arg2,arg3) BC_LOGWARNING(FORMAT_3(message,arg1,arg2,arg3))
#define BC_LOGWARNING_4(message,arg1,arg2,arg3,arg4) BC_LOGWARNING(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_LOGWARNING_5(message,arg1,arg2,arg3,arg4,arg5) BC_LOGWARNING(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_LOGWARNING_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_LOGWARNING(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_LOGWARNING_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_LOGWARNING(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_LOGWARNING_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_LOGWARNING(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_WARNINGFORMAT(message) BC_LOGFORMAT(COMPONENT,"WARNING",message)
#define BC_WARNINGFORMAT_1(message,arg1) BC_WARNINGFORMAT(FORMAT_1(message,arg1))
#define BC_WARNINGFORMAT_2(message,arg1,arg2) BC_WARNINGFORMAT(FORMAT_2(message,arg1,arg2))
#define BC_WARNINGFORMAT_3(message,arg1,arg2,arg3) BC_WARNINGFORMAT(FORMAT_3(message,arg1,arg2,arg3))
#define BC_WARNINGFORMAT_4(message,arg1,arg2,arg3,arg4) BC_WARNINGFORMAT(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_WARNINGFORMAT_5(message,arg1,arg2,arg3,arg4,arg5) BC_WARNINGFORMAT(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_WARNINGFORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_WARNINGFORMAT(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_WARNINGFORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_WARNINGFORMAT(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_WARNINGFORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_WARNINGFORMAT(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_LOGINFO(message) BC_LOG(COMPONENT,"INFO",message)
#define BC_LOGINFO_1(message,arg1) BC_LOGINFO(FORMAT_1(message,arg1))
#define BC_LOGINFO_2(message,arg1,arg2) BC_LOGINFO(FORMAT_2(message,arg1,arg2))
#define BC_LOGINFO_3(message,arg1,arg2,arg3) BC_LOGINFO(FORMAT_3(message,arg1,arg2,arg3))
#define BC_LOGINFO_4(message,arg1,arg2,arg3,arg4) BC_LOGINFO(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_LOGINFO_5(message,arg1,arg2,arg3,arg4,arg5) BC_LOGINFO(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_LOGINFO_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_LOGINFO(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_LOGINFO_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_LOGINFO(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_LOGINFO_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_LOGINFO(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_INFOFORMAT(message) BC_LOGFORMAT(COMPONENT,"INFO",message)
#define BC_INFOFORMAT_1(message,arg1) BC_INFOFORMAT(FORMAT_1(message,arg1))
#define BC_INFOFORMAT_2(message,arg1,arg2) BC_INFOFORMAT(FORMAT_2(message,arg1,arg2))
#define BC_INFOFORMAT_3(message,arg1,arg2,arg3) BC_INFOFORMAT(FORMAT_3(message,arg1,arg2,arg3))
#define BC_INFOFORMAT_4(message,arg1,arg2,arg3,arg4) BC_INFOFORMAT(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_INFOFORMAT_5(message,arg1,arg2,arg3,arg4,arg5) BC_INFOFORMAT(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_INFOFORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_INFOFORMAT(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_INFOFORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_INFOFORMAT(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_INFOFORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_INFOFORMAT(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_LOGDEBUG(message) BC_LOG(COMPONENT,"DEBUG",message)
#define BC_LOGDEBUG_1(message,arg1) BC_LOGDEBUG(FORMAT_1(message,arg1))
#define BC_LOGDEBUG_2(message,arg1,arg2) BC_LOGDEBUG(FORMAT_2(message,arg1,arg2))
#define BC_LOGDEBUG_3(message,arg1,arg2,arg3) BC_LOGDEBUG(FORMAT_3(message,arg1,arg2,arg3))
#define BC_LOGDEBUG_4(message,arg1,arg2,arg3,arg4) BC_LOGDEBUG(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_LOGDEBUG_5(message,arg1,arg2,arg3,arg4,arg5) BC_LOGDEBUG(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_LOGDEBUG_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_LOGDEBUG(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_LOGDEBUG_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_LOGDEBUG(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_LOGDEBUG_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_LOGDEBUG(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_DEBUGFORMAT(message) BC_LOGFORMAT(COMPONENT,"DEBUG",message)
#define BC_DEBUGFORMAT_1(message,arg1) BC_DEBUGFORMAT(FORMAT_1(message,arg1))
#define BC_DEBUGFORMAT_2(message,arg1,arg2) BC_DEBUGFORMAT(FORMAT_2(message,arg1,arg2))
#define BC_DEBUGFORMAT_3(message,arg1,arg2,arg3) BC_DEBUGFORMAT(FORMAT_3(message,arg1,arg2,arg3))
#define BC_DEBUGFORMAT_4(message,arg1,arg2,arg3,arg4) BC_DEBUGFORMAT(FORMAT_4(message,arg1,arg2,arg3,arg4))
#define BC_DEBUGFORMAT_5(message,arg1,arg2,arg3,arg4,arg5) BC_DEBUGFORMAT(FORMAT_5(message,arg1,arg2,arg3,arg4,arg5))
#define BC_DEBUGFORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6) BC_DEBUGFORMAT(FORMAT_6(message,arg1,arg2,arg3,arg4,arg5,arg6))
#define BC_DEBUGFORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7) BC_DEBUGFORMAT(FORMAT_7(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7))
#define BC_DEBUGFORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) BC_DEBUGFORMAT(FORMAT_8(message,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8))

#define BC_DEPRECATED(arg1,arg2,arg3) BC_LOGWARNING_3("%1 is deprecated. Support will be dropped in version %2. Replaced by: %3",arg1,arg2,arg3)

#define PFORMAT_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) \
    format ['%1: A=%2, B=%3, C=%4, D=%5, E=%6, F=%7, G=%8, H=%9, I=%10 J=%11', MESSAGE, RETNIL(A), RETNIL(B), RETNIL(C), RETNIL(D), RETNIL(E), RETNIL(F), RETNIL(G), RETNIL(H), RETNIL(I), RETNIL(J)]
#ifdef DEBUG_MODE_FULL
#define TRACE_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) \
    [THIS_FILE_, __LINE__, PFORMAT_10(MESSAGE,A,B,C,D,E,F,G,H,I,J)] call CBA_fnc_log
#else
   #define TRACE_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) /* disabled */
#endif