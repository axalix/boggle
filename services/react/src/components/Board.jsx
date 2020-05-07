import React from 'react';

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
        {props.table.map(row =>
          <tr key={row.join('')}>
            {row.map(col =>
              <td style={TdStyle} key={row.join('') + col}>{col.toUpperCase().replace('Q', 'Qu')}</td>
            )}
          </tr>
        )}
      </tbody>
    </table>
  );
};

export default Board;
