// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

uint256 constant _tableId = uint256(keccak256("/world_internals/tables/SystemTable"));
uint256 constant SystemTableTableId = _tableId;

library SystemTable {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](2);
    _schema[0] = SchemaType.ADDRESS;
    _schema[1] = SchemaType.BOOL;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](2);
    _fieldNames[0] = "system";
    _fieldNames[1] = "publicAccess";
    return ("SystemTable", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Register the table's schema for the specified store */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema());
  }

  /** Set the table's metadata for the specified store */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get system */
  function getSystem(uint256 routeId) internal view returns (address system) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 0);
    return address(Bytes.slice20(_blob, 0));
  }

  /** Get system from the specified store */
  function getSystem(IStore _store, uint256 routeId) internal view returns (address system) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 0);
    return address(Bytes.slice20(_blob, 0));
  }

  /** Set system */
  function setSystem(uint256 routeId, address system) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    StoreSwitch.setField(_tableId, _primaryKeys, 0, abi.encodePacked(system));
  }

  /** Get publicAccess */
  function getPublicAccess(uint256 routeId) internal view returns (bool publicAccess) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 1);
    return _toBool(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get publicAccess from the specified store */
  function getPublicAccess(IStore _store, uint256 routeId) internal view returns (bool publicAccess) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 1);
    return _toBool(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set publicAccess */
  function setPublicAccess(uint256 routeId, bool publicAccess) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    StoreSwitch.setField(_tableId, _primaryKeys, 1, abi.encodePacked(publicAccess));
  }

  /** Get the full data */
  function get(uint256 routeId) internal view returns (address system, bool publicAccess) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _primaryKeys, getSchema());
    return decode(_blob);
  }

  /** Get the full data from the specified store */
  function get(IStore _store, uint256 routeId) internal view returns (address system, bool publicAccess) {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    bytes memory _blob = _store.getRecord(_tableId, _primaryKeys);
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(uint256 routeId, address system, bool publicAccess) internal {
    bytes memory _data = abi.encodePacked(system, publicAccess);

    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    StoreSwitch.setRecord(_tableId, _primaryKeys, _data);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal pure returns (address system, bool publicAccess) {
    system = address(Bytes.slice20(_blob, 0));

    publicAccess = _toBool(uint8(Bytes.slice1(_blob, 20)));
  }

  /* Delete all data for given keys */
  function deleteRecord(uint256 routeId) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);

    _primaryKeys[0] = bytes32(uint256(routeId));

    StoreSwitch.deleteRecord(_tableId, _primaryKeys);
  }
}

function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}
