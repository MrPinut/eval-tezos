#import "./bootstrap.mligo" "Bootstrap"

let () = Test.log("Testing entrypoints for contract")

let test_success_add_admin =
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (Add_Admin(user1)) 0mutez in
    ()



