// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";
import "contracts/STORAGE.sol";
import "contracts/DHRMS_PAT.sol";
import "contracts/DHRMS_DOC.sol";
import "contracts/DHRMS_HOS.sol";
import "contracts/DHRMS_GOV.sol";
import "hardhat/console.sol";

contract ApproveDetails {
    struct Approve {
        address instanceAdd;
        address userAdd;
        string userType;
        uint256 timestamp;
    }

    address STORAGE_CONTRACT_ADDRESS;
    address DHRMS_GOV_CONTRACT_ADDRESS;
    address DHRMS_PAT_CONTRACT_ADDRESS;
    address DHRMS_DOC_CONTRACT_ADDRESS;
    address DHRMS_HOS_CONTRACT_ADDRESS;


    constructor(address _DHRMS_PAT_CONTRACT_ADDRESS,address _DHRMS_HOS_CONTRACT_ADDRESS,address _DHRMS_DOC_CONTRACT_ADDRESS,address _DHRMS_GOV_CONTRACT_ADDRESS) {
        DHRMS_PAT_CONTRACT_ADDRESS = _DHRMS_PAT_CONTRACT_ADDRESS;
        DHRMS_HOS_CONTRACT_ADDRESS = _DHRMS_HOS_CONTRACT_ADDRESS;
        DHRMS_DOC_CONTRACT_ADDRESS = _DHRMS_DOC_CONTRACT_ADDRESS;
        DHRMS_GOV_CONTRACT_ADDRESS = _DHRMS_GOV_CONTRACT_ADDRESS;

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

    function addPatienttoList(string memory _details, address _PID) public {
        address patientAdd = address(new Patient(_details, _PID));

        ApproveList.push(Approve(patientAdd, _PID, "PAT", block.timestamp));
    }

    function getApproveList() public view returns (Approve[] memory) {
        return ApproveList;
    }

    function getPatientDetails(address _instanceAddress)
        public
        view
        returns (string memory)
    {
        return Patient(_instanceAddress).getDetails();
    }

    function getDoctorDetails(address _instanceAddress)
        public
        view
        returns (string[6] memory)
    {
        return [
            Doctor(_instanceAddress).getDoctorName(),
            Doctor(_instanceAddress).getphoneNumber(),
            Doctor(_instanceAddress).getQualification(),
            Doctor(_instanceAddress).getPhoto(),
            Doctor(_instanceAddress).getDob(),
            Doctor(_instanceAddress).getDepartment()
        ];
    }

    function getHospitalDetails(address _instanceAddress)
        public
        view
        returns (string[2] memory)
    {
        return [
            Hospital(_instanceAddress).getHospitalName(),
            Hospital(_instanceAddress).getPhoneNumber()
        ];
    }

    function getGovernmentDetails(address _instanceAddress)
        public
        view
        returns (string[2] memory)
    {
        return [
            Government(_instanceAddress).getOfficeName(),
            Government(_instanceAddress).getPhoneNumber()
        ];
    }

    function approve(address _userAdd) public {
        for (uint256 i = 0; i < ApproveList.length; i++) {
            if (ApproveList[i].userAdd == _userAdd) {
                if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("GOV")
                ) {
                    DHRMS_GOV(DHRMS_GOV_CONTRACT_ADDRESS).addGovernmentOffice(
                        Government(ApproveList[i].instanceAdd).getOfficeName(),
                        Government(ApproveList[i].instanceAdd).getPhoneNumber(),
                        Government(ApproveList[i].instanceAdd).getGID()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("HOS")
                ) {
                    DHRMS_HOS(DHRMS_HOS_CONTRACT_ADDRESS).addHospital(
                        Hospital(ApproveList[i].instanceAdd).getHospitalName(),
                        Hospital(ApproveList[i].instanceAdd).getPhoneNumber(),
                        Hospital(ApproveList[i].instanceAdd).getHID()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("DOC")
                ) {
                    DHRMS_DOC(DHRMS_DOC_CONTRACT_ADDRESS).addDoctor(
                        Doctor(ApproveList[i].instanceAdd).getDoctorName(),
                        Doctor(ApproveList[i].instanceAdd).getphoneNumber(),
                        Doctor(ApproveList[i].instanceAdd).getQualification(),
                        Doctor(ApproveList[i].instanceAdd).getPhoto(),
                        Doctor(ApproveList[i].instanceAdd).getDob(),
                        Doctor(ApproveList[i].instanceAdd).getHospital(),
                        Doctor(ApproveList[i].instanceAdd).getDID(),
                        Doctor(ApproveList[i].instanceAdd).getDepartment()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("PAT")
                ) {
                    DHRMS_PAT(DHRMS_PAT_CONTRACT_ADDRESS).addPatient(
                        Patient(ApproveList[i].instanceAdd).getDetailsForGov(),
                        Patient(ApproveList[i].instanceAdd).getPID()
                    );
                }
                if (ApproveList.length == 1) {
                    ApproveList.pop();
                } else {
                    ApproveList[i] = ApproveList[ApproveList.length - 1];
                    ApproveList.pop();
                }
            }
        }
    }

    function disApprove(address _userAdd) public {
        for (uint256 i = 0; i < ApproveList.length; i++) {
            if (ApproveList[i].userAdd == _userAdd) {
                if (ApproveList.length != 1) {
                    ApproveList[i] = ApproveList[ApproveList.length - 1];
                }
                ApproveList.pop();
            }
        }
    }
}
