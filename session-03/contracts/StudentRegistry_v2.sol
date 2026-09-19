// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title IStudentRegistry
 * @dev Interface exposing the read functions
 */

interface IsStudentRegistry {
        function getStudent(address _student) external view returns (string memory, uint256, StudentRegistry.Status);    
}

/**
 * @title StudentRegistry
 * @dev Register, update, and fetch student records
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

 contract StudentRegistry is IsStudentRegistry {
    enum Status {
        Active,
        Inactive,
        Graduated
    }

    struct Student{
        string name;
        uint256 enrollmentId;
        Status status;
    }

    address public owner;

    mapping(address => Student) students;
    mapping(address => bool) isRegistered;

    event StudentRegistered(address indexed student, uint256 enrllmentId);
    event StatusUpdated(address indexed student, Status newStatus);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() { 
        owner = msg.sender;
    }

    function registerStudent(string memory _name, uint256 _enrollmentId) public onlyOwner {
        require(!isRegistered[msg.sender], "Student already registered");

        students[msg.sender] = Student(_name, _enrollmentId, Status.Active);
        isRegistered[msg.sender] = true;

        emit StudentRegistered(msg.sender, _enrollmentId);
    }

    function updateStatus(Status _status) public {
        require(isRegistered[msg.sender], "Student not registered");

        students[msg.sender].status = _status;

        emit StatusUpdated(msg.sender, _status);
    }

    function getStudent(address _student) public view override returns (string memory, uint256, Status) {        
        require(isRegistered[_student], "Student not registered");

        Student memory s = students[_student];
        return (s.name, s.enrollmentId, s.status);
    }
}


 