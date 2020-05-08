import React from 'react';
import PropTypes from 'prop-types';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '0 auto'
};

const TdStyle = {
  border: '1px dotted #69899F',
  padding: '20px',
  minWidth: '40px',
  minHeight: '40px'
};


const Board = props => {
  return (
    <table style={TableStyle}>
      <tbody>
        {props.table.map((row, index) =>
          <tr key={index}>
            {row.map((col, index) =>
              <td style={TdStyle} key={index}>{col.toUpperCase().replace('Q', 'Qu')}</td>
            )}
          </tr>
        )}
      </tbody>
    </table>
  );
};

Board.propTypes = {
  table: PropTypes.array.isRequired
};

export default Board;
