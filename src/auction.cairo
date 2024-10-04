#[starknet::interface]
pub trait IAuction<TContractState> {
    fn register_item(ref self: TContractState, item_name: felt252);
    fn unregister_item(ref self: TContractState, item_name: felt252);
    fn bid(ref self: TContractState, item_name: felt252, amount: u32);
    fn get_bid(self: @TContractState, item_name: felt252) -> u32;
    fn get_highest_bidder(self: @TContractState, item_name: felt252) ->  u32;
    fn is_registered(self: @TContractState, item_name: felt252) -> bool;
}

#[starknet::contract]
pub mod Auction {
    use starknet::event::EventEmitter;
use super::IAuction;
    use starknet::storage::{StorageMapReadAccess, StorageMapWriteAccess, Map};

    #[storage]
    struct Storage {
        bids: Map<felt252, u32>,
        register: Map<felt252, bool>,
        highest_bid: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ItemRegistered: ItemRegistered,
        ItemDeregistered: ItemDeregistered,
        ItemBid: ItemBid,
    }

    #[derive(Drop, starknet::Event)]
    struct ItemRegistered {
        item_name: felt252,
    }
    
    #[derive(Drop, starknet::Event)]
    struct ItemDeregistered {
        item_name: felt252,
    }
    
    #[derive(Drop, starknet::Event)]
    struct ItemBid {
        item_name: felt252,
        amount: u32,
    }

    //TODO Implement interface and events .. deploy contract
    #[abi(embed_v0)]
    impl AuctionContractImpl of IAuction<ContractState> {
        fn register_item(ref self: ContractState, item_name: felt252) {
            let item = self.register.read(item_name);
            assert!(item == false, "Item already exists");

            self.register.write(item_name, true);
            self.emit( ItemRegistered {item_name} );
        }

        fn unregister_item(ref self: ContractState, item_name: felt252) {
            assert!(self.register.read(item_name) == true, "Item does not exist in register.");
            self.register.write(item_name, false);
            self.emit( ItemDeregistered {item_name} );
        }

        fn bid(ref self: ContractState, item_name: felt252, amount: u32) {
            assert!(self.register.read(item_name) == true, "The item you are bidding for does not exist in the register.");
            self.bids.write(item_name, amount);

            let highest_bid = self.highest_bid.read();
            if amount > highest_bid {
                self.highest_bid.write(amount);
            }

            self.emit( ItemBid{item_name, amount} );
        }

        fn get_bid(self: @ContractState, item_name: felt252) -> u32 {
            let bid = self.bids.read(item_name);
            assert!(bid != 0, "Bid does not exist");
            bid
        }

        fn get_highest_bidder(self: @ContractState, item_name: felt252) -> u32 {
            assert!(self.bids.read(item_name) != 0, "Item has no bids");
            self.highest_bid.read()
        }

        fn is_registered(self: @ContractState, item_name: felt252) -> bool {
            self.register.read(item_name)
        }
    }
}
