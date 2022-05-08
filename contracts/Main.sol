// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "contracts/Government.sol";
import "contracts/Hospital.sol";
import "contracts/Doctor.sol";
import "contracts/Patient.sol";
import "hardhat/console.sol";


contract Main is AccessControl {
    bytes32 public constant GOVERNMENT = keccak256("GOVERNMENT");
    bytes32 public constant PATIENT = keccak256("PATIENT");
    bytes32 public constant HOSPITAL = keccak256("HOSPITAL");
    bytes32 public constant DOCTOR = keccak256("DOCTOR");

    mapping(address => address) patientDetails;
    mapping(address => address) doctorDetails;
    mapping(address => address) hospitalDetails;
    mapping(address => address) governmentDetails;

    struct Approve {
        address instanceAdd;
        address userAdd;
        string userType;
        uint256 timestamp;
    }

    Approve[] private ApproveList;

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

    constructor(string memory _officeName, string memory _phoneNumber) {
        governmentDetails[msg.sender] = address(
            new Government(_officeName, _phoneNumber, msg.sender)
        );

        _setupRole("GOVERNMENT", msg.sender);
        _setRoleAdmin("GOVERNMENT", "GOVERNMENT");
        _setRoleAdmin("PATIENT", "GOVERNMENT");
        _setRoleAdmin("HOSPITAL", "GOVERNMENT");
        _setRoleAdmin("DOCTOR", "GOVERNMENT");
    }

    function addGovernmentOffice(
        string memory _officeName,
        string memory _phoneNumber,
        address _GID
    ) public onlyGoverment {
        governmentDetails[_GID] = address(
            new Government(_officeName, _phoneNumber, _GID)
        );
        grantRole("GOVERNMENT", _GID);
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
        grantRole("HOSPITAL", _HID);
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
        grantRole("DOCTOR", _DID);
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

        grantRole("PATIENT", _PID);

        emit newPatient(_details, _PID);
    }



    function addGovernmentOfficetoList(
        string memory _officeName,
        string memory _phoneNumber,
        address _GID
    ) public onlyGoverment {
        ApproveList.push(Approve(address(
            new Government(_officeName, _phoneNumber, _GID)
        ), _GID, "GOV", block.timestamp));
    }

    function addHospitaltoList(
        string memory _hospitalName,
        string memory _phoneNumber,
        address _HID
    ) public onlyGoverment {
        ApproveList.push(Approve(address(
            new Hospital(_hospitalName, _HID, _phoneNumber)
        ), _HID, "HOS", block.timestamp));
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
    ) public onlyGoverment {
        ApproveList.push(Approve( address(new Doctor( _doctorName,_phoneNumber,_qualification, _photo,_dob,_HID, _DID,_department)), _DID, "DOC", block.timestamp));
        
    }

    function addPatienttoList(string memory _details, address _PID)
        public
        onlyGoverment
    {

        ApproveList.push(Approve(address(new Patient(_details, _PID)), _PID, "PAT", block.timestamp));
    }

    function getApproveList() public view returns (Approve[] memory) {
        return ApproveList;
    }


function addGovernmentOfficeFromList(
        address _GID
    ) public onlyGoverment {

        for (uint256 i = 0; i < ApproveList.length ; i++) {
            if (ApproveList[i].userAdd == _GID) {
                governmentDetails[_GID] = ApproveList[i].instanceAdd;
                delete ApproveList[i];
                grantRole("GOVERNMENT", _GID);
                emit newOffice(Government(governmentDetails[_GID]).getOfficeName(),Government(governmentDetails[_GID]).getPhoneNumber(), _GID);
                break;
            }
        }
    }

    function addHospitalFromList(
        address _HID
    ) public onlyGoverment {
        for (uint256 i = 0; i < ApproveList.length ; i++) {
            if (ApproveList[i].userAdd == _HID) {
                hospitalDetails[_HID] = ApproveList[i].instanceAdd;
                delete ApproveList[i];
                grantRole("HOSPITAL", _HID);
                emit newHospital(Hospital(hospitalDetails[_HID]).getHospitalName(), Hospital(hospitalDetails[_HID]).getPhoneNumber(), _HID);
                break;
            }
        }
    }

    function addDoctorFromList(
        address _DID
    ) public onlyGoverment {
        for (uint256 i = 0; i < ApproveList.length ; i++) {
            if (ApproveList[i].userAdd == _DID) {
                doctorDetails[_DID] = ApproveList[i].instanceAdd;
                delete ApproveList[i];
                grantRole("DOCTOR", _DID);
                emit newDoctor(
                    Doctor(doctorDetails[_DID]).getDoctorName(),
                    Doctor(doctorDetails[_DID]).getphoneNumber(),
                    Doctor(doctorDetails[_DID]).getQualification(),
                    Doctor(doctorDetails[_DID]).getPhoto(),
                    Doctor(doctorDetails[_DID]).getDob(),
                    Doctor(doctorDetails[_DID]).getHospital(),
                    _DID,
                    Doctor(doctorDetails[_DID]).getDepartment()
                    );
                    break;
                }
        }
    }

    function addPatientFromList(address _PID)
        public
        onlyGoverment
    {
        for (uint256 i = 0; i < ApproveList.length ; i++) {
            if (ApproveList[i].userAdd == _PID) {
                patientDetails[_PID] = ApproveList[i].instanceAdd;
                delete ApproveList[i];
                grantRole("PATIENT", _PID);
                emit newPatient(getPatientDetailsForGov(_PID), _PID);
                break;
            }
        }
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
        view
        onlyGoverment
        returns (string memory)
    {
        return Patient(patientDetails[_PID]).getDetailsForGov();
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
        return [Hospital(hospitalDetails[_HID]).getHospitalName(), Hospital(hospitalDetails[_HID]).getPhoneNumber()];
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
        return [Government(governmentDetails[_GID]).getOfficeName(), Government(governmentDetails[_GID]).getPhoneNumber()];
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


    function _onlyGoverment() private view {
        require(isGovernment(msg.sender), "Restricted to users.");
    }

    modifier onlyGoverment() {
        _onlyGoverment();
        _;
    }

    function _onlyPatient() private view{
        require(isPatient(msg.sender), "Restricted to PATIENT.");
    }
    modifier onlyPatient() {
        _onlyPatient();
        _;
    }

    function _onlyDoctor() private view {
        require(isDoctor(msg.sender), "Restricted to DOCTOR.");
    }
    modifier onlyDoctor() {
        _onlyDoctor();
        _;
    }

    function _onlyHospital() private view {
        require(isHospital(msg.sender), "Restricted to HOSPITAL.");

    }
    modifier onlyHospital() {
        _onlyHospital();
        _;
    }
}
