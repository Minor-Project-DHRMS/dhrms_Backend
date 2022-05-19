import "contracts/RBAC.sol";
import "contracts/STORAGE.sol";


contract STORAGE_HOS{
    address STORAGE_CONTRACT_ADDRESS;
    address RBAC_CONTRACT_ADDRESS;

    event newHospital(string HospitalName, string ph_no, address HID);
    event newRecordForUploadH(string _file, address _PID, address _HID);



    function addHospital(
        string memory _hospitalName,
        string memory _phoneNumber,
        address _HID
    ) public onlyGoverment {
        STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[_HID] = address(
            new Hospital(_hospitalName, _HID, _phoneNumber)
        );
        ROLE_BASED_ACCESS(RBAC_CONTRACT_ADDRESS).grantRoleAccessControl(
            "HOSPITAL",
            _HID
        );
        emit newHospital(_hospitalName, _phoneNumber, _HID);
    }



    function sendRecordsForUploadH(
        string memory _file,
        address _PID,
        address _HID
    ) public onlyHospital {
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[msg.sender]).addToUplaodQueue(
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
        Patient(STORAGE(STORAGE_CONTRACT_ADDRESS).patientDetails[_PID]).addrecordsHistory(_CID);
        Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[msg.sender]).removeReport(_PID);
    }

    function getHospitalDoctorList(address _HID)
        public
        view
        returns (address[] memory)
    {
        return Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[_HID]).getDoctorsList();
    }

    function getHospitalDetails(address _HID)
        public
        view
        returns (string[2] memory)
    {
        return [
            Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[_HID]).getHospitalName(),
            Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[_HID]).getPhoneNumber()
        ];
    }

    function getHospitalPatientList(address _HID)
        public
        view
        returns (address[] memory)
    {
        return Hospital(STORAGE(STORAGE_CONTRACT_ADDRESS).hospitalDetails[_HID]).getPatientsList();
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
}