// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CTokenInterface.sol";
import "./ComptrollerInterface.sol";
//import "./PriceOracleInterface.sol";

contract MyDeFiProject {
    ComptrollerInterface public comptroller;
    //PriceOracleInterface public priceOracle;
    IERC20 public token;
    CTokenInterface public cToken;

    constructor(
        address _comptroller,
        //address _priceOracle,
        address _token,
        address _cToken
    ) {
        comptroller = ComptrollerInterface(_comptroller);
        //priceOracle = PriceOracleInterface(_priceOracle);
        cToken = CTokenInterface(_cToken);
        token = IERC20(_token);
    }
    // mapping(uint=>uint) liquidity;
    function supply(uint underlyingAmount) public {
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(address(cToken), underlyingAmount);
        uint result = cToken.mint(underlyingAmount);
        require(result == 0, "mint() failed");
    }

    function redeem(uint cTokenAmount) external {
        uint result = cToken.redeem(cTokenAmount);
        require(result == 0, "redeem() failed");
    }

    function enterMarket() external {
        address[] memory markets = new address[](1);
        markets[0] = address(cToken);
        uint[] memory results = comptroller.enterMarkets(markets);
        require(results[0] == 0, "enterMarket() failed");
    }

    function borrow(uint borrowAmount) external {
        //address underlyingAddress = cToken.underlying();
        uint result = cToken.borrow(borrowAmount);
        require(result == 0, "borrow() failed");
    }

    function repayBorrow(uint underlyingAmount) external {
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(address(cToken), underlyingAmount);
        uint result = cToken.repayBorrow(underlyingAmount);
        require(result == 0, "repayBorrow() failed");
    }

    function transferEther(address payable receiver) public payable {
        require(msg.value > 0, "Please send some Ether");
        receiver.transfer(msg.value);
    }

    // function getMaxBorrow() external view returns(uint) {
    //   (uint result, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity(address(this));
    //   require(result == 0, "getAccountLiquidity() failed");
    //   require(shortfall == 0, "account underwater");
    //   require(liquidity > 0, "account does not have collateral");
    //   uint underlyingPrice = priceOracle.getUnderlyingPrice(address(cToken));
    //   return liquidity / underlyingPrice;
    // }
}
//0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B
//0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9
