import { WalletNotConnectedError } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import React, { FC, useCallback } from "react";

const RequestRecords = () => {
  const { publicKey, requestRecords } = useWallet();

  const onClick = async () => {
    const program = "aleo_financial_kyc2.aleo";
    if (!publicKey) throw new WalletNotConnectedError();
    if (requestRecords) {
      const records = await requestRecords(program);
      console.log("Records: \n" + JSON.stringify(records));
    }
  };

  return (
    <button onClick={onClick} disabled={!publicKey}>
      Request Records
    </button>
  );
};

export default RequestRecords