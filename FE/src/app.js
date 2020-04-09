import '../style/style.scss';
import { Column } from './view/Column.js';

const todoColumn = new Column('To Do', 0);
const inProgressColumn = new Column('In Progress', 1);
const doneColumn = new Column('Done', 2);

window.addEventListener('DOMContentLoaded', () => {
  todoColumn.init();
  inProgressColumn.init();
  doneColumn.init();
});
