pragma solidity ^0.4.17;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import "../lib/dappsys/auth.sol";


contract Resolver is DSAuth {
  struct Pointer { address destination; uint outsize; }
  mapping (bytes4 => Pointer) public pointers;

  function register(string signature, address destination, uint outsize) public
  auth
  {
    pointers[stringToSig(signature)] = Pointer(destination, outsize);
  }

  // Public API
  function lookup(bytes4 sig) public view returns(address, uint) {
    return (destination(sig), outsize(sig));
  }

  // Helpers
  function destination(bytes4 sig) public view returns(address) {
    return pointers[sig].destination;
  }

  function outsize(bytes4 sig) public view returns(uint) {
    if (pointers[sig].destination != 0) {
      // Stored destination and outsize
      return pointers[sig].outsize;
    } else {
      // Default
      return 32;
    }
  }

  function stringToSig(string signature) public pure returns(bytes4) {
    return bytes4(keccak256(signature));
  }
}