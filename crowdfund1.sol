contract CrowdFund {

    mapping (address => uint256) funders;
    uint goal;
    uint public deadline;
    address beneficiary;
    bool locked;

    function CrowdFund(address _beneficiary, uint _goal, uint _timelimit) {
        beneficiary = _beneficiary;
        goal = _goal;
        deadline = now + _timelimit;
    }
    
    function fund() {
        if (now > deadline) throw;
        funders[msg.sender] += msg.value;
    }
    
    function collect() {
        if (now > deadline && this.balance >= goal) {
            beneficiary.send(this.balance);
        }
    }
    
    function refund() {
        if (now > deadline && this.balance < goal) {
            uint val = funders[msg.sender];
            funders[msg.sender] = 0;
            msg.sender.send(val);
        }
    }
}
