"use client"
import React, { FC, useMemo, useState } from "react";
import { WalletProvider } from "@demox-labs/aleo-wallet-adapter-react";
import { WalletModalProvider } from "@demox-labs/aleo-wallet-adapter-reactui";
import { LeoWalletAdapter } from "@demox-labs/aleo-wallet-adapter-leo";
import {
  DecryptPermission,
  WalletAdapterNetwork,
} from "@demox-labs/aleo-wallet-adapter-base";
// Default styles that can be overridden by your app
require("@demox-labs/aleo-wallet-adapter-reactui/styles.css");

const Wallet = () => {
    const wallets = React.useMemo(
      () => [
        new LeoWalletAdapter({
          appName: "Leo Demo App",
        }),
      ],
      []
    );

    console.log("wallets : ", wallets);
  
    return (
      <WalletProvider
        wallets={wallets}
        decryptPermission={DecryptPermission.UponRequest}
        network={WalletAdapterNetwork.Localnet}
        autoConnect
      >
        <WalletModalProvider>
          {/* Your app's components go here */}
          {/* <button>wallet</button> */}
        </WalletModalProvider>
      </WalletProvider>
    );
  };

export default Wallet