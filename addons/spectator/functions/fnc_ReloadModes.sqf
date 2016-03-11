private["_curIndex", "_listBox"];
_listBox = 2101;
_curIndex = lbCurSel _listBox;
lbClear _listBox;
// NV
if(!bc_spectator_tiWHOn && !bc_spectator_tiBHOn && !bc_spectator_nvOn) then
{
    bc_spectator_lb_toggleNormal = lbAdd [_listBox,"[Normal]"];
}
else
{
    bc_spectator_lb_toggleNormal = lbAdd [_listBox,"Normal"]
};
if(bc_spectator_nvOn) then
{
    bc_spectator_lb_toggletiNVIndex = lbAdd[_listBox,"[NV]"];

}
else
{
    bc_spectator_lb_toggletiNVIndex = lbAdd[_listBox,"NV"];
};
// blackhot
if(bc_spectator_tiBHOn) then
{
    bc_spectator_lb_toggletiBHIndex = lbAdd[_listBox,"[TI - Blackhot]"];

}
else
{
    bc_spectator_lb_toggletiBHIndex = lbAdd[_listBox,"TI - Blackhot"];
};

// whtiehot
if(bc_spectator_tiWHOn) then
{
    bc_spectator_lb_toggletiWHIndex = lbAdd[_listBox,"[TI - Whitehot]"];

}
else
{
    bc_spectator_lb_toggletiWHIndex = lbAdd[_listBox,"TI - Whitehot"];
};

