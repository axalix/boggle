import React from 'react';


class Board extends React.Component {
  render() {
    return (
      <table border="1" cellPadding={30}>
        <tbody>
        {this.props.table.map(row =>
          <tr key={row.id}>
            {row.map(col =>
              <td key={col}>{col.toUpperCase().replace('Q', 'Qu')}</td>
            )}
          </tr>
        )}
        </tbody>
      </table>
    );
  }
}

export default Board;
