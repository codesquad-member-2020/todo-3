import { URL } from '../util/constant.js'
const token = JSON.parse(localStorage.getItem('token'));

export const requestToken = async (url, data) => {
  return await fetch(url, {
    method: 'POST',
    headers: {
      'accept' : 'application/json',
      'content-type' : 'application/json; charset=utf-8'
    },
    body: JSON.stringify(data)
  }).then(response => {
    return response.json();
  });
}

export const fetchGETJSON = async (url) => {
  console.log(url)
  return await fetch(url, {
    method: 'GET',
    headers: {
      'accept' : 'application/json',
      "content-type" : "application/json",
      "Authorization" : token
    }
  }).then((response) => response.json());
}

export const fetchPOSTJSON = async (url, data) => {
  return await fetch(url, {
    method: 'POST',
    headers: {
      'accept' : 'application/json',
      'content-type' : 'application/json; charset=utf-8',
      'Authorization' : token
    },
    body: JSON.stringify(data)
  }).then(response => {
    return response.json();
  });
}

export const fetchDELETEJSON = async (url) => {
  return await fetch(url, {
    method: 'DELETE',
    headers: {
      'accept' : 'application/json',
      'content-type' : 'application/json; charset=utf-8',
      'Authorization' : token
    }
  }).then((response) => response.json());
}

export const fetchPUTJSON = async (url, data) => {
  return await fetch(url, {
    method: 'PUT',
    headers: {
      'accept' : 'application/json',
      'content-type' : 'application/json; charset=utf-8',
      'Authorization' : token
    },
    body: JSON.stringify(data)
  }).then(response => {
    return response.json();
  })
}
