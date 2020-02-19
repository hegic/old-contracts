pragma solidity ^0.6.0;
import "./oz/access/Roles.sol";
import "./oz/ownership/Ownable.sol";

contract SpenderRole is Ownable {
    using Roles for Roles.Role;

    event SpenderAdded(address indexed account);
    event SpenderRemoved(address indexed account);

    Roles.Role private _spenders;

    
    modifier onlySpender() {
        require(isSpender(msg.sender), "SpenderRole: caller does not have the Spender role");
        _;
    }

    function isSpender(address account) public view returns (bool) {
        return _spenders.has(account);
    }

    function addSpender(address account) public onlyOwner {
        _addSpender(account);
    }

    function removeSpender(address account) public onlyOwner {
        _removeSpender(account);
    }
    
    function renounceSpender() public {
        _removeSpender(msg.sender);
    }

    function _addSpender(address account) internal {
        _spenders.add(account);
        emit SpenderAdded(account);
    }

    function _removeSpender(address account) internal {
        _spenders.remove(account);
        emit SpenderRemoved(account);
    }
}
