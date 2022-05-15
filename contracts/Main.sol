// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";
import "hardhat/console.sol";

contract ROLE_BASED_ACCESS is AccessControl {
    bytes32 public constant GOVERNMENT = keccak256("GOVERNMENT");
    bytes32 public constant PATIENT = keccak256("PATIENT");
    bytes32 public constant HOSPITAL = keccak256("HOSPITAL");
    bytes32 public constant DOCTOR = keccak256("DOCTOR");

    constructor() {
        _setupRole("GOVERNMENT", msg.sender);
        _setRoleAdmin("GOVERNMENT", "GOVERNMENT");
        _setRoleAdmin("PATIENT", "GOVERNMENT");
        _setRoleAdmin("HOSPITAL", "GOVERNMENT");
        _setRoleAdmin("DOCTOR", "GOVERNMENT");
    }

    function setContracts(address _address) public {
        grantRole("GOVERNMENT", _address);
    }


    function grantRoleAccessControl(bytes32 _role, address _address) public {
        grantRole(_role, _address);
    }

    function setUpRoleAccessControl(bytes32 _role, address _address) public {
        _setupRole(_role, _address);
    }

    function setUpRoleAdminAccessControl(bytes32 _role, bytes32 _roleAdmin) public {
        _setRoleAdmin(_role, _roleAdmin);
    }

    function isGovernment(address _GID) public view returns (bool) {
        return (hasRole("GOVERNMENT", _GID));
    }

    function isPatient(address _GID) public view returns (bool) {
        return (hasRole("PATIENT", _GID));
    }

    function isHospital(address _GID) public view returns (bool) {
        return (hasRole("HOSPITAL", _GID));
    }

    function isDoctor(address _GID) public view returns (bool) {
        return (hasRole("DOCTOR", _GID));
    }
}




contract DHRMS{
    mapping(address => address) patientDetails;
    mapping(address => address) doctorDetails;
    mapping(address => address) hospitalDetails;
    mapping(address => address) governmentDetails;

    address RBAC_CONTRACT_ADDRESS;
    address APPROVE_CONTRACT_ADDRESS;

    event newOffice(string officeName, string _phoneNumber, address _GID);
    event newHospital(string HospitalName, string ph_no, address HID);
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
    event newPatient(string _details, address _PID);
    event newReadAccess(address _DID);
    event newWriteAccess(address _HID);
    event removeReadAccessDoctor(address _DID);
    event removeWriteAccessHospital(address _HID);
    event newRecordForUpload(string _file, address _PID);
    event newRecordForUploadH(string _file, address _PID, address _HID);

    constructor(string memory _officeName, string memory _phoneNumber, address _RBAC_CONTRACT_ADDRESS) {
        governmentDetails[msg.sender] = address(
            new Government(_officeName, _phoneNumber, msg.sender)
        );

        RBAC_CONTRACT_ADDRESS = _RBAC_CONTRACT_ADDRESS;
        // APPROVE_CONTRACT_ADDRESS = _APPROVE_CONTRACT_ADDRESS;


        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).setUpRoleAccessControl("GOVERNMENT",msg.sender);
        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).setUpRoleAdminAccessControl("GOVERNMENT","GOVERNMENT");
        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).setUpRoleAdminAccessControl("PATIENT", "GOVERNMENT");
        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).setUpRoleAdminAccessControl("HOSPITAL", "GOVERNMENT");
        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).setUpRoleAdminAccessControl("DOCTOR", "GOVERNMENT");


        // ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl("GOVERNMENT", _APPROVE_CONTRACT_ADDRESS);
    }


    function addGovernmentOffice(
        string memory _officeName,
        string memory _phoneNumber,
        address _GID
    ) public onlyGoverment {
    
        governmentDetails[_GID] = address(
            new Government(_officeName, _phoneNumber, _GID)
        );

        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl("GOVERNMENT", _GID);
        emit newOffice(_officeName, _phoneNumber, _GID);
    }

    function addHospital(
        string memory _hospitalName,
        string memory _phoneNumber,
        address _HID
    ) public onlyGoverment {
        hospitalDetails[_HID] = address(
            new Hospital(_hospitalName, _HID, _phoneNumber)
        );
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl("HOSPITAL", _HID);
        emit newHospital(_hospitalName, _phoneNumber, _HID);
    }

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
        doctorDetails[_DID] = address(
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
        );
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl("DOCTOR", _DID);
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

    function addPatient(string memory _details, address _PID)
        public
        onlyGoverment
    {
        patientDetails[_PID] = address(new Patient(_details, _PID));
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl("PATIENT", _PID);
        emit newPatient(_details, _PID);
    }

    function giveReadAccess(address _DID) public onlyPatient {
        Patient(patientDetails[msg.sender]).addDoctor(_DID);
        Doctor(doctorDetails[_DID]).addPatient(msg.sender);
        emit newReadAccess(_DID);
    }

    function giveWriteAccess(address _HID) public onlyPatient {
        Patient(patientDetails[msg.sender]).addHospital(_HID);
        Hospital(hospitalDetails[_HID]).addPatient(msg.sender);
        emit newWriteAccess(_HID);
    }

    function removeReadAccess(address _DID) public onlyPatient {
        Patient(patientDetails[msg.sender]).removeDoctor(_DID);
        Doctor(doctorDetails[_DID]).removePatient(msg.sender);
        emit removeReadAccessDoctor(_DID);
    }

    function removeWriteAccess(address _HID) public onlyPatient {
        Patient(patientDetails[msg.sender]).removeHospital(_HID);
        Hospital(hospitalDetails[_HID]).removePatient(msg.sender);
        emit removeWriteAccessHospital(_HID);
    }

    function sendRecordsForUpload(string memory _file, address _PID)
        public
        onlyDoctor
    {
        address _HID = Doctor(doctorDetails[msg.sender]).getHospital();
        Hospital(hospitalDetails[_HID]).addToUplaodQueue(_file, _PID, _HID);
        emit newRecordForUpload(_file, _PID);
    }

    function sendRecordsForUploadH(
        string memory _file,
        address _PID,
        address _HID
    ) public onlyHospital {
        Hospital(hospitalDetails[msg.sender]).addToUplaodQueue(
            _file,
            _PID,
            _HID
        );
        emit newRecordForUploadH(_file, _PID, _HID);
    }

    function reportUploaded(address _PID, string memory _CID)
        public
        onlyHospital
    {
        Patient(patientDetails[_PID]).addrecordsHistory(_CID);
        Hospital(hospitalDetails[msg.sender]).removeReport(_PID);
    }

    function getDoctorsList(address _PID)
        public
        view
        returns (address[] memory)
    {
        return Patient(patientDetails[_PID]).getDoctorsList();
    }

    function getHospitalsList(address _PID)
        public
        view
        returns (address[] memory)
    {
        return Patient(patientDetails[_PID]).getHospitalsList();
    }

    function getRecordsHistory(address _PID)
        public
        view
        returns (string[] memory)
    {
        return Patient(patientDetails[_PID]).getrecordsHistory();
    }

    function getPatientDetails(address _PID)
        public
        view
        returns (string memory)
    {
        return Patient(patientDetails[_PID]).getDetails();
    }

    function getPatientDetailsForGov(address _PID)
        public
        onlyGoverment
        view
        returns (string memory)
    {
        return Patient(patientDetails[_PID]).getDetails();
    }

    function getDoctorDetails(address _DID)
        public
        view
        returns (string[6] memory)
    {
        return [
            Doctor(doctorDetails[_DID]).getDoctorName(),
            Doctor(doctorDetails[_DID]).getphoneNumber(),
            Doctor(doctorDetails[_DID]).getQualification(),
            Doctor(doctorDetails[_DID]).getPhoto(),
            Doctor(doctorDetails[_DID]).getDob(),
            Doctor(doctorDetails[_DID]).getDepartment()
        ];
    }

    function getPatientList(address _DID)
        public
        view
        returns (address[] memory)
    {
        return Doctor(doctorDetails[_DID]).getPatientList();
    }

    function getDoctorH(address _DID) public view returns (address) {
        return Doctor(doctorDetails[_DID]).getHospital();
    }

    function getHospitalDetails(address _HID)
        public
        view
        returns (string[2] memory)
    {
        return [
            Hospital(hospitalDetails[_HID]).getHospitalName(),
            Hospital(hospitalDetails[_HID]).getPhoneNumber()
        ];
    }

    function getHospitalDoctorList(address _HID)
        public
        view
        returns (address[] memory)
    {
        return Hospital(hospitalDetails[_HID]).getDoctorsList();
    }

    function getHospitalPatientList(address _HID)
        public
        view
        returns (address[] memory)
    {
        return Hospital(hospitalDetails[_HID]).getPatientsList();
    }

    function getGovernmentDetails(address _GID)
        public
        view
        returns (string[2] memory)
    {
        return [
            Government(governmentDetails[_GID]).getOfficeName(),
            Government(governmentDetails[_GID]).getPhoneNumber()
        ];
    }

    function _onlyGoverment() private view {
        console.log(tx.origin);
        require(ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isGovernment(tx.origin), "Restricted to users.");
    }

    modifier onlyGoverment() {
        _onlyGoverment();
        _;
    }

    function _onlyPatient() private view {
        require(ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isPatient(tx.origin), "Restricted to PATIENT.");
    }

    modifier onlyPatient() {
        _onlyPatient();
        _;
    }

    function _onlyDoctor() private view {
        require(ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isDoctor(tx.origin), "Restricted to DOCTOR.");
    }

    modifier onlyDoctor() {
        _onlyDoctor();
        _;
    }

    function _onlyHospital() private view {
        require(ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).isHospital(tx.origin), "Restricted to HOSPITAL.");
    }

    modifier onlyHospital() {
        _onlyHospital();
        _;
    }
}

contract ApproveDetails {
    struct Approve {
        address instanceAdd;
        address userAdd;
        string userType;
        uint256 timestamp;
    }

    address DHRMS_CONTRACT_ADDRESS; 

    constructor(address _DHRMS_CONTRACT_ADDRESS) {
        DHRMS_CONTRACT_ADDRESS = _DHRMS_CONTRACT_ADDRESS;
    }


    Approve[] private ApproveList;

    function addGovernmentOfficetoList(
        string memory _officeName,
        string memory _phoneNumber,
        address _GID
    ) public {
        address govOfficeAdd = address(
            new Government(_officeName, _phoneNumber, _GID)
        );

        ApproveList.push(Approve(govOfficeAdd, _GID, "GOV", block.timestamp));
    }

    function addHospitaltoList(
        string memory _hospitalName,
        string memory _phoneNumber,
        address _HID
    ) public {
        address hospitalAdd = address(
            new Hospital(_hospitalName, _HID, _phoneNumber)
        );
        ApproveList.push(Approve(hospitalAdd, _HID, "HOS", block.timestamp));
    }

    function addDoctortoList(
        string memory _doctorName,
        string memory _phoneNumber,
        string memory _qualification,
        string memory _photo,
        string memory _dob,
        address _HID,
        address _DID,
        string memory _department
    ) public {
        address doctorAdd = address(
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
        );
        ApproveList.push(Approve(doctorAdd, _DID, "DOC", block.timestamp));
    }

    function addPatienttoList(string memory _details, address _PID) public {
        address patientAdd = address(new Patient(_details, _PID));

        ApproveList.push(Approve(patientAdd, _PID, "PAT", block.timestamp));
    }

    function getApproveList() public view returns (Approve[] memory) {
        return ApproveList;
    }

    function getPatientDetails(address _instanceAddress)
        public
        view
        returns (string memory)
    {
        return Patient(_instanceAddress).getDetails();
    }

    function getDoctorDetails(address _instanceAddress)
        public
        view
        returns (string[6] memory)
    {
        return [
            Doctor(_instanceAddress).getDoctorName(),
            Doctor(_instanceAddress).getphoneNumber(),
            Doctor(_instanceAddress).getQualification(),
            Doctor(_instanceAddress).getPhoto(),
            Doctor(_instanceAddress).getDob(),
            Doctor(_instanceAddress).getDepartment()
        ];
    }

    function getHospitalDetails(address _instanceAddress)
        public
        view
        returns (string[2] memory)
    {
        return [
            Hospital(_instanceAddress).getHospitalName(),
            Hospital(_instanceAddress).getPhoneNumber()
        ];
    }

    function getGovernmentDetails(address _instanceAddress)
        public
        view
        returns (string[2] memory)
    {
        return [
            Government(_instanceAddress).getOfficeName(),
            Government(_instanceAddress).getPhoneNumber()
        ];
    }


    function approve(address _userAdd) public {
        for (uint256 i = 0; i < ApproveList.length; i++) {
            if (ApproveList[i].userAdd == _userAdd) {
                if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("GOV")
                ) {
                    DHRMS(DHRMS_CONTRACT_ADDRESS).addGovernmentOffice(
                        Government(ApproveList[i].instanceAdd).getOfficeName(),
                        Government(ApproveList[i].instanceAdd).getPhoneNumber(),
                        Government(ApproveList[i].instanceAdd).getGID()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("HOS")
                ) {
                    DHRMS(DHRMS_CONTRACT_ADDRESS).addHospital(
                        Hospital(ApproveList[i].instanceAdd).getHospitalName(),
                        Hospital(ApproveList[i].instanceAdd).getPhoneNumber(),
                        Hospital(ApproveList[i].instanceAdd).getHID()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("DOC")
                ) {
                    DHRMS(DHRMS_CONTRACT_ADDRESS).addDoctor(
                        Doctor(ApproveList[i].instanceAdd).getDoctorName(),
                        Doctor(ApproveList[i].instanceAdd).getphoneNumber(),
                        Doctor(ApproveList[i].instanceAdd).getQualification(),
                        Doctor(ApproveList[i].instanceAdd).getPhoto(),
                        Doctor(ApproveList[i].instanceAdd).getDob(),
                        Doctor(ApproveList[i].instanceAdd).getHospital(),
                        Doctor(ApproveList[i].instanceAdd).getDID(),
                        Doctor(ApproveList[i].instanceAdd).getDepartment()
                    );
                } else if (
                    keccak256(bytes(ApproveList[i].userType)) ==
                    keccak256("PAT")
                ) {
                    DHRMS(DHRMS_CONTRACT_ADDRESS).addPatient(
                        Patient(ApproveList[i].instanceAdd).getDetailsForGov(),
                        Patient(ApproveList[i].instanceAdd).getPID()
                    );
                }
                if (ApproveList.length == 1) {
                    ApproveList.pop();
                } else {
                    ApproveList[i] = ApproveList[ApproveList.length - 1];
                    ApproveList.pop();
                }
            }
        }
    }
    function disApprove(address _userAdd) public {
        for (uint256 i = 0; i < ApproveList.length; i++) {
            if (ApproveList[i].userAdd == _userAdd) {
                if (ApproveList.length != 1) {
                    ApproveList[i] = ApproveList[ApproveList.length - 1];
                } 
                ApproveList.pop();
            }
        }
    }
}
