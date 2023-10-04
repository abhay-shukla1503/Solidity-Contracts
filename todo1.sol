// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "./1.sol";
// import "./2.sol";
// import "./3.sol";

contract compound{

    struct Detail{
        uint nftId;
        uint amount;
        uint cToken;
    }
     Contract NFT;
     USDT usdtToken;
     CompoundContract CContract;

    constructor(
        address NFTContractAddress,
        address IUSDTADDRESS,
        address CAdd
    ){
        NFT = Contract(NFTContractAddress);
        usdtToken = USDT(IUSDTADDRESS);
        CContract = CompoundContract(CAdd);
    }
    
    address _owner = msg.sender;
    mapping (address => Detail[]) Data;

    function deposit(uint _amt) public{
        address owner = msg.sender;
        uint tokenid = NFT.totalSupply()+1;
        uint tokenToWithdraw = getCBal(address(this));
        //require(usdtToken.transferFrom(owner, address(this), _amt), "USDT transfer failed");
        require(usdtToken.approve(address(CContract), _amt), "Approval failed");
        CContract.mint(_amt);
        NFT.mint(owner);
        tokenToWithdraw = getCBal(address(this)) - tokenToWithdraw;
        Data[msg.sender].push(Detail(tokenid ,_amt,tokenToWithdraw));
    }

    function Claim(uint id) public {
        uint txAmt = Data[msg.sender][0].amount;
        uint txCToken = Data[msg.sender][0].cToken;
        uint nftid = Data[msg.sender][0].nftId;

       
        address reedemer = msg.sender;
        require(NFT.transferFrom(reedemer,address(this),id),"Couldn't get nft.");
        NFT.burn(nftid);

        uint previousBal = usdtBal(address(this));
        CContract.redeem(txCToken); 
        uint IncreasedAmt = usdtBal(address(this)) - previousBal;
        uint reward = IncreasedAmt - txAmt;

        usdtToken.transfer(reedemer,txAmt); 
        usdtToken.transfer(_owner, reward);
    }

     function getCRate() public view  returns(uint){
        return CContract.borrowRatePerBlock();
    }

    function getCBal(address add) public view  returns(uint){
        return CContract.balanceOf(add);
    }

    function usdtBal(address add) public view returns(uint){
       return usdtToken.balanceOf(add);
    }
}

//IUSDT mainnet:-0xdAC17F958D2ee523a2206206994597C13D831ec7
//CUsdt mainnet:-0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9

//IUSDT Goerli:-0x79C950C7446B234a6Ad53B908fBF342b01c4d446
//CUsdt goerli:-0x5A74332C881Ea4844CcbD8458e0B6a9B04ddb716
//ganache-cli --fork https://goerli.infura.io/v3/d1ca998e042a43219dbc26662e0546c0

//deployed nft:0xe58f359cd688a2cd1e61eb78e172bdf799df3f57
//Deployed contract:0xd5605edfa3de31ddcc28a9b43100627813a40491 only deposit and balance check 42bal
//0x813480F9Fc434f88C512A3e4dFb88EEb8130e321 contract 50bal
//0xF1B7A8CEAB69DE5A45De5C19Ebdb259306798b36 again contract 0bal

//0x0d8F78C6c851e68f115bbf49C8A81E7182285398

//0x53B4A938A337E82eBde476A29463de9cf2Bf8278


//0x23270d364425e61F4AD10C0aaDffcf1CCaA076D7 50bal

//0xA6cFC0AD4CB9967BCD7a6b66b3f0C2Cf27B3c627 100bal