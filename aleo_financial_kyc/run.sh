#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null

then
    echo "leo is not installed."
    exit
fi

echo "
###############################################################################
########                                                               ########
########               STEP 0: Compile the KYC program                 ########
########                                                               ########
###############################################################################
"
# Build the Leo vote program.
(
  leo build || exit
)

# 1: Initializing Player 1
echo "
###############################################################################
########                                                               ########
########                 STEP 1: Initializing FI 1                     ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

echo "✅ Successfully initialized FI 1."


# 2: DAO member creates FI
echo "
###############################################################################
########                                                               ########
########                   STEP 2: Create FI Record                    ########
########                                                               ########
###############################################################################
"
leo run create_fi 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32

# 3: DAO member approves FI
echo "
###############################################################################
########                                                               ########
########                  STEP 3: Approve FI Record                    ########
########                                                               ########
###############################################################################
"
leo run approve_fi aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32

# 4: FI creates user personal info
echo "
###############################################################################
########                                                               ########
########            STEP 4: Create User Personal Info Record           ########
########                                                               ########
###############################################################################
"
leo run create_personal_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur

# 5: User shares personal info with FI
echo "
###############################################################################
########                                                               ########
########            STEP 5: User shares personal info with FI          ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_personal_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

# 6: FI creates user contact info
echo "
###############################################################################
########                                                               ########
########            STEP 6: Create User Contact Info Record           ########
########                                                               ########
###############################################################################
"
leo run create_contact_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32 aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur

# 7: User shares contact info with FI
echo "
###############################################################################
########                                                               ########
########            STEP 7: User shares contact info with FI           ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_contact_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u32 1u32 1u32 aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json


# 8: FI creates user employment info
echo "
###############################################################################
########                                                               ########
########          STEP 8: Create User Employment Info Record           ########
########                                                               ########
###############################################################################
"
leo run create_employment_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# 9: User shares employment info with FI
echo "
###############################################################################
########                                                               ########
########         STEP 9: User shares employment info with FI           ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_employment_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

# 10: FI creates user Financial info
echo "
###############################################################################
########                                                               ########
########          STEP 10: Create User Financial Info Record            ########
########                                                               ########
###############################################################################
"
leo run create_financial_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# 11: User shares Financial info with FI
echo "
###############################################################################
########                                                               ########
########         STEP 11: User shares Financial info with FI           ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_financial_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u64 aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

# 12: FI creates user Investment Exp info
echo "
###############################################################################
########                                                               ########
########      STEP 12: Create User Investment Exp Info Record          ########
########                                                               ########
###############################################################################
"
leo run create_investment_exp_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field true true true true true true true true true true true true true aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# 13: User shares Investment Exp info with FI
echo "
###############################################################################
########                                                               ########
########       STEP 13: User shares Investment Exp info with FI        ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_investment_exp_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field true true true true true true true true true true true true true aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

# 14: FI creates user Pep info
echo "
###############################################################################
########                                                               ########
########            STEP 14: Create User Pep Info Record               ########
########                                                               ########
###############################################################################
"
leo run create_pep_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field true 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# 15: User shares Pep info with FI
echo "
###############################################################################
########                                                               ########
########             STEP 15: User shares Pep info with FI             ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_pep_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field true 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

# 16: FI creates user Risk Assessment info
echo "
###############################################################################
########                                                               ########
########        STEP 16: Create User Risk Assessment Info Record       ########
########                                                               ########
###############################################################################
"
leo run create_risk_assessment_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# 17: User shares Pep info with FI
echo "
###############################################################################
########                                                               ########
########       STEP 17: User shares Risk Assessment info with FI       ########
########                                                               ########
###############################################################################
"

# Mimick User
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpC6zzfQVS29Q6PX9q24yQvvRgLB8ktfWTPukAm9GgMVhU\",
      \"view_key\": \"AViewKey1oE1q9BV3cYBGjjpJqczEABnbMAHjAYYLpcXjgonVgdzF\",
      \"address\": \"aleo17wu6f949ehk3rvkgmq5kykxt562q64nua6ecn7rd68d4zg5dwy9qvrqgur\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run post_share_risk_assessment_info 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 21888242871839275222246405745257275088548364400416034343698204186575808495617field 1u8 1u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

# Reverse Changes, Mimick FI
echo "{
  \"program\": \"aleo_financial_kyc2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json