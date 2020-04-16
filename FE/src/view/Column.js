import { fetchGETJSON, fetchPOSTJSON } from '../data/http.js';
import { getElement, getElements, addClass, removeClass, hasClass, show, hide } from '../util/dom.js';
import { Card } from './Card.js';
import { URL } from '../util/constant.js';
import { controller } from '../controller/controller.js';

export class Column {
  constructor(columnData) {
    Object.assign(this, columnData);
    this.cardLength = this.cards.length;
    this.index = this.id - 1;
    this.isInputBox = false;
    this.columnEle;
    this.cardArguments = {};
  }

  init() {
    const container = getElement('.container');
    const initalHTML = this.render();

    container.insertAdjacentHTML('beforeend', initalHTML);
    this.columnEle = getElement(`#column${this.id}`);
    this.setEventListener();

    if(!this.cardLength) return;

    this.cards.forEach((cardData) => {
      this.cardArguments = {
        columnEle: this.columnEle,
        columnCategoryName: this.categoryName,
        columnId: this.id,
        cardData: cardData
      }
      const newCard = new Card(this.cardArguments);
      controller.responseData[`${this.categoryName}Cards`].push(newCard);
      this.columnEle.insertAdjacentHTML('beforeend', newCard.render());
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
      "title" : "",
      "contents" : textareaValue,
    }

    const addData = await fetchPOSTJSON(`${URL.DEFAULT}/columns/${this.id}/cards`, data);

    if(addData.responseMessage === 'Create data is Success') {
      textareaEle.value = '';
      addClass(targetBtn, 'disable');
      this.cardArguments = {
        columnEle: this.columnEle,
        columnCategoryName: this.categoryName,
        columnId: this.id,
        cardData: addData.responseData
      }
      const newCard = new Card(this.cardArguments);
      this.columnEle.insertAdjacentHTML('beforeend', newCard.render());
      controller.responseData[`${this.categoryName}Cards`].push(newCard);
      console.log(controller.responseData[`${this.categoryName}Cards`])
      this.columnEle.querySelector('.card-length').textContent = controller.responseData[`${this.categoryName}Cards`].length;
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

  render() {
    return `
      <div class="column" data-id="${this.id}" id="column${this.id}">
        <div class="column-top">
          <div class="column-title">
            <strong class="column-name"><span class="card-length">${this.cardLength}</span><span class="column-title-name">${this.colName}</span></strong>
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
