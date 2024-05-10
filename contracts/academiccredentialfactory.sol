pragma solidity >=0.5.0 <0.6.0;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "./ownable.sol";

contract AcademicCredentialFactory is Ownable, AccessControl {
    event NewAcademicCredential(uint academicCredentialId, string degree);

    struct AcademicCredential {
        string degree;
        address institution;
        uint256 dateIssued;
    }

    AcademicCredential[] public academicCredentials;

    mapping (uint => address) public academicCredentialsToOwner;
    mapping (address => uint) ownerAcademicCredentialsCount;

    bytes32 public constant INSTITUTION_ROLE = keccak256("INSTITUTION_ROLE");

    // Constructor accepts admin addresses
    constructor(address[] memory adminAddresses) {
        for (uint i = 0; i < adminAddresses.length; i++) {
            _setupRole(DEFAULT_ADMIN_ROLE, adminAddresses[i]);
        }
    }

    function addInstitution(address institution) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(INSTITUTION_ROLE, institution);
    }

    function _createAcademicCredential(string memory _degree, uint _dateIssued) internal onlyRole(INSTITUTION_ROLE) {
        uint id = academicCredentials.push(AcademicCredential(_degree, msg.sender, _dateIssued)) - 1;
        academicCredentialsToOwner[id] = msg.sender;
        ownerAcademicCredentialsCount[msg.sender]++;
        emit NewAcademicCredential(id, _degree);
    }

    function createAcademicCredential(string memory _degree, uint _dateIssued) external onlyRole(INSTITUTION_ROLE) {
        _createAcademicCredential(_degree, _dateIssued);
    }
}

/*
import "./ownable.sol";
//import "./safemath.sol";

contract AcademicCredentialFactory is Ownable {
    //TODO: adapt
    event NewAcademicCredential(uint academicCredentialId, string degree);

    // zombie =  academic credential
    struct AcademicCredential {
        string degree;
        address institution;
        uint256 dateIssued;
    }

    AcademicCredential[] public academicCredentials;

    mapping (uint => address) public academicCredentialsToOwner;

    mapping (address => uint) ownerAcademicCredentialsCount;     // ?

    function _createAcademicCredential(string memory _degree, uint _dateIssued) internal {
        uint id = zombies.push(AcademicCredential(_degree, msg.sender, _dateIssued));
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        emit NewAcademicCredential(id, _degree);
    }
}*/
