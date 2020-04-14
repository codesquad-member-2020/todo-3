// export const URL = {
//   SHOW: 'http://15.164.78.121/api/cards/show',
//   ADD: 'http://15.164.78.121/api/cards',
//   UPDATE: 'http://15.164.78.121/api/cards/update',
//   MOVE: 'http://15.164.78.121/api/cards/move',
//   DELETE: 'http://15.164.78.121:8080/api/cards/delete'
// }

const DEFAULT_URL = 'http://15.164.78.121/api/cards';
export const URL = {
  DEFAULT: DEFAULT_URL,
  SHOW: `${DEFAULT_URL}/show`,
  MOVE: `${DEFAULT_URL}/move`
}