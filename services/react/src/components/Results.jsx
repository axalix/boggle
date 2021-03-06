import React from 'react';
import PropTypes from 'prop-types';

const HeaderStyle = {
  color: 'GoldenRod',
  marginBottom: '15px',
  display: 'block'
};

const TableStyle = {
  borderCollapse: 'collapse',
  margin: '0 auto'
};

const TdStyle = {
  border: '1px solid #383838',
  padding: '5px',
  fontSize: '12pt'
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

Results.propTypes = {
  results: PropTypes.object.isRequired
};

export default Results;
