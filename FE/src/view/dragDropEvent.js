export const dragdropEvent = () => (function () {
  const cards = document.querySelectorAll('.card');
  let currentDroppable = null;

  cards.forEach((card) => {
    card.addEventListener('mousedown', mouseDownHandler);
  })

  function mouseDownHandler () {
    if(event.target.tagName === 'P' || event.target.tagName === 'BUTTON' || event.target.tagName === 'A' ) return;
    const cardBefore = event.currentTarget;
    const card = event.currentTarget.cloneNode(true);
    cardBefore.closest('.column').insertBefore(card, cardBefore);
    let shiftX = event.clientX - card.getBoundingClientRect().left;
    let shiftY = event.clientY - card.getBoundingClientRect().top;
    let pageX = event.pageX;
    let pageY = event.pageY;
    cardBefore.classList.add('drag-target');
    const cardWidth = cardBefore.offsetWidth;
    card.classList.add('dragging');
    card.style.width = cardWidth + 'px';
    document.querySelector('.container').append(card);

    moveAt({card, pageX, pageY, shiftX, shiftY});
    const bindMouseMove = onMouseMove.bind(null, card, shiftX, shiftY);
    document.addEventListener('mousemove', bindMouseMove);
    card.addEventListener('mouseup', () => {
      document.removeEventListener('mousemove', bindMouseMove);
      if(!currentDroppable) return;
      card.remove();
      currentDroppable.appendChild(cardBefore);
      cardBefore.classList.remove('drag-target');
      currentDroppable.style.background = '';
    })
  }

  function moveAt({card, pageX, pageY, shiftX, shiftY}) {
    card.style.left = pageX - shiftX + 'px';
    card.style.top = pageY - shiftY + 'px';
  }

  function onMouseMove(card, shiftX, shiftY) {
    const pageX = event.pageX;
    const pageY = event.pageY;
    moveAt({card, pageX, pageY, shiftX, shiftY});

    card.hidden = true;
    let elemBelow = document.elementFromPoint(event.clientX, event.clientY);
    card.hidden = false;

    if (!elemBelow) return;

    let droppableBelow = elemBelow.closest('.column');
    if (currentDroppable != droppableBelow) {
      if (currentDroppable) {
        leaveDroppable(currentDroppable);
      }
      currentDroppable = droppableBelow;
      if (currentDroppable) {
        enterDroppable(currentDroppable);
      }
    }
    if(!currentDroppable) return;
    const currentColumnCard = currentDroppable.querySelectorAll('.card');
    currentColumnCard.forEach((card, idx) => {
      // console.log(card.offsetTop);
      // const cardHeight = card.offsetHeight / 2;
      // if()
    })
  }

  function enterDroppable(elem) {
    elem.style.background = 'pink';
  }

  function leaveDroppable(elem) {
    elem.style.background = '';
  }

  cards.forEach((card) => {
    card.addEventListener('dragstart', () => {
      return false
    });
  })
})();