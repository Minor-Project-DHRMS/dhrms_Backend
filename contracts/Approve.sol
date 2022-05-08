//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";
import "hardhat/console.sol";

contract ApproveDetails{

    struct Approve {
        address instanceAdd;
        address userAdd;
        string userType;
        uint256 timestamp;
    }

    Approve[] private ApproveList;

    function addGovernmentOfficetoList(
        string memory _officeName,
        string memory _phoneNumber,
        address _GID
    ) public {
        address govOfficeAdd = address(
            new Government(_officeName, _phoneNumber, _GID)
        );
        
        ApproveList.push(Approve(govOfficeAdd, _GID, "GOV", block.timestamp));
    }

    function addHospitaltoList(
        string memory _hospitalName,
        string memory _phoneNumber,
        address _HID
    ) public {
        address hospitalAdd = address(
            new Hospital(_hospitalName, _HID, _phoneNumber)
        );
        ApproveList.push(Approve(hospitalAdd, _HID, "HOS", block.timestamp));
    }

    function addDoctortoList(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) public {
        address doctorAdd = address(
            new Doctor(
                _doctorName,
                _phoneNumber,
                _qualification,
                _photo,
                _dob,
                _HID,
                _DID,
                _department
            )
        );
        ApproveList.push(Approve(doctorAdd, _DID, "DOC", block.timestamp));
    }

    function addPatienttoList(string memory _details, address _PID)
        public
    
    {
        address patientAdd = address(new Patient(_details, _PID));

        ApproveList.push(Approve(patientAdd, _PID, "PAT", block.timestamp));
    }

    function getApproveList() public view returns (Approve[] memory) {
        return ApproveList;
    }


    function getInstanceAddress(address _userAdd) public
        returns (address) {
            address instance;
        if(ApproveList.length == 1){
            instance = ApproveList[0].instanceAdd;
            ApproveList.pop();
            return instance;
        }
        for (uint256 i = 0; i < ApproveList.length ; i++) {
            if (ApproveList[i].userAdd == _userAdd) {
                instance = ApproveList[i].instanceAdd;
                ApproveList[i] = ApproveList[ApproveList.length-1];
                ApproveList.pop();
                return instance;
            }
        }
        return 0x0000000000000000000000000000000000000000;
    }
    



}