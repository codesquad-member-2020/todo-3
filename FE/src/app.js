import '../style/style.scss';
import { Column } from './view/Column.js';
import { getElement, hide } from './util/dom';
import { dragDropHandle } from './view/dragDropEvent';

const todoColumn = new Column('To do', 0);
const inProgressColumn = new Column('In Progress', 1);
const doneColumn = new Column('Done', 2);

window.addEventListener('DOMContentLoaded', () => {
  todoColumn.init();
  inProgressColumn.init();
  doneColumn.init();
  setTimeout(() => {
    hide(getElement('.loader'));
  }, 1000);
  
});
