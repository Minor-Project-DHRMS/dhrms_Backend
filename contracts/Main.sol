//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";


import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";


// contract RoleAccess{



//     mapping(address => bool) isPatient;
//     mapping(address => bool) isDoctor;
//     mapping(address => bool) isHospital;
//     mapping(address => bool) isGovernment;


    
    
// }

contract Main is AccessControl{

    bytes32 public constant GOVERNMENT = keccak256("GOVERNMENT");
    bytes32 public constant PATIENT = keccak256("PATIENT");
    bytes32 public constant HOSPITAL = keccak256("HOSPITAL");
    bytes32 public constant DOCTOR = keccak256("DOCTOR");

    

    mapping(address => address) patientDetails; 
    mapping(address => address) doctorDetails;     
    mapping(address => address) hospitalDetails;    
    mapping(address => address) governmentDetails;  




    event newOffice(string officeName, string _phoneNumber, address _GID);
    event newHospital(string HospitalName, string ph_no, address HID);
    event newDoctor(string _doctorName, string _phoneNumber, string _qualification, string _photo, string _dob, address _HID, address _DID,string _department);
    event newPatient(string _details,address _PID);
    event newReadAccess(address _DID);
    event newWriteAccess(address _HID);
    event removeReadAccessDoctor(address _DID);
    event removeWriteAccessHospital(address _HID);
    event newRecordForUpload(string _file, address _PID);
    event newRecordForUploadH(string _file, address _PID,address _HID);

    constructor(string memory _officeName, string memory _phoneNumber){
        address firstGovermentOfficeAdd = address(new Government(_officeName, _phoneNumber, msg.sender));
        governmentDetails[msg.sender] = firstGovermentOfficeAdd;

        _setupRole("GOVERNMENT", msg.sender);
        _setRoleAdmin("PATIENT", "GOVERNMENT");
        _setRoleAdmin("HOSPITAL", "GOVERNMENT");
        _setRoleAdmin("DOCTOR", "GOVERNMENT");
    }

    function addGovernmentOffice(string memory _officeName, string memory _phoneNumber, address _GID) public onlyGoverment() {
        address govOfficeAdd = address(new Government(_officeName, _phoneNumber, _GID));
        governmentDetails[_GID] = govOfficeAdd;
        grantRole("GOVERNMENT", _GID);
        // isGovernment[_GID] = true;
        emit newOffice(_officeName, _phoneNumber, _GID);
    }

    function addHospital(string memory _hospitalName, string memory _phoneNumber, address _HID) public onlyGoverment() {
        address hospitalAdd = address(new Hospital(_hospitalName, _HID, _phoneNumber));
        hospitalDetails[_HID] = hospitalAdd;
        grantRole("HOSPITAL", _HID);
        // isHospital[_HID] = true;
        emit newHospital(_hospitalName,_phoneNumber,_HID);
    }

    function addDoctor(string memory _doctorName, string memory _phoneNumber,string memory _qualification,string memory _photo,string memory _dob,address _HID,address _DID,string memory _department) public onlyGoverment() {
        address doctorAdd = address(new Doctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department));
        doctorDetails[_DID] = doctorAdd;
        grantRole("DOCTOR", _DID);
        // isDoctor[_DID] = true;
        emit newDoctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department);
    }

    function addPatient(string memory _details, address _PID) public onlyGoverment() {
        address  patientAdd = address(new Patient(_details, _PID));
        patientDetails[_PID] = patientAdd;

        grantRole("PATIENT", _PID);

        emit newPatient(_details, _PID);
    }

    function giveReadAccess(address _DID) public onlyPatient(){
        Patient patient = Patient(patientDetails[msg.sender]);
        Doctor doctor = Doctor(doctorDetails[_DID]);
        patient.addDoctor(_DID);
        doctor.addPatient(msg.sender);
        emit newReadAccess(_DID);
    }
    function giveWriteAccess(address _HID) public onlyPatient() {
        Patient patient = Patient(patientDetails[msg.sender]);
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        patient.addHospital(_HID);
        hospital.addPatient(msg.sender);
        emit newWriteAccess(_HID);
    }

    function removeReadAccess(address _DID) public onlyPatient() {
        Patient patient = Patient(patientDetails[msg.sender]);
        Doctor doctor = Doctor(doctorDetails[_DID]);
        patient.removeDoctor(_DID);
        doctor.removePatient(msg.sender);
        emit removeReadAccessDoctor(_DID);
    }

    function removeWriteAccess(address _HID) public onlyPatient() {
        Patient patient = Patient(patientDetails[msg.sender]);
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        patient.removeHospital(_HID);
        hospital.removePatient(msg.sender);
        emit removeWriteAccessHospital(_HID);
    }

    function sendRecordsForUpload(string memory _file, address _PID) public onlyDoctor() {
        Doctor doctor = Doctor(doctorDetails[msg.sender]);
        address _HID = doctor.getHospital();
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        hospital.addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUpload(_file, _PID);
    }

    function sendRecordsForUploadH(string memory _file, address _PID,address _HID) public onlyHospital() {
        Hospital hospital = Hospital(hospitalDetails[msg.sender]);
        hospital.addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUploadH(_file, _PID, _HID);
    }

    function reportUploaded(address _PID,string memory _CID) public onlyHospital() {
        Patient patient = Patient(patientDetails[_PID]);
        Hospital hospital = Hospital(hospitalDetails[msg.sender]);
        patient.addrecordsHistory(_CID);
        hospital.removeReport(_PID);
    }

    
    modifier onlyGoverment() {
        // require(isGovernment[msg.sender]);
        require(hasRole("GOVERNMENT", msg.sender), "Restricted to users.");
        _;
    }

    modifier onlyPatient() {
        // require(isPatient[msg.sender]);
        require(hasRole("PATIENT", msg.sender), "Restricted to PATIENT.");
        _;
    }

    modifier onlyDoctor() {
        // require(isDoctor[msg.sender]);
        require(hasRole("DOCTOR", msg.sender), "Restricted to DOCTOR.");
        _;
    }

    modifier onlyHospital() {
        // require(isHospital[msg.sender]);
        require(hasRole("HOSPITAL", msg.sender), "Restricted to HOSPITAL.");
        _;
    }
}