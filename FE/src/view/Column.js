import { fetchGETJSON, fetchPOSTJSON } from '../data/http.js';
import { getElement, getElements, addClass, removeClass, hasClass, show, hide } from '../util/dom.js';
import { Card } from './Card.js';
import { URL } from '../util/constant.js';

export class Column {
  constructor(name, columnIndex) {
    this.columnName = name;
    this.index = columnIndex;
    this.isInputBox = false;
    this.columnEle;
    this.cardLength = 0;
  }

  async init() {
    const container = getElement('.container');
    const data = await fetchGETJSON(URL.SHOW);
    const initalHTML = await this.render(data);
    const cardList = data.responseData[this.index].cardList;
    this.cardLength = cardList.length;

    container.insertAdjacentHTML('beforeend', initalHTML);
    this.columnEle = getElements('.column')[this.index];
    this.setEventListener();

    if(!this.cardLength) return;

    cardList.forEach((card) => {
      this.columnEle.insertAdjacentHTML('beforeend', new Card(this.columnEle, card).render());
    });
  }

  setEventListener() {
    const addButton = this.columnEle.querySelector('.add-btn');
    const cancelButton = this.columnEle.querySelector('.cancel-btn');
    const textareaEle = this.columnEle.querySelector('textarea');

    this.columnEle.querySelector('.content-add-btn').addEventListener('click', this.toggleInputBox.bind(this));
    addButton.addEventListener('click', this.addCardHandle.bind(this, textareaEle));
    cancelButton.addEventListener('click', this.cancelInputHandle.bind(this, textareaEle, addButton));
    textareaEle.addEventListener('input', this.inputEventHandle.bind(this, addButton));
  }

  toggleInputBox() {
    this.isInputBox = !this.isInputBox;
    const inputEle = this.columnEle.querySelector('.column-note');
    this.isInputBox ? show(inputEle) : hide(inputEle);
  }

  async addCardHandle(textareaEle) {
    const targetBtn = event.currentTarget;
    if(hasClass(targetBtn, 'disable')) return event.preventDefault;
    const textareaValue = textareaEle.value.replace(/(?:\r\n|\r|\n)/g, '<br />');
    const data = {
      "row" : ++this.cardLength,
      "contents" : textareaValue,
      "writer" : "ari",
      "colName" : this.columnName
    }

    const addData = await fetchPOSTJSON(URL.DEFAULT, data);

    if(addData.responseMessage === 'Create data is Success') {
      textareaEle.value = '';
      addClass(targetBtn, 'disable');
      this.columnEle.insertAdjacentHTML('beforeend', new Card(this.columnEle, addData.responseData).render());
      this.columnEle.querySelector('.card-length').textContent = this.cardLength;
    };
  }

  cancelInputHandle(textareaEle, addButton) {
    textareaEle.value = '';
    addClass(addButton, 'disable');
  }

  inputEventHandle(addBtnEle) {
    const input = event.currentTarget;
    input.value ? removeClass(addBtnEle, 'disable') : addClass(addBtnEle, 'disable');
  }

  render(data) {
    return `
      <div class="column">
        <div class="column-top">
          <div class="column-title">
            <strong class="column-name"><span class="card-length">${data.responseData[this.index].cardList.length}</span>${this.columnName}</strong>
            <button type="button" class="content-add-btn"><span class="blind">추가</span></button>
          </div>
          <div class="column-note">
            <form action="" method="POST">
              <textarea name="todoNote" id="todoNote" maxlength="500"></textarea>
              <div class="btn-wrap">
                <button type="button" class="add-btn disable">Add</button>
                <button type="button" class="cancel-btn">Cancel</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `
  }
}
