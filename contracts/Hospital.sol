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
         if(doctorsList.length == 1){
            doctorsList.pop();
        }
        else{
            for(uint i=0; i < doctorsList.length; i++){
                if(doctorsList[i] == _DID){
                    doctorsList[i] = doctorsList[doctorsList.length-1];
                    doctorsList.pop();
                    break;
                }
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
        if(patientsList.length == 1){
            patientsList.pop();
        }
        else{
            for(uint i=0; i < patientsList.length; i++){
            if(patientsList[i] == _PID){
                patientsList[i] = patientsList[patientsList.length-1];
                patientsList.pop();
                break;
            }
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
        address _HID
    ) public {
        uplaodQueue.push(
            fileDetails(PID, _file, msg.sender, _HID, block.timestamp)
        );
    }

    function getUploadQueue() public view returns (fileDetails[] memory) {
        return uplaodQueue;
    }

    function removeReport(address _PID) public {
        if(uplaodQueue.length == 1){
            uplaodQueue.pop();
        }
        else{
            for(uint i=0; i < uplaodQueue.length; i++){
                if(uplaodQueue[i].PID == _PID){
                    uplaodQueue[i] = uplaodQueue[uplaodQueue.length-1];
                    uplaodQueue.pop();
                    break;
                }
            }
        }
    }
}
