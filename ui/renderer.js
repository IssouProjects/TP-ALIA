const prolog = require('./prolog');

const swipl = require('swipl');
swipl.call('consult(ia/quatro)');
const { list, compound, variable, serialize } = swipl.term;




var winner0 = 0
var winner1 = 0

var stop = false

function play(games) {
  prolog.getOutput(function (winner) {
    console.log("Games to play: " + games)
    console.log(winner)
    //winner = output.replace(/\n/g, "<br />");
    if(winner == 0) {
      winner0 ++
    }
    else if(winner == 1) {
      winner1 ++
    }

    document.getElementById("winner0").style.width = winner0 + "%"
    document.getElementById("winner1").style.width = winner1 + "%"
    document.getElementById("wins0").innerHTML = winner0
    document.getElementById("wins1").innerHTML = winner1
    if(winner0 + winner1 < games && stop === false) {
      play(games)
    } else {
      stop = false
      done()
    }
  })
}

/*function playProlog(){
  const ret = swipl.call('play(X).');
}*/

function test(){
  swipl.call('init.')

  var res;

  res = swipl.call('play(0,Piece,Move).')
  console.log(res.Piece)
  console.log(res.Move)

  const escaped = serialize(
    compound('member', [
        0,
        list([1, 2, 3, 4])]));
 
 console.log(swipl.call(escaped));
  
  

  res2 = swipl.call('play(0,Piece,Move).')
  console.log(res2.Piece)
  console.log(res2.Move)
  

}

function done() {
  document.getElementById("start").disabled = false
  document.getElementById("stop").disabled = true
}

document.getElementById("start").addEventListener("click", function () {
  winner0 = 0
  winner1 = 0
  document.getElementById("start").disabled = true
  document.getElementById("stop").disabled = false
  test();
  //play(100)
})

document.getElementById("stop").addEventListener("click", function () {
  stop = true
})
