// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    /**
     * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    string public _baseTokenURI;

    //price is one price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;

    //_paused is used to pause the contract in case of an emergency
    bool public _paused;

    //max supply of CrptoDevs
    uint256 public maxTokenIds = 20;

    //total number of tokenIds minted
    uint256 public tokenIds;

    //Whitelist contract instance
    IWhitelist public whitelist;

    //boolean to keep track of whether presale started or not
    bool public presaleStarted;

    //timestamp for when presale would end
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currntly paused");
        _;
    }

    /**
     * @dev Constructor
        takes name and symbole of token 
        and instantiates the whitelist contract
     */

    constructor(string memory baseURI, address whitelistContract)
        ERC721("Crypto Devs", "CD")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    //Start presale for whitelisted addresses
    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    //allow a user to mint NFT per transaction during presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "Presale has not started yet"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIds < maxTokenIds, "Max number of tokens reached");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;

        //safely mint token
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp > presaleEnded,
            "Presale has not ended"
        );
        require(tokenIds < maxTokenIds, "Exceed maximum Crypto Devs");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;

        //safely mint token
        _safeMint(msg.sender, tokenIds);
    }

    //_baseURI overrides OpenZeppelin's default tokenURI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    //paused or unpaused contract
    function setPaused(bool paused) public onlyOwner {
        _paused = paused;
    }

    //withdraw ether from contract and sends to owner
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether to owner");
    }

    //function to receive ether msg.data must be empty
    receive() external payable {}

    //fallback function is called when msg.data is not empty
    fallback() external payable {}
}
