#include "script_component.hpp"
params["_structure"];

private _id = _structure addAction ["<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />", {
        params ["", "_caller"];
        private _isProne = stance _caller == "PRONE";
        private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
        _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
        if (_medicAnim != "") then {
            _caller playMove _medicAnim;
        };
        [{
            params ["_target", "_caller"];
            if (!alive _target || {!alive _caller || {_caller getVariable [QGVAR(unconscious), false]}}) exitWith {};
			private _isMedic = _caller getUnitTrait "Medic";
			if (!_isMedic) then {_caller setUnitTrait ["Medic", true]};
            [QGVAR(heal), [_caller, _caller, false], _caller] call CBA_fnc_targetEvent;
			[{params ["_caller","_isMedic"];if (!_isMedic) then {_caller setUnitTrait ["Medic", false]}; }, [_caller,_isMedic], 1] call CBA_fnc_waitAndExecute;
        }, _this, 5] call CBA_fnc_waitAndExecute;
    }, [], 10, true, true, "",
    format ["!(_this getVariable ['%6',false]) && {alive _this && {(_this getVariable ['%1' , %2]) < (_this getVariable ['%7', ([%8,%2] select (isPlayer _this)) * %5]) }}", QGVAR(hp), QGVAR(maxPlayerHP), QFUNC(hasHealItems), QGVAR(maxHealRifleman), QGVAR(maxHealMedic), QGVAR(unconscious), QGVAR(maxHp), QGVAR(maxAiHp)],
    10];
    _structure setUserActionText [_id, format [((localize "STR_A3_CfgActions_Heal0") + " (APS)"), getText ((configOf _structure) >> "displayName")], "<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />"];