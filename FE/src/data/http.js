import { URL } from '../util/constant.js'

export const fetchGETJSON = async (url) => {
  return await fetch(url).then((response) => response.json());
}

export const fetchPOSTJSON = async (url, data) => {
  return await fetch(url, {
    method: 'POST',
    headers: {
      'accept' : 'application/json',
      'content-type' : 'application/json; charset=utf-8'
    },
    body: JSON.stringify(data)
  })
}

// export const requestDataShow = async () => {
//   return await fetchGETJSON(URL.SHOW);
// }

// export const requestDataAdd = async (data) => {
//   return await fetchPOSTJSON(URL.ADD, data);
// }

// export const requestDataUpdate = async (data) => {
//   return await fetchPOSTJSON(URL.UPDATE, data);
// }

// export const requestDataMove = async (data) => {
//   return await fetchPOSTJSON(URL.MOVE, data);
// }

// export const requestDataDelete = async (data) => {
//   return await fetchPOSTJSON(URL.DELETE, data);
// }