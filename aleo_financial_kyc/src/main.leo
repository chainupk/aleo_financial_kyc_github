// The 'aleo_financial_kyc' program.
program aleo_financial_kyc2.aleo {

    record PersonalInfo {
        private reference_id: field,
        private first_name: field,
        private middle_name: field,
        private last_name: field,
        private dob_day: u32,
        private dob_month: u32,
        private dob_year: u32,
        private nationality: field,
        private national_reference_id: field,
        private owner: address,
        private secondary_owner: address,
    }

    record ContactInfo {
        private reference_id: field,
        private residential_address_1: field,
        private residential_address_2: field,
        private residential_address_3: field,
        private residential_state: field,
        private residential_country: field,
        private email_address: field,
        private email_address_domain: field,
        private phone_country_code: u32,
        private phone_area_code: u32,
        private phone_number: u32,
        private owner: address,
        private secondary_owner: address,
    }

    record EmploymentInfo {
        private reference_id: field,
        private occupation: field,
        private employer_name_1: field,
        private employer_company_type: field,
        private employer_address_1: field,
        private employer_address_2: field,
        private employer_address_3: field,
        private employer_state: field,
        private employer_country: field,
        private owner: address,
        private secondary_owner: address,
    }

    record FinancialInfo {
        private reference_id: field,
        private annual_income_amount: u64,
        private source_of_income: field,
        private funds_amount: u64,
        private source_of_fund: field,
        private wealth_amount: u64,
        private source_of_wealth: field,
        private estimated_net_worth: u64,
        private owner: address,
        private secondary_owner: address,
    }

    record InvestmentExpInfo {
        private reference_id: field,
        private stocks: bool,
        private bonds: bool,
        private mutual_funds: bool, // These are investment vehicles that pool money from many investors to purchase a diversified portfolio of stocks, bonds, or other assets.
        private exchange_traded_funds: bool, // Similar to mutual funds, but they are traded on an exchange like individual stocks.
        private real_estate: bool,
        private commodities: bool,
        private cryptocurrencies: bool,
        private options_futures: bool, // Contracts that give the right, but not the obligation, to buy or sell an asset at a specific price before a certain date.
        private foreign_exchange: bool,
        private equity_venture_capital: bool, // Investments in companies or startups.
        private hedge_funds: bool, // Pooled investment funds that use a variety of strategies to earn returns for their investors.
        private money_market_funds: bool, // Mutual funds that invest in short-term, high-quality investments.
        private annuities: bool, // Financial products sold by insurance companies that provide a stream of income in the future.
        private owner: address,
        private secondary_owner: address,
    }

    record PepInfo {
        private reference_id: field,
        private political_association: bool,
        private association_declaration_1: field,
        private owner: address,
        private secondary_owner: address,
    }

    record RiskAssessmentInfo {
        private owner: address,
        private secondary_owner: address,
        private reference_id: field,
        private country_risk: u8,
        private country_reason_1: field,
        private employment_risk: u8,
        private employment_reason_1: field,
        private account_activity_risk: u8,
        private account_activity_amount: u64,
        private account_activity_frequency: field,
        private account_activity_reason_1: field,
    }

    record FinancialInstitution {
        private owner: address,
        private is_trusted: bool,
        id: field,
        private company_name_1: field,
        private company_type: field,
        private company_address_1: field,
        private company_address_2: field,
        private company_address_3: field,
        private company_state: field,
        private company_country: field,
        private email_address: field,
        private email_address_domain: field,
        private phone_country_code: u32,
        private phone_area_code: u32,
        private phone_number: u32,
    }

    // financial_instituitions maps financial institution's id to an address
    mapping financial_instituitions: field => address;

    // trusted_financial_instituitions maps financial institution's address to a boolean to represent it being a dao approved financial institution
    mapping trusted_financial_instituitions: address => bool;

    transition create_fi(
        id: field, 
        company_name_1: field, 
        company_type: field, 
        company_address_1: field, 
        company_address_2: field, 
        company_address_3: field, 
        company_state: field, 
        company_country: field, 
        email_address: field, 
        email_address_domain: field, 
        phone_country_code: u32, 
        phone_area_code: u32, 
        phone_number: u32
    ) -> FinancialInstitution {
        let new_fi: FinancialInstitution = FinancialInstitution {
            owner: self.caller,
            is_trusted: false,
            id: id,
            company_name_1: company_name_1,
            company_type: company_type,
            company_address_1: company_address_1,
            company_address_2: company_address_2,
            company_address_3: company_address_3,
            company_state: company_state,
            company_country: company_country,
            email_address: email_address,
            email_address_domain: email_address_domain,
            phone_country_code: phone_country_code,
            phone_area_code: phone_area_code,
            phone_number: phone_number,
        };

        return new_fi then finalize(self.caller, id);
    }

    finalize create_fi(owner: address, fi_id: field) {
        Mapping::set(financial_instituitions, fi_id, owner);
    }

    transition approve_fi(owner: address, id: field, company_name_1: field, company_type: field, company_address_1: field, company_address_2: field, company_address_3: field, company_state: field, company_country: field, email_address: field, email_address_domain: field, phone_country_code: u32, phone_area_code: u32, phone_number: u32) -> FinancialInstitution {
        // check that caller belongs to the DAO
        let new_fi: FinancialInstitution = FinancialInstitution {
            owner: owner,
            is_trusted: true,
            id: id,
            company_name_1: company_name_1,
            company_type: company_type,
            company_address_1: company_address_1,
            company_address_2: company_address_2,
            company_address_3: company_address_3,
            company_state: company_state,
            company_country: company_country,
            email_address: email_address,
            email_address_domain: email_address_domain,
            phone_country_code: phone_country_code,
            phone_area_code: phone_area_code,
            phone_number: phone_number,
        };

        return new_fi then finalize(self.caller, owner, id);
    }

    finalize approve_fi(daoMember: address, fi_owner: address, fi_id: field) {
        // checks that it is the DAO member
        assert(daoMember == aleo147pn9l4pmd5q6wfqk67werwdm5wa9y04ufk3kmyzmt2mcjpxqsrse9euhf);
        // checks that the FI exists
        assert(Mapping::get(financial_instituitions, fi_id) == fi_owner);

        Mapping::set(trusted_financial_instituitions, fi_owner, true);
    }

    transition create_personal_info(
        reference_id: field,
        first_name: field,
        middle_name: field,
        last_name: field,
        dob_day: u32,
        dob_month: u32,
        dob_year: u32,
        nationality: field,
        national_reference_id: field,
        created_at: field,
        secondary_owner: address,
        ) -> (PersonalInfo, PersonalInfo) {
        // fi owned kyc document
        let fi_personal_info: PersonalInfo = PersonalInfo {
            owner: self.caller,
            secondary_owner: secondary_owner,
            reference_id: reference_id,
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            dob_day: dob_day,
            dob_month: dob_month,
            dob_year: dob_year,
            nationality: nationality,
            national_reference_id: national_reference_id,
        };
        // customer owned kyc
        let customer_personal_info: PersonalInfo = PersonalInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            dob_day: dob_day,
            dob_month: dob_month,
            dob_year: dob_year,
            nationality: nationality,
            national_reference_id: national_reference_id,
        };

        return (fi_personal_info, customer_personal_info) then finalize(self.caller);
    }

    finalize create_personal_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    // Because there's no concept of an array. what we will have is a complete duplicate of the data
    transition post_share_personal_info(
        reference_id: field,
        first_name: field,
        middle_name: field,
        last_name: field,
        dob_day: u32,
        dob_month: u32,
        dob_year: u32,
        nationality: field,
        national_reference_id: field,
        fi_shared_to: address) -> PersonalInfo {
        // fi owned kyc document
        let new_fi_personal_info: PersonalInfo = PersonalInfo {
            owner: fi_shared_to,
            secondary_owner: self.caller,
            reference_id: reference_id,
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            dob_day: dob_day,
            dob_month: dob_month,
            dob_year: dob_year,
            nationality: nationality,
            national_reference_id: national_reference_id,
        };

        return new_fi_personal_info then finalize(fi_shared_to);
    }

    finalize post_share_personal_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_contact_info(
        reference_id: field,
        residential_address_1: field,
        residential_address_2: field,
        residential_address_3: field,
        residential_state: field,
        residential_country: field,
        email_address: field,
        email_address_domain: field,
        phone_country_code: u32,
        phone_area_code: u32,
        phone_number: u32,
        secondary_owner: address,
        ) -> (ContactInfo, ContactInfo) {
        // fi owned kyc document
        let fi_contact_info: ContactInfo = ContactInfo {
            owner: self.caller,
            reference_id: reference_id,
            residential_address_1: residential_address_1,
            residential_address_2: residential_address_2,
            residential_address_3: residential_address_3,
            residential_state: residential_state,
            residential_country: residential_country,
            email_address: email_address,
            email_address_domain: email_address_domain,
            phone_country_code: phone_country_code,
            phone_area_code: phone_area_code,
            phone_number: phone_number,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_contact_info: ContactInfo = ContactInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            residential_address_1: residential_address_1,
            residential_address_2: residential_address_2,
            residential_address_3: residential_address_3,
            residential_state: residential_state,
            residential_country: residential_country,
            email_address: email_address,
            email_address_domain: email_address_domain,
            phone_country_code: phone_country_code,
            phone_area_code: phone_area_code,
            phone_number: phone_number,
        };

        return (fi_contact_info, customer_contact_info) then finalize(self.caller);
    }

    finalize create_contact_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    // Because there's no concept of an array. what we will have is a complete duplicate of the data
    transition post_share_contact_info(
        reference_id: field,
        residential_address_1: field,
        residential_address_2: field,
        residential_address_3: field,
        residential_state: field,
        residential_country: field,
        email_address: field,
        email_address_domain: field,
        phone_country_code: u32,
        phone_area_code: u32,
        phone_number: u32,
        fi_shared_to: address) -> ContactInfo {
        // fi owned kyc document
        let new_fi_contact_info: ContactInfo = ContactInfo {
            owner: fi_shared_to,
            secondary_owner: self.caller,
            reference_id: reference_id,
            residential_address_1: residential_address_1,
            residential_address_2: residential_address_2,
            residential_address_3: residential_address_3,
            residential_state: residential_state,
            residential_country: residential_country,
            email_address: email_address,
            email_address_domain: email_address_domain,
            phone_country_code: phone_country_code,
            phone_area_code: phone_area_code,
            phone_number: phone_number,
        };

        return new_fi_contact_info then finalize(fi_shared_to);
    }

    finalize post_share_contact_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_employment_info(
        reference_id: field,
        occupation: field,
        employer_name_1: field,
        employer_company_type: field,
        employer_address_1: field,
        employer_address_2: field,
        employer_address_3: field,
        employer_state: field,
        employer_country: field,
        owner: address,
        secondary_owner: address,
        ) -> (EmploymentInfo, EmploymentInfo) {
        // fi owned kyc document
        let fi_employment_info: EmploymentInfo = EmploymentInfo {
            owner: self.caller,
            reference_id: reference_id,
            occupation: occupation,
            employer_name_1: employer_name_1,
            employer_company_type: employer_company_type,
            employer_address_1: employer_address_1,
            employer_address_2: employer_address_2,
            employer_address_3: employer_address_3,
            employer_state: employer_state,
            employer_country: employer_country,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_employment_info: EmploymentInfo = EmploymentInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            occupation: occupation,
            employer_name_1: employer_name_1,
            employer_company_type: employer_company_type,
            employer_address_1: employer_address_1,
            employer_address_2: employer_address_2,
            employer_address_3: employer_address_3,
            employer_state: employer_state,
            employer_country: employer_country,
        };

        return (fi_employment_info, customer_employment_info) then finalize(self.caller);
    }

    finalize create_employment_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    transition post_share_employment_info(
        reference_id: field,
        occupation: field,
        employer_name_1: field,
        employer_company_type: field,
        employer_address_1: field,
        employer_address_2: field,
        employer_address_3: field,
        employer_state: field,
        employer_country: field,
        fi_shared_to: address) -> EmploymentInfo {
        // fi owned kyc document
        let new_fi_employment_info: EmploymentInfo = EmploymentInfo {
            reference_id: reference_id,
            occupation: occupation,
            employer_name_1: employer_name_1,
            employer_company_type: employer_company_type,
            employer_address_1: employer_address_1,
            employer_address_2: employer_address_2,
            employer_address_3: employer_address_3,
            employer_state: employer_state,
            employer_country: employer_country,
            owner: fi_shared_to,
            secondary_owner: self.caller,
        };

        return new_fi_employment_info then finalize(fi_shared_to);
    }

    finalize post_share_employment_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_financial_info(
        reference_id: field,
        annual_income_amount: u64,
        source_of_income: field,
        funds_amount: u64,
        source_of_fund: field,
        wealth_amount: u64,
        source_of_wealth: field,
        estimated_net_worth: u64,
        owner: address,
        secondary_owner: address,
        ) -> (FinancialInfo, FinancialInfo) {
        // fi owned kyc document
        let fi_financial_info: FinancialInfo = FinancialInfo {
            owner: self.caller,
            reference_id: reference_id,
            annual_income_amount: annual_income_amount,
            source_of_income: source_of_income,
            funds_amount: funds_amount,
            source_of_fund: source_of_fund,
            wealth_amount: wealth_amount,
            source_of_wealth: source_of_wealth,
            estimated_net_worth: estimated_net_worth,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_financial_info: FinancialInfo = FinancialInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            annual_income_amount: annual_income_amount,
            source_of_income: source_of_income,
            funds_amount: funds_amount,
            source_of_fund: source_of_fund,
            wealth_amount: wealth_amount,
            source_of_wealth: source_of_wealth,
            estimated_net_worth: estimated_net_worth,
        };

        return (fi_financial_info, customer_financial_info) then finalize(self.caller);
    }

    finalize create_financial_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    transition post_share_financial_info(
        reference_id: field,
        annual_income_amount: u64,
        source_of_income: field,
        funds_amount: u64,
        source_of_fund: field,
        wealth_amount: u64,
        source_of_wealth: field,
        estimated_net_worth: u64,
        fi_shared_to: address) -> FinancialInfo {
        // fi owned kyc document
        let new_fi_financial_info: FinancialInfo = FinancialInfo {
            reference_id: reference_id,
            annual_income_amount: annual_income_amount,
            source_of_income: source_of_income,
            funds_amount: funds_amount,
            source_of_fund: source_of_fund,
            wealth_amount: wealth_amount,
            source_of_wealth: source_of_wealth,
            estimated_net_worth: estimated_net_worth,
            owner: fi_shared_to,
            secondary_owner: self.caller,
        };

        return new_fi_financial_info then finalize(fi_shared_to);
    }

    finalize post_share_financial_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_investment_exp_info(
        reference_id: field,
        stocks: bool,
        bonds: bool,
        mutual_funds: bool,
        exchange_traded_funds: bool,
        real_estate: bool,
        commodities: bool,
        cryptocurrencies: bool,
        options_futures: bool,
        foreign_exchange: bool,
        equity_venture_capital: bool,
        hedge_funds: bool,
        money_market_funds: bool,
        annuities: bool,
        owner: address,
        secondary_owner: address,
        ) -> (InvestmentExpInfo, InvestmentExpInfo) {
        // fi owned kyc document
        let fi_investment_exp_info: InvestmentExpInfo = InvestmentExpInfo {
            owner: self.caller,
            reference_id: reference_id,
            stocks: stocks,
            bonds: bonds,
            mutual_funds: mutual_funds,
            exchange_traded_funds: exchange_traded_funds,
            real_estate: real_estate,
            commodities: commodities,
            cryptocurrencies: cryptocurrencies,
            options_futures: options_futures,
            foreign_exchange: foreign_exchange,
            equity_venture_capital: equity_venture_capital,
            hedge_funds: hedge_funds,
            money_market_funds: money_market_funds,
            annuities: annuities,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_investment_exp_info: InvestmentExpInfo = InvestmentExpInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            stocks: stocks,
            bonds: bonds,
            mutual_funds: mutual_funds,
            exchange_traded_funds: exchange_traded_funds,
            real_estate: real_estate,
            commodities: commodities,
            cryptocurrencies: cryptocurrencies,
            options_futures: options_futures,
            foreign_exchange: foreign_exchange,
            equity_venture_capital: equity_venture_capital,
            hedge_funds: hedge_funds,
            money_market_funds: money_market_funds,
            annuities: annuities,
        };

        return (fi_investment_exp_info, customer_investment_exp_info) then finalize(self.caller);
    }

    finalize create_investment_exp_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    transition post_share_investment_exp_info(
        reference_id: field,
        stocks: bool,
        bonds: bool,
        mutual_funds: bool,
        exchange_traded_funds: bool,
        real_estate: bool,
        commodities: bool,
        cryptocurrencies: bool,
        options_futures: bool,
        foreign_exchange: bool,
        equity_venture_capital: bool,
        hedge_funds: bool,
        money_market_funds: bool,
        annuities: bool,
        fi_shared_to: address) -> InvestmentExpInfo {
        // fi owned kyc document
        let new_fi_investment_exp_info: InvestmentExpInfo = InvestmentExpInfo {
            reference_id: reference_id,
            stocks: stocks,
            bonds: bonds,
            mutual_funds: mutual_funds,
            exchange_traded_funds: exchange_traded_funds,
            real_estate: real_estate,
            commodities: commodities,
            cryptocurrencies: cryptocurrencies,
            options_futures: options_futures,
            foreign_exchange: foreign_exchange,
            equity_venture_capital: equity_venture_capital,
            hedge_funds: hedge_funds,
            money_market_funds: money_market_funds,
            annuities: annuities,
            owner: fi_shared_to,
            secondary_owner: self.caller,
        };

        return new_fi_investment_exp_info then finalize(fi_shared_to);
    }

    finalize post_share_investment_exp_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_pep_info(
        reference_id: field,
        political_association: bool,
        association_declaration_1: field,
        owner: address,
        secondary_owner: address,
        ) -> (PepInfo, PepInfo) {
        // fi owned kyc document
        let fi_pep_info: PepInfo = PepInfo {
            owner: self.caller,
            reference_id: reference_id,
            political_association: political_association,
            association_declaration_1: association_declaration_1,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_pep_info: PepInfo = PepInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            political_association: political_association,
            association_declaration_1: association_declaration_1,
        };

        return (fi_pep_info, customer_pep_info) then finalize(self.caller);
    }

    finalize create_pep_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    transition post_share_pep_info(
        reference_id: field,
        political_association: bool,
        association_declaration_1: field,
        fi_shared_to: address) -> PepInfo {
        // fi owned kyc document
        let new_fi_pep_info: PepInfo = PepInfo {
            reference_id: reference_id,
            political_association: political_association,
            association_declaration_1: association_declaration_1,
            owner: fi_shared_to,
            secondary_owner: self.caller,
        };

        return new_fi_pep_info then finalize(fi_shared_to);
    }

    finalize post_share_pep_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }

    transition create_risk_assessment_info(
        reference_id: field,
        country_risk: u8,
        country_reason_1: field,
        employment_risk: u8,
        employment_reason_1: field,
        account_activity_risk: u8,
        account_activity_amount: u64,
        account_activity_frequency: field,
        account_activity_reason_1: field,
        owner: address,
        secondary_owner: address,
        ) -> (RiskAssessmentInfo, RiskAssessmentInfo) {
        // fi owned kyc document
        let fi_risk_assessment_info: RiskAssessmentInfo = RiskAssessmentInfo {
            owner: self.caller,
            reference_id: reference_id,
            country_risk: country_risk,
            country_reason_1: country_reason_1,
            employment_risk: employment_risk,
            employment_reason_1: employment_reason_1,
            account_activity_risk: account_activity_risk,
            account_activity_amount: account_activity_amount,
            account_activity_frequency: account_activity_frequency,
            account_activity_reason_1: account_activity_reason_1,
            secondary_owner: secondary_owner,
        };
        // customer owned kyc
        let customer_risk_assessment_info: RiskAssessmentInfo = RiskAssessmentInfo {
            owner: secondary_owner,
            secondary_owner: self.caller,
            reference_id: reference_id,
            country_risk: country_risk,
            country_reason_1: country_reason_1,
            employment_risk: employment_risk,
            employment_reason_1: employment_reason_1,
            account_activity_risk: account_activity_risk,
            account_activity_amount: account_activity_amount,
            account_activity_frequency: account_activity_frequency,
            account_activity_reason_1: account_activity_reason_1,
        };

        return (fi_risk_assessment_info, customer_risk_assessment_info) then finalize(self.caller);
    }

    finalize create_risk_assessment_info(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    transition post_share_risk_assessment_info(
        reference_id: field,
        country_risk: u8,
        country_reason_1: field,
        employment_risk: u8,
        employment_reason_1: field,
        account_activity_risk: u8,
        account_activity_amount: u64,
        account_activity_frequency: field,
        account_activity_reason_1: field,
        fi_shared_to: address) -> RiskAssessmentInfo {
        // fi owned kyc document
        let new_fi_risk_assessment_info: RiskAssessmentInfo = RiskAssessmentInfo {
            reference_id: reference_id,
            country_risk: country_risk,
            country_reason_1: country_reason_1,
            employment_risk: employment_risk,
            employment_reason_1: employment_reason_1,
            account_activity_risk: account_activity_risk,
            account_activity_amount: account_activity_amount,
            account_activity_frequency: account_activity_frequency,
            account_activity_reason_1: account_activity_reason_1,
            owner: fi_shared_to,
            secondary_owner: self.caller,
        };

        return new_fi_risk_assessment_info then finalize(fi_shared_to);
    }

    finalize post_share_risk_assessment_info(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }
}
