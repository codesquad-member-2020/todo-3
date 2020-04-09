export class Card {
  constructor(data) {
    Object.assign(this, data);
  }

  render() {
    return `
      <div class="card" data-id="${this.id}" data-index="${this.row}">
        <p class="comment">${this.title} ${this.contents}</p>
        <span class="user-name">Add by <a href="#none">${this.writer}</a></span>
        <button type="button" class="delete-btn"><span class="blind">삭제</span></button>
      </div>
    `
  }
}