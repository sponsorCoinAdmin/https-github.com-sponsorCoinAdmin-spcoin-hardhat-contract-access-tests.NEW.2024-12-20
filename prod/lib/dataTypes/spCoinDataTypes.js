let burnAddress = "0x0000000000000000000000000000000000000000";

class AccountStruct {
  // Initialize values to maintain output display order

  constructor() {
    this.TYPE = "--ACCOUNT--";
    this.accountKey = 0;
    this.balanceOf = 0;
    this.stakedSPCoins = 0;
    this.creationTime = 0;
    this.verified = false;
    this.sponsorAccountList = 0;
    this.recipientAccountList = 0;
    this.agentAccountList = 0;
    this.agentsParentRecipientAccountList = 0;
    this.recipientRecordList = 0;
    this.totalStakingRewards = 0;
    this.stakingRewardList = 0;
  }
}

class RecipientStruct {
  constructor() {
    this.TYPE = "--RECIPIENT_RECORD--";
    this.recipientKey;
    this.creationTime;
    this.stakedSPCoins;
    this.verified;
    this.recipientRateRecordList;
  }
}

class RecipientRateStruct {
  constructor() {
    this.TYPE = "--RECIPIENT_RATE--";
    this.recipientRate;
    this.creationTime;
    this.lastUpdateTime;
    this.stakedSPCoins;
    this.transactions;
    this.agentAccountList;
    this.agentRecordList;
  }
}

class AgentStruct {
  constructor() {
    this.TYPE = "--AGENT_RECORD--";
    this.agentKey;
    this.stakedSPCoins;
    this.creationTime;
    this.verified;
    this.agentRateList;
  }
}

class AgentRateStruct {
  constructor() {
    this.TYPE = "--AGENT_RATE--";
    this.agentRate;
    this.stakedSPCoins;
    this.creationTime;
    this.lastUpdateTime;
    this.transactions;
  }
}

class StakingTransactionStruct {
  constructor() {
    this.TYPE = "--STAKING TRANSACTION RECORD--";
    this.insertionTime;
    this.location;
    this.quantity;
  }
}

/// STAKING REWARDS SECTION ////////////////////////////////////////////////////////////////////

class RewardsStruct {
  constructor() {
    this.TYPE = "--REWARDS STRUCTURE--";
    this.sponsorRewardsList;
    this.recipientRewardsList;
    this.agentRewardsList;
  }
}

class RewardTypeStruct {
  constructor() {
    this.TYPE;
    this.stakingRewards;
    this.rewardAccountList;
  }
}

class RewardAccountStruct {
  constructor() {
    this.TYPE = "--REWARD ACCOUNT--";
    this.sourceKey;
    this.stakingRewards;
    this.rateList;
  }
}

class RewardRateStruct {
  constructor() {
    this.TYPE = "--REWARD RATE--";
    this.rate;
    this.stakingRewards;
    this.rewardTransactionList;
  }
}

class RewardTransactionStruct {
  constructor() {
    this.TYPE = "--REWARD TRANSACTION--";
    this.updateTime;
    this.stakingRewards;
  }
}

module.exports = {
  RewardAccountStruct,
  AccountStruct,
  AgentRateStruct,
  AgentStruct,
  RewardRateStruct,
  RecipientStruct,
  RecipientRateStruct,
  RewardsStruct,
  RewardTransactionStruct,
  RewardTypeStruct,
  StakingTransactionStruct,
};
