import * as dotenv from 'dotenv';
dotenv.config(( { path: '../.env' } ));

const accountsList = {
    sandbox: {
        alice:{
            publickey: "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb",
            privatekey:"edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq",
        },
        bob: {
            publickey: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
            privatekey:"edsk3RFfvaFaxbHx8BMtEW1rKQcPtDML3LXjNqMNLCzC3wLC1bWbAt",
        }
    },
    ghostnet:{
        alice:{
            publickey: "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb",
            privatekey:"edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq",
        },
        bob: {
            publickey: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
            privatekey:"edsk3RFfvaFaxbHx8BMtEW1rKQcPtDML3LXjNqMNLCzC3wLC1bWbAt",
        },
        admin: {
            publickey: "tz1fZngkXnSYzZNgYu8cazX7nArgMHnyoMG6",
            privatekey: process.env.ADMIN_PRIVATE_KEY,
        }

    },
    mainnet:{
        alice:{
            publickey: "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb",
            privatekey:"edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq",
        },
        bob: {
            publickey: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
            privatekey:"edsk3RFfvaFaxbHx8BMtEW1rKQcPtDML3LXjNqMNLCzC3wLC1bWbAt",
        },
        admin: {
            publickey: "tz1fZngkXnSYzZNgYu8cazX7nArgMHnyoMG6",
            privatekey: process.env.ADMIN_PRIVATE_KEY,
        }

    }
}

let accounts;

switch (process.env.TEZ_NETWORK) {
    case "SANDBOX":
        accounts = accountsList.sandbox;
    case "GHOSTNET":
        accounts = accountsList.ghostnet;
    case "MAINNET":
        accounts = accountsList.mainnet;
}

export default accounts;