pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./academiccredentialhelper.sol";

contract AcademicCredentialOwnership is AcademicCredentialHelper, ERC721 {

    mapping (uint => address) academicCredentialsApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerAcademicCredentialsCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return academicCredentialsToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerAcademicCredentialsCount[_to] = ownerAcademicCredentialsCount[_to].add(1);
        ownerAcademicCredentialsCount[msg.sender] = ownerAcademicCredentialsCount[msg.sender].sub(1);
        academicCredentialsToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    // prima data Cambridge creaza diploma apoi o transfera la cine a luat o
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require (academicCredentialsToOwner[_tokenId] == msg.sender || academicCredentialsApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        academicCredentialsApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}