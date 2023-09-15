#import "ligo-extendable-fa2/lib/multi_asset/fa2.mligo" "FA2"

#import "nft-factory-cameligo/src/main.mligo" "Fact_FA2"

type extension = {
    adminMap : (address, bool) map;
    whiteMap : (address, bool) map;
    blackMap : (address, bool) map;
    collectionMap : (address, bool) map; // not used
}

type storage = Fact_FA2.storage
type extended_storage = extension storage

type return = operation list * extended_storage

type parameter = 
    | Creat_Collection of Fact_FA2.parameter
    | Add_Admin of address
    | Supp_Admin of address
    | Get_Whitelisted of address
    | Blacklist_Creator of address

let addAdmin (newAdmin : address) (store : extended_storage) : extended_storage =
    let isAdmin = Map.find_opt Tezos.get_sender() store.adminMap in
    let () = if (isAdmin = None || False ) then (failwith "Not an Admin") in
    let isnewAdmin = Map.find_opt newAdmin store.adminMap in
    match isnewAdmin with
    | True -> (failwith "already Admin")
    | False -> let newMap = Map.update newAdmin True store.adminMap in
    | None -> let newMap = Map.add newAdmin True store.adminMap in
{ store with adminMap = newMap }
//     let () = if (isnewAdmin = True )
//         then (failwith "Already Admin")
//         else if (isnewAdmin = False)
//             then let newMap = Map.update newAdmin True store.adminMap in
//             else let newMap = Map.add newAdmin True store.adminMap in
// { store with adminMap = newMap }
    
let suppAdmin ( removedAdmin : address) (store : extended_storage) : extended_storage =
    let isAdmin = Map.find_opt Tezos.get_sender() store.adminMap in
    let () = if (isAdmin = None || False ) then (failwith "Not an Admin") in
    let isAlreadyAdmin = Map.find_opt removedAdmin store.adminMap in
    let () = if (isAlreadyAdmin = False || None )
    then (failwith "Not an Admin")
    else let newMap = Map.add removedAdmin False store.adminMap in
        { store with adminMap = newMap }


let getWhitelisted (newAdmin : address) (store : extended_storage) : extended_storage =
    let () = if (Tezos.get_amount() < 10tez ) then failwith "Not enougth Tez"
    let isCreatorBlacklisted = Map.find_opt Tezos.get_sender() store.blackMap in
    let () = if (isCreatorBlacklisted = True) then failwith "Creator Blacklisted"
    let isCreatorWhitelisted = Map.find_opt Tezos.get_sender() store.whiteMap in
    let () = if (isCreatorWhitelisted = True) then failwith "Creator already Whitelisted"
    let () = if (isCreatorWhitelisted = False)
        then let newMap = Map.update newAdmin True store.whiteMap in
        else let newMap = Map.add newAdmin True store.whiteMap in
{store with whiteMap = newMap}

let blacklistCreator (creator : address) (store : extended_storage) : extended_storage =
    let isAdmin = Map.find_opt Tezos.get_sender() store.adminMap in
    let () = if (isAdmin = None || False ) then (failwith "Not an Admin") in
    let isCreatorBlacklisted = Map.find_opt creator store.blackMap in
    let () = if (isCreatorBlacklisted = True)
    then (failwith "Already Blacklisted")
    else if (isCreatorBlacklisted = False)
        then let newBlackMap = Map.update creator True store.blackMap in
        else let newBlackMap = Map.add creator True store.blackMap in
{store with blackMap = newBlackMap}

let mygererateCollection (param : Fact_FA2.parameter) (store : extended_storage) : extended_storage =
    let isCreatorBlacklisted = Map.find_opt Tezos.get_sender() store.blackMap in
    let () = if (isCreatorBlacklisted = True) then failwith "Creator Blacklisted"
    let isCreatorWhitelisted = Map.find_opt Tezos.get_sender() store.whiteMap in
    let () = if (isCreatorWhitelisted = False || None) then failwith "Creator not Whitelisted"
    Fact_FA2.generateCollection(action, store)


let main(action : parameter) (store : extended_storage ) : return =
    match action with
    | Creat_Collection (p) -> Fact_FA2.generateCollection(action, store)
    | Add_Admin (p) -> addAdmin p store
    | Supp_Admin (p) -> suppAdmin p store
    | Get_Whitelisted (p) -> getWhitelisted p store
    | Blacklist_Creator (p) -> blacklistCreator p store

[@view] let getCollectionByUser (owner : address) (store :extended_storage) : address list =
    let address_list = Map.find_opt owner store.storage.t.owned_collections in
    match address_list with
    | None -> failwith "Nothing for this owner"
    | Some (addresses) -> addresses











// #import "ligo-extendable-fa2/lib/multi_asset/fa2.mligo" "FA2"

// type extension = {
//     admin : address
// }

// type storage = FA2.storage
// type extended_storage = extension storage

// type return = operation list * extended_storage

// type parameter = FA2.parameter

// let main (action : parameter) (store : extended_storage ) : return =
//     match action with
//     | Transfer (p) -> FA2.transfer p store
//     | Balance_of (p) -> FA2.balance_of p store 
//     | Update_operators (p) -> FA2.update_ops p store

