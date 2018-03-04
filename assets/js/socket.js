// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect();

let channel = socket.channel("rates:update", {});
var timer = 10;

channel.on("rates_refresh", rates => {
  Object.keys(rates["rates"]).forEach(function(key) { document.querySelector(`#${key}`).innerText = 1 / rates["rates"][key] });
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
