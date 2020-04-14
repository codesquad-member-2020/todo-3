import { getElement } from "../util/dom";
import { fetchPOSTJSON, fetchDELETEJSON } from "../data/http";
import { URL } from "../util/constant";
import { modal } from "./popup";

export class Card {
  constructor(parentColumnEle, data) {
    Object.assign(this, data);
    this.parentColumnEle = parentColumnEle;
    this.removeCardHandle();
  }

  removeCardHandle() {
    this.parentColumnEle.addEventListener('click', this.removeCard);
  }

  async removeCard() {
    if(event.target.className !== 'delete-btn') return;
    const card = event.target.closest('.card');
    // const removeData = await fetchDELETEJSON(`${URL.CARD}/${card.dataset.id}`);
    const alertHTML = modal.alert('삭제에 실패했습니다.');
    getElement('.container').insertAdjacentHTML('beforeend', alertHTML);
    // if(removeData.responseMessage !== 'Delete data is Success') return modal.alert('삭제에 실패했습니다.');
    // card.remove();
  }

  eventHandleWrap() {
    
  }

  render() {
    return `
      <div class="card" data-id="${this.id}" data-index="${this.row}">
        <p class="comment">${this.contents}</p>
        <span class="user-name">Add by <a href="#none">${this.writer}</a></span>
        <button type="button" class="delete-btn"><span class="blind">삭제</span></button>
      </div>
    `
  }
}