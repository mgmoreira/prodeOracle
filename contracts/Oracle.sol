pragma solidity ^0.8.4;
// SPDX-License-Identifier: UNLICENSED
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable{
    struct Result {
        uint8 firstMatchLocal;
        uint8 firstMatchVisitor;
        uint8 secondMatchLocal;
        uint8 secondMatchVisitor;
        uint8 penaltyMatchLocal;
        uint8 penaltyMatchVisitor;
    }

    Result[] results;

    constructor() {
    }

    struct Match {
        uint8[] score;
    }
    struct ResultArray {
        Match[] matches;
    }

    //Opcion 1 de carga
    //Example
    //[{matches:[{score:[1,2]}, {score:[1,2]}, {score:[4,5]}]}]
    function setResultArray(ResultArray[] memory _results) public onlyOwner{
        uint8 penaltyLocal;
        uint8 penaltyVisitor;

        for(uint counter; counter < _results.length;){
            require(_results[counter].matches.length == 2 || _results[counter].matches.length == 3, "Wrong number of matches");
            penaltyLocal = 0;
            penaltyVisitor = 0;
            if(_results[counter].matches.length == 3){
                penaltyLocal = _results[counter].matches[2].score[0];
                penaltyVisitor = _results[counter].matches[2].score[1];
                require(penaltyLocal != penaltyVisitor, "Wrong penalty result.");
            }
            results.push(Result(_results[counter].matches[0].score[0],
                                _results[counter].matches[0].score[1],
                                _results[counter].matches[1].score[0],
                                _results[counter].matches[1].score[1],
                                penaltyLocal,
                                penaltyVisitor)
            );
            unchecked{ counter++; }
        }
    }

    //Opcion 2 de carga
    //Example
    //[{firstMatchLocal: 1, firstMatchVisitor: 2, secondMatchLocal: 2, secondMatchVisitor: 4, penaltyMatchLocal:0, penaltyMatchVisitor:0}]
    function setResult(Result[] memory _results) public onlyOwner{
        for(uint counter; counter < _results.length;){
            console.log("Enfrentamiento %d PRIMER partido: %d - %d ", counter+1,
                                                    _results[counter].firstMatchLocal,
                                                    _results[counter].firstMatchVisitor
                                                    );
            console.log("Enfrentamiento %d SEGUNDO partido: %d - %d ", counter+1,
                                                    _results[counter].secondMatchLocal,
                                                    _results[counter].secondMatchVisitor
            );
            console.log("Counter %d", counter);
            results.push(Result(_results[counter].firstMatchLocal,
                                _results[counter].firstMatchVisitor,
                                _results[counter].secondMatchLocal,
                                _results[counter].secondMatchVisitor,
                                _results[counter].penaltyMatchLocal,
                                _results[counter].penaltyMatchVisitor));
            unchecked{ counter++; }
        }
    }

    function getResult() public view returns(bool[] memory) {
        bool[] memory booleanResults = new bool[](results.length);
        for(uint counter; counter < results.length;){
            booleanResults[counter] = getIndividualResult(results[counter]);
            unchecked{ counter++; }
        }
        return booleanResults;
    }

    function getIndividualResult(Result memory result) private pure returns(bool flag){
        uint8 firstTeamScore = result.firstMatchLocal + result.secondMatchVisitor;
        uint8 secondTeamScore = result.secondMatchLocal + result.firstMatchVisitor;
        if(firstTeamScore > secondTeamScore){
            return true;
        }else{
            if(firstTeamScore < secondTeamScore){
                return false;
            }else{
                if(result.penaltyMatchLocal > result.penaltyMatchVisitor){
                    return false;
                }else{
                    return true;
                }
            }
        }
    }

}
