import { getElement, getElements, hasClass } from '../util/dom.js';

const columnEle = getElement('.column');
let isMove = false;
let startPointX;
let startPointY;
const cardGap = 10;
let cloneCardtNode;

export const dragDropHandle = () => {
  columnEle.addEventListener('mousedown', (e) => {
    if(!hasClass(e.target, 'card')) return;
    const target = e.target;
    cloneCardtNode = target.cloneNode(true);
    console.log(cloneCardtNode);
    isMove = true;
    startPointX = e.offsetX;
    startPointY = e.offsetY;
  })

  columnEle.addEventListener('mousemove', (e) => {
    if(!hasClass(e.target, 'card')) return;
    if(!isMove) return;
    const target = e.currentTarget;
    
  })
}