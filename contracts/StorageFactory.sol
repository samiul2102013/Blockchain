//SPDX-License-Identifier: MIt
pragma solidity ^0.6.0;
import './SimpleStorage.sol';


contract StorageFactory{
    SimpleStorage[] public simpleStorageArray;
   function CreatingnewobjectContract() public {
    SimpleStorage  smpstr = new SimpleStorage();
    simpleStorageArray.push(smpstr);
   }

   function sfStorage( uint256 obIndex, uint256 fav) public {
        SimpleStorage smplstge = SimpleStorage(address(simpleStorageArray[obIndex]));
        smplstge.store(fav);
   }

   function sfGet(uint256 index) public view returns (uint256){
        SimpleStorage  smptrge = SimpleStorage(address(simpleStorageArray[index]));
        return smptrge.retrive();
   }
}