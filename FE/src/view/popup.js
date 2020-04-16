import { getElement } from "../util/dom";
import { fetchPUTJSON } from '../data/http.js';
import { URL } from "../util/constant";

export const modal = {
  alert(msg = '') {
    const alertHTML = `
      <div class="modal">
        <div class="alert">
          <div>${msg}</div>
          <button type="button" class="close-btn">확인</button>
        </div>
      </div>
    `;
    this.render(alertHTML);
    getElement('.modal .close-btn').addEventListener('click', this.remove.bind(this));
  },

  confirm(msg = '') {
    const confirmHTML = `
      <div class="modal">
        <div class="confirm">
          <div>${msg}</div>
          <button type="button" class="yes-btn">네</button>
          <button type="button" class="no-btn">아니요</button>
        </div>
      </div>
    `
    this.render(confirmHTML);
    getElement('.modal .no-btn').addEventListener('click', this.remove.bind(this));
  },

  edit(target, columnId) {
    const editHTML = `
      <div class="modal">
        <div class="edit">
          <h5>Edit note</h5>
          <div>
            <strong>Note</strong>
            <form action="" method="POST">
              <textarea name="todoNote" id="todoNote" maxlength="500">${target.textContent}</textarea>
              <button type="button" class="save-btn">Save note</button>
            </form>
          </div>
          <button type="button" class="close-btn"><span class="blind">닫기</span></button>
        </div>
      </div>
    `
    this.render(editHTML);
    getElement('.modal .edit .save-btn').addEventListener('click', this.saveCard.bind(this, target.closest('.card'), columnId));
    getElement('.modal .close-btn').addEventListener('click', this.remove.bind(this));
  },

  render(html) {
    getElement('.container').insertAdjacentHTML('beforeend', html);
  },

  async saveCard(target, columnId) {
    const newCardComment = event.target.closest('form').querySelector('textarea').value;
    const targetId = target.dataset.id;
    const responseEdit = await this.requestEdit({newCardComment, targetId, columnId});
    this.remove();
    if(responseEdit.responseMessage !== 'Update data is Success') return this.alert('저장을 실패했습니다.');
    target.querySelector('.comment').textContent = newCardComment;
  },

  async requestEdit({newCardComment, targetId, columnId}) {
    const requestBodyData = {
      "title" : '',
      "contents" : newCardComment
    }
    // http://15.164.78.121/api/columns/{columnId}/cards/{cardId}
    return await fetchPUTJSON(`${URL.DEFAULT}/columns/${columnId}/cards/${targetId}`, requestBodyData);
  },

  remove() {
    if(getElement('.modal')) getElement('.modal').remove();

  }
}
