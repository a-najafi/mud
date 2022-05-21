import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { blue, green } from "colorette";
import { CombinedFacets, LocalLatticeGameLocator } from "../types/ethers-contracts";
import { deployComponent } from "../deploy-utils/components";
import { deployAccessController } from "../deploy-utils/accessControllers";
// import { deployContentCreator } from "../deploy-utils/contentCreators";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { diamond, deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  const personaMiror = await hre.ethers.getContract("PersonaMirror", deployer);
  const LibQuery = await hre.deployments.get("LibQuery");

  console.log(blue("Deploying Diamond"));

  await diamond.deploy("Diamond", {
    from: deployer,
    owner: deployer,
    facets: ["EmberFacet", "InitializeFacet", "CastSpellFacet"],
    log: true,
    execute: {
      methodName: "initializeExternally",
      args: [[true, personaMiror.address]],
    },
    libraries: {
      LibQuery: LibQuery.address,
    },
    autoMine: true,
  });

  const ember = (await hre.ethers.getContract("Diamond", deployer)) as CombinedFacets;
  const world = await ember.world();
  // Deploy components
  await deployComponent(hre, world, ember.address, "PositionComponent");
  await deployComponent(hre, world, ember.address, "EntityTypeComponent");
  // Deploy access controllers
  await deployAccessController(hre, ember, "PersonaAccessController");
  // Deploy content creators
  // await deployContentCreator(hre, ember, "SpellContentCreator")
  // Deploy embodied systems

  console.log(blue("Deploying LocalLatticeGameLocator"));
  await deploy("LocalLatticeGameLocator", {
    from: deployer,
    log: true,
    autoMine: true,
    args: [],
    deterministicDeployment: "0xAAAAFFFF",
  });
  console.log(blue("Local Lattice game linked"));
  const localLatticeGameLocator = (await hre.ethers.getContract(
    "LocalLatticeGameLocator",
    deployer
  )) as LocalLatticeGameLocator;
  const tx = await localLatticeGameLocator.setLocalLatticeGameAddress(ember.address);
  await tx.wait();
  console.log(green("LocalLatticeGameLocator: " + localLatticeGameLocator.address));
};
export default func;
func.tags = ["Diamond"];