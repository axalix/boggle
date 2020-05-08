import React, {Component} from 'react'
import PropTypes from 'prop-types';

const DivStyle = {
  margin: '10px 0 10px'
};

export default class Timer extends Component {
  constructor(props) {
    super(props);
    this.state = {seconds: props.game_length_secs};
  }

  componentDidMount() {
    this.myInterval = setInterval(() => {
      const {seconds} = this.state;

      if (seconds > 1) {
        this.setState(({seconds}) => ({seconds: seconds - 1}));
        return
      }

      this.props.onTriggerStop();
      clearInterval(this.myInterval);
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
      <div style={DivStyle}>
        {
          <b>Time Left: {m === 0 ? `${s}s` : `${m}:${(s < 10 ? '0' : '')}${s}`}</b>
        }
      </div>
    )
  }
}

Timer.propTypes = {
  game_length_secs: PropTypes.number.isRequired,
  onTriggerStop:    PropTypes.func.isRequired
};
