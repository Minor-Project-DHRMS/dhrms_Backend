// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";
import "./lib/Roles.sol";

import "hardhat/console.sol";

contract Main{

    
    using Roles for Roles.Role;
    Roles.Role private ispatient;
    Roles.Role private isdoctor;
    Roles.Role private ishospital;
    Roles.Role private isgovernment;

    
    modifier onlyGoverment() {
        require(ispatient.has(msg.sender));
        _;
    }

    modifier onlyPatient() {
        require(ishospital.has(msg.sender));
        _;
    }

    modifier onlyDoctor() {
        require(isgovernment.has(msg.sender));
        _;
    }

    modifier onlyHospital() {
        require(isdoctor.has(msg.sender));
        _;
    }
    

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
        //isgovernment.add(msg.sender);
    }

    function addGovernmentOffice(string memory _officeName, string memory _phoneNumber, address _GID) public onlyGoverment() {
        address govOfficeAdd = address(new Government(_officeName, _phoneNumber, _GID));
        governmentDetails[_GID] = govOfficeAdd;
        //isgovernment.add(_GID);
        emit newOffice(_officeName, _phoneNumber, _GID);
    }

    function addHospital(string memory _hospitalName, string memory _phoneNumber, address _HID) public onlyGoverment() {
        address hospitalAdd = address(new Hospital(_hospitalName, _HID, _phoneNumber));
        hospitalDetails[_HID] = hospitalAdd;
        //ishospital.add(_HID);
        emit newHospital(_hospitalName,_phoneNumber,_HID);
    }

    function addDoctor(string memory _doctorName, string memory _phoneNumber,string memory _qualification,string memory _photo,string memory _dob,address _HID,address _DID,string memory _department) public onlyGoverment() {
        address doctorAdd = address(new Doctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department));
        doctorDetails[_DID] = doctorAdd;
        //isdoctor.add(_DID);
        emit newDoctor(_doctorName, _phoneNumber, _qualification, _photo, _dob, _HID, _DID, _department);
    }

    function addPatient(string memory _details, address _PID) public{
        console.log("Hiii from addpatient : ");
        console.log(_PID);
        address  patientAdd = address(new Patient(_details, _PID));
        patientDetails[_PID] = patientAdd;
        //ispatient.add(_PID);
        emit newPatient(_details, _PID);
    }


    function getGovDetails(address _GID) public view returns (string memory) {
        return Government(governmentDetails[_GID]).getOfficeName();
    }

    function getPatentDetails(address _PID) public view returns (string memory) {
        return Patient(patientDetails[_PID]).getDetails();
    }


    function giveReadAccess(address _DID) public onlyPatient() {
        Patient(patientDetails[msg.sender]).addDoctor(_DID);
        Doctor(doctorDetails[_DID]).addPatient(msg.sender);
        emit newReadAccess(_DID);
    }
    
    function giveWriteAccess(address _HID) public onlyPatient() {
        Patient(patientDetails[msg.sender]).addHospital(_HID);
        Hospital(hospitalDetails[_HID]).addPatient(msg.sender);
        emit newWriteAccess(_HID);
    }

    function removeReadAccess(address _DID) public onlyPatient() {
        Patient(patientDetails[msg.sender]).removeDoctor(_DID);
        Doctor(doctorDetails[_DID]).removePatient(msg.sender);
        emit removeReadAccessDoctor(_DID);
    }

    function removeWriteAccess(address _HID) public onlyPatient() {
        Patient(patientDetails[msg.sender]).removeHospital(_HID);
        Hospital(hospitalDetails[_HID]).removePatient(msg.sender);
        emit removeWriteAccessHospital(_HID);
    }

    function sendRecordsForUpload(string memory _file, address _PID) public onlyDoctor() {
        address _HID = Doctor(doctorDetails[msg.sender]).getHospital();
        Hospital(hospitalDetails[_HID]).addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUpload(_file, _PID);
    }

    function sendRecordsForUploadH(string memory _file, address _PID,address _HID) public onlyHospital() {
        Hospital(hospitalDetails[msg.sender]).addToUplaodQueue(_file,_PID,_HID);
        emit newRecordForUploadH(_file, _PID, _HID);
    }

    function reportUploaded(address _PID,string memory _CID) public onlyHospital() {
        Patient(patientDetails[_PID]).addrecordsHistory(_CID);
        Hospital(hospitalDetails[msg.sender]).removeReport(_PID);
    }
}