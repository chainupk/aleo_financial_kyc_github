import { WalletNotConnectedError } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { LeoWalletAdapter } from "@demox-labs/aleo-wallet-adapter-leo";
import React, { FC, useCallback } from "react";

const SignMessage = () => {
    const { wallet, publicKey } = useWallet();

    const onClick = useCallback(async () => {
        console.log('click!');
        console.log("wallet : ", wallet);
      if (!publicKey) throw new WalletNotConnectedError();

      const message = "a message to sign";
  
      const bytes = new TextEncoder().encode(message);
      const signatureBytes = await wallet.adapter.signMessage(bytes);
      const signature = new TextDecoder().decode(signatureBytes);
      console.log("signature: ", signature);
      alert("Signed message: " + signature);
    }, [wallet, publicKey]);

    console.log("wallet : ", wallet);
    console.log("publicKey : ", publicKey);
  
    return (
      <button onClick={onClick} disabled={!publicKey}>
        Sign message
      </button>
    );
};

export default SignMessage