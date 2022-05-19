// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "hardhat/console.sol";


contract STORAGE {
    mapping (address => address) public doctorDetails;
    mapping (address => address) public patientDetails;
    mapping (address => address) public hospitalDetails;
    mapping (address => address) public governmentDetails;

    address RBAC_CONTRACT_ADDRESS;
    address APPROVE_CONTRACT_ADDRESS;

    constructor(
        string memory _officeName,
        string memory _phoneNumber,
        address _RBAC_CONTRACT_ADDRESS
    ) {
        governmentDetails[msg.sender] = address(
            new Government(_officeName, _phoneNumber, msg.sender)
        );

        RBAC_CONTRACT_ADDRESS = _RBAC_CONTRACT_ADDRESS;
    }

}