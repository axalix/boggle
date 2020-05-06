import React from 'react';
import { render } from '@testing-library/react';
import Boggle from './Boggle';

test('renders learn react link', () => {
  const { getByText } = render(<Boggle />);
  // const linkElement = getByText(/boggle/i);
  expect(linkElement).toBeInTheDocument();
});
