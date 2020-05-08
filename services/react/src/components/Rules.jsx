import React from 'react';

const Rules = () => {
  return (
    <React.Fragment>
      <span>How to Play</span>
      <div className="Boggle-rules">
        <ul>
          <li>The letters must be adjoining in a 'chain'. (Letter cubes in the chain may be adjacent horizontally, vertically, or diagonally.)</li>
          <li>Words must contain at least three letters.</li>
          <li>No letter cube may be used more than once within a single word.</li>
        </ul>
      </div>
    </React.Fragment>
  );
};

export default Rules;
