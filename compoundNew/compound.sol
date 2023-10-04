// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./1.sol";
import "./2.sol";
import "./nftInterface.sol";

contract compound{
    address _owner;

    struct Detail{
        uint nftId;
        uint amount;
        uint cToken;
    }
     Contract NFT;
     USDT usdtToken;
     CUSDT cusdt;

    constructor(
        address NFTAddress,
        address USDTAddress,
        address CompoundAddress
    ){
        _owner= msg.sender;
        NFT = Contract(NFTAddress);
        usdtToken = USDT(USDTAddress);
        cusdt = CUSDT(CompoundAddress);
    }
    
     
    mapping (address => Detail[]) Data;

    function deposit(uint _amt) public{
        uint tokenid = NFT.totalSupply()+1;
        uint getToken = getCBal(address(this));
        require(usdtToken.approve(address(cusdt), _amt), "Approval failed");
        cusdt.mint(_amt);
        NFT.mint(address(this));
        getToken = getCBal(address(this)) - getToken;
        Data[msg.sender].push(Detail(tokenid ,_amt,getToken));
    }

    function Claim() public {
        uint txAmt = Data[msg.sender][0].amount;
        uint txCToken = Data[msg.sender][0].cToken;
        uint nftid = Data[msg.sender][0].nftId;
        NFT.burn(nftid);  
        cusdt.redeem(txCToken);  
        usdtToken.transfer(msg.sender,txAmt); 
    }

    function withdrawReward() public{
        usdtToken.transfer(_owner, usdtToken.balanceOf(address(this)));
    }

     function getCRate() public view  returns(uint){
        return cusdt.borrowRatePerBlock();
    }

    function getCBal(address add) public view  returns(uint){
        return cusdt.balanceOf(add);
    }

    function usdtBal(address add) public view returns(uint){
       return usdtToken.balanceOf(add);
    }
}

//IUSDT Goerli:-0x79C950C7446B234a6Ad53B908fBF342b01c4d446
//CUsdt goerli:-0x5A74332C881Ea4844CcbD8458e0B6a9B04ddb716
//ganache-cli --fork https://goerli.infura.io/v3/d1ca998e042a43219dbc26662e0546c0

//deployed nft:0xBC4008312cb2D845c26022F6fEF9fB68A3650524
//deployed contract:-0x0aeaD1Aa1DD33d2351bd8DAeB73cAd3a193FdDD5
