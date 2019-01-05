pragma solidity ^0.4.24;

contract AccessControlList {
    
    address public owner;
    mapping(address => mapping( address => bool )) accessList;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function grantAccess(address _addr) public returns(bool) {
        // user can not grant access to himself; 
        // prevents un-necessary extra mapping entry storage
        if(msg.sender == _addr){
            return false;
        }else{
            accessList[msg.sender][_addr] = true;
	        return true;
        }
    }
    
    // Check for granted access
    function checkGranteeAccess(address _addr) public view returns(bool) {
        return accessList[msg.sender][_addr];
    }
    
    // Check if grantor granted grantee access
    function checkGrantorAccess(address _addr) public view returns(bool) {
        return accessList[_addr][msg.sender];
    }
    
    // Grantor delete/un-grant access to grantee
    function deleteAccess(address _addr) public returns(bool) {
        require(msg.sender != _addr);
        if(accessList[msg.sender][_addr]){
            delete accessList[msg.sender][_addr];
            return true;
        }else{
            return false;   
        }
    }
    
    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
    
    function kill() public onlyowner {
        selfdestruct(owner);
    }
}
