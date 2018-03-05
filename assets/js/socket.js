import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect();

let channel = socket.channel("rates:update", {});
var timer = 10;

channel.on("rates_refresh", rates => {
  Object.keys(rates["rates"]).forEach(function(key) {
  	rates["rates"][key] == 0
  	  ? document.querySelector(`#${key}-bad`).innerText = "No info for the given date"
      : document.querySelector(`#${key}`).innerText = rates["rates"][key]
  });
  let date = new Date(rates["timestamp"] * 1000).toGMTString();
  document.querySelector("#actual-time").innerText = date;
  timer = 10;
})

var intervalID = setInterval(function() { document.querySelector("#timer").innerText = timer--; }, 1000);

document.querySelector("#refresh").addEventListener("click", () => {
  channel.push("force_update", {date: document.querySelector("#refresh-date").value, time: document.querySelector("#refresh-time").value});
  clearInterval(intervalID);
  document.querySelector("#refreshing").style.display = 'none';
  document.querySelector("#not-refreshing").style.display = 'inline';
  document.querySelector("#continue").style.display = 'inline-block';
})

document.querySelector("#continue").addEventListener("click", () => {
  channel.push("start_updating", {});
  intervalID = setInterval(function() { document.querySelector("#timer").innerText = timer--; }, 1000);
  document.querySelector("#refreshing").style.display = 'inline';
  document.querySelector("#not-refreshing").style.display = 'none';
  document.querySelector("#continue").style.display = 'none';
})

channel.join()
  .receive("ok", resp => {
  	console.log("Joined successfully", resp);
  	channel.push("start_updating", {});
  	document.querySelector("#actual-time").innerText = new Date().toGMTString();
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
