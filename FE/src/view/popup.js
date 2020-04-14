export const modal = {
  alert(msg = '') {
    
    return `
      <div class="modal">
        <div class="alert">
          <div>${msg}</div>
          <button type="button" class="close-btn">확인</button>
        </div>
      </div>
    `
  },

  confirm(msg = '') {
    return `
      <div class="modal">
        <div class-"confirm">
          <div>${msg}</div>
          <button type="button" class="yes-btn">네</button>
          <button type="button" class="no-btn">아니요</button>
        </div>
      </div>
    `
  },

  edit() {
    return `
      <div class="modal">
        <div class="edit">
          <h5>Edit note</h5>
          <div>
            <strong>Note</strong>
            <form action="" method="POST">
              <textarea name="todoNote" id="todoNote" maxlength="500"></textarea>
              <button type="button" class="save-btn">Save note</button>
            </form>
          </div>
          <button type="button" class="close-btn">닫기</button>
        </div>
      </div>
    `
  },

  remove(target) {
    target.querySelector('.modal').remove();
  }
}