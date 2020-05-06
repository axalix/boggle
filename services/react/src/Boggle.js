import React from 'react';

import './Boggle.css';
import Board from "./components/Board";
import FoundWordsList from "./components/FoundWordsList";
import Timer from "./components/Timer";
import AddWord from "./components/AddWord";
import WorkflowButton from "./components/WorkflowButton";
import Results from "./components/Results";


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
    words_with_scores: [['apple', 2], ['pear', 1], ['watermelon', 11]]
  };
  const game_length_secs = 77

  return (
    <div className="Boggle">
      <header className="Boggle-header">
        <br/>Board:
        <Board table={table} />

        <br/>FoundWordsList:
        <FoundWordsList list={list} />

        <br/>Results:
        <Results results={results} />

        <br/>Timer:
        <Timer game_length_secs={game_length_secs} />

        <AddWord name="this is an add word" />
        <WorkflowButton name="this is a workflow button" />
      </header>
    </div>
  );
}

export default Boggle;
