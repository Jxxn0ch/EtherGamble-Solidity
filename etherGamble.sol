pragma solidity ^0.4.25;

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Basic {

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  function balanceOf(address _owner) public view returns (uint256 _balance);

  function ownerOf(uint256 _tokenId) public view returns (address _owner);

  function exists(uint256 _tokenId) public view returns (bool _exists);

  function approve(address _to, uint256 _tokenId) public;

  function getApproved(uint256 _tokenId)
    public view returns (address _operator);

  function setApprovalForAll(address _operator, bool _approved) public;

  function isApprovedForAll(address _owner, address _operator)
    public view returns (bool);

  function transferFrom(address _from, address _to, uint256 _tokenId) public;

  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
    public;

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    public;
}

contract EtherGambleFactory {
    address[] private etherGambles;

    function createEtherGambles(uint baseAmount) public returns (address){
        address etherGamble = new EtherGamble(msg.sender, baseAmount);
        etherGambles.push(etherGamble);
        return etherGamble;
    }

    function getEtherGambles() public view returns (address[]) {
        return etherGambles;
    }
}

contract EtherGamble {

    struct Record {
        uint round;
        string winnerId;
        address winnerAddr;
        uint value;
    }

    Record[] public records;
    address public manager;
    uint public baseAmount;
    mapping(address => bool) public joiners;
    uint public joinersCount;

    constructor(address _manager, uint _baseAmount) public payable{
        manager = _manager;
        baseAmount = _baseAmount;
    }

    function getSummary() public view returns (uint, uint, uint, address) {
        address contractAddress = this;
        return (
            baseAmount,
            contractAddress.balance,
            joinersCount,
            manager
        );
    }

    function bet() public payable {
        require(msg.value > baseAmount);
        joiners[msg.sender] = true;

        joinersCount++;
    }

    function finalizeGamble(uint _round, string _winnerId, address _winnerAddr, uint _value) public managerOf{

        _winnerAddr.transfer(_value);

        Record memory newRecord = Record({
            round : _round,
            winnerId : _winnerId,
            winnerAddr : _winnerAddr,
            value : _value
        });

        records.push(newRecord);
    }

    modifier managerOf() {
        require(msg.sender == manager);
        _;
    }

}
