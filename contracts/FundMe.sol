// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {

    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;
    address[] public funders;
    constructor() public  {
        owner = msg.sender;
    }

    function fund() public payable {
        // ETH to USD convertion rate
        uint256 minimumUSD = 50* 10**18;
        require(getConversionRate(msg.value) >= minimumUSD, "you need to spend minimum $50"); // kind to if else condition if it doesn't met minimum $50 transaction won't be happend
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return pricefeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,  ,  ,  ) = pricefeed.latestRoundData();
        return uint256(answer*10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount)/1000000000000000000;
        return ethAmountInUSD;
    }

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
    function withdraw() payable public {
        require(owner==msg.sender);
        msg.sender.transfer(address(this).balance);

        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
    }
}
