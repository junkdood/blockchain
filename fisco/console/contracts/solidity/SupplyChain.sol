pragma solidity >=0.4.22 <0.7.0;

contract SupplyChain{  

    struct company{  

        string name;  

        address adr;  

    }  

      

    struct receipt{  

        address come;  

        address to;  

        uint amount;  

    }  

      

    receipt[] public receipts;  

    company[] public companies;  

    mapping(address=>uint) debt;  

      

    constructor(){  

          

    }  

      

    function Transaction(address receive,uint amount,bool is_bank){  

        if(is_bank){  

            GetDebt();  

            if(debt[msg.sender]<0){  

                return;  

            }  

        }  

        receipt memory r;  

        r.come = msg.sender;  

        r.to = receive;  

        r.amount = amount;  

        receipts.push(r);  

    }  

      

    function Transfer(address adr){  

        address adr1 = msg.sender;  

        address adr2 = adr;  

        for(uint i=0;i<receipts.length;i++){  

            if(receipts[i].come==adr1){  

                address adr3 = receipts[i].to;  

                for(uint j=0;j<receipts.length;j++){  

                    if(receipts[j].come==adr3 && receipts[j].to==adr2){  

                        receipts[i].amount -= receipts[j].amount;  

                        receipt memory r;  

                        r.come = adr1;  

                        r.to = adr2;  

                        r.amount = receipts[j].amount;  

                        receipts.push(r);  

                    }  

                }  

            }  

        }  

    }  

      

    function GetDebt(){  

        uint sum = 0;  

        for(uint i=0;i<receipts.length;i++){  

            if(receipts[i].come==msg.sender){  

                sum -= receipts[i].amount;  

            }  

            else if(receipts[i].to==msg.sender){  

                sum += receipts[i].amount;  

            }  

        }  

        debt[msg.sender] = sum;  

    }  

      

    function PayDebt(address receive, uint amount){  

        for(uint i=0;i<receipts.length;i++){  

            if(receipts[i].come==msg.sender && receipts[i].to==receive){  

                if(receipts[i].amount-amount>0){  

                    receipts[i].amount-=amount;  

                    break;  

                }  

                else if(receipts[i].amount-amount==0){  

                    for(uint j=i;j<receipts.length-1;j++){  

                        receipts[j].come = receipts[j+1].come;  

                        receipts[j].to = receipts[j+1].to;  

                        receipts[j].amount = receipts[j+1].amount;  

                    }  

                }  

                else return;  

            }  

        }  

    }  
}  

