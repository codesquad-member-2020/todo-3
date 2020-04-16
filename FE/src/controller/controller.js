import { Column } from '../view/Column.js';
import { URL } from '../util/constant.js';
import { fetchGETJSON } from '../data/http.js';
import { dragdropEvent } from '../view/dragDropEvent.js';

let responseData = {};

const init = async () => {
  const data = await fetchGETJSON(URL.SHOW);
  const todoColumn = new Column(data.responseData[0]);
  const inProgressColumn = new Column(data.responseData[1]);
  const doneColumn = new Column(data.responseData[2]);

  responseData.data = data.responseData;
  responseData.todoCards = [];
  responseData.doingCards = [];
  responseData.doneCards = [];

  todoColumn.init();
  inProgressColumn.init();
  doneColumn.init();
  dragdropEvent();
}

export const controller = {
  init: init,
  responseData: responseData
}
