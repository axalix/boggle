import React, {Component} from 'react'
import axios from 'axios';

import './Boggle.css';
import Board from "./components/Board";
import FoundWordsList from "./components/FoundWordsList";
import Timer from "./components/Timer";
import AddWord from "./components/AddWord";
import WorkflowButton from "./components/WorkflowButton";
import MessageBlock from "./components/MessageBlock";
import Results from "./components/Results";


export default class Boggle extends Component {
  constructor(props) {
    super(props);

    this.state = {
      game_token: null,
      status: 'welcome',
      table: this.string_to_board('****************', 4),
      list: [],
      results: {
        total_score: 0,
        words_with_scores: []
      },
      game_length_secs: 0,
      message: {
        type: '',
        text: ''
      }
    };
  }

  string_to_board(str, size) {
    str = str.split('');
    const result = [];
    while (str.length) {
      result.push(str.splice(0, size));
    }

    return result;
  }

  addWordCallback = (word) => {
    this.setState({message: {type: '', text: ''}});
    axios.post('http://localhost:3000/game/word', {word: word}, {headers: {'Game-Token': this.state.game_token}})
      .then(res => {
        this.setState(prevState => ({
          list: [word, ...prevState.list]
        }))
      }).catch((error) => {
      this.setState({message: {type: 'Error', text: error.response.data.message}});
    });
  };

  stop = () => {
    // this.setState({message: {type: '', text: ''}});
    axios.get('http://localhost:3000/game/results', {headers: {'Game-Token': this.state.game_token}})
      .then(res => {
        this.setState({
          status: 'ended',
          results: res.data.results
        })
      }).catch((error) => {
      this.setState({message: {type: 'Error', text: error.response.data.message}});
    });
  };

  start = () => {
    this.setState({message: {type: '', text: ''}});
    axios.post('http://localhost:3000/game', {})
      .then(res => {
        this.setState({
          status: 'running',
          game_token: res.data.id,
          table: this.string_to_board(res.data.board.dice_string, res.data.board.size),
          list: [],
          results: {
            total_score: 0,
            words_with_scores: []
          },
          game_length_secs: res.data.seconds_left,
          message: {
            type: 'Notification',
            text: ''
          }
        })
      })
  };

  triggerStatus = () => {
    if (this.state.status === 'running') {
      this.stop()
    } else {
      this.start()
    }
  };

  render() {
    return (
      <div className="Boggle">
        <header className="Boggle-header">
          BOGGLE

          {this.state.status === 'running' &&
          <Timer trigger_stop={() => this.stop()} game_length_secs={this.state.game_length_secs}/>}

          <MessageBlock message={this.state.message}/>

          <div className="row">

            <div className="left_column">
              <Board table={this.state.table}/>
              <WorkflowButton status={this.state.status} trigger_status={() => this.triggerStatus}/>
            </div>

            <div className="right_column">

              {this.state.status === 'running' &&
              <React.Fragment>
                <AddWord add_wrod={(word) => this.addWordCallback(word)}/>
                <FoundWordsList list={this.state.list}/>
              </React.Fragment>}


              {this.state.status === 'ended' &&
              <Results results={this.state.results} />
              }


              {this.state.status === 'welcome' &&
              <React.Fragment>
                <span>How to Play</span>
                <div className="Boggle-rules">
                  <ul>
                  <li>The letters must be adjoining in a 'chain'. (Letter cubes in the chain may be adjacent horizontally, vertically, or diagonally.)</li>
                  <li>Words must contain at least three letters.</li>
                  <li>No letter cube may be used more than once within a single word.</li>
                  </ul>
                </div>
              </React.Fragment>}
            </div>

          </div>
        </header>
      </div>
    );
  }
}
