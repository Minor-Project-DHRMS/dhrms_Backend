// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "contracts/Patient.sol";
import "contracts/STORAGE.sol";
import "contracts/RBAC.sol";


contract DHRMS_PAT{
    address STORAGE_CONTRACT_ADDRESS;
    address RBAC_CONTRACT_ADDRESS;

    constructor(address _STORAGE_CONTRACT_ADDRESS, address _RBAC_CONTRACT_ADDRESS) {
        STORAGE_CONTRACT_ADDRESS = _STORAGE_CONTRACT_ADDRESS;
        RBAC_CONTRACT_ADDRESS = _RBAC_CONTRACT_ADDRESS;
    }

    event newPatient(string _details, address _PID);
    event newReadAccess(address _DID);
    event newWriteAccess(address _HID);
    event removeReadAccessDoctor(address _DID);
    event removeWriteAccessHospital(address _HID);



    function addPatient(string memory _details, address _PID)
        public
        onlyGoverment
    {
        STORAGE(STORAGE_CONTRACT_ADDRESS).addPatientDetails(_PID,address(new Patient(_details, _PID))
        );
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl(
            "PATIENT",
            _PID
        );
        // STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID) = ;
        emit newPatient(_details, _PID);
    }

    function giveReadAccess(address _DID) public onlyPatient {
        Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(msg.sender)).addDoctor(_DID);
        Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).addPatient(msg.sender);
        emit newReadAccess(_DID);
    }


    function giveWriteAccess(address _HID) public onlyPatient {
        Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(msg.sender)).addHospital(_HID);
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).addPatient(msg.sender);
        emit newWriteAccess(_HID);
    }


    function removeReadAccess(address _DID) public onlyPatient {
        Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(msg.sender)).removeDoctor(_DID);
        Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).removePatient(msg.sender);
        emit removeReadAccessDoctor(_DID);
    }

    function removeWriteAccess(address _HID) public onlyPatient {
        Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(msg.sender)).removeHospital(_HID);
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).removePatient(msg.sender);
        emit removeWriteAccessHospital(_HID);
    }


    function getDoctorsList(address _PID)
        public
        view
        returns (address[] memory)
    {
        return Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID)).getDoctorsList();
    }

    function getHospitalsList(address _PID)
        public
        view
        returns (address[] memory)
    {
        return Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID)).getHospitalsList();
    }


    function getRecordsHistory(address _PID)
        public
        view
        returns (string[] memory)
    {
        return Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID)).getrecordsHistory();
    }


    function getPatientDetails(address _PID)
        public
        view
        returns (string memory)
    {
        return Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID)).getDetails();
    }

    function getPatientDetailsForGov(address _PID)
        public
        view
        onlyGoverment
        returns (string memory)
    {
        return Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails(_PID)).getDetails();
    }







    function _onlyGoverment() private view {
        require(
            ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isGovernment(tx.origin),
            "Restricted to users."
        );
    }

    modifier onlyGoverment() {
        _onlyGoverment();
        _;
    }

    function _onlyPatient() private view {
        require(
            ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isPatient(tx.origin),
            "Restricted to PATIENT."
        );
    }

    modifier onlyPatient() {
        _onlyPatient();
        _;
    }

    function _onlyDoctor() private view {
        require(
            ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isDoctor(tx.origin),
            "Restricted to DOCTOR."
        );
    }

    modifier onlyDoctor() {
        _onlyDoctor();
        _;
    }

    function _onlyHospital() private view {
        require(
            ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isHospital(tx.origin),
            "Restricted to HOSPITAL."
        );
    }

    modifier onlyHospital() {
        _onlyHospital();
        _;
    }
}