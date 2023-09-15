import {outputFile} from "fs-extra";
import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit, MichelsonMap } from "@taquito/taquito";
import metadata from "./metadata.json"
import * as dotenv from 'dotenv';
import code from "../compiled/factory.json";
import { char2Bytes } from "@taquito/utils";
import networks from "./config";
import accounts from "./accounts";
dotenv.config(( { path: '../.env' } ));

const TezosNodeRPC : string = networks ;// process.env.TEZOS_NODE_URL;
const publicKey : string = accounts.alice.publicKey//process.env.ALICE_PUBLIC;//ADMIN_PUBLIC_KEY;
const privateKey : string = accounts.alice.privateKey//process.env.ALICE_PRIVATE;//ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });

Tezos.tz.getBalance(publicKey)
    .then((balance) => console.log(`Address Balance : ${balance.toNumber() / 1000000} ꜩ`))
    .catch((error) => console.log(JSON.stringify(error)));

const saveContractAddress = (name : string , address: string) => {
    outputFile(`deployment/${name}.ts`,
    `export default "${address}"`)
}

const deploy = async () => {
    try {
        const storage = {
            adminMap : new MichelsonMap(),
            whiteMap : new MichelsonMap(),
            BlackMap : new MichelsonMap(),
            collectionList : [], // not used
            all_collections : new MichelsonMap(),
            owned_collections : new MichelsonMap(),
            metadata : MichelsonMap.fromLiteral({
                "" : char2Bytes("tezos-storage:jsonfile"),
                "jsonfile" : char2Bytes(JSON.stringify(metadata)),
            }),
        }
        const origination = await Tezos.contract.originate({
            code : code,
            storage: storage
        });
        console.log(origination.contractAddress);
        saveContractAddress("deployed_contract", origination.contractAddress);
    }
    catch (error) {
        console.log(error)
    }


}

deploy()