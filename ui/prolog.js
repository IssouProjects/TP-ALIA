
var execute = require('child_process').exec;

module.exports.getOutput = function(callback) {
  execute("swipl -s ia/quatro.pl -g init", function(error, stdout, stderr) {  
    if(stdout.includes("Board full")){
      callback(-1)
    }
    else if(stdout.includes("Winner: 0")) {
      callback(0)
    }
    else if(stdout.includes("Winner: 1")) {
      callback(1)
    }
  })
};