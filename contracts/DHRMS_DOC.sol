// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "contracts/RBAC.sol";
import "contracts/STORAGE.sol";
import "contracts/Doctor.sol";



contract DHRMS_DOC{
    address STORAGE_CONTRACT_ADDRESS;
    address RBAC_CONTRACT_ADDRESS;

    constructor(address _STORAGE_CONTRACT_ADDRESS, address _RBAC_CONTRACT_ADDRESS) {
        STORAGE_CONTRACT_ADDRESS = _STORAGE_CONTRACT_ADDRESS;
        RBAC_CONTRACT_ADDRESS = _RBAC_CONTRACT_ADDRESS;
    }

    event newDoctor(
        string _doctorName,
        string _phoneNumber,
        string _qualification,
        string _photo,
        string _dob,
        address _HID,
        address _DID,
        string _department
    );

    function addDoctor(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) public onlyGoverment {
        STORAGE(STORAGE_CONTRACT_ADDRESS).addDoctorDetails(_DID,address(
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
        ));
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl(
            "DOCTOR",
            _DID
        );
        emit newDoctor(
            _doctorName,
            _phoneNumber,
            _qualification,
            _photo,
            _dob,
            _HID,
            _DID,
            _department
        );
    }

    event newRecordForUpload(string _file, address _PID);



    function sendRecordsForUpload(string memory _file, address _PID)
        public
        onlyDoctor
    {
        address _HID = Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(msg.sender)).getHospital();
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).addToUplaodQueue(_file, _PID, _HID);
        emit newRecordForUpload(_file, _PID);
    }


    function getDoctorDetails(address _DID)
        public
        view
        returns (string[6] memory)
    {
        return [
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDoctorName(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getphoneNumber(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getQualification(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getPhoto(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDob(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDepartment()
        ];
    }
    
    function getDoctorH(address _DID) public view returns (address) {
        return Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getHospital();
    }


    function getPatientListOfDoc(address _DID)
        public
        view
        returns (address[] memory)
    {
        return Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getPatientList();
    }


    

    modifier onlyGoverment() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyGoverment();
        _;
    }

    

    modifier onlyPatient() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyPatient();
        _;
    }

    

    modifier onlyDoctor() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyDoctor();
        _;
    }

    

    modifier onlyHospital() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyHospital();
        _;
    }
}