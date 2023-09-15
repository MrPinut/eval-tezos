import * as dotenv from 'dotenv';
dotenv.config(( { path: '../.env' } ));

// const sandbox = {
//     node_url: "http://localhotst:20000"
// }
// const ghostnet ={
//     node_url: "https://rpc.tzkt.io/ghostnet"
// }
// const mainnet ={
//     node_url: 
// }

let networks;

switch (process.env.TEZ_NETWORK) {
    case "SANDBOX" :
        networks = "http://localhotst:20000";
    case "GHOSTNET" :
        networks = "https://rpc.tzkt.io/ghostnet";
    case "MAINNET" :
        networks = "https://rpc.tzkt.io/mainnet";
}

export default networks;