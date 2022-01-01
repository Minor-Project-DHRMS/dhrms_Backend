//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Patient {
    string private details;
    address private PID;
    mapping(address => bool) private doctors;
    mapping(address => bool) private hospitals;
    string[] recordsHistory;

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

    function getDID(address _DID) public view returns (bool) {
        return doctors[_DID];
    }

    function addHospital(address _HID) public {
        doctors[_HID] = true;
    }

    function getHID(address _HID) public view returns (bool) {
        return doctors[_HID];
    }

    function addrecordsHistory(string memory _cid) public {
        recordsHistory.push(_cid);
    }

    function getrecordsHistory() public view returns (string[] memory) {
        return recordsHistory;
    }
}
