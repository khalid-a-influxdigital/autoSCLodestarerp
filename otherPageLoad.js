var page = require('webpage').create();
var system = require('system');
var args = system.args;
var fs = require('fs');


page.onLoadFinished = function(){
    window.setTimeout(function(){
        console.log(page.title);
        page.render(args[2] + '.jpg');
        console.log('success');
        phantom.exit();
    }, 5000);
}

page.open(args[1]);
