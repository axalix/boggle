import React, {Component} from 'react'

export default class Timer extends Component {
  constructor(props) {
    super(props);
    this.state = {seconds: props.game_length_secs};
  }

  componentDidMount() {
    this.myInterval = setInterval(() => {
      const {seconds} = this.state;

      if (seconds > 0) {
        return this.setState(({seconds}) => ({seconds: seconds - 1}));
      }

      clearInterval(this.myInterval)
    }, 1000)
  }

  componentWillUnmount() {
    clearInterval(this.myInterval)
  }

  render() {
    const {seconds} = this.state;
    const m = parseInt(seconds / 60);
    const s = seconds % 60;

    return (
      <span>
        {seconds === 0
          ? <b>Game over!</b>
          : <b>Time Left: {m === 0 ? `${s}s` : `${m}:${(s < 10 ? '0' : '')}${s}`}</b>
        }
      </span>
    )
  }
}
