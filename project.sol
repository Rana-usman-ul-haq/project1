//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VaccineManagementSystem {

    
    // Struct to store user information
    struct User {
        string name;
        uint age;
        string nid;
        uint vaccineDoses;
        bool isApproved;
    }

    struct certificateInformation{
        string name;
        uint age;
        string nid;
        uint vaccineDoses;
    }

    

    // Mapping to store user information
    mapping(address => User) public Users;
    mapping(address => certificateInformation) public Certificates;

    // Address of the authority (enter address here)
    address public authorityAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    // Address of the healthcare center(enter address here)
    address public healthcareCenterAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    // Event to emit when a user is registered
    event UserRegistered(address indexed user, string name, uint age, string nid);

    // Event to emit when a user is approved by the authority
    event UserApproved(address indexed user, string name, uint age, string nid);

    // Event to emit when a user receives a vaccine dose
    event UserVaccinated(address indexed user, uint vaccineDoses);

    // Event to emit when a certificate is issued
    event CertificateIssued(address indexed user, string name, uint age, uint vaccineDoses);

    // Function to register a user
    function registerUser(string memory name, uint age, string memory nid) public {
        // Check if the user's NID is already in the blockchain
       require (keccak256(abi.encodePacked(Users[msg.sender].nid)) == keccak256(abi.encodePacked("")), "User nid already in database"); 
            // Add the user to the mapping
            Users[msg.sender] = User(name, age, nid, 0, false);

            // Emit the UserRegistered event
            emit UserRegistered(msg.sender, name, age, nid);
        
          
    }

    // Function for the authority to approve a user's registration
    function approveUser(address user) public {
        require(msg.sender == authorityAddress, "Only the authority can approve a user");
        User storage userA = Users[user];

        // Update the user's isApproved status
        Users[user].isApproved = true;

        // Emit the UserApproved event
        emit UserApproved(user, userA.name, userA.age, userA.nid);
    }

    // Function for the healthcare center to record a vaccine dose
    function recordVaccineDose(address user) public {
        require(msg.sender == healthcareCenterAddress, "Only the healthcare center can record a vaccine dose");
        User storage userA = Users[user];
        // Increment the user's vaccineDoses
        userA.vaccineDoses++;

        // Emit the UserVaccinated event
        emit UserVaccinated(user, userA.vaccineDoses);
    }

    // Function for a user to request a certificate
    function requestCertificate(address user) public {
        User storage userA = Users[user];
        // Check if the user's registration has been approved
        require(userA.isApproved, "The user's registration must be approved first");
        Certificates[user] = certificateInformation(userA.name, userA.age, userA.nid, userA.vaccineDoses);

        // Emit the CertificateIssued event
        emit CertificateIssued(user, userA.name, userA.age, userA.vaccineDoses);
        Certificates[user] = certificateInformation(userA.name, userA.age, userA.nid, userA.vaccineDoses);
    }


}
