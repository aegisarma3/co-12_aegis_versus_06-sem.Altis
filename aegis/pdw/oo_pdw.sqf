	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_PDW -  Pesistent Data World

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	*/

	#include "oop.h"

	CLASS("OO_PDW")
		PRIVATE VARIABLE("string","driver");
		PRIVATE VARIABLE("string","filename");

		PUBLIC FUNCTION("string","constructor") {
			if(_this == "inidbi") then {
				if !(isClass(configFile >> "cfgPatches" >> "inidbi")) exitwith {
					MEMBER("ToLog", "PDW: requires INIDBI");
				};
				call compilefinal preProcessFile "\inidbi\init.sqf";
			};
			MEMBER("filename", "oo_pdw");
			MEMBER("driver", _this);
		};

		PUBLIC FUNCTION("string","setFileName") {
			MEMBER("filename", _this);
		};

		PRIVATE FUNCTION("array","read") {
			private ["_driver", "_key", "_result", "_filename"];

			_key = _this select 0;
			_type = _this select 1;

			_driver = MEMBER("driver", nil);
			_filename = MEMBER("filename", nil);

			switch (_driver) do {
				case "inidbi": {
					_result = [_filename, "pdw", _key, _type] call iniDB_read;
				};

				case "profile": {
					_result = profileNamespace getVariable _key;
				};

				default {

				};
			};
			_result;
		};

		PRIVATE FUNCTION("array","write") {
			private ["_driver", "_key", "_array", "_result", "_filename"];

			_key = _this select 0;
			_array = _this select 1;

			_driver = MEMBER("driver", nil);
			_filename = MEMBER("filename", nil);

			switch (_driver) do {
				case "inidbi": {
					_result = [_filename, "pdw", _key, _array] call iniDB_write;
				};

				case "profile": {
					profileNamespace setVariable [_key, _array];
					saveProfileNamespace;
					_result = true;
				};

				default {

				};
			};
			_result;
		};

		PUBLIC FUNCTION("string","toLog") {
			hint _this;
			diag_log _this;
		};

		PUBLIC FUNCTION("object","clearInventory") {
			removeallweapons _this;
			removeGoggles _this;
			removeHeadgear _this;
			removeVest _this;
			removeUniform _this;
			removeAllAssignedItems _this;
			removeBackpack _this;
		};

		PUBLIC FUNCTION("object","clearObject") {
			clearWeaponCargoGlobal _this;
			clearMagazineCargoGlobal _this;
			clearItemCargoGlobal _this;
			clearBackpackCargoGlobal _this;
		};

		PUBLIC FUNCTION("","saveGroups") {
			private ["_save", "_counter", "_filename"];
			_filename = MEMBER("filename", nil);
			{
				_save = [format ["PDW_UNIT_%1", _foreachindex], _x];
				MEMBER("saveUnit", _save);
				_counter = _foreachindex;
				sleep 0.01;
			}foreach allGroups;
			_save = ["pdw_groups", _counter];
			MEMBER("write", _save);
		};


		PUBLIC FUNCTION("","saveObjects") {
			private ["_save", "_counter"];
			{
				_save = [format ["objects_%1", _foreachindex], _x];
				MEMBER("saveObject", _save);
				_counter = _foreachindex;
				sleep 0.01;
			}foreach vehicles;
			_save = ["pdw_objects", _counter];
			MEMBER("write", _save);
		};

		PUBLIC FUNCTION("","loadObjects") {
			private ["_name", "_counter", "_object","_objects"];

			_save = ["pdw_objects", "SCALAR"];
			_counter = MEMBER("read", _save);

			_objects = [];
			for "_x" from 0 to _counter step 1 do {
				_name = format ["objects_%1", _x];
				_object = MEMBER("loadObject", _name);
				_objects = _objects + [_object];
				sleep 0.01;
			};
			_objects;
		};

		PUBLIC FUNCTION("array","saveObject") {
			private ["_array", "_name", "_result", "_object"];

			_name = _this select 0;
			_object = _this select 1;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a object name to saveObject");
			};

			_name = "pdw_object_" + _name;

			_array = [
				(typeof _object),
				(getpos _object),
				(getdir _object),
				(getDammage _object),
				(getWeaponCargo _object),
				(getMagazineCargo _object),
				(getItemCargo _object),
				(getBackpackCargo _object)
				];

			_save = [_name, _array];
			_result = MEMBER("write", _save);
		};

		PUBLIC FUNCTION("string","loadObject") {
			private ["_array", "_name", "_object", "_item", "_count"];

			_name = _this;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a object name to loadObject");
			};

			_name = "pdw_object_" + _name;

			_save = [_name, "ARRAY"];
			_array = MEMBER("read", _save);

			if(_array isequalto "") exitwith {false};

			_object = createVehicle [(_array select 0), (_array select 1), [], 0, "NONE"];
			_object setposatl (_array select 1);
			_object setdir (_array select 2);
			_object setdamage (_array select 3);

			MEMBER("ClearObject", _this);

			_items = (_array select 4) select 0;
			_count = (_array select 4) select 1;
			{
				_object addWeaponCargoGlobal [_x, _count select _foreachindex];
			}foreach _items;

			_items = (_array select 5) select 0;
			_count = (_array select 5) select 1;
			{
				_object addMagazineCargoGlobal [_x, _foreachindex];
			}foreach _items;

			_items = (_array select 6) select 0;
			_count = (_array select 6) select 1;
			{
				_object addItemCargoGlobal [_x, _count select _foreachindex];
			}foreach _items;

			_items = (_array select 7) select 0;
			_count = (_array select 7) select 1;
			{
				_object addBackpackCargoGlobal [_x, _count select _foreachindex];
			}foreach _items;
			_object;
		};

		PUBLIC FUNCTION("array","savePlayer") {
			private ["_name", "_object", "_result", "_array"];

			_object = _this select 0;
			_name = _this select 1;
			_uid = _this select 2;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to savePlayer");
			};

			_name = format["aegis_%1_%2_unit", _name,_uid];

			_array = [(getpos _object), (getdir _object), (getdammage _object)];

			_save = [_name, _array];
			MEMBER("write", _save);
		};

		PUBLIC FUNCTION("array","loadPlayer") {
			private ["_name", "_array", "_position", "_damage", "_dir", "_typeof", "_unit"];

			_object = _this select 0;
			_name = _this select 1;
			_uid = _this select 2;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to loadUnit");
			};

			_name = format["aegis_%1_%2_unit", _name,_uid];

			_save = [_name, "ARRAY"];
			_array = MEMBER("read", _save);
			if(_array isequalto "") exitwith {false};

			_position	= _array select 0;
			_dir		= _array select 1;
			_damage 	= _array select 2;

			_object setpos _position;
			_object setdir _dir;
			_object setdammage _damage;
		};

		PUBLIC FUNCTION("array","saveUnit") {
			private ["_name", "_object", "_result", "_array"];

			_name = _this select 0;
			_object = _this select 1;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to saveUnit");
			};

			_name = "pdw_unit_" + _name;

			_array = [(typeof _object), (getpos _object), (getdir _object), (getdammage _object)];

			_save = [_name, _array];
			MEMBER("write", _save);
		};

		PUBLIC FUNCTION("string","loadUnit") {
			private ["_name", "_array", "_position", "_damage", "_dir", "_typeof", "_unit"];

			_name = _this;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to loadUnit");
			};

			_name = "pdw_unit_" + _name;

			_save = [_name, "ARRAY"];
			_array = MEMBER("read", _save);
			if(_array isequalto "") exitwith {false};

			_typeof 	= _array select 0;
			_position	= _array select 1;
			_dir		= _array select 2;
			_damage 	= _array select 3;

			_unit = createVehicle [_typeof, _position,[], 0, "NONE"];
			_unit setpos _position;
			_unit setdir _dir;
			_unit setdammage _damage;
			_unit;
		};

		PUBLIC FUNCTION("array","saveInventory") {
			private ["_name", "_object", "_result", "_array"];

			_object = _this select 0;
			_name = _this select 1;
			_uid =_this select 2;

			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to saveUnit");
			};

			_name = format["aegis_%1_%2_inventory", _name,_uid];

			_array = [
				(headgear _object),
				(goggles _object),
				(uniform _object),
				(UniformItems _object),
				(vest _object),
				(VestItems _object),
				(backpack _object),
				(backpackItems _object),
				(primaryWeapon _object),
				(primaryWeaponItems _object),
				(primaryWeaponMagazine _object),
				(secondaryWeapon _object),
				(secondaryWeaponItems _object),
				(secondaryWeaponMagazine _object),
				(handgunWeapon _object),
				(handgunItems _object),
				(handgunMagazine _object),
				(assignedItems _object)
			];

			_save = [_name, _array];
			MEMBER("write", _save);
		};

		PUBLIC FUNCTION("array","loadInventory") {
			private ["_name", "_array", "_headgear", "_goggles", "_uniform", "_uniformitems", "_vest", "_vestitems", "_backpack", "_backpackitems", "_primaryweapon", "_primaryweaponitems", "_primaryweaponmagazine", "_secondaryweapon", "_secondaryweaponitems", "_secondaryweaponmagazine", "_handgun", "_handgunweaponitems", "_handgunweaponmagazine", "_assigneditems", "_position", "_damage", "_dir", "_object"];

			_object = _this select 0;
			_name = _this select 1;
			_uid =_this select 2;
			_oID = owner _object;


			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to loadUnit");
			};

			_name = format["aegis_%1_%2_inventory", _name,_uid];

			_save = [_name, "ARRAY"];
			_array = MEMBER("read", _save);
			if(_array isequalto "") exitwith {false};

			[[_object, _array],"aegis_fnc_restoreInventory",_oID,true] call BIS_fnc_MP;

			true;
		};

		PUBLIC FUNCTION("array","savePlayerMoney") {
			private ["_name", "_amount", "_result", "_array"];

			_name = _this select 0;
			_UID = _this select 1;
			_amount = _this select 2;


			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to savePlayerMoney");
			};

			_name = format["aegis_%1_%2_money", _name, _UID];

			_array = [_amount];

			_save = [_name, _array];
			MEMBER("write", _save);
		};


		PUBLIC FUNCTION("array","getPlayerBalance") {
			private ["_name", "_balance", "_result", "_array"];

			_name = _this select 0;
			_UID = _this select 1;



			if (isnil "_name") exitwith {
				MEMBER("ToLog", "PDW: require a unit name to getPlayerBalance");
			};

			_name = format["aegis_%1_%2_money", _name, _UID];

			_save = [_name, "ARRAY"];
			_array = MEMBER("read", _save);
			if(_array isequalto "") exitwith {false};

			_balance = _array select 0;

			_balance;

		};



		PUBLIC FUNCTION("","deconstructor") {
			DELETE_VARIABLE("driver");
			DELETE_VARIABLE("filename");
		};
	ENDCLASS;
