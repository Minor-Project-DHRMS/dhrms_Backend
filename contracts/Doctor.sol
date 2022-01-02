//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract Doctor{

    string private name;
    address private DID;
    string private phno;
    string private qualification;
    string private photo;
    string private dob;
    address private HID;
    mapping(address => bool) private patients;
    address[] PIDList;
    string private department;
    uint patientCount;
    //  "Raja","2342342342","MBBS","asdsdfsdf","12/02/2123",0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC,"Medical"
    constructor(string memory _name,string memory _phno,string memory _qualification,string memory _photo,string memory _dob,address _HID,address _DID,string memory _department)
     {
        name =_name;
        DID = _DID;
        phno = _phno;
        qualification = _qualification;
        photo = _photo;
        dob = _dob;
        HID = _HID;
        department = _department;
    }

    function getDoctorName() public view returns(string memory){
        return name;
    }

    function setDoctorName(string memory _name) public {
        name = _name;
    }

    function getDID() public view returns(address){
        return DID;
    }

    function setDID(address _DID) public {
        DID = _DID;
    }

    function setPhNO(string memory _phno) public {
        phno = _phno;
    }

    function getPhNo() public view returns(string memory){
        return phno;
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
        PIDList.push(_PID);
    }

    function removePatient(address _PID) public {
       uint i;
       delete patients[_PID];
   
       for(i=0;i<PIDList.length;i++){
           if(PIDList[i] == _PID){
               break;
           }
       }
       delete PIDList[i];
    }

    function getPatientList() public view returns(address[] memory){
        return PIDList;
    }


    

}