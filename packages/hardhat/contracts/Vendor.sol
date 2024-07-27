pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
      require(msg.value > 0, "Necesitas enviar algo de ether");
      uint256 amount = msg.value;
      
      uint256 tokens = amount * tokensPerEth;
      
      uint256 tokenBalance = yourToken.balanceOf(address(this));
      require (tokenBalance >= tokens, "No hay suficientes tokens en reserva");
    
      (bool sent) =yourToken.transfer(msg.sender, tokens);
      require(sent, "Transferencia fallida"); 

      emit BuyTokens(msg.sender, amount, tokens);
    }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
   function withdraw() public onlyOwner{
        uint256 balance = address(this).balance;
        require(balance > 0, "Sin balance para retiro");
        payable(owner()).transfer(balance);
    }


  // ToDo: create a sellTokens(uint256 _amount) function:
function sellTokens(uint256 amount) public {
    require(
      yourToken.balanceOf(msg.sender) >= amount,
      "Insufficient token balance"
    );

    uint256 amountOfEth = amount / tokensPerEth;
    require(
      address(this).balance >= amountOfEth,
      "Vendor has insufficient ETH"
    );

    yourToken.transferFrom(msg.sender, address(this), amount);
    payable(msg.sender).transfer(amountOfEth);

    emit SellTokens(msg.sender, amount, amountOfEth);
  }
}
