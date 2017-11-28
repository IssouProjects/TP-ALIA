const prolog = require('./prolog');

var winner0 = 0
var winner1 = 0
var ties = 0

var stop = false

function play(games) {
  prolog.getOutput(function (winner) {
    console.log("Games to play: " + games)
    console.log(winner)
    //winner = output.replace(/\n/g, "<br />");
    if(winner == 0) {
      winner0 ++
      document.getElementById("winner0").style.width = winner0 + "%"
      document.getElementById("wins0").innerHTML = winner0
    }
    else if(winner == 1) {
      winner1 ++
      document.getElementById("winner1").style.width = winner1 + "%"
      document.getElementById("wins1").innerHTML = winner1
    }
    else {
      ties ++
      document.getElementById("ties").innerHTML = ties
    }
    
    if(winner0 + winner1 < games && stop === false) {
      play(games)
    } else {
      stop = false
      done()
    }
  })
}

function done() {
  document.getElementById("start").disabled = false
  document.getElementById("stop").disabled = true
}

document.getElementById("start").addEventListener("click", function () {
  winner0 = 0
  winner1 = 0
  ties = 0
  document.getElementById("start").disabled = true
  document.getElementById("stop").disabled = false
  play(100)
})

document.getElementById("stop").addEventListener("click", function () {
  stop = true
})