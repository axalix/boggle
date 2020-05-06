import React from 'react';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '20px'
};

const TdStyle = {
  border: '1px solid grey',
  padding: '5px',
  fontSize: '10pt'
};

const FoundWordsList = props => {
  return (
    <table style={TableStyle}>
      <tbody>
      {props.list.reverse().map(row =>
        <tr key={'r' + row}>
            <td key={'c' + row} style={TdStyle}>{row}</td>
        </tr>
      )}
      </tbody>
    </table>
  );
};

export default FoundWordsList;