use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

// use auction::IHelloStarknetSafeDispatcher;
// use auction::IHelloStarknetSafeDispatcherTrait;
// use auction::IHelloStarknetDispatcher;
// use auction::IHelloStarknetDispatcherTrait;

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

// #[test]
// #[should_panic]
// fn test_register_item_twice () {
//     let contract_address = deploy_contract("Auction");
//     let dispatcher = IAuctionDispatcher { contract_address };

//     let register_1 = dispatcher.register_item('Mona Lisa');
//     let register_2 = dispatcher.register_item('Mona Lisa');
// }

// #[test]
// #[feature("safe_dispatcher")]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract("Auction");

//     let safe_dispatcher = IAuctionDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         }
//     };
// }
