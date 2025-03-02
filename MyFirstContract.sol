// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract simpleContract { 

    uint private age;
    string private name;

    //set 

    function setName ( string memory _name) public { 
        name = _name;
    }

    function setAge ( uint _age ) public {
        age = _age;
    }

    //get 

    function getName () public view returns ( string memory ) { 
        return name;
    }

    function getAge () public view returns ( uint ) { 
        return age;
    }
}

