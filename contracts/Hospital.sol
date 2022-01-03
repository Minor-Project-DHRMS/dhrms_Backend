//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Hospital {
    string private hospitalName;
    address private HID;
    string private phoneNumber;
    mapping(address => bool) private doctors;
    mapping(address => bool) private patients;
    address[] doctorsList;
    address[] patientsList;

    constructor(
        string memory _hospitalName,
        address _HID,
        string memory _phoneNumber
    ) {
        hospitalName = _hospitalName;
        HID = _HID;
        phoneNumber = _phoneNumber;
    }

    struct fileDetails {
        address PID;
        string file;
        address DID;
        address HID;
        uint256 timeStamp;
    }

    fileDetails[] uplaodQueue;

    function getHospitalName() public view returns (string memory) {
        return hospitalName;
    }

    function setHospitalName(string memory _hospitalName) public {
        hospitalName = _hospitalName;
    }

    function getHID() public view returns (address) {
        return HID;
    }

    function setHID(address _HID) public {
        HID = _HID;
    }

    function getPhoneNumber() public view returns (string memory) {
        return phoneNumber;
    }

    function setPhoneNumber(string memory _phoneNumber) public {
        phoneNumber = _phoneNumber;
    }

    function addDoctor(address _DID) public {
        doctorsList.push(_DID);
        doctors[_DID] = true;
    }

    function removeDoctor(address _DID) public {
        for(uint i=0; i < doctorsList.length-1; i++){
            if(doctorsList[i] == _DID){
                delete doctorsList[i];
                break;
            }
        }
        delete doctors[_DID];
    }

    function getDoctorsList() public view returns(address[] memory){
        return doctorsList;
    }

    function addPatient(address _PID) public {
        patientsList.push(_PID);
        patients[_PID] = true;
    }

    function removePatient(address _PID) public {
        for(uint i=0; i < patientsList.length-1; i++){
            if(patientsList[i] == _PID){
                delete doctorsList[i];
                break;
            }
        }
        delete patients[_PID];
    }

    function getPatientsList() public view returns(address[] memory){
        return patientsList;
    }

    function isDoctor(address _DID) public view returns (bool) {
        return doctors[_DID];
    }

    function isPatient(address _DID) public view returns (bool) {
        return patients[_DID];
    }

    function addToUplaodQueue(
        string memory _file,
        address PID,
        address HID
    ) public {
        uplaodQueue.push(
            fileDetails(PID, _file, msg.sender, HID, block.timestamp)
        );
    }

    function getUploadQueue() public view returns (fileDetails[] memory) {
        return uplaodQueue;
    }
}
