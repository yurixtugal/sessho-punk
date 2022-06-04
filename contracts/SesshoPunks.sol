// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
import "./PunkDNA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SesshoPunks is ERC721, ERC721Enumerable, PunkDNA {

    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("SesshoPunks", "SSHPKS") {
        maxSupply = _maxSupply;
    }
    
    //Necesary functions for ERC721Enumerable
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable){
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool){
        return super.supportsInterface(interfaceId);
    }

     function mint() public {
         uint256 current = _idCounter.current();
         require(current < maxSupply,"No SesshoPunks left");
         _safeMint(msg.sender, current);
         tokenDNA[current] = deterministicPseudoRandomDNA(current,msg.sender);
         _idCounter.increment();
     }    
     
    function getImageByDNA (uint256 _dna) public view returns (string memory) {
        return string(abi.encodePacked(_baseURI(),"?",_paramsURI(_dna)));
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";
    }

    function _paramsURI(uint256 _dna) internal view returns (string memory){
            string memory params;
            string memory paramsAux =string(abi.encodePacked(   "accessoriesType=",getAccesoriesType(_dna),
                                                "&clotheColor=",getClotheColor(_dna),
                                                "&clotheType=",getClotheType(_dna),
                                                "&eyeType=",getEyeType(_dna),
                                                "&eyebrowType=",getEyeBrowType(_dna),
                                                "&facialHairColor=",getFacialHairColor(_dna),
                                                "&facialHairType=",getFacialHairType(_dna)));

            params = string(abi.encodePacked(   paramsAux,
                                                "&hairColor=",getHairColor(_dna),
                                                "&hatColor=",getHatColor(_dna),
                                                "&graphicType=",getGraphicType(_dna),
                                                "&mouthType=",getMouthType(_dna),
                                                "&skinColor=",getSkinColor(_dna),
                                                "&topType=",getTopType(_dna)));
                                

            return params;
    }


     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
            string memory jsonURI = Base64.encode(abi.encodePacked(
                                    '{"name":"',name(),' #',tokenId.toString(),
                                    '","description": "Sessho Token for NFTs",',
                                    '"image":"',getImageByDNA(tokenDNA[tokenId]),'"}'));
            return string(abi.encodePacked("data:application/json;base64,",jsonURI));  
     }

}