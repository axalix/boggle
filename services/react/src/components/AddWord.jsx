import React, { useState } from 'react';

const CancelButtonStyle = {
  boxShadow: 'inset 0px 1px 0px 0px #f7c5c0',
  background: 'linear-gradient(to bottom, #fc8d83 5%, #e4685d 100%)',
  backgroundColor: '#fc8d83'
};


const AddWord = ({ add_wrod }) => {
  const [word, setWord] = useState('');

  const notiftyGame = (word) => {
    word = word.replace(/[^a-zA-Z]+/g, '');
    if (word === '') {
      setWord('');
      return;
    }

    add_wrod(word);
    setWord('')
  };

  return (
    <form>
      <button type="reset" style={CancelButtonStyle}>
        Erase
      </button>
      <input
        value={word}
        placeholder="Enter a word"
        onChange={e => setWord(e.target.value)}
      />
      <button type="button" onClick={(e) => notiftyGame(word)}>
        Add
      </button>
    </form>
  );
};

export default AddWord;
