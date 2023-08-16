import { WalletNotConnectedError, Transaction, WalletAdapterNetwork, } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { LeoWalletAdapter } from '@demox-labs/aleo-wallet-adapter-leo';
import React, { FC, useCallback, useState, useEffect } from "react";

var bs58check = require('bs58check')

const RequestTransaction = () => {
  const { publicKey, wallet, requestTransaction, requestRecords } = useWallet();
  let [transactionId, setTransactionId] = useState("")

  useEffect(() => {
    let intervalId;

    if (transactionId) {
      intervalId = setInterval(() => {
        getTransactionStatus(transactionId);
      }, 1000);
    }

    return () => {
      if (intervalId) {
        clearInterval(intervalId);
      }
    };
  }, [transactionId]);

    const onClick = async () => {
        const program = "aleo_financial_kyc2.aleo";
        if (!publicKey) throw new WalletNotConnectedError();
        let records = ''
        if (requestRecords) {
          records = await requestRecords(program);
          console.log("Records: " + JSON.stringify(records));
        }
        // The record here is an output from the Requesting Records above
        // const record = `{owner : "${publicKey}",is_trusted: false, id: "aleoid1", company_name_1: "name",company_name_2: "name2",company_type: "type",company_address_1: "company_address_1", "company_address_2: "company_address_2", "company_address_3": "company_address_3", "company_state": "state", "company_country": "Singapore", "email_address": "something", "email_address_domain": "something.com", "backup_email_address": "nothing", "backup_email_address_domain": "nothing.com", "phone_country_code": 65, "phone_area_code": 1, "phone_number": 1234, "created_at": "23:12:12T00.00z"}`

        let inputs = []
        // if (records.length) {
        //   console.log('records are : ', records);
        //   // Note that the inputs must be formatted in the same order as the Aleo program function expects, otherwise it will fail
        //   inputs = [JSON.parse(records), "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", `1u32`, `1u32`, `1u32`];
        // } else {
          inputs = ["21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", "21888242871839275222246405745257275088548364400416034343698204186575808495617field", `1u32`, `1u32`, `1u32`];
        // }
        const fee = 2_500_000; // This will fail if fee is not set high enough

        const aleoTransaction = Transaction.createTransaction(
            publicKey,
            WalletAdapterNetwork.Testnet,
            'aleo_financial_kyc2.aleo',
            'create_fi',
            inputs,
            fee
        );

        console.log("aleoTransaction : ", aleoTransaction);

        if (requestTransaction) {
            // Returns a transaction Id, that can be used to check the status. Note this is not the on-chain transaction id
            const adapter = wallet ? wallet.adapter : undefined;
            console.log("adapter: ", adapter);
            try {
              // result :  97f28ac2-55a5-4d7a-bf8b-13f4fcffde7b ,  b0787e06-5b09-43cf-b3f8-0bc51631632c
              const result = adapter ? await adapter.requestTransaction(aleoTransaction) : '';
              console.log("result : ", result);
              if (result) {
                setTransactionId(result)
              }
            } catch (e) {
              console.log("error : ", e);
            }
        }
    };

    const getTransactionStatus = async (txId) => {
      console.log('txnId : ', txId);
      const status = await wallet.adapter.transactionStatus(txId);
      console.log("status : ", status);
    };

    const stringToBase58 = (str) => {
      const buffer = Buffer.from(str);
      return bs58check.encode(buffer);
    }
  
  const base58ToBigInt = (base58Str) => {
      const buf = bs58check.decode(base58Str);
      let intValue = BigInt(0);
      for (let i = 0; i < buf.length; i++) {
          intValue = (intValue * BigInt(256)) + BigInt(buf[i]);  
      }
      return intValue;
  }

  return (
    <div>
      <button onClick={onClick} disabled={!publicKey}>
        Request Transaction
      </button>
      &nbsp;
      <button onClick={getTransactionStatus} disabled={!publicKey}>
        Request Transaction Status
      </button>
    </div>
  );
};

export default RequestTransaction

// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "21888242871839275222246405745257275088548364400416034343698204186575808495617field"
// "1u32"
// "1u32"
// "1u32"