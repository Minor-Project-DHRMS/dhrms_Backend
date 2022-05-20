// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "contracts/RBAC.sol";
import "contracts/STORAGE.sol";
import "contracts/Doctor.sol";



contract DHRMS_DOC{
    address STORAGE_CONTRACT_ADDRESS;
    address RBAC_CONTRACT_ADDRESS;

    constructor(address _STORAGE_CONTRACT_ADDRESS, address _RBAC_CONTRACT_ADDRESS) {
        STORAGE_CONTRACT_ADDRESS = _STORAGE_CONTRACT_ADDRESS;
        RBAC_CONTRACT_ADDRESS = _RBAC_CONTRACT_ADDRESS;
    }

    event newDoctor(
        string _doctorName,
        string _phoneNumber,
        string _qualification,
        string _photo,
        string _dob,
        address _HID,
        address _DID,
        string _department
    );

    function addDoctor(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) public onlyGoverment {
        STORAGE(STORAGE_CONTRACT_ADDRESS).addDoctorDetails(_DID,address(
            new Doctor(
                _doctorName,
                _phoneNumber,
                _qualification,
                _photo,
                _dob,
                _HID,
                _DID,
                _department
            )
        ));
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl(
            "DOCTOR",
            _DID
        );
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).addDoctor(_DID);
        emit newDoctor(
            _doctorName,
            _phoneNumber,
            _qualification,
            _photo,
            _dob,
            _HID,
            _DID,
            _department
        );
    }

    event editDoctor(
        string _doctorName,
        string _phoneNumber,
        string _qualification,
        string _photo,
        string _dob,
        address _HID,
        address _DID,
        string _department
    );

    function setDoctorDetails(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) public onlyAuth(_DID) {
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(msg.sender)).getHospital())).removeDoctor(_DID);
        Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(msg.sender)).setDoctorDetails(_doctorName,
                _phoneNumber,
                _qualification,
                _photo,
                _dob,
                _HID,
                _department);
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).addDoctor(_DID);
        emit editDoctor(
            _doctorName,
            _phoneNumber,
            _qualification,
            _photo,
            _dob,
            _HID,
            _DID,
            _department
        );
    }

    event removeOldDoctor(address _DID);

    function removeDoctor(address _DID) onlyAuth(_DID) public {
        STORAGE(STORAGE_CONTRACT_ADDRESS).removeDoctorDetails(_DID);
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).revokeRoleAccessControl(
            "DOCTOR",
            _DID
        );
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(msg.sender)).getHospital())).removeDoctor(_DID);
        emit removeOldDoctor(_DID);
    }

    event newRecordForUpload(string _file);



    function sendRecordsForUpload(string memory _file)
        public
        onlyDoctor
    {
        address _HID = Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(msg.sender)).getHospital();
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails(_HID)).addToUplaodQueue(_file);
        emit newRecordForUpload(_file);
    }


    function getDoctorDetails(address _DID)
        public
        view
        returns (string[6] memory)
    {
        return [
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDoctorName(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getphoneNumber(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getQualification(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getPhoto(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDob(),
            Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getDepartment()
        ];
    }
    
    function getDoctorH(address _DID) public view returns (address) {
        return Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getHospital();
    }


    function getPatientListOfDoc(address _DID)
        public
        view
        returns (address[] memory)
    {
        return Doctor(STORAGE(STORAGE_CONTRACT_ADDRESS).doctorDetails(_DID)).getPatientList();
    }


    

    modifier onlyGoverment() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyGoverment();
        _;
    }

    

    modifier onlyPatient() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyPatient();
        _;
    }

    

    modifier onlyDoctor() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyDoctor();
        _;
    }

    

    modifier onlyHospital() {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyHospital();
        _;
    }

    modifier onlyAuth(address _DOC) {
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS)._onlyAuth(_DOC,"DOCTOR");
        _;
    }
}