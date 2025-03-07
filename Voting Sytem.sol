// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;
pragma abicoder v2;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Ballot {
    
    struct Voter {
        uint weight;
        bool voted;
        uint vote;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    enum State { Created, Voting, Ended }
    State public state;
    
    // Events for transparency
    event VoterRegistered(address voter);
    event Voted(address voter, uint candidate);
    event ElectionStarted();
    event ElectionEnded();
    event CandidateAdded(string name);
    
    constructor(string[] memory candidateNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        state = State.Created;
        
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({name: candidateNames[i], voteCount: 0}));
        }
    }
    
    // Modifiers
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can perform this action");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state for this action");
        _;
    }
    
    // Allow users to self-register as voters
    function registerAsVoter() public {
        require(voters[msg.sender].weight == 0, "Already registered.");
        voters[msg.sender].weight = 1;
        emit VoterRegistered(msg.sender);
    }
    
    function addCandidate(string memory candidateName) public onlyChairperson inState(State.Created) {
        candidates.push(Candidate({name: candidateName, voteCount: 0}));
        emit CandidateAdded(candidateName);
    }
    
    function startVote() public onlyChairperson inState(State.Created) {
        state = State.Voting;
        emit ElectionStarted();
    }
    
    function endVote() public onlyChairperson inState(State.Voting) {
        state = State.Ended;
        emit ElectionEnded();
    }
    
    function vote(uint candidate) public inState(State.Voting) {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No right to vote");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = candidate;
        candidates[candidate].voteCount += sender.weight;
        emit Voted(msg.sender, candidate);
    }
    
    function getCurrentVotes() public view returns (Candidate[] memory) {
        return candidates;
    }
    
    function winningCandidate() public view inState(State.Ended) returns (string memory winnerName_) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winnerName_ = candidates[i].name;
            }
        }
    }
}