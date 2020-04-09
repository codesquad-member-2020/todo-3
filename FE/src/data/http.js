import { URL } from '../util/constant.js'

const fetchJSON = async (url) => {
  return await fetch(url).then((response) => response.json());
}

export const requestDataShow = async () => {
  return await fetchJSON(URL.show);
}