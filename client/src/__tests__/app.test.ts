import {render} from '@testing-library/svelte';
import App from '../App.svelte';

test('should render the text hello world!', () => {
  const results = render(App, {props: {name: 'hello world'}});

  expect(() => results.getByText('hello world')).not.toThrow();
});
