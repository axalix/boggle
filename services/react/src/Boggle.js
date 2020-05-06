import React from 'react';

import './Boggle.css';
import Board from "./components/Board";
import FoundWordsList from "./components/FoundWordsList";
import Timer from "./components/Timer";
import AddWord from "./components/AddWord";
import WorkflowButton from "./components/WorkflowButton";
import ResultFoundWordsList from "./components/ResultFoundWordsList";


function string_to_board(str, size)
{
  str = str.split('');
  const result = [];
  while(str.length) {
    result.push(str.splice(0, size));
  }
  return result;
}


function Boggle() {
  const table = string_to_board('Qbcdefghijklmnop', 4);
  const list = ['apple', 'pear', 'watermelon'];
  const results = {
    total_score: 14,
    words_with_scores: [['apple', 5], ['pear', 4], ['watermelon', 11]]
  };

  return (
    <div className="Boggle">
      <header className="Boggle-header">
        <br/>Board:
        <Board table={table} />

        <br/>FoundWordsList:
        <FoundWordsList list={list} />

        <br/>ResultFoundWordsList:
        <ResultFoundWordsList results={results} />
        <Timer name="this is a timer" />
        <AddWord name="this is an ad word" />
        <WorkflowButton name="this is a workflow button" />
      </header>
    </div>
  );
}

export default Boggle;
