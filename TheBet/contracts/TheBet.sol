// SPDX-License-Identifier: GPL-3.0

/**

    */

pragma solidity >=0.8.12 <0.9.0;

contract TheBet {
    string public Current_Bet =
        "O dolar vai estar acima de 5 reais em julho/2022?";
    address private owner;
    uint256 five_dollar = 5;
    address[] totalVotes;
    address[] winnersVotes;
    uint256 public cumulativeAward;

    struct Vote {
        address Addres;
        bool Value;
        string NameBet;
        bool HasVote;
    }

    mapping(address => Vote) listVotes;

    constructor() {
        owner = msg.sender;
    }

    modifier validateBalance() {
        require(
            msg.value >= .01 ether,
            "Insuficient balance to bet, the minim vaue is 1 ether!"
        );
        _;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner of the contract can create Bet!"
        );
        _;
    }
    modifier hasVote() {
        require(
            listVotes[msg.sender].HasVote == false,
            "You can vote only once!"
        );
        _;
    }

    event moneySent(address _from, address _to, uint256 _amount);
    event log(string valor, uint256 valorUint, bool result);

    function vote(bool _vote) external payable validateBalance hasVote {
        Vote storage vote = listVotes[msg.sender];
        vote.Value = _vote;
        vote.HasVote = true;

        listVotes[msg.sender].Value = _vote;

        totalVotes.push(msg.sender);

        cumulativeAward++;

        payable(address(this)).transfer(msg.value);
    }

    fallback() external payable {}

    function endVoteAndPay(uint256 dollar) public payable onlyOwner {
        if (dollar > five_dollar) {
            for (uint256 i = 0; i < totalVotes.length; i++) {
                if (listVotes[totalVotes[i]].Value == true) {
                    winnersVotes.push(totalVotes[i]);
                }
            }

            (bool result, uint256 totalAward) = tryDiv(
                address(this).balance,
                winnersVotes.length
            );

            if (result) {
                for (uint256 i = 0; i < winnersVotes.length; i++) {
                    emit moneySent(owner, winnersVotes[i], totalAward);
                    payable(winnersVotes[i]).transfer(
                        address(this).balance / winnersVotes.length
                    );
                }
            }
        }
    }

    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
}
