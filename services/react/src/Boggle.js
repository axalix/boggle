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
import Rules from "./components/Rules";
import DiceType from "./components/DiceType";

export default class Boggle extends Component {
  constructor(props) {
    super(props);

    this.state = {
      game_token: null,
      dice_type: 'classic_16',
      status: 'welcome',
      table: this.string_to_board('****************', 4),
      words: [],
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

    this.axios = axios.create({
      baseURL: 'http://localhost:3000/',
      timeout: 1000
    });

  }

  string_to_board = (str, size) => {
    str = str.split('');
    const result = [];
    while (str.length) {
      result.push(str.splice(0, size));
    }

    return result;
  };

  componentDidMount() {
    const game_id = localStorage.getItem('game_id');
    if (game_id) {
      this.axios.get('game', {headers: {'Game-Token': game_id}})
        .then(res => {
          this.setState({
            status: 'running',
            game_token: res.data.id,
            dice_type: res.data.dice_type,
            table: this.string_to_board(res.data.board.dice_string, res.data.board.size),
            words: res.data.words,
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
    }
  }

  addWord = (word) => {
    this.setState({message: {type: '', text: ''}});
    this.axios.post('game/word', {word: word}, {headers: {'Game-Token': this.state.game_token}})
      .then(() => {
        this.setState(prevState => ({
          words: [word, ...prevState.words]
        }))
      }).catch((error) => {
      this.setState({message: {type: 'Error', text: error.response.data.message}});
    });
  };

  stop = () => {
    // this.setState({message: {type: '', text: ''}});
    localStorage.clear();
    this.axios.get('game/results', {headers: {'Game-Token': this.state.game_token}})
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
    this.axios.post('game', {dice_type: this.state.dice_type})
      .then(res => {
        localStorage.setItem('game_id', res.data.id);
        this.setState({
          status: 'running',
          game_token: res.data.id,
          dice_type: res.data.dice_type,
          table: this.string_to_board(res.data.board.dice_string, res.data.board.size),
          words: res.data.words,
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

  handleTriggerStatus = () => {
    if (this.state.status === 'running') {
      this.stop()
    } else {
      this.start()
    }
  };

  handleDiceTypeChange = (dice_type) => {
    this.setState({dice_type: dice_type});
  };

  render() {
    return (
      <div className="Boggle">
        <header className="Boggle-header">
          BOGGLE
          <DiceType diceType={this.state.dice_type} onDiceTypeChange={(dice_type) => this.handleDiceTypeChange(dice_type)} disabled={this.state.status === 'running'} />
          {this.state.status === 'running' &&
          <Timer onTriggerStop={() => this.stop()} gameLengthSecs={this.state.game_length_secs}/>}

          <MessageBlock message={this.state.message}/>

          <div className="row">

            <div className="left_column">
              <Board table={this.state.table}/>
              <WorkflowButton status={this.state.status} onStatusTrigger={() => this.handleTriggerStatus}/>
            </div>

            <div className="right_column">

              {this.state.status === 'running' &&
              <React.Fragment>
                <AddWord onAddWord={(word) => this.addWord(word)}/>
                <FoundWordsList words={this.state.words}/>
              </React.Fragment>}


              {this.state.status === 'ended' &&
              <Results results={this.state.results}/>
              }


              {this.state.status === 'welcome' &&
              <Rules/>
              }
            </div>

          </div>
        </header>
      </div>
    );
  }
}
