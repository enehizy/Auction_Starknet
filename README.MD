## GIDA Academy Basic Auction Smart Contract

This repository contains a basic Auction Smart Contract developed as part of the GIDA Academy’s blockchain development curriculum. The contract is written in cairo and is designed to allow users to bid on an item, with the highest bidder winning the auction. The project focuses on introducing writing testing and deploying samrt contract using scarb and starknet foundry

### interface
```rust

#[starknet::interface]
trait IAuction<T>{
    fn register_item(ref self:T,item_name: ByteArray);

    fn unregister_item(ref self:T,item_name: ByteArray);

    fn bid(ref self:T,item_name:ByteArray,amount:u32);

    fn get_highest_bidder(self:@T, item_name:ByteArray)->u32;
    
    fn is_registered(self:@T, item_name:ByteArray)->bool;

}
```

### Methods in contract Interface:
1. register_item: Registers item and emits ItemRegistered event if item doesn't already exist.
2. unregister_item: Deregisters item if item doesn't already exist, and emits ItemDeregistered event.
3. bid: Check if item is in register before submitting bid. If bid is the highest, write bid to highest_bid storage variable.
4. get_bid: Returns latest bid for an item if item is registered.
5. get_highest_bidder: returns highest_bid value
6. is_registered: returns true if item is registered, false otherwise.


## Tests:
1. test_register_item
2. test_register_item_twice
3. test_unregister_item
4. test_unregister_invalid_item
5. test_bid
6. test_bid_2(registers two bids for one item and checkks that get_bid() returns latest one)
7. test_bid_for_invalid_item
8. test_get_highest_bidder
9. test_get_highest_bidder_on_item_with_no_bids
10. test_is_registered
11. test_is_registeted_invalid
12. test_register_then_deregister

### Caveats/Backlog:
Bidders can currently bid less for an item.
The highest_bid storage variable currently returns the highest bid among ALL ITEMS, not the item specified.