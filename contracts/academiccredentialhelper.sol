pragma solidity >=0.5.0 <0.6.0;

import "./academiccredentialfactory.sol";

contract AcademicCredentialHelper is AcademicCredentialFactory {
    //TODO: adapt
    function getCredentialsByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerAcademicCredentialsCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < academicCredentials.length; i++) {
            if (academicCredentialsToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

}