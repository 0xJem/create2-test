// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

import {console2} from "forge-std/console2.sol";

import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        bytes32 counterInitCodeHash = keccak256(type(Counter).creationCode);

        console2.log("Counter initCodeHash: ");
        console2.logBytes32(counterInitCodeHash);

        // $ cast create2 -s FC --init-code-hash 0x0af94c052fb79378e511526805e00814a0e81be6b634c19bb57b7b0aaf20c5f8
        //
        // Starting to generate deterministic contract address...
        // Successfully found contract address(es) in 2.492678083s
        // Address: 0xFc2E04f3429bE87aBaFE19d80B061B6859018724
        // Salt: 0x607a1fd1f257baba01ab4a4d465521e4f121246296fa586b0338bd9687ccf065 (43637808420183804479980065876984421386295630072161432758959918930559738114149)

        address expectedAddress = address(0xFc2E04f3429bE87aBaFE19d80B061B6859018724);
        bytes32 salt = bytes32(0x607a1fd1f257baba01ab4a4d465521e4f121246296fa586b0338bd9687ccf065);

        Counter counter = new Counter{salt: salt}();
        console2.log("Counter address: %s", address(counter));

        require(address(counter) == expectedAddress, "Counter address mismatch");

        vm.stopBroadcast();
    }
}
