import { requestDataShow } from '../data/http.js';
import { getElement, getElements, show, hide } from '../util/dom.js';
import { Card } from './Card.js';


export class Column {
  constructor(name, columnIndex) {
    this.columnName = name;
    this.index = columnIndex;
    this.isInputBox = false;
    this.columnEle;
  }

  async init() {
    const container = getElement('.container');
    const data = await requestDataShow();
    const initalHTML = await this.render(data);
    container.insertAdjacentHTML('beforeend', initalHTML);
    const cardList = data.responseMessage[this.index].cardList;
    if(!cardList.length) return;
    this.columnEle = getElements('.column')[this.index];
    cardList.forEach((content) => {
      this.columnEle.insertAdjacentHTML('beforeend', new Card(content).render());
    });
  this.columnEle.querySelector('.content-add-btn').addEventListener('click', this.toggleInputBox.bind(this));
  }

  toggleInputBox() {
    this.isInputBox = !this.isInputBox;
    const inputEle = this.columnEle.querySelector('.column-note');
    console.log(this.isInputBox)
    this.isInputBox ? show(inputEle) : hide(inputEle);
  }

  render(data) {
    return `
      <div class="column">
        <div class="column-top">
          <div class="column-title">
            <strong class="column-name"><span class="card-length">${data.responseMessage[this.index].cardList.length}</span>${this.columnName}</strong>
            <button type="button" class="content-add-btn"><span class="blind">추가</span></button>
          </div>
          <div class="column-note">
            <form action="" method="POST">
              <textarea name="todoNote" id="todoNote" maxlength="500"></textarea>
              <div class="btn-wrap">
                <button type="button" class="add-btn">Add</button>
                <button type="button" class="cancel-btn">Cancel</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `
  }
}
