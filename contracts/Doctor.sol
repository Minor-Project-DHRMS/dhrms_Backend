//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Doctor {
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
    uint256 patientCount;

    constructor(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) {
        doctorName = _doctorName;
        DID = _DID;
        phoneNumber = _phoneNumber;
        qualification = _qualification;
        photo = _photo;
        dob = _dob;
        HID = _HID;
        department = _department;
    }

    function getDoctorName() public view returns (string memory) {
        return doctorName;
    }

    function setDoctorDetails(string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        string memory _department)  public {
            doctorName = _doctorName;
            phoneNumber = _phoneNumber;
            qualification = _qualification;
            photo = _photo;
            dob = _dob;
            HID = _HID;
            department = _department;
        
    }

    

    function getDID() public view returns (address) {
        return DID;
    }

    function setDID(address _DID) public {
        DID = _DID;
    }

    function getphoneNumber() public view returns (string memory) {
        return phoneNumber;
    }

    function getQualification() public view returns (string memory) {
        return qualification;
    }

    function getPhoto() public view returns (string memory) {
        return photo;
    }

    function getDob() public view returns (string memory) {
        return dob;
    }

    function getDepartment() public view returns (string memory) {
        return department;
    }

    function getHospital() public view returns (address) {
        return HID;
    }

    function addPatient(address _PID) public {
        patients[_PID] = true;
        patientlist.push(_PID);
    }

    function removePatient(address _PID) public {
        
        for (uint256 i = 0; i < patientlist.length-1; i++) {
            if (patientlist[i] == _PID) {
                if(patientlist.length != 1){
                    patientlist[i] =  patientlist[patientlist.length-1];
                }
                delete patients[_PID];
                patientlist.pop();
                break;
            }
        }
        
    }

    function getPatientList() public view returns (address[] memory) {
        return patientlist;
    }
}
