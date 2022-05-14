//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Patient {
    string private details;
    address private PID;
    mapping(address => bool) private doctors;
    mapping(address => bool) private hospitals;
    address[] doctorsList;
    address[] hospitalsList;
    string[] recordsHistory;

    constructor(string memory _details, address _PID) {
        details = _details;
        PID = _PID;
    }

    function setDetails(string memory _details) public {
        details = _details;
    }

    function getDetails() public onlyAllowed view returns (string memory)  {
        return details;
    }

    function getPID() public view returns (address) {
        return PID;
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
            for (uint256 i = 0; i < doctorsList.length; i++) {
                if (doctorsList[i] == _DID) {
                    doctorsList[i] = doctorsList[doctorsList.length-1];
                    doctorsList.pop();
                    break;
                }
            }
        }
        
        delete doctors[_DID];
    }

    function getDoctorsList() public view returns (address[] memory) {
        return doctorsList;
    }

    function isDoctor(address _DID) public view returns (bool) {
        return doctors[_DID];
    }

    function addHospital(address _HID) public {
        hospitalsList.push(_HID);
        hospitals[_HID] = true;
    }

    function removeHospital(address _HID) public {
        if(hospitalsList.length == 1){
            hospitalsList.pop();
        }
        for (uint256 i = 0; i < hospitalsList.length; i++) {
            if (hospitalsList[i] == _HID) {
                hospitalsList[i] = hospitalsList[hospitalsList.length-1];
                hospitalsList.pop();
                break;
            }
        }
        delete hospitals[_HID];
    }

    function getHospitalsList() public view returns (address[] memory) {
        return hospitalsList;
    }

    function isHospital(address _HID) public view returns (bool) {
        return hospitals[_HID];
    }

    function addrecordsHistory(string memory _cid) public {
        recordsHistory.push(_cid);
    }

    function getrecordsHistory() public view returns (string[] memory) {
        return recordsHistory;
    }

    modifier onlyAllowed() {
        require(isDoctor(tx.origin) || isHospital(tx.origin) || (tx.origin == PID), "Restricted to PATIENT.");
        _;
    }
}
