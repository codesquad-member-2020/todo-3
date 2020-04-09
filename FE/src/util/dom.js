export function getElement(target) {
  return document.querySelector(target);
}

export function getElements(target) {
  return document.querySelectorAll(target);
}

export function addClass(target, className) {
  getElement(target).classList.add(className);
}

export function removeClass(target, className) {
  getElement(target).classList.remove(className);
}

export function hasClass(target, className) {
  return getElement(target).classList.contains(className);
}

export function show(target) {
  target.style.display = 'block';
}

export function hide(target) {
  target.style.display = 'none';
}
