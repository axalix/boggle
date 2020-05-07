import React from 'react';

const HeaderStyle = {
  color: 'GoldenRod'
};

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '0 auto'
};

const TdStyle = {
  border: '1px solid #383838',
  padding: '5px',
  fontSize: '10pt'
};

const Results = props => {
  return (
    <React.Fragment>
      <b style={HeaderStyle}>Total Score: {props.results['total_score']}</b>
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
    </React.Fragment>
  );
};

export default Results;
