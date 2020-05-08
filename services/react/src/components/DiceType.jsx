import React from 'react';
import PropTypes from 'prop-types';

const SelectStyle = {
  'margin': '10px'
};

const DiceType = ({ diceType, onDiceTypeChange, disabled }) => {
  return (
    <select onChange={(e) => onDiceTypeChange(e.target.value)} value={diceType} style={SelectStyle} disabled={disabled}>
      <option value="classic_16">Classic Dice</option>
      <option value="new_16">New Dice</option>
      <option value="fancy_25">Fancy 5x5 Dice</option>
    </select>
  );
};

DiceType.propTypes = {
  diceType: PropTypes.string.isRequired,
  onDiceTypeChange: PropTypes.func.isRequired,
  disabled: PropTypes.bool.isRequired
};

export default DiceType;
