
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")

app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set 'view engine', 'html'
  app.engine 'html', require('hbs').__express
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.get "/users", user.list

server = http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

# socket.io code
io = require("socket.io").listen(server)

io.sockets.on 'connection', (socket) ->
  socket.emit 'news', { hello: 'world'}
  # sample event
  socket.on 'custom_event', (data) ->
    console.log data


