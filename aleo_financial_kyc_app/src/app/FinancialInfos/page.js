import { WalletNotConnectedError, Transaction, WalletAdapterNetwork, } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { LeoWalletAdapter } from '@demox-labs/aleo-wallet-adapter-leo';
import React, { FC, useCallback, useState, useEffect } from "react";
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import Slide from '@mui/material/Slide';
import Card from '@mui/material/Card';
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


const FinancialInfo = () => {

  const { publicKey, wallet, requestTransaction, requestRecords } = useWallet();
  let [transactionId, setTransactionId] = useState("")
  let [transactionStatus, setTransactionStatus] = useState("")
  let [referenceId, setReferenceId] = useState("")
  let [annualIncomeAmt, setAnnualIncomeAmt] = useState("")
  let [sourceOfIncome, setSourceOfIncome] = useState("")
  let [fundsAmt, setFundsAmt] = useState("")
  let [sourceOfFund, setSourceOfFund] = useState("")
  let [wealthAmt, setWealthAmt] = useState("")
  let [sourceOfWealth, setSourceOfWealth] = useState("")
  let [estimatedNetWorth, setEstimatedNetWorth] = useState("")
  let [secondaryOwnerAddress, setSecondaryOwnerAddress] = useState("")
  let [myFiRecords, setMyFiRecords] = useState([])


  useEffect(() => {
    let intervalId;
    let status = ""
    if (transactionId) {
      intervalId = setInterval(() => {
        getTransactionStatus(transactionId);
      }, 1000);
    }

    return () => {
      if (intervalId) {
        clearInterval(intervalId);
        // if txn status is complete or failed update transaction ID to ""
      }
    };
  }, [transactionId]);

  const getRecords = async () => {
    console.log('getting records..');
    if (requestRecords) {
      console.log('requesting records...');
      const program = "aleo_financial_kyc2.aleo";
      const records = await requestRecords(program);
      console.log("Records: " + JSON.stringify(records));
      if (records && records.length) {
        let fiRecords = records.filter((eachRecord) => {
          console.log("eachRecord :", eachRecord);
          return eachRecord && eachRecord.data && eachRecord.data.source_of_wealth && eachRecord.data.source_of_wealth.length > 0
        })
        setMyFiRecords(fiRecords)
      }
      return records
    }
    return ""
  }

  useEffect(() => {
    getRecords()
  },[])

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

  const bigIntToBase58 = (bigIntValue) => {
    let buf = [];
    while (bigIntValue > BigInt(0)) {
        const remainder = bigIntValue % BigInt(256);
        buf.unshift(Number(remainder));  // convert the BigInt to a regular Number
        bigIntValue = bigIntValue / BigInt(256);
    }
    return bs58check.encode(Buffer.from(buf));
}


  const base58ToString = (base58Str) => {
    const buf = bs58check.decode(base58Str);
    const textDecoder = new TextDecoder('utf-8');
    const decodedString = textDecoder.decode(buf)
    return decodedString;
  }

  const onClick = async () => {
      const program = "aleo_financial_kyc2.aleo";
      if (!publicKey) throw new WalletNotConnectedError();
      let records = ''
      if (requestRecords) {
        records = await requestRecords(program);
        console.log("Records: " + JSON.stringify(records));
        if (records && records.length) {
          let fiRecords = records.filter((eachRecord) => {
            return eachRecord && eachRecord.data && eachRecord.data.source_of_wealth && eachRecord.data.source_of_wealth.length > 0
          })
          setMyFiRecords(fiRecords)
        }
      }
      // The record here is an output from the Requesting Records above
      // const record = `{owner : "${publicKey}",is_trusted: false, id: "aleoid1", company_name_1: "name",company_name_2: "name2",company_type: "type",company_address_1: "company_address_1", "company_address_2: "company_address_2", "company_address_3": "company_address_3", "company_state": "state", "company_country": "Singapore", "email_address": "something", "email_address_domain": "something.com", "backup_email_address": "nothing", "backup_email_address_domain": "nothing.com", "phone_country_code": 65, "phone_area_code": 1, "phone_number": 1234, "created_at": "23:12:12T00.00z"}`

      if (
        !referenceId ||
        !annualIncomeAmt ||
        !sourceOfIncome ||
        !fundsAmt ||
        !sourceOfFund ||
        !wealthAmt ||
        !sourceOfWealth ||
        !estimatedNetWorth ||
        !secondaryOwnerAddress
      ) {
        return;
      }

      console.log("publicKey: ", publicKey);
      let inputs = [
          `${base58ToBigInt(stringToBase58(referenceId))}field`, 
          `${annualIncomeAmt}u64`, 
          `${base58ToBigInt(stringToBase58(sourceOfIncome))}field`, 
          `${fundsAmt}u64`, 
          `${base58ToBigInt(stringToBase58(sourceOfFund))}field`, 
          `${wealthAmt}u64`, 
          `${base58ToBigInt(stringToBase58(sourceOfWealth))}field`, 
          `${estimatedNetWorth}u64`, 
          `${publicKey}`, 
          `${secondaryOwnerAddress}`, 
      ];
      const fee = 2_500_000; // This will fail if fee is not set high enough

      const aleoTransaction = Transaction.createTransaction(
          publicKey,
          WalletAdapterNetwork.Testnet,
          'aleo_financial_kyc2.aleo',
          'create_financial_info',
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
    setTransactionStatus(status)
    if (status === 'Finalized' || status === 'Rejected'  || status === 'Failed') {
      setTransactionId("")
      setTransactionStatus("")
      getRecords()
    }
    return status
  };



  return (
    <Slide direction="up" in={true} mountOnEnter unmountOnExit>
    <div style={{ maxWidth: 800 }}>
      <Typography variant="h2" gutterBottom>
        Financial Information (Approved FIs only)
      </Typography>
      <StyledTextField
        disabled={transactionId} 
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
        disabled={transactionId} 
        fullWidth 
        id="outlined-annualIncomeAmt" 
        label="Annual Income Amount" 
        variant="outlined"
        value={annualIncomeAmt}
        onChange={(e) => {
          setAnnualIncomeAmt(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-sourceOfIncome" 
        label="Source Of Income" 
        variant="outlined"
        value={sourceOfIncome}
        onChange={(e) => {
          setSourceOfIncome(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-fundsAmt" 
        label="Funds Amount" 
        variant="outlined"
        value={fundsAmt}
        onChange={(e) => {
          setFundsAmt(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-sourceOfFund" 
        label="Source Of Fund" 
        variant="outlined"
        value={sourceOfFund}
        onChange={(e) => {
          setSourceOfFund(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-wealthAmt" 
        label="Wealth Amount" 
        variant="outlined"
        value={wealthAmt}
        onChange={(e) => {
          setWealthAmt(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-sourceOfWealth" 
        label="Source Of Wealth" 
        variant="outlined"
        value={sourceOfWealth}
        onChange={(e) => {
          setSourceOfWealth(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-estimatedNetWorth" 
        label="Estimated Net Worth" 
        variant="outlined"
        value={estimatedNetWorth}
        onChange={(e) => {
          setEstimatedNetWorth(e.target.value);
        }}
      />
      <StyledTextField
        disabled={transactionId} 
        fullWidth 
        id="outlined-secondaryOwnerAddress" 
        label="Secondary Owner Address" 
        variant="outlined"
        value={secondaryOwnerAddress}
        onChange={(e) => {
          setSecondaryOwnerAddress(e.target.value);
        }}
      />
      <Button sx={{margin: '0.5em' }}  variant="contained" onClick={onClick} disabled={(!publicKey || transactionId)}>
        {`Request Transaction ${transactionStatus}`}
      </Button>
      <div>
        { myFiRecords && myFiRecords.length && myFiRecords.map((eachFiRecord, index) => {
          console.log("eachFiRecord : ", eachFiRecord);
          if (!eachFiRecord.data.reference_id || !eachFiRecord.data.annual_income_amount || !eachFiRecord.data.source_of_income || !eachFiRecord.data.funds_amount || !eachFiRecord.data.source_of_fund || !eachFiRecord.data.wealth_amount || !eachFiRecord.data.source_of_wealth || !eachFiRecord.data.estimated_net_worth || !eachFiRecord.data.secondary_owner) {
            return ''
          }
          return <Card sx={{ margin: '0.5em' }} variant="outlined" key={`firecord-${index}`}>
              <Typography variant="body2" noWrap gutterBottom>
                {`Reference ID: ${base58ToString(bigIntToBase58(BigInt(eachFiRecord.data.reference_id.split("field")[0])))}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Annual Income: ${eachFiRecord.data.annual_income_amount.split("u64")[0]}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Source of Income: ${base58ToString(bigIntToBase58(BigInt(eachFiRecord.data.source_of_income.split("field")[0])))}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Funds Amount: ${eachFiRecord.data.funds_amount.split("u64")[0]}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Source of Funds: ${base58ToString(bigIntToBase58(BigInt(eachFiRecord.data.source_of_fund.split("field")[0])))}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Wealth Amount: ${eachFiRecord.data.wealth_amount.split("u64")[0]}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Source of Wealth: ${base58ToString(bigIntToBase58(BigInt(eachFiRecord.data.source_of_wealth.split("field")[0])))}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Estimated Net Worth: ${eachFiRecord.data.estimated_net_worth.split("u64")[0]}`}
              </Typography>
              <Typography variant="body2" noWrap gutterBottom>
                {`Secondary Owner: ${eachFiRecord.data.secondary_owner.split(".")[0]}`}
              </Typography>
          </Card>
        })}
      </div>
    </div>
    </Slide>
  );
};

export default FinancialInfo