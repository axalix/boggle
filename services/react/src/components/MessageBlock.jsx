import React from 'react';

const NotificationStyle = {
  backgroundColor: '#5b8009',
  border: '1px solid #003700',
  width: '40%',
  height: '50px'
};

const ErrorStyle = {
  backgroundColor: '#a94746',
  border: '1px solid #361B1B',
  width: '40%',
  height: '50px'
};

const MessageBlock = props => {
  return (
    <div style={props.message.type === 'Notification' ? NotificationStyle : ErrorStyle}>
      {props.text}
    </div>
  );
};

export default MessageBlock;
