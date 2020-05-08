import React from 'react';
import PropTypes from 'prop-types';

const NotificationStyle = {
  backgroundColor: '#5b8009',
  border: '1px solid #003700'
};

const ErrorStyle = {
  backgroundColor: '#a94746',
  border: '1px solid #361B1B'
};

const MessageBlock = props => {
  return (
    <div className="Boggle-message-box-parent" style={{visibility: props.message.text === '' ? 'hidden': 'visible'}}>
      <div className="Boggle-message-box" style={ props.message.type === 'Notification' ? NotificationStyle : ErrorStyle }>
        {props.message.text}
      </div>
    </div>
  );
};

MessageBlock.propTypes = {
  message: PropTypes.object.isRequired
};

export default MessageBlock;
