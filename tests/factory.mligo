#import "./bootstrap.mligo" "Bootstrap"
#import "../contracts/factory.mligo" "MyFact"

let () = Test.log("Testing entrypoints for contract")

let token_ids : nat list = [1n]
let token_info_1 = (Map.literal[("QRcode", 0x623d82eff132);] : (string, bytes) map)
let token_metadata = (Big_map.literal [
    (1n, ({token_id=1n;token_info=token_info_1;} : Fact_FA2.Factory.NFT_FA2.NFT.TokenMetadata.data));
] : Fact_FA2.Factory.NFT_FA2.NFT.TokenMetadata.t) in

let test_success_add_admin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (Add_Admin(user1)) 0mutez in
    ()

let test_fail_add_already_admin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (Add_Admin(admin)) 0mutez in
    ()

let test_fail_add_admin_butNotAdmin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (Add_Admin(user1)) 0mutez in
    ()

let test_success_remove_admin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (Add_Admin(user1)) 0mutez in
    let _ = Test.transfer_to_contract contr (Supp_Admin(user1)) 0mutez in
    ()

let test_fail_remove_admin_butNotAdmin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (Supp_Admin(admin)) 0mutez in
    ()

let test_fail_remove_already_Notadmin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (Supp_Admin(user1)) 0mutez in
    ()

let test_success_become_creator = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (Get_Whitelisted) 12mutez in
    ()

let test_fail_become_creator =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let test_result : test_exec_result = Test.transfer_to_contract contr (Get_Whitelisted) 1mutez in
    let () = match  test_result with
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval MyFact.Errors.low_value))
        | Fail (Other p) -> failwith (p)
        | Success (_) -> failwith("Test should have failed")
    in
    ()


let test_success_createCollection =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (Get_Whitelisted) 12mutez in
    let _ = Test.transfer_to_contract contr (Creat_Collection({name="alice_collection_1"; token_ids=[1n]; token_metas=token_metadata})) 0mutez in
    ()

let test_fail_createCollection =


