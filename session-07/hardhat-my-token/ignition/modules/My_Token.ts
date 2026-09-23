import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseUnits } from "ethers";

export default buildModule("MyTokenModule", (m) => {
  const initialSupply = m.getParameter("initialSupply", parseUnits("1000", 18));

  const token = m.contract("MyToken", [initialSupply]);

  return { token };
});