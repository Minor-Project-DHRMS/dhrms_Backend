//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Government{
    string private officeName;
    string private phoneNumber;
    address private GID;

    constructor(string memory _officeName, string memory _phoneNumber, address _GID){
        officeName=_officeName;
        phoneNumber=_phoneNumber;
        GID=_GID;
    }

    function setOfficeName(string memory _officeName ) public {
        officeName=_officeName;
    }

    function setPhoneNumber(string memory _phoneNumber) public{
        phoneNumber=_phoneNumber;
    }

    function setGID(address _GID) public {
        GID=_GID;
    }

    function getOfficeName() public view return (string memory) {
        return officeName;        
    }

    function getPhoneNumber() public view return (string memory) {
        return phoneNumber;        
    }

    function getGID() public view return (address) {
        return GID;        
    }

}