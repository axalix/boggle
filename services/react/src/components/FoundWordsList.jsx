import React from 'react';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '20px auto'
};

const TdStyle = {
  border: '1px solid #383838',
  padding: '5px',
  fontSize: '10pt'
};

const FoundWordsList = props => {
  return (
    <table style={TableStyle}>
      <tbody>
      {props.list.map(row =>
        <tr key={'r' + row}>
            <td key={'c' + row} style={TdStyle}>{row}</td>
        </tr>
      )}
      </tbody>
    </table>
  );
};

export default FoundWordsList;
