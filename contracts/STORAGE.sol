// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


import "contracts/Government.sol";
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

    function addPatientDetails(address PID, address instanceAdd) public {
        patientDetails[PID] = instanceAdd;
    }
    function addGovernmentDetails(address GID, address instanceAdd) public {
        governmentDetails[GID] = instanceAdd;
    }
    function addHospitalDetails(address HID, address instanceAdd) public {
        hospitalDetails[HID] = instanceAdd;
    }
    function addDoctorDetails(address DID, address instanceAdd) public {
        doctorDetails[DID] = instanceAdd;
    }


    function removePatientDetails(address PID) public {
        delete patientDetails[PID];
    }
    function removeGovernmentDetails(address GID) public {
        delete governmentDetails[GID];
    }
    function removeHospitalDetails(address HID) public {
        delete hospitalDetails[HID];
    }
    function removeDoctorDetails(address DID) public {
        delete doctorDetails[DID];
    }

}