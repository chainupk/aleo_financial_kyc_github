import { WalletNotConnectedError } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import React, { FC, useCallback, useState } from "react";
import TextField from '@mui/material/TextField';
import { styled } from '@mui/system';

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
    }
  });

const DecryptMessage = () => {
  const { publicKey, decrypt } = useWallet();
  const [dMessage, seDMessage] = useState('')

  const onClick = async () => {
    if (!publicKey) throw new WalletNotConnectedError();
    if (decrypt) {
        console.log(decrypt);
        console.log(dMessage);
        const decryptedPayload = await decrypt(dMessage);
        console.log("Decrypted payload: " + decryptedPayload);
    }
  };

  const handleChange = (e) => {
    seDMessage(e.target.value)
  }

  return (
    <div>
        <StyledTextField styles={{ color: 'white' }} fullWidth id="descrypt-basic" label="Decrypt" onChange={handleChange}/>
        <button onClick={onClick} disabled={!publicKey}>
            Decrypt message
        </button>
    </div>
  );
};

export default DecryptMessage