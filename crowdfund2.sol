contract CrowdFund {

    struct Funder {
        address addr;
        uint value;
    }
    Funder[] funders;
    uint goal;
    uint public deadline;
    address beneficiary;
    uint refundIndex;
    bool locked;

    function CrowdFund(address _beneficiary, uint _goal, uint _timelimit) {
        beneficiary = _beneficiary;
        goal = _goal;
        deadline = now + _timelimit;
    }
    
    function fund() {
        if (now > deadline) throw;
        funders.push(Funder(msg.sender, msg.value));
    }
    
    function collect() {
        if (now > deadline && this.balance >= goal) {
            beneficiary.send(this.balance);
        }
    }
    
    function refund() {
        if (now > deadline && this.balance < goal) {
            uint i = refundIndex;
            while (i < funders.length && msg.gas > 200000) {
                funders[i].addr.send(funders[i].value);
                i++;
            }
            refundIndex = i;
        }
    }
}
