// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/// @title ERC20 Contract
import "./Sponsors.sol";
import "../utils/StructSerialization.sol";

contract Agents is Sponsors {
        constructor(){
    }

    /// @notice insert sponsors Agent
    /// @param _patreonKey public Sponsor Coin Account Key
    /// @param _sponsorKey public account key to get sponsor array
    /// @param _agentKey new sponsor to add to account list
    function addSponsorAgent(address _patreonKey, address _sponsorKey, address _agentKey)
            public onlyOwnerOrRootAdmin(msg.sender) 
            nonRedundantAgent ( _patreonKey, _sponsorKey, _agentKey) {
        addPatreonSponsor(_patreonKey, _sponsorKey);
        addAccountRecord(_agentKey);

        AccountStruct storage accountSponsorRec = accountMap[_sponsorKey];
        AccountStruct storage accountAgentRec = accountMap[_agentKey];
        SponsorStruct storage patreonSponsorRec = getPatreonSponsorRecByKeys(_patreonKey, _sponsorKey);
        AgentStruct storage  sponsorChildAgentRec = getAgentRecordByKeys(_patreonKey, _sponsorKey, _agentKey);
        if (!sponsorChildAgentRec.inserted) {
            sponsorChildAgentRec.index = patreonSponsorRec.accountAgentKeys.length;
            sponsorChildAgentRec.insertionTime = block.timestamp;
            sponsorChildAgentRec.agentAccountKey    = _agentKey;
            sponsorChildAgentRec.inserted = true;
            patreonSponsorRec.accountAgentKeys.push(_agentKey);
            accountSponsorRec.accountAgentKeys.push(_agentKey);
            accountAgentRec.accountAgentSponsorKeys.push(_agentKey);
        }
    }

    /// @notice determines if agent address is inserted in account.sponsor.agent.map
    /// @param _patreonKey public account key validate Insertion
    /// @param _sponsorKey public sponsor account key validate Insertion
    /// @param _agentKey public agent account key validate Insertion
    function isAgentInserted(address _patreonKey,address _sponsorKey,address _agentKey) public onlyOwnerOrRootAdmin(_patreonKey) view returns (bool) {
        if (getAgentRecordByKeys(_patreonKey, _sponsorKey, _agentKey).inserted)
            return true;
        else
            return false;
    }

    function getAgentIndex(address _patreonKey, address _sponsorKey, address _agentKey) public onlyOwnerOrRootAdmin(_patreonKey) view returns (uint) {
        if (isAgentInserted(_patreonKey, _sponsorKey, _agentKey)) {
            //uint256 agentIndex = accountMap[_patreonKey].sponsorMap[_sponsorKey].agentMap[_agentKey].index;
            // console.log(_patreonKey, _sponsorKey, _agentKey);
            // console.log("Index = ", agentIndex);
            return accountMap[_patreonKey].sponsorMap[_sponsorKey].agentMap[_agentKey].index;
        }
        else
            return 0;
        }

    function getAgentInsertionTime(address _patreonKey, address _sponsorKey, address _agentKey) public onlyOwnerOrRootAdmin(_patreonKey) view returns (uint) {
        if (isAgentInserted(_patreonKey, _sponsorKey, _agentKey))
            return accountMap[_patreonKey].sponsorMap[_sponsorKey].agentMap[_agentKey].insertionTime;
        else
            return 0;
    }

    function getAgentRecordByKeys(address _patreonKey, address _sponsorKey, address _agentKey) internal view onlyOwnerOrRootAdmin(_patreonKey) returns (AgentStruct storage) {
        SponsorStruct storage sponsorRec = getPatreonSponsorRecByKeys(_patreonKey, _sponsorKey);
        AgentStruct storage sponsorChildAgentRec = sponsorRec.agentMap[_agentKey];
        return sponsorChildAgentRec;
     }

    /// @notice get address for an account sponsor
    /// @param _sponsorKey public account key to get agent array
    /// @param _agentIdx new agent to add to account list
    function getSponsorAgentKeyAddress(address _patreonKey, address _sponsorKey, uint _agentIdx ) public view onlyOwnerOrRootAdmin(msg.sender) returns (address) {
        address[] memory agentList = getAgentList(_patreonKey, _sponsorKey);
        address agentAddress = agentList[_agentIdx];
        return agentAddress;
    }

    /// @notice retreives the sponsor array record size a specific address.
    /// @param _sponsorKey public account key to get Sponsor Record Length
    function getSponsorAgentSize(address _patreonKey, address _sponsorKey) public view onlyOwnerOrRootAdmin(_sponsorKey) returns (uint) {
        return getAgentList(_patreonKey, _sponsorKey).length;
    }

    /// @notice retreives the sponsor array records from a specific account address.
    /// @param _sponsorKey public account key to get Sponsors
    function getAgentList(address _patreonKey, address _sponsorKey) internal view onlyOwnerOrRootAdmin(_sponsorKey) returns (address[] memory) {
        SponsorStruct storage sponsorRec = getPatreonSponsorRecByKeys(_patreonKey, _sponsorKey);
        address[] memory accountAgentKeys = sponsorRec.accountAgentKeys;
        return accountAgentKeys;
    }
}
