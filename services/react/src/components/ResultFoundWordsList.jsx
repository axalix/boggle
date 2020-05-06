import React from 'react';

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '20px'
};

const TdStyle = {
  border: '1px solid green',
  padding: '5px',
  fontSize: '10pt'
};

const ResultFoundWordsList = props => {
  return (
    <table style={TableStyle}>
      <tbody>
      {props.results['words_with_scores'].map(row =>
        <tr key={'r' + row[0]}>
            <td key={'c1' + row[0]} style={TdStyle}>{row[0]}</td>
            <td key={'c2' + row[0]} style={TdStyle}>{row[1]}</td>
        </tr>
      )}
      </tbody>
    </table>
  );
};

export default ResultFoundWordsList;