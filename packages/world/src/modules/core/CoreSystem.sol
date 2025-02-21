// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IErrors } from "../../interfaces/IErrors.sol";

import { WorldRegistrationSystem } from "./implementations/WorldRegistrationSystem.sol";
import { StoreRegistrationSystem } from "./implementations/StoreRegistrationSystem.sol";
import { ModuleInstallationSystem } from "./implementations/ModuleInstallationSystem.sol";
import { AccessManagementSystem } from "./implementations/AccessManagementSystem.sol";

/**
 * The CoreSystem includes all World functionality that is externalized
 * from the World contract to keep the World contract's bytecode as lean as possible.
 */
contract CoreSystem is
  IErrors,
  WorldRegistrationSystem,
  StoreRegistrationSystem,
  ModuleInstallationSystem,
  AccessManagementSystem
{

}
