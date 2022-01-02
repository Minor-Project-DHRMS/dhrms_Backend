//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Patient {
    string private details;
    address private PID;
    mapping(address => bool) private doctors;
    mapping(address => bool) private hospitals;
    string[] recordsHistory;

    constructor(string memory _details,address _PID){
        details=_details;
        PID=_PID;
    }

    function setDetails(string memory _details) public {
        details = _details;
    }

    function getDetails() public view returns (string memory) {
        return details;
    }

    function getPID() public view returns (address) {
        return PID;
    }

    function addDoctor(address _DID) public {
        doctors[_DID] = true;
    }

    function removeDoctor(address _DID) public{
        delete doctors[_DID];
    }

    function isDoctor(address _DID) public view returns (bool) {
        return doctors[_DID];
    }

    function addHospital(address _HID) public {
        hospitals[_HID] = true;
    }

    function removeHospital(address _HID) public{
        delete hospitals[_HID];
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

    function getDoctorsList() public pure return()
}
