import React, {Component} from 'react'

import './Boggle.css';
import Board from "./components/Board";
import FoundWordsList from "./components/FoundWordsList";
import Timer from "./components/Timer";
import AddWord from "./components/AddWord";
import WorkflowButton from "./components/WorkflowButton";
import Results from "./components/Results";
import MessageBlock from "./components/MessageBlock";


export default class Boggle extends Component {
  constructor(props) {
    super(props);
    this.state = {
      table: this.string_to_board('Qbcdefghijklmnop', 4),
      list: ['apple', 'pear', 'watermelon'],
      results: {
        total_score: 14,
        words_with_scores: [['apple', 2], ['pear', 1], ['watermelon', 11]]
      },
      game_length_secs: 77,
      workflow_button: 'Start',
      message: {
        type: 'Notification',
        text: 'Boggle'
      }
    };
  }

  string_to_board(str, size) {
    str = str.split('');
    const result = [];
    while(str.length) {
      result.push(str.splice(0, size));
    }

    return result;
  }

  loginCallback(word) {
    this.setState(prevState => ({
      list: [word,...prevState.list]
    }))
  }

  render() {
    return (
      <div className="Boggle">
        <header className="Boggle-header">
          <br/>Board:
          <Board table={this.state.table} />

          <br/>FoundWordsList:
          <FoundWordsList list={this.state.list} />

          <br/>Results:
          <Results results={this.state.results} />

          <br/>Timer:
          <Timer game_length_secs={this.state.game_length_secs} />

          <br/>AddWord:
          <AddWord add_wrod={(word) => this.loginCallback(word)} />

          <br/>WorkflowButton:
          <WorkflowButton caption={this.state.workflow_button} />

          <br/>MessageBlock:
          <MessageBlock message={this.state.message} />
        </header>
      </div>
    );
  }
}
