#import "../contracts/factory.mligo" "MyFact"

type originated = {
    addr : address;
    t_addr : (Contract.parameter, Contract.storage) typed_address;
    contr : Contract.parameter contract
}

let bootstrap_accounts () =
    let () = Test.reset_state 5n ([] : tez list) in
    let accounts =
        Test.nth_bootstrap_account 1,
        Test.nth_bootstrap_account 2,
        Test.nth_bootstrap_account 3
    in
    accounts

let initial_storage(initial_admin : address) = {
    adminMap = (Map.literal [(initial_admin : address ), (True)] :  (address, bool) map);
    whiteMap = (Map.empty : (address, bool) map);
    blackMap = (Map.empty : (address, bool) map);
    collectionMap = (Map.empty : (address, bool) map);
    all_collections = (Big_map.empty : (address, address) big_map);
    owned_collections = (Big_map.empty : (address, address) big_map);
    metadata = (Big_map.empty: (string, bytes) big_map);
}

let initial_balance = 0mutez

let originate_contract (admin : address) : address * (Contract.parameter , Contract.storage) typed_address * Contract.parameter contract =
    let (addr, _code, _nonce) = Test.originate_from_file "../contracts/factory.mligo" "main" (["getCollectionByUser"] : string list) (Test.eval (initial_storage(admin))) initial_balance in
    let actual_storage = Test.get_storage_of_address addr in
    let () = assert(Test.eval(initial_storage(admin)) = actual_storage) in
    let my_typed_address = Test.cast_address addr in 
    let contr = Test.to_contract my_typed_address in


    // // let addr = Tezos.address contr in
    (addr, my_typed_address, contr)
    