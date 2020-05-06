import React from 'react';

import './Boggle.css';
import Board from "./components/Board";
import FoundWordsList from "./components/FoundWordsList";
import Timer from "./components/Timer";
import AddWord from "./components/AddWord";
import WorkflowButton from "./components/WorkflowButton";


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

  return (
    <div className="Boggle">
      <header className="Boggle-header">
        <Board table={table} />
        <FoundWordsList name="this is a found words list" />
        <Timer name="this is a timer" />
        <AddWord name="this is an ad word" />
        <WorkflowButton name="this is a workflow button" />
      </header>
    </div>
  );
}

export default Boggle;
