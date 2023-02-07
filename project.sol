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

    // Mapping to store user information
    mapping(address => User) public users;

    // Address of the authority
    address public authorityAddress;

    // Address of the healthcare center
    address public healthcareCenterAddress;

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
        if (users[msg.sender].nid == "") {
            // Add the user to the mapping
            users[msg.sender] = User(name, age, nid, 0, false);

            // Emit the UserRegistered event
            emit UserRegistered(msg.sender, name, age, nid);
        }
    }

    // Function for the authority to approve a user's registration
    function approveUser(address user) public {
        require(msg.sender == authorityAddress, "Only the authority can approve a user");

        // Update the user's isApproved status
        users[user].isApproved = true;

        // Emit the UserApproved event
        emit UserApproved(user, users[user].name, users[user].age, users[user].nid);
    }

    // Function for the healthcare center to record a vaccine dose
    function recordVaccineDose(address user) public {
        require(msg.sender == healthcareCenterAddress, "Only the healthcare center can record a vaccine dose");

        // Increment the user's vaccineDoses
        users[user].vaccineDoses++;

        // Emit the UserVaccinated event
        emit UserVaccinated(user, users[user].vaccineDoses);
    }

    // Function for a user to request a certificate
    function requestCertificate(address user) public {
        // Check if the user's registration has been approved
        require(users[user].isApproved, "The user's registration must be approved first");

        // Emit the CertificateIssued event
        emit CertificateIssued(user, users[user].name, users[user].age, users[user].vaccineDoses);
    }
}
