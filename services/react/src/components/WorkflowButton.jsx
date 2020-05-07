import React from 'react';

const WorkflowButtonStyle = {
  boxShadow: 'inset 0px 1px 0px 0px #a4e271',
  background: 'linear-gradient(to bottom, #89c403 5%, #77a809 100%)',
  backgroundColor: '#5aad00',
  padding: '10px 20px 10px 20px',
  fontSize: '20px',
  margin: '10px'
};

const WorkflowButton = props => {
  return (
    <form>
      <button type="button" style={WorkflowButtonStyle} onClick={props.trigger_status()}>
        {props.status === 'running' ? 'Stop' : 'Start'}
      </button>
    </form>
  );
};

export default WorkflowButton;
