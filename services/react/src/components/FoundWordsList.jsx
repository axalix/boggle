import React from 'react';
import PropTypes from 'prop-types';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '20px auto'
};

const TdStyle = {
  border: '1px solid #383838',
  padding: '5px',
  fontSize: '12pt'
};

const FoundWordsList = props => {
  return (
    <table style={TableStyle}>
      <tbody>
      {props.words.map((row, index) =>
        <tr key={index}>
            <td key={index} style={TdStyle}>{row}</td>
        </tr>
      )}
      </tbody>
    </table>
  );
};

FoundWordsList.propTypes = {
  words: PropTypes.array.isRequired
};

export default FoundWordsList;
