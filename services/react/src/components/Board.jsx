import React from 'react';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '20px'
};

const TdStyle = {
  border: '1px dotted #69899F',
  padding: '25px'
};


const Board = props => {
  return (
    <table style={TableStyle}>
      {props.table.map(row =>
        <tr key={row.join('')}>
          {row.map(col =>
            <td style={TdStyle} key={row.join('') + col}>{col.toUpperCase().replace('Q', 'Qu')}</td>
          )}
        </tr>
      )}
    </table>
  );
};

export default Board;
