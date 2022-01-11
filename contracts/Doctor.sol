//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract Doctor{

    string private doctorName;
    address private DID;
    string private phoneNumber;
    string private qualification;
    string private photo;
    string private dob;
    address private HID;
    mapping(address => bool) private patients;
    address[] patientlist;
    string private department;
    uint patientCount;

    //  "Raja","2342342342","MBBS","asdsdfsdf","12/02/2123",0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC,"Medical"
    constructor(string memory _doctorNstring memory _phoneNumber,string memory _qualification,string memory _photo,string memory _dob,address _HID,address _DID,string memory _department)
    {
        doctorN =_doctorN
        DID = _DID;
        phoneNumber = _phoneNumber;
        qualification = _qualification;
        photo = _photo;
        dob = _dob;
        HID = _HID;
        department = _department;
    }

    function getDoctordoctorN) public view returns(string memory){
        return doctorN
    }

    function setDoctordoctorNstring memory _doctorN public {
        doctorN= _doctorN
    }

    function getDID() public view returns(address){
        return DID;
    }

    function setDID(address _DID) public {
        DID = _DID;
    }

    function setphoneNumber(string memory _phoneNumber) public {
        phoneNumber = _phoneNumber;
    }

    function getphoneNumber() public view returns(string memory){
        return phoneNumber;
    }

    function setQualification(string memory _qualification) public {
        qualification = _qualification;
    }

    function getQualification() public view returns(string memory){
        return qualification;
    }

    function setPhoto(string memory _photo) public {
        photo = _photo;
    }

    function getPhoto() public view returns(string memory){
        return photo;
    }

    function setHospital(address _HID) public {
        HID = _HID;
    }

    function getHospital() public view returns(address){
        return HID;
    }

    function addPatient(address _PID) public{
        patients[_PID] = true;
        patientlist.push(_PID);
    }

    function removePatient(address _PID) public {
       delete patients[_PID];
   
       for(unit i=0; i < patientlist.length; i++){
           if(patientlist[i] == _PID){
               break;
           }
       }
       delete patientlist[i];
    }

    function getPatientList() public view returns(address[] memory){
        return patientlist;
    }


    

}