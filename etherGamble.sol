pragma solidity ^0.4.25;

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 *
 * @dev 대체 불가능한 (Non-Fungible) 토큰 규약 ERC721 에 따른 인터페이스 선언
 */
contract ERC721Basic {

  // Transfer, Approval, ApprovalForAll 이벤트
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

  // _owner 의 모든 토큰에 대한 접근 권한이 _operator 에게 있는지를 체크
  function isApprovedForAll(address _owner, address _operator)
    public view returns (bool);

 // 본인의 혹은 접근 가능한 _tokenId 토큰을 _from 에서 _to 로 넘김
  function transferFrom(address _from, address _to, uint256 _tokenId) public;

  // _to 가 콘트랙트 주소인 경우에는 ERC721Receiver 의 onERC721Received 함수가 존재하는지를 체크한 후에 토큰을 넘김.
  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
    public;

  // 위와 같은 함수에 옵셔널하게 체크 가능한 _data 가 첨부됨. (function overloading)
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