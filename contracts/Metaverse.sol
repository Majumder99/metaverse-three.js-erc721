// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Metaverse is ERC721, Ownable(msg.sender) {
    constructor() ERC721("META", "MTA") {}

    using Counters for Counters.Counter;
    Counters.Counter private supply;
    uint256 public maxSupply = 100;

    uint256 public cost = 1 ether;

    struct Object {
        string name;
        int8 w;
        int8 h;
        int8 d;
        int8 x;
        int8 y;
        int8 z;
    }

    mapping(address => Object[]) public NFTOwners;
    Object[] public objects;

    function getObject() public view returns (Object[] memory) {
        return objects;
    }

    function totalSupply() public view returns (uint256) {
        return supply.current();
    }

    function mint(
        string memory _object_name,
        int8 _w,
        int8 _h,
        int8 _d,
        int8 _x,
        int8 _y,
        int8 _z
    ) public payable {
        require(msg.value >= cost, "Not enough ETH sent; check price!");
        require(supply.current() < maxSupply, "Max supply reached!");
        supply.increment();
        _safeMint(msg.sender, supply.current());
        NFTOwners[msg.sender].push(
            Object(_object_name, _w, _h, _d, _x, _y, _z)
        );
        objects.push(Object(_object_name, _w, _h, _d, _x, _y, _z));
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function getOwnerObjects() public view returns (Object[] memory) {
        return NFTOwners[msg.sender];
    }
}
