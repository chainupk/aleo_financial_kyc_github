"use client"
import React, { FC, useMemo, useState, useCallback } from "react";
import { WalletProvider, useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { WalletModalProvider } from "@demox-labs/aleo-wallet-adapter-reactui";
import { LeoWalletAdapter } from "@demox-labs/aleo-wallet-adapter-leo";
import {
  DecryptPermission,
  WalletAdapterNetwork,
  WalletNotConnectedError
} from "@demox-labs/aleo-wallet-adapter-base";
// Default styles that can be overridden by your app
require("@demox-labs/aleo-wallet-adapter-reactui/styles.css");

import Image from 'next/image'
import styles from './page.module.css'
// import Wallet from './Wallet/page'
import SignMessage from './Signing/page'
import Navbar from './NavBar/page'
import DecryptMessage from './Decrypting/page'
import RequestRecords from './RequestRecords/page'
import RequestTransaction from './RequestTransactions/page'
import CreateFI from './CreateFIs/page'
import ApproveFI from './ApproveFIs/page'
import FinancialInfo from './FinancialInfos/page'
import { createTheme, ThemeProvider } from '@mui/material/styles';

export default function Home() {

  const wallets = React.useMemo(
    () => [
      new LeoWalletAdapter({
        appName: "Leo Demo App",
      }),
    ],
    []
  );

  const [appPage, setAppPage] = useState("financial_info");

  const changeAppPage = (page) => {
    setAppPage(page)
  }

  const theme = createTheme({
    palette: {
      primary: {
        main: '#104df9',  // Change this to the grey color you want
      },
    },
  });

  return (
    <WalletProvider
      wallets={wallets}
      decryptPermission={DecryptPermission.UponRequest}
      network={WalletAdapterNetwork.Localnet}
      autoConnect
    >
      <WalletModalProvider>
        {/* Your app's components go here */}
        <ThemeProvider theme={theme}>
          <Navbar changeAppPage={changeAppPage}/>
          <main className={styles.main}>
            {appPage === "create_fi" && <CreateFI/>}
            {appPage === "approve_fi" && <ApproveFI/>}
            {appPage === "financial_info" && <FinancialInfo/>}
            {/* <SignMessage />
            <DecryptMessage />
            <RequestRecords />
            <RequestTransaction/> */}
          </main>
        </ThemeProvider>
      </WalletModalProvider>
    </WalletProvider>
  )
}