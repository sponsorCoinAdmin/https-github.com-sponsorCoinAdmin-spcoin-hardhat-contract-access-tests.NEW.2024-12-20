// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
/// @title ERC20 Contract
import "../accounts/UnSubscribe.sol";
import "../accounts/Transactions.sol";

contract StakingManager is UnSubscribe{
    constructor(){
    }

//////////////// INSERT STAKING REWARDS /////////////////////////////////////////////////////////////////////

    function depositAgentStakingRewards(address _bennificaryAccount, address _agentAccount, uint _rate, uint _amount )
        public returns ( uint ) {
        require (_amount > 0, "AMOUNT BALANCE MUST BE LARGER THAN 0");
        // string memory errMsg = concat("BENNIFICARY ACCOUNT ",  toString(_bennificaryAccount), " NOT FOUND FOR AGENT ACCOUNT ",  toString(_agentAccount));
        // require (agentHasBennificary( _bennificaryAccount, _agentAccount ), errMsg);
        // console.log("SOL=>1 depositRecipientStakingRewards("); 
        // console.log("SOL=>2 _bennificaryAccount    = ", _bennificaryAccount);
        // console.log("SOL=>3 _agentAccount = ", _agentAccount);
        // console.log("SOL=> _rate             = ", _rate);
        // console.log("SOL=> _amount           = ", _amount, ")" );
        totalSupply += _amount;

        // console.log("SOL=>4 FETCHING agentAccount = accountMap[", _agentAccount, "]");
        AccountStruct storage agentAccount = accountMap[_agentAccount];
        // console.log("agentAccount.bennificaryAccountList.length =", agentAccount.bennificaryAccountList.length);
        // console.log("agentAccount.bennificaryAccountList[0] =", agentAccount.bennificaryAccountList[0]);

        RewardsStruct storage rewards = agentAccount.rewardsMap["RECIPIENT"];
        rewards.totalStakingRewards += _amount;
        rewards.totalRecipientRewards += _amount;
        mapping(address => RewardAccountStruct) storage agentRewardsMap = rewards.agentRewardsMap;


        RewardAccountStruct storage agentAccountRecord = agentRewardsMap[_bennificaryAccount];
        agentAccountRecord.stakingRewards += _amount;

        uint256[] storage rewardRateList = agentAccountRecord.rewardRateList;
        RewardRateStruct storage rewardRateRecord = agentAccountRecord.rewardRateMap[_rate];
        if (rewardRateRecord.rate != _rate) {
            rewardRateList.push(_rate);
            rewardRateRecord.rate = _rate;
        }
        rewardRateRecord.stakingRewards += _amount;
        RewardsTransactionStruct[] storage rewardTransactionList = rewardRateRecord.rewardTransactionList;
        depositRewardTransaction( rewardTransactionList, _amount );
        return agentAccountRecord.stakingRewards;
    }

    function depositRecipientStakingRewards(address _sponsorAccount, address _recipientAccount, uint _rate, uint _amount )
        public returns ( uint ) {
        require (_amount > 0, "AMOUNT BALANCE MUST BE LARGER THAN 0");
        string memory errMsg = concat("SPONSOR ACCOUNT ",  toString(_sponsorAccount), " NOT FOUND FOR RECIPIENT ACCOUNT ",  toString(_recipientAccount));
        require (recipientHasSponsor( _sponsorAccount, _recipientAccount ), errMsg);
        // console.log("SOL=>1 depositRecipientStakingRewards("); 
        // console.log("SOL=>2 _sponsorAccount    = ", _sponsorAccount);
        // console.log("SOL=>3 _recipientAccount = ", _recipientAccount);
        // console.log("SOL=> _rate             = ", _rate);
        // console.log("SOL=> _amount           = ", _amount, ")" );
        totalSupply += _amount;

        // console.log("SOL=>4 FETCHING recipientAccount = accountMap[", _recipientAccount, "]");
        AccountStruct storage recipientAccount = accountMap[_recipientAccount];
        // console.log("recipientAccount.sponsorAccountList.length =", recipientAccount.sponsorAccountList.length);
        // console.log("recipientAccount.sponsorAccountList[0] =", recipientAccount.sponsorAccountList[0]);

        RewardsStruct storage rewards = recipientAccount.rewardsMap["RECIPIENT"];
        rewards.totalStakingRewards += _amount;
        rewards.totalRecipientRewards += _amount;
        mapping(address => RewardAccountStruct) storage recipientRewardstMap = rewards.recipientRewardstMap;


        RewardAccountStruct storage recipientAccountRecord = recipientRewardstMap[_sponsorAccount];
        recipientAccountRecord.stakingRewards += _amount;

        uint256[] storage rewardRateList = recipientAccountRecord.rewardRateList;
        RewardRateStruct storage rewardRateRecord = recipientAccountRecord.rewardRateMap[_rate];
        if (rewardRateRecord.rate != _rate) {
            rewardRateList.push(_rate);
            rewardRateRecord.rate = _rate;
        }
        rewardRateRecord.stakingRewards += _amount;
        
        RewardsTransactionStruct[] storage rewardTransactionList = rewardRateRecord.rewardTransactionList;

        depositRewardTransaction( rewardTransactionList, _amount );

        return recipientAccountRecord.stakingRewards;
    }

    function depositRewardTransaction(  RewardsTransactionStruct[] storage rewardTransactionList,
                                        uint _amount )  internal {
        // console.log("SOL=>9 depositRewardTransaction("); 
        // console.log("SOL=>10 stakingAccountRecord.stakingRewards = ", stakingAccountRecord.stakingRewards);
        // console.log("SOL=>12               _amount               = ", _amount, ")" );
        // console.log("SOL=>13 BEFORE rewardTransactionList.length = ", rewardTransactionList.length);

        RewardsTransactionStruct memory  rewardsTransactionRecord;
        rewardsTransactionRecord.stakingRewards = _amount;
        rewardsTransactionRecord.updateTime = block.timestamp;
        rewardTransactionList.push(rewardsTransactionRecord);
        // console.log("SOL=>14 AFTER rewardTransactionList.length = ", rewardTransactionList.length);
    }

//////////////// RETREIVE STAKING REWARDS /////////////////////////////////////////////////////////////////////
    function getAgentRewardAccounts(address _accountKey)
        public view returns (string memory memoryRewards) {
        // console.log("SOL=>15 getRecipientRewardAccounts(", _accountKey, ")");
        
            AccountStruct storage sponsorAccount = accountMap[_accountKey];
            address[] storage sponsorAccountList = sponsorAccount.sponsorAccountList;
            memoryRewards = "";

            // console.log("SOL=>16 sponsorAccountList.length = ", sponsorAccountList.length);
            // Check the Agents's Benificary List
            for (uint sponsorIdx = 0; sponsorIdx < sponsorAccountList.length; sponsorIdx++) {
                address sponsorKey = sponsorAccountList[sponsorIdx];
                memoryRewards = concat(memoryRewards, "SPONSOR_ACCOUNT:", toString(sponsorKey));

            ///////////////// **** START REPLACE LATER **** ///////////////////////////

            RewardsStruct storage rewards = sponsorAccount.rewardsMap["RECIPIENT"];
            mapping(address => RewardAccountStruct) storage recipientRewardstMap = rewards.recipientRewardstMap;
            
            ///////////////// **** END REPLACE LATER **** ///////////////////////////

            // console.log("SOL=>17 sponsorKey[", sponsorIdx,"] = ", sponsorAccountList[sponsorIdx]);
            RewardAccountStruct storage recipientAccountRecord = recipientRewardstMap[sponsorKey];
            memoryRewards = concat(memoryRewards, getRewardRateRecords(recipientAccountRecord));
        }
    }
        
    function getRecipientRewardAccounts(address _sponsorKey)
        public view returns (string memory memoryRewards) {
        // console.log("SOL=>15 getRecipientRewardAccounts(", _sponsorKey, ")");
        
            AccountStruct storage sponsorAccount = accountMap[_sponsorKey];
            address[] storage sponsorAccountList = sponsorAccount.sponsorAccountList;
            memoryRewards = "";

            // console.log("SOL=>16 sponsorAccountList.length = ", sponsorAccountList.length);
            // Check the Recipient's Sponsor List
            for (uint sponsorIdx = 0; sponsorIdx < sponsorAccountList.length; sponsorIdx++) {
                address sponsorKey = sponsorAccountList[sponsorIdx];
                memoryRewards = concat(memoryRewards, "SPONSOR_ACCOUNT:", toString(sponsorKey));

            ///////////////// **** START REPLACE LATER **** ///////////////////////////

            RewardsStruct storage rewards = sponsorAccount.rewardsMap["RECIPIENT"];
            mapping(address => RewardAccountStruct) storage recipientRewardstMap = rewards.recipientRewardstMap;
            
            ///////////////// **** END REPLACE LATER **** ///////////////////////////

            // console.log("SOL=>17 sponsorKey[", sponsorIdx,"] = ", sponsorAccountList[sponsorIdx]);
            RewardAccountStruct storage recipientAccountRecord = recipientRewardstMap[sponsorKey];
            memoryRewards = concat(memoryRewards, getRewardRateRecords(recipientAccountRecord));
        }
        
// console.log("SOL=>3 RETURNING MEMORY REWARDS =", memoryRewards);
        return memoryRewards;
    }

    // NEW STUFF
        function getRewardRateRecords(RewardAccountStruct storage _recipientAccountRecord)
        internal  view returns (string memory memoryRewards) {
        
        uint256[] storage rewardRateList = _recipientAccountRecord.rewardRateList;
// console.log("SOL=>17 BEFORE memoryRewards", memoryRewards);

        for (uint rateIdx = 0; rateIdx < rewardRateList.length; rateIdx++) {
            uint rate = rewardRateList[rateIdx];
// console.log("SOL=>18 rate", rate);

            RewardRateStruct storage rewardRateRecord = _recipientAccountRecord.rewardRateMap[rate];
            RewardsTransactionStruct[] storage rewardTransactionList = rewardRateRecord.rewardTransactionList;

            memoryRewards = concat(memoryRewards, ",", toString(_recipientAccountRecord.stakingRewards));
                // console.log("SOL=> _recipientAccountRecord.rewardTransactionList.length         = ", _recipientAccountRecord.rewardTransactionList.length);
                // console.log("SOL=> _recipientAccountRecord.rewardTransactionList.stakingRewards = ", _recipientAccountRecord.stakingRewards);
            memoryRewards = concat(memoryRewards, "\nRATE:", toString(rate));
            memoryRewards = concat(memoryRewards, ",", toString(rewardRateRecord.stakingRewards));

        // console.log("SOL=>19 rewardTransactionList.length", rewardTransactionList.length);
            if (rewardTransactionList.length != 0) {
                string memory stringRewards = serializeRewardsTransactionList(rewardTransactionList);
        // console.log("SOL=>20 stringRewards", stringRewards);
                memoryRewards = concat(memoryRewards, "\n" , stringRewards);
            }
        }
        // console.log("SOL=>21 AFTER memoryRewards", memoryRewards);
        // console.log("*** END SOL ******************************************************************************");
        return memoryRewards;
    }

    function serializeRewardsTransactionList(RewardsTransactionStruct[] storage _rewardTransactionList)
        internal  view returns (string memory memoryRewards) {
        for (uint idx = 0; idx < _rewardTransactionList.length; idx++) {
            RewardsTransactionStruct storage rewardTransaction = _rewardTransactionList[idx];
            // console.log("SOL6=> rewardTransaction.updateTime     = ", rewardTransaction.updateTime);
            // console.log("SOL7=> rewardTransaction.stakingRewards = ", rewardTransaction.stakingRewards);

            memoryRewards = concat(memoryRewards, toString(rewardTransaction.updateTime));
            memoryRewards = concat(memoryRewards, ",", toString(rewardTransaction.stakingRewards));
            if (idx < _rewardTransactionList.length - 1) {
                memoryRewards = concat(memoryRewards , "\n" );
            }
           // console.log("SOL=>21 getRecipientRewardAccounts:Transaction =", memoryRewards);
           // console.log("rewardsRecordList", memoryRewards);
           // console.log("*** END SOL ******************************************************************************");
        }
        return memoryRewards;
    }

    function getSerializedAccountRewards(address _accountKey)
        public view returns (string memory) {
        require(isAccountInserted(_accountKey));
        return serializeRewards(accountMap[_accountKey]);
    }
}