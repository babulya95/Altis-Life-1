#include "..\..\script_macros.hpp"
/*
	File: fn_weaponShopMenu.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Something
*/
private["_shopSide","_shopSide","_license","_itemInfo","_itemList","_license","_flag","_exit","_level","_levelAssert","_levelName","_levelType","_levelValue","_levelMsg"];
_exit = false;
_shopTitle = M_CONFIG(getText,"WeaponShops",(SEL(_this,3)),"name");
_shopSide = M_CONFIG(getText,"WeaponShops",(SEL(_this,3)),"side");
_license = M_CONFIG(getText,"WeaponShops",(SEL(_this,3)),"license");
_levelAssert = M_CONFIG(getArray,"WeaponShops",(SEL(_this,3)),"level");
_levelName = SEL(_levelAssert,0);
_levelType = SEL(_levelAssert,1);
_levelValue = SEL(_levelAssert,2);
_levelMsg = SEL(_levelAssert,3);


if(!(EQUAL(_license,""))) then {
	_flag = M_CONFIG(getText,"Licenses",_license,"side");
	if(!(LICENSE_VALUE(_license,_flag))) exitWith {hint localize "STR_Shop_Veh_NoLicense"; _exit = true;};
};
if(_exit) exitWith {};

_flag = switch(playerSide) do {case west: {"cop"}; case independent: {"med"}; default {"civ"};};
if(!(EQUAL(_flag,_shopSide))) exitWith {};
if(!(EQUAL(_levelValue,-1))) then {
	_level = GVAR_MNS _levelName;
	if(typeName _level == typeName {}) then {_level = FETCH_CONST(_level);};

	_flag = switch(_levelType) do {
		case (typeName 0): {_level >= _levelValue};
		case (typeName true): {_level};
		default {EQUAL(_level,_levelValue)};
	};

	if(!(_flag)) exitWith {
		if(!(EQUAL(_levelMsg,""))) then {
			hint _levelMsg;
		}else{
			hint localize "STR_Shop_Veh_NotAllowed";
		};
	};
};

uiNamespace setVariable ["Weapon_Shop",SEL(_this,3)];

if(!(createDialog "life_weapon_shop")) exitWith {};
if(!isClass(missionConfigFile >> "WeaponShops" >> (SEL(_this,3)))) exitWith {}; //Bad config entry.

disableSerialization;

ctrlSetText[38401,_shopTitle];

_filters = ((findDisplay 38400) displayCtrl 38402);
lbClear _filters;

_filters lbAdd localize "STR_Shop_Weapon_ShopInv";
_filters lbAdd localize "STR_Shop_Weapon_YourInv";

_filters lbSetCurSel 0;
