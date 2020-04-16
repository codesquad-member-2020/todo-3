import '../style/style.scss';
import { getElement, hide, show } from './util/dom';
import { dragEventHandle } from './view/dragDropEvent.js';
import { requestToken } from './data/http';
import { USER, URL } from './util/constant';
import { controller } from './controller/controller.js';

window.addEventListener('DOMContentLoaded', () => initLogin());

const initLogin = () => {
  getElement('.login-btn').addEventListener('click', () => loginHandler());
}

const loginHandler = async () => {
  if(!localStorage.getItem('token')) {
    const responseToken = await requestToken(URL.TOKEN, USER.INFO);
    localStorage.setItem("token", JSON.stringify(responseToken.responseData));
  }
  getElement('.loader').style.display = 'flex';
  getElement('.login').remove();

  await handelLoad();
}

const handelLoad = async () => {
  await controller.init();

  setTimeout(() => {
    getElement('.loader').remove();
    getElement('header').style.display = 'flex';
    getElement('.container').style.display = 'flex';
  }, 500);

  // dragEventHandle();
}

