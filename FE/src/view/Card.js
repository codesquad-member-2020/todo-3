import { getElement } from "../util/dom";
import { fetchPOSTJSON, fetchDELETEJSON } from "../data/http";
import { URL } from "../util/constant";
import { modal } from "./popup";
import { dragEventHandle } from "./dragDropEvent";
import { controller } from "../controller/controller";

export class Card {
  constructor({columnEle, columnCategoryName, columnId, cardData}) {
    Object.assign(this, cardData);
    this.parentColumnEle = columnEle;
    this.columnCategoryName = columnCategoryName;
    this.columnId = columnId;
    this.index = this.row - 1;
    // this.cardListener.call(this);
    this.cardListener();
  }

  cardListener() {
    this.parentColumnEle.addEventListener('click', this.removeCardHandler.bind(this));
    this.parentColumnEle.addEventListener('dblclick', this.editCardHandler);
  }

  removeCardHandler(event) {
    if(event.target.className === 'delete-btn' && event.target.closest('.card').dataset.index === `${this.row}`) {
      console.log(event.target)
      const card = event.target.closest('.card');
      const column = event.target.closest('.column');
      if(!getElement('.container').querySelectorAll('.modal').length) modal.confirm('삭제하시겠습니까?');
      console.log(this)
      this.removeClickHandler.call(this, card, column);
    }
  }

  removeClickHandler(card, column) {
    getElement('.modal .yes-btn').addEventListener('click', async () => {
      const removeData = await fetchDELETEJSON(`${URL.DEFAULT}/columns/${column.dataset.id}/cards/${card.dataset.id}`);
      modal.remove();
      if(removeData.responseMessage !== 'Delete data is Success') return modal.alert('삭제에 실패했습니다.');
      card.remove();
      console.log(`${this.columnCategoryName}Cards`);
      controller.responseData[`${this.columnCategoryName}Cards`].splice(this.index, 1);
      column.querySelector('.card-length').textContent = controller.responseData[`${this.columnCategoryName}Cards`].length;
    });
  }

  editCardHandler() {
    // debugger
    if(event.target.className !== 'comment') return;
    modal.edit(event.target, this.columnId);
  }

  render() {
    return `
      <div class="card" id="card${this.id}" data-id="${this.id}" data-index="${this.row}">
        <p class="comment">${this.contents}</p>
        <span class="user-name">Add by <a href="#none">${this.writer}</a></span>
        <button type="button" class="delete-btn"><span class="blind">삭제</span></button>
      </div>
    `
  }
}