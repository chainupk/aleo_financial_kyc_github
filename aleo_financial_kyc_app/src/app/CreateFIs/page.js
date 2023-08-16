import { WalletNotConnectedError, Transaction, WalletAdapterNetwork, } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { LeoWalletAdapter } from '@demox-labs/aleo-wallet-adapter-leo';
import React, { FC, useCallback, useState, useEffect } from "react";
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import Slide from '@mui/material/Slide';
import { styled } from '@mui/system';

var bs58check = require('bs58check')

const StyledTextField = styled(TextField)({
  "& .MuiOutlinedInput-root": {
    "& fieldset": {
      borderColor: "white",
    },
    "&:hover fieldset": {
      borderColor: "white",
    },
    "&.Mui-focused fieldset": {
      borderColor: "white",
    },
  },
  "& .MuiInputBase-input": {
    color: "white"
  },
  "& .MuiFormLabel-root": {
    color: "white"
  },
  margin: '0.5em'
});


const CreateFI = () => {

  // id: field, 
  // company_name_1: field, 
  // company_type: field, 
  // company_address_1: field, 
  // company_address_2: field, 
  // company_address_3: field, 
  // company_state: field, 
  // company_country: field, 
  // email_address: field, 
  // email_address_domain: field, 
  // phone_country_code: u32, 
  // phone_area_code: u32, 
  // phone_number: u32

  const { publicKey, wallet, requestTransaction, requestRecords } = useWallet();
  let [transactionId, setTransactionId] = useState("")
  let [referenceId, setReferenceId] = useState("")
  let [companyName, setCompanyName] = useState("")
  let [companyType, setCompanyType] = useState("")
  let [companyAddress1, setCompanyAddress1] = useState("")
  let [companyAddress2, setCompanyAddress2] = useState("")
  let [companyAddress3, setCompanyAddress3] = useState("")
  let [companyState, setCompanyState] = useState("")
  let [companyCountry, setCompanyCountry] = useState("")
  let [companyEmailAdd, setCompanyEmailAdd] = useState("")
  let [companyEmailDomain, setCompanyEmailDomain] = useState("")
  let [companyPhoneCountry, setCompanyPhoneCountry] = useState("")
  let [companyPhoneArea, setCompanyPhoneArea] = useState("")
  let [companyPhoneNumber, setCompanyPhoneNumber] = useState("")

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

        if (
          !referenceId ||
          !companyName ||
          !companyType ||
          !companyAddress1 ||
          !companyAddress2 ||
          !companyAddress3 ||
          !companyState ||
          !companyCountry ||
          !companyEmailAdd ||
          !companyEmailDomain ||
          !companyPhoneCountry ||
          !companyPhoneArea ||
          !companyPhoneNumber
        ) {
          return;
        }
        let inputs = [
            `${base58ToBigInt(stringToBase58(referenceId))}field`, 
            `${base58ToBigInt(stringToBase58(companyName))}field`, 
            `${base58ToBigInt(stringToBase58(companyType))}field`, 
            `${base58ToBigInt(stringToBase58(companyAddress1))}field`, 
            `${base58ToBigInt(stringToBase58(companyAddress2))}field`, 
            `${base58ToBigInt(stringToBase58(companyAddress3))}field`, 
            `${base58ToBigInt(stringToBase58(companyState))}field`, 
            `${base58ToBigInt(stringToBase58(companyCountry))}field`, 
            `${base58ToBigInt(stringToBase58(companyEmailAdd))}field`, 
            `${base58ToBigInt(stringToBase58(companyEmailDomain))}field`, 
            `${companyPhoneCountry}u32`, 
            `${companyPhoneArea}u32`,
            `${companyPhoneNumber}u32`
          ];
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

  return (
    <Slide direction="up" in={true} mountOnEnter unmountOnExit>
    <div style={{ maxWidth: 800 }}>
      <Typography variant="h2" gutterBottom>
        Create Financial Institution (Anyone)
      </Typography>
      <StyledTextField 
        fullWidth 
        id="outlined-referenceId" 
        label="Reference ID" 
        variant="outlined"
        value={referenceId}
        onChange={(e) => {
          setReferenceId(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyName" 
        label="Company Name" 
        variant="outlined"
        value={companyName}
        onChange={(e) => {
          setCompanyName(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyType" 
        label="Company Type" 
        variant="outlined"
        value={companyType}
        onChange={(e) => {
          setCompanyType(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-address1" 
        label="Company Address 1" 
        variant="outlined"
        value={companyAddress1}
        onChange={(e) => {
          setCompanyAddress1(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-address2" 
        label="Company Address 2" 
        variant="outlined"
        value={companyAddress2}
        onChange={(e) => {
          setCompanyAddress2(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-address3" 
        label="Company Address 3" 
        variant="outlined"
        value={companyAddress3}
        onChange={(e) => {
          setCompanyAddress3(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyState" 
        label="Company State" 
        variant="outlined"
        value={companyState}
        onChange={(e) => {
          setCompanyState(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyCountry" 
        label="Company Country" 
        variant="outlined"
        value={companyCountry}
        onChange={(e) => {
          setCompanyCountry(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyEmailAdd" 
        label="Company Email Add" 
        variant="outlined"
        value={companyEmailAdd}
        onChange={(e) => {
          setCompanyEmailAdd(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyEmailDomain" 
        label="Company Email Domain" 
        variant="outlined"
        value={companyEmailDomain}
        onChange={(e) => {
          setCompanyEmailDomain(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyPhoneCountry" 
        label="Company Phone Country" 
        variant="outlined"
        value={companyPhoneCountry}
        onChange={(e) => {
          setCompanyPhoneCountry(e.target.value);
        }}
      />
      <StyledTextField 
        fullWidth 
        id="outlined-companyPhoneArea" 
        label="Company Phone Area" 
        variant="outlined"
        value={companyPhoneArea}
        onChange={(e) => {
          setCompanyPhoneArea(e.target.value);
        }}
      />
     <StyledTextField 
        fullWidth 
        id="outlined-companyPhoneNumber" 
        label="Company Phone Number" 
        variant="outlined"
        value={companyPhoneNumber}
        onChange={(e) => {
          setCompanyPhoneNumber(e.target.value);
        }}
      />
      <Button sx={{margin: '0.5em' }} variant="contained" onClick={onClick} disabled={!publicKey}>
        Request Transaction
      </Button>
      <Button sx={{margin: '0.5em' }} variant="contained" onClick={getTransactionStatus} disabled={!publicKey}>
        Request Transaction Status
      </Button>
    </div>
    </Slide>
  );
};

export default CreateFI