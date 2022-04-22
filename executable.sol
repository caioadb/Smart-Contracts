// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9;

contract executable{

    address internal owner;
    address internal receiver;
    address[] internal executor;


    constructor(){
        executor = new address[](0);
        owner = msg.sender;
        receiver = msg.sender;
    }

    /**
    * @dev Modifier which verifies if the caller is an executor or owner.
    * 
    * Only executors or the owner can call the acting functions of the contract.
    * 
    */
    modifier onlyExecutor(){
        require(owner == msg.sender || isExecutor(msg.sender), "not executor or owner");
        _;
    }

    /**
    * @dev Modifier which verifies if the caller is an owner.
    * 
    * Only owner can call the acting functions of the contract.
    *
    * By default (setted in the constructor) the account which deployed this smart contract is the owner.
    * 
    */
    modifier onlyOwner(){
        require(owner == msg.sender, "not owner");
        _;
    }

    /**
        * @dev Function which verifies if an address is an executor.
        *
        */
    function isExecutor(address _toCheck) public view returns (bool) {
        for (uint8 i = 0; i < executor.length; i++) {
            if (_toCheck == executor[i]) return true;
        }
        return false;
    }

    /**
        * @dev Function which adds a list addresses to the list of executors.
        */
    event NewExecutor(address indexed _whoDid, address indexed _newExecutor);
    function addExecutor(address[] memory _toAdd) external onlyOwner {
        for (uint8 i = 0; i < _toAdd.length; i++) {
            if (!isExecutor(_toAdd[i])){
                emit NewExecutor(msg.sender, _toAdd[i]);
                executor.push(_toAdd[i]);
            }
        }
    }

    /**
        * @dev Function which removes an address from the list of exetuors.
        *
        * Only allowed to be called internally
        */
    function _remove(uint8 _position) internal {
        require(_position < executor.length, "position does not exist");

        // if (executor.length - 1 != _position){
        //     address oldLast = executor[executor.length - 1];
        //     executor[executor.length - 1] = executor[_position];
        //     executor[_position] = oldLast;
        // }
        executor[_position] = executor[executor.length - 1];
        executor.pop();
    }

    /**
        * @dev Function which removes a list of addresses from the list of executors.
        */
    event RemovedExecutor(address indexed _whoDid, address indexed _removedExecutor);
    function removeExecutor(address[] memory _toRemove) external onlyExecutor {
        require(executor.length >= _toRemove.length, "too many addresses to remove");
        for (uint8 i = 0; i < _toRemove.length; i++) {
            for (uint8 j = 0; j < executor.length; j++) {
                if (_toRemove[i] == executor[j]) {
                    emit RemovedExecutor(msg.sender, _toRemove[i]);
                    _remove(j);
                    break;
                }
            }
        }
    }

    /**
        * @dev Function which lists all executors.
        */
    function listExecutors()
        external
        view
        onlyExecutor
        returns (address[] memory)
    {
        return executor;
    }

}