/*SPDX-License-Identifier: GPL-3.0*/
pragma solidity >=0.4.0 < 0.9.0;

contract Scorecard{
    uint256 studentCount = 0;
    address public classTeacher;

    constructor(){
        classTeacher = msg.sender;
    }

    modifier onlyClassTeacher(address _classTeacher){
        require(classTeacher == _classTeacher, "Only the class teacher has access to this function");
        _;
    }

    struct StudentDetails {
        string firstName;
        string lastName;
        uint256 ID;
    }

    struct Score{
        uint256 studentID;
        uint256 englishMarks;
        uint256 mathMarks;
        uint256 scienceMarks;
    }

    mapping(uint => StudentDetails) students;

    mapping(uint => Score) scores;

    event studentAdded(
        string _firstName, 
        string _lastName, 
        uint256 _studentID
    );

    event studentScoresRecorded(
        uint256 _studentID, 
        uint256 _englishMarks, 
        uint256 _mathMarks, 
        uint256 _scienceMarks
    );

    function addStudentDetails(
        string memory _firstName, 
        string memory _lastName
    ) public onlyClassTeacher(msg.sender){
        StudentDetails storage studentObj = students[studentCount];
        studentObj.firstName = _firstName;
        studentObj.lastName = _lastName;
        studentObj.ID = studentCount;
        emit studentAdded(_firstName, _lastName, studentCount);
        studentCount++;
    }

    function addStudentScores(
        uint256 _studentID, 
        uint256 _englishMarks, 
        uint256 _mathMarks, 
        uint256 _scienceMarks
    ) public onlyClassTeacher(msg.sender){
        Score storage scoreObject = scores[_studentID];
        scoreObject.englishMarks = _englishMarks;
        scoreObject.mathMarks = _mathMarks;
        scoreObject.scienceMarks = _scienceMarks;
        scoreObject.studentID = _studentID;
        emit studentScoresRecorded(_studentID, _englishMarks, _mathMarks, _scienceMarks);
    }
}