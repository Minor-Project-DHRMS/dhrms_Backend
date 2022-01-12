// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";


contract Main{

    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;
    mapping(address => bool) isHospital;
    mapping(address => bool) isGovernment;

    mapping(address => address) patientDetails; 
    mapping(address => address) doctorDetails;     
    mapping(address => address) hospitalDetails;    
    mapping(address => address) governmentDetails;  


    event newOffice(string officeName, string ph_no, address GID);
    event newHospital(string HospitalName, string ph_no, address HID);
    event newDoctor(string _doctorName, string _phoneNumber, string _qualification, string _photo, string _dob, address _HID, address _DID,string _department);
    event newPatient(string _details,address _PID);
    event newReadAccess(address _DID);
    event newWriteAccess(address _HID);
    event removeReadAccessDoctor(address _DID);
    event removeWriteAccessHospital(address _HID);
    event newRecordForUpload(string _file, address _PID);
    event newRecordForUploadH(string _file, address _PID,address _HID);

    function addGovernmentOffice(string memory _officeName, string memory _phoneNumber, address _GID) onlyGoverment() public{
        address govOfficeAdd = address(new Government(_officeName, _phoneNumber, _GID));
        governmentDetails[_GID] = govOfficeAdd;
        isGovernment[_GID] = true;
        emit newOffice(_officeName, _phoneNumber, _GID);
    }

    function addDoctor(string memory _doctorName, string memory _phoneNumber,string memory _qualification,string memory _photo,string memory _dob,address _HID,address _DID,string memory _department) onlyGoverment() public{
        address doctorAdd = address(new Doctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department));
        doctorDetails[_DID] = doctorAdd;
        isDoctor[_DID] = true;
        emit newDoctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department);
    }

    function addPatient(string memory _details, address _PID) onlyGoverment() public{
        address  patientAdd = address(new Patient(_details, _PID));
        patientDetails[_PID] = patientAdd;
        isPatient[_PID] = true;
        emit newPatient(_details, _PID);
    }

    function giveReadAccess(address _DID) public {
        Patient patient = Patient(patientDetails[msg.sender]);
        Doctor doctor = Doctor(doctorDetails[_DID]);
        patient.addDoctor(_DID);
        doctor.addPatient(msg.sender);
        emit newReadAccess(_DID);
    }
    function giveWriteAccess(address _HID) public {
        Patient patient = Patient(patientDetails[msg.sender]);
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        patient.addHospital(_HID);
        hospital.addPatient(msg.sender);
        emit newWriteAccess(_HID);
    }

    function removeReadAccess(address _DID) public {
        Patient patient = Patient(patientDetails[msg.sender]);
        Doctor doctor = Doctor(doctorDetails[_DID]);
        patient.removeDoctor(_DID);
        doctor.removePatient(msg.sender);
        emit removeReadAccessDoctor(_DID);
    }

    function removeWriteAccess(address _HID) public {
        Patient patient = Patient(patientDetails[msg.sender]);
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        patient.removeHospital(_HID);
        hospital.removePatient(msg.sender);
        emit removeWriteAccessHospital(_HID);
    }

    function sendRecordsForUpload(string memory _file, address _PID) public {
        Doctor doctor = Doctor(doctorDetails[msg.sender]);
        address _HID = doctor.getHospital();
        Hospital hospital = Hospital(hospitalDetails[_HID]);
        hospital.addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUpload(_file, _PID);
    }

    function sendRecordsForUploadH(string memory _file, address _PID,address _HID) public {
        Hospital hospital = Hospital(hospitalDetails[msg.sender]);
        hospital.addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUploadH(_file, _PID, _HID);
    }

    function reportUploaded(address _PID,string memory _CID) public {
        Patient patient = Patient(patientDetails[_PID]);
        Hospital hospital = Hospital(hospitalDetails[msg.sender]);
        patient.addrecordsHistory(_CID);
        hospital.removeReport(_PID);
    }

    modifier onlyGoverment() {
        require(isGovernment[msg.sender]);
        _;
    }

    modifier onlyPatient() {
        require(isPatient[msg.sender]);
        _;
    }

    modifier onlyDoctors() {
        require(isDoctor[msg.sender]);
        _;
    }

    modifier onlyHospitals() {
        require(isHospital[msg.sender]);
        _;
    }
    
}
