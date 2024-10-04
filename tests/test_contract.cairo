use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use auction::auction::IAuctionDispatcher;
use auction::auction::IAuctionDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_register_item() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');

    let get_mona_lisa: bool = dispatcher.is_registered('Mona Lisa');
    assert!(get_mona_lisa == true, "Mona Lisa not registered");
}

#[test]
#[should_panic]
fn test_register_item_twice() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.register_item('Mona Lisa');
}

#[test]
fn test_unregister_item() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.register_item('Van Gogh Painting');

    dispatcher.unregister_item('Mona Lisa');
    dispatcher.unregister_item('Van Gogh Painting');

    assert!(
        dispatcher.is_registered('Mona Lisa') == false,
        "Mona Lisa has not been removed from the register"
    );
    assert!(
        dispatcher.is_registered('Van Gogh Painting') == false,
        "Van Gogh Painting has not been removed from the register"
    );
}

#[test]
#[should_panic]
fn test_unregister_invalid_item() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.unregister_item('Mona Lisa');
}

#[test]
fn test_bid() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.bid('Mona Lisa', 1_000);

    let actual: u32 = dispatcher.get_bid('Mona Lisa');
    let expected: u32 = 1_000;

    assert!(actual == expected, "Wrong bid price returned for Mona Lisa");
}

#[test]
fn test_bid_2() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.bid('Mona Lisa', 1_000);
    dispatcher.bid('Mona Lisa', 2_000);

    let actual: u32 = dispatcher.get_bid('Mona Lisa');
    let expected: u32 = 2_000;

    assert!(actual == expected, "Wrong bid price returned for Mona Lisa");
}

#[test]
#[should_panic]
fn test_bid_for_invalid_item() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.bid('Mona Lisa', 10_000);
}

#[test]
fn test_get_highest_bidder() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.bid('Mona Lisa', 1_000);
    dispatcher.bid('Mona Lisa', 2_000);
    dispatcher.bid('Mona Lisa', 3_000);

    let highest_amount_bid  = dispatcher.get_highest_bidder('Mona Lisa');
    let expected = 3_000;

    assert!(highest_amount_bid == expected, "Highest bid should be 3_000");
}

#[test]
#[should_panic]
fn test_get_highest_bidder_on_item_with_no_bids() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.get_highest_bidder('Mona Lisa');
}

#[test]
fn test_is_registered() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    let valid_item = dispatcher.is_registered('Mona Lisa');

    assert!(valid_item == true, "Mona Lisa has not been registered");
}

#[test]
fn test_is_registered_invalid() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    let invalid_item = dispatcher.is_registered('Mona Lisa');
    assert!(invalid_item == false, "Mona Lisa should not be registered");
}

#[test]
fn test_register_then_deregister() {
    let contract_address = deploy_contract("Auction");
    let dispatcher = IAuctionDispatcher { contract_address };

    dispatcher.register_item('Mona Lisa');
    dispatcher.unregister_item('Mona Lisa');

    let invalid_item = dispatcher.is_registered('Mona Lisa');
    assert!(invalid_item == false, "Mona Lisa should not be registered");
}
